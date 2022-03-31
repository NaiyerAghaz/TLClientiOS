//
//  NotificationViewController.swift
//  TLClientApp
//
//  Created by Mac on 12/10/21.
//

import UIKit
import Alamofire
import HSSearchable
class NotificationTableViewCell:UITableViewCell{
    
    @IBOutlet weak var selectAppointmentBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var notificationWebview: UIWebView!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var notificationLbl: UILabel!
    @IBOutlet var notificationTV: UITableView!
    override func awakeFromNib() {
        //self.notificationWebview.scrollView.isScrollEnabled = false
        self.mainView.addShadowGrey()
    }
}
class StatusFilterTableViewCell : UITableViewCell{
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var titleImg: UIImageView!
}
class NotificationViewController: UIViewController ,UISearchBarDelegate{
    @IBOutlet weak var filterTV: UITableView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet var notificationTV: UITableView!
    @IBOutlet var countLbl: UILabel!
    var appointmentStatusArr = [String]()
    var ifSearchEnable = false
    var filterSearch = [FilterSearch]()
    var statusFilterSearch = ""
    var searchArray = [ApiNotificationDetailDataModel]()
    var apiNotificationDetailResponseModel:ApiNotificationDetailResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.notificationTV.delegate = self
        self.notificationTV.dataSource = self
        self.filterTV.delegate = self
        self.filterTV.dataSource = self
        filterView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        filterView.isHidden = true
        getNotificatioDetail()
        if let textfield = searchbar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor(hexString: "#CECECE")
            textfield.backgroundColor = UIColor.lightGray
            //textfield.font = UIFont(name: "GlacialIndifference-Regular", size: 14.0)
         
            //   give Shadow And Round Corner to Search bar
            
            if #available(iOS 13.0, *) {
                 let searchField = searchbar.searchTextField
                 searchField.layer.cornerRadius = 18
                       searchField.borderStyle = .none
                       searchField.layer.borderWidth = 1
                       searchField.layer.borderColor = UIColor.clear.cgColor
                       searchField.backgroundColor = UIColor.white
                       searchField.textColor = UIColor(hexString: "#CECECE")
    
