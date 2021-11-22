//
//  NotificationViewController.swift
//  TLClientApp
//
//  Created by Mac on 12/10/21.
//

import UIKit
import Alamofire
class NotificationTableViewCell:UITableViewCell{
    
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var notificationLbl: UILabel!
    @IBOutlet var notificationTV: UITableView!
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
        let date = dateString.digits
        print("date \(date)")
        let actualDate = conertDateString(time: Double(date) ?? 0)
        cell.dateLbl.text = actualDate
        cell.dateLbl.textColor = UIColor.gray
        let subStatus = indx?.subStatus ?? ""
        let notificationStringa = indx?.notification ?? ""
        let notif4 = notificationStringa.replacingOccurrences(of: "#: <b>", with: "<table border=1 style=font-size:6vw;border-collapse:collapse; ><tr><td><b>")
        let  notif5 = notif4.replacingOccurrences(of: ": ", with: "</b></td><td>")
        let  notif6 = notif5.replacingOccurrences(of: ",", with: "</td></tr><tr><td><b>")
        let  notif7 = notif6.replacingOccurrences(of: "</b>.", with: "</b></td></tr></table>")
        let mainString = notificationStringa + subStatus
        
        let notificationString = notif7.convertHtmlToAttributedStringWithCSS(font: UIFont.systemFont(ofSize: 16) , csscolor: "Black", lineheight: 5, csstextalign: "left")
        cell.notificationLbl.attributedText = notificationString
        return cell
    }
    
    
}



class TestNav : UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

