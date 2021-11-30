//
//  NotificationViewController.swift
//  TLClientApp
//
//  Created by Mac on 12/10/21.
//

import UIKit
import Alamofire
class NotificationTableViewCell:UITableViewCell{
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var notificationWebview: UIWebView!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var notificationLbl: UILabel!
    @IBOutlet var notificationTV: UITableView!
    override func awakeFromNib() {
        self.notificationWebview.scrollView.isScrollEnabled = false
        self.mainView.addShadowGrey()
    }
}
class NotificationViewController: UIViewController {
    @IBOutlet var notificationTV: UITableView!
    @IBOutlet var countLbl: UILabel!
    var apiNotificationDetailResponseModel:ApiNotificationDetailResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.notificationTV.delegate = self
        self.notificationTV.dataSource = self
        getNotificatioDetail()
    }
    
   
    @IBAction func actionBackButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    func getNotificatioDetail(){
        SwiftLoader.show(animated: true)
        self.apiNotificationDetailResponseModel = nil
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let companyID = GetPublicData.sharedInstance.companyID
        let urlPostFix = "UserID=\(userId)&CompanyID=\(companyID)&SortOrder=Desc&RowNumber=0&AppID=0"
        let urlPrefix = "\(APi.notificationDetail.url)"
        let urlString = urlPrefix + urlPostFix
        print("url to get notificationDetail  \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success Notification Data ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiNotificationDetailResponseModel = try jsonDecoder.decode(ApiNotificationDetailResponseModel.self, from: daata)
                               print("Success notification Model ")
                                let count = self.apiNotificationDetailResponseModel?.notificationsByUsername?.count ?? 0
                                self.countLbl.text = "No. of Record \(count)"
                                DispatchQueue.main.async {
                                    self.notificationTV.reloadData()
                                }
        
                                
                            } catch{
                                
                                print("error block notification Data  " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                           
                        }
                })
     }
    func conertDateString(time :Double ) -> String{
        print("MILI SECONDS IS \(time)")
      //        let milisecond = 1479714427
              let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(time)/1000)
              let dateFormatter = DateFormatter()
              dateFormatter.locale = Locale(identifier: "en_US")
              dateFormatter.dateFormat = "dd-MM-yyyy"
              print(dateFormatter.string(from: dateVar))
              let timeConverted = (dateFormatter.string(from: dateVar))
              return timeConverted
    }
    func getTimefromTimeStamp(timeStamp: String ) -> String {
        let unixTimestamp = "\(timeStamp)"
        print("unixTimestamp",unixTimestamp)//"\(1622138536)"
        let ddate = Date(timeIntervalSince1970: TimeInterval(unixTimestamp)!)
        print("date from timestamp is ",ddate )
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatterGet.string(from: ddate)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM/dd/yyyy HH:mm a"
        let date: NSDate? = dateFormatterGet.date(from: dateString) as NSDate?
         let currentdate = dateFormatterPrint.string(from: date! as Date)
            print(currentdate)
        return currentdate
    }

}
extension NotificationViewController :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiNotificationDetailResponseModel?.notificationsByUsername?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
       //self.apiPrivacyPolicyResponseModel?.term_payload?.text?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Muli", size: 16), csscolor: "white", lineheight: 5, csstextalign: "left")
        let indx = self.apiNotificationDetailResponseModel?.notificationsByUsername?[indexPath.row]
        let dateString = indx?.createDate ?? ""
        let date = dateString.digits ?? ""
        print("date \(date)")
        //let actualDate = conertDateString(time: Double(date) ?? 0)
        let atualtime = getTimefromTimeStamp(timeStamp: date)
        cell.dateLbl.text = atualtime//actualDate
        cell.dateLbl.textColor = UIColor.gray
        let subStatus = indx?.subStatus ?? ""
        let notificationStringa = indx?.notification ?? ""
        var arr = notificationStringa.components(separatedBy: ",")
        print("array count is \(arr.count)")
        if arr.count == 9 {
            arr.remove(at: 3)
            arr.remove(at: 4)
            arr.remove(at: 4)
        }
        if arr.count == 13 {
            arr.remove(at: 3)
            arr.remove(at: 4)
            arr.remove(at: 4)
            arr.remove(at: 4)
            arr.remove(at: 4)
            arr.remove(at: 4)
            arr.remove(at: 4)
        }
        if arr.count == 14 {
            arr.remove(at: 3)
            arr.remove(at: 4)
            arr.remove(at: 4)
            arr.remove(at: 4)
            arr.remove(at: 4)
            arr.remove(at: 4)
            arr.remove(at: 4)
            arr.remove(at: 4)
        }
        let newString = arr.joined(separator: ",")
        print("newString \(newString)")
        let prefix = "<style>table,th,td{border:1px solid black;}table{width:100%}</style><body>"
        //let a1 = prefix +  notificationStringa.replacingOccurrences(of: "#: <b>Job Type:", with: "<table><tr><th>Job Type</th><td>")
        let a1 = prefix +  newString.replacingOccurrences(of: "#: <b>Job Type:", with: "<table><tr><th>Job Type</th><td>")
       
        let a2 = a1.replacingOccurrences(of: ", AuthCode:", with: "</td></tr><tr><th>AuthCode</th><td>")
        let a3 = a2.replacingOccurrences(of: ", Start Time:", with: "</td></tr><tr><th>Start Time</th><td>")
        let a4 = a3.replacingOccurrences(of: ", EndTime:", with: "")
        let a5 = a4.replacingOccurrences(of: ", Venue:", with: "</td></tr><tr><th>Venue</th><td>")
        let a6 = a5.replacingOccurrences(of: " Department:", with: "")
        let a7 = a6.replacingOccurrences(of: ", Provider:", with: "")
        let a8 = a7.replacingOccurrences(of: ", Language:", with: "</td></tr><tr><th>Language</th><td>")
        let a9 = a8.replacingOccurrences(of: ", InterPreter:", with: "</td></tr><tr><th>Interpreter</th><td>")
        let a10 = a9.replacingOccurrences(of: "</b>.", with: "</td></tr></table></body>")
        print(a10)
        
        cell.notificationWebview.loadHTMLString(a10, baseURL: nil)
        
       // let notificationString = a10.convertHtmlToAttributedStringWithCSS(font: UIFont.systemFont(ofSize: 16) , csscolor: "Black", lineheight: 5, csstextalign: "left")
        let appStatus = indx?.appStatus ?? ""
        GetPublicData.sharedInstance.apiGetSpecialityDataModel?.appointmentStatus?.forEach({ (appointmentStatus) in
            if  appointmentStatus.code == appStatus {
                cell.notificationLbl.text = appStatus
                let color = appointmentStatus.color ?? ""
                cell.notificationLbl.textColor = UIColor(hexString: color)
            }
        })
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}



class TestNav : UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