                       searchField.layer.shadowOpacity = 0.7
                       searchField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                       searchField.layer.shadowRadius = 4.0
                       searchField.layer.shadowColor = UIColor.lightGray.cgColor
   
            } else{
        let searchField = (searchbar.value(forKey: "_searchField") as! UITextField)
        searchField.layer.cornerRadius = 18
        searchField.borderStyle = .none
        searchField.layer.borderWidth = 1
        searchField.layer.borderColor = UIColor.clear.cgColor
        searchField.backgroundColor = UIColor.white
        searchField.textColor = UIColor(hexString: "#CECECE")
   
        searchField.layer.shadowOpacity = 0.7
        searchField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        searchField.layer.shadowRadius = 4.0
        searchField.layer.shadowColor = UIColor.lightGray.cgColor
    
        }
        }
       /// checkmark.square.fill
        //square
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchtext from searchbar  \(searchText)")
        
        if searchText == "" {
            getNotificatioDetail()
        }
        else {
            self.searchArray.removeAll()
            self.apiNotificationDetailResponseModel?.notificationsByUsername?.forEach({ (notificationData) in
                let notification = notificationData.notification ?? ""
                notification.range(of: searchText, options: .caseInsensitive)
               // if (notification.range(of: searchText, options: .caseInsensitive) != nil) {
                if notification.contains(searchText) {
                    print("exists text ",searchText)
                    self.searchArray.append(notificationData)
                }else{
                    print("not exists text ",searchText)
                    //self.searchArray.removeAll()
                }
                notificationTV.reloadData()
            })
        }
    }
   
    @IBAction func filterOkBtnTapped(_ sender: UIButton) {
        self.searchArray.removeAll()
        if appointmentStatusArr.count == 0 {
            self.apiNotificationDetailResponseModel?.notificationsByUsername?.forEach({ (notificationData) in
               
                self.searchArray.append(notificationData)
            })
        }else {
            self.apiNotificationDetailResponseModel?.notificationsByUsername?.forEach({ (notificationData) in
                let notification = notificationData.appStatus ?? ""
                
                print("exists text ",notification)
                print("exists text ",statusFilterSearch)
                self.appointmentStatusArr.forEach { (ab) in
                    if ab == notification {
                        //print("exists text ",searchText)
                        self.searchArray.append(notificationData)
                    }else{
                       // print("not exists text ",searchText)
                        //self.searchArray.removeAll()
                    }
                }
                
            })
        }
        notificationTV.reloadData()
        self.filterView.isHidden = true
    }
    @IBAction func filterTapped(_ sender: UIButton) {
        self.filterView.isHidden = false
    }
    @IBAction func actionBackButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    func getNotificatioDetail(){
        if Reachability.isConnectedToNetwork() {
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
                            guard let daataA = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiNotificationDetailResponseModel = try jsonDecoder.decode(ApiNotificationDetailResponseModel.self, from: daataA)
                               print("Success notification Model ")
                                let count = self.apiNotificationDetailResponseModel?.notificationsByUsername?.count ?? 0
                                
                                self.countLbl.text = "No of Records \(count)"
                                self.searchbar.delegate = self
                                self.apiNotificationDetailResponseModel?.notificationsByUsername?.forEach({ (notificationData) in
                                    self.searchArray.append(notificationData)
                                    
                                    let aptStatus = notificationData.appStatus ?? ""
                                    let item = FilterSearch(name: aptStatus, searchSelect: false)
                                    if filterSearch.contains(where: { $0.name == aptStatus }) {
                                        print("status Already exist ")
                                    } else {
                                        print("status not exist ")
                                        filterSearch.append(item)
                                    }
//                                    if item.name.contains(aptStatus){
//                                        print("status Already exist ")
//                                    }else {
//                                        print("status not exist ")
//                                        filterSearch.append(item)
//                                        //appointmentStatusArr.append(aptStatus)
//                                    }
                                    
                                })
                                DispatchQueue.main.async {
                                    self.filterTV.reloadData()
                                    self.notificationTV.reloadData()
                                }
        
                                
                            } catch{
                                
                                print("error block notification Data  " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                           
                        }
                    })}else {
                        self.view.makeToast(ConstantStr.noItnernet.val)
                    }
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
        let t = Int(timeStamp) ?? 0/1000
        let unixTimestamp = "\(t)"
        print("unixTimestamp",unixTimestamp , t )
       //"\(1622138536)"   1638360102567
        let epochTime = TimeInterval(t) / 1000
       // let date6 = Date(timeIntervalSince1970: epochTime)
        let ddate = Date(timeIntervalSince1970: epochTime)
        print("date from timestamp is ",ddate )
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterGet.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateString = dateFormatterGet.string(from: ddate)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterPrint.dateFormat = "MM/dd/yyyy hh:mm a"
        let date: NSDate? = dateFormatterGet.date(from: dateString) as NSDate?
         let currentdate = dateFormatterPrint.string(from: date! as Date)
        
            print("date converted is ", currentdate)
        return currentdate
    }
    

}
extension NotificationViewController :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.apiNotificationDetailResponseModel?.notificationsByUsername?.count ?? 0
        print("array count \(self.searchArray.count)")
        print("array count \(self.filterSearch.count)")
        if tableView == notificationTV {
            return self.searchArray.count
        }else {
            return self.filterSearch.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == notificationTV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
           //self.apiPrivacyPolicyResponseModel?.term_payload?.text?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Muli", size: 16), csscolor: "white", lineheight: 5, csstextalign: "left")
            let indx = self.searchArray[indexPath.row] //self.apiNotificationDetailResponseModel?.notificationsByUsername?[indexPath.row]
            let dateString = indx.createDate ?? ""
            let date = dateString.digits ?? ""
            print("date \(date)")
            //let actualDate = conertDateString(time: Double(date) ?? 0)
            let atualtime = getTimefromTimeStamp(timeStamp: date)
            cell.dateLbl.text = atualtime//actualDate
            cell.dateLbl.textColor = UIColor.gray
            cell.selectAppointmentBtn.tag = indexPath.row
            cell.selectAppointmentBtn.addTarget(self, action: #selector(goToAppointment), for: .touchUpInside)
            let subStatus = indx.subStatus ?? ""
            let notificationStringa = indx.notification ?? ""
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
            let appStatus = indx.appStatus ?? ""
            GetPublicData.sharedInstance.apiGetSpecialityDataModel?.appointmentStatus?.forEach({ (appointmentStatus) in
                if  appointmentStatus.code == appStatus {
                    cell.notificationLbl.text = appStatus
                    let color = appointmentStatus.color ?? ""
                    cell.notificationLbl.textColor = UIColor(hexString: color)
                }
            })
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatusFilterTableViewCell", for: indexPath) as! StatusFilterTableViewCell
            let indx = filterSearch[indexPath.row]
            GetPublicData.sharedInstance.apiGetSpecialityDataModel?.appointmentStatus?.forEach({ (appointmentStatus) in
                let appStatus = indx.name 
                if  appointmentStatus.code == appStatus {
                    //cell.titleLbl.text = appStatus
                    let color = appointmentStatus.color ?? ""
                    cell.titleLbl.textColor = UIColor(hexString: color)
                }
            })
            cell.titleLbl.text = indx.name
            if indx.searchSelect == true {
                cell.titleImg.image = UIImage(systemName: "checkmark.square.fill")
            }else {
                cell.titleImg.image = UIImage(systemName: "square")
            }
            return cell
        }
        
        
        
    }
    
    @objc func goToAppointment(_ sender : UIButton){
        let vc = self.storyboard?.instantiateViewController(identifier: "ScheduleAppointmentDetailVC") as! ScheduleAppointmentDetailVC
        //vc.showAppointmentArr = self.showAppointmentArr[indexPath.row]
        vc.appointmentID = self.apiNotificationDetailResponseModel?.notificationsByUsername?[sender.tag].appointmentID ?? 0
       // vc.apiScheduleAppointmentResponseModel = self.apiScheduleAppointmentResponseModel ?? ApiScheduleAppointmentResponseModel()
        vc.ifComeFromNotification = true
        vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == notificationTV {
            let vc = self.storyboard?.instantiateViewController(identifier: "ScheduleAppointmentDetailVC") as! ScheduleAppointmentDetailVC
            //vc.showAppointmentArr = self.showAppointmentArr[indexPath.row]
            vc.appointmentID = self.apiNotificationDetailResponseModel?.notificationsByUsername?[indexPath.row].appointmentID ?? 0
           // vc.apiScheduleAppointmentResponseModel = self.apiScheduleAppointmentResponseModel ?? ApiScheduleAppointmentResponseModel()
            vc.ifComeFromNotification = true
            vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            //self.navigationController?.pushViewController(vc, animated: true)
        }else {
            //statusFilterSearch = self.appointmentStatusArr[indexPath.row]
            print("abcd ")
            let cell = filterTV.cellForRow(at: indexPath) as! StatusFilterTableViewCell
            
            if self.filterSearch[indexPath.row].searchSelect == false{
                
                cell.titleImg.image = UIImage(systemName: "checkmark.square.fill")
                self.filterSearch[indexPath.row].searchSelect = true
                let status = self.filterSearch[indexPath.row].name
                self.appointmentStatusArr.append(status)
                print("SENDDD TO SERVERR ARRAY ISSS \(appointmentStatusArr)")
            }
            else {
                cell.titleImg.image = UIImage(systemName: "square")
                self.filterSearch[indexPath.row].searchSelect = false
                let status = self.filterSearch[indexPath.row].name
                if let index = appointmentStatusArr.firstIndex(of: status) {
                    appointmentStatusArr.remove(at: index)
                    print("SENDDD TO SERVERR ARRAY ISSS \(appointmentStatusArr)")
                }
            }
            
        }
        
    }
    
}


struct FilterSearch{
    var name: String = ""
    var searchSelect : Bool = false
}
class InitialNav : UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

