//
//  BlockedAppointmentDetailVC.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 04/03/22.
//

import UIKit
import Alamofire
class BlockedAppointmentDetailVC: UIViewController {
    
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endtimeLbl: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var appointmentDetailTV: UITableView!
    var startDateString = ""
    var startTime = ""
    var EndTime = ""
    var appointmentID = 0
    @IBOutlet var cancelBtn: UIButton!
    var cancelKey:Int?
    var ifComeFromNotification = false
    var apiCancelRequestResponseModel:ApiCancelRequestResponseModel?
    var apiGetCustomerDetailResponseModel = [ApiGetCustomerDetailResponseModel]()
    var apiScheduleAppointmentResponseModel:ApiScheduleAppointmentResponseModel?
    var appointmentDataArray = [ApiBlockedAppointmentResponseModelData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getAppointmentDetail()
        appointmentDetailTV.delegate = self
        appointmentDetailTV.dataSource = self
        self.startDate.text = self.startDateString
        self.startTimeLbl.text = self.startTime
        self.endtimeLbl.text = self.EndTime
         print("AppointmentID \(appointmentID)")
       
    }
    
    @IBAction func actionBackBtn(_ sender: UIButton) {
        
        if ifComeFromNotification{
            self.dismiss(animated: true, completion: nil)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func actionCancelRequest(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want to cancel the request ?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            self.hitApiCancelRequest()
           }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    //MARK: - Time conversion method
    
    func convertDateFormater(_ date: String) -> String
    {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return  dateFormatter.string(from: newdate)
        }else {
            return ""
        }
        

    }
    func convertTimeFormater(_ date: String) -> String
    {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "h:mm a"
            return  dateFormatter.string(from: newdate)
        }else {
            return ""
        }
    }
   //MARK: - APi Methoda
    func hitApiCancelRequest(){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
        let userId = GetPublicData.sharedInstance.userID
        let urlPostfix = "AppointmentId=\(self.appointmentID)&CurrentUserId=\(userId)&UserType=Customer"
        let urlPrefix = "\(APi.cancelAppointmentRequest.url)"
        let urlString = urlPrefix + urlPostfix
       
             print("url to cancel Appointment \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success cancel request  ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiCancelRequestResponseModel = try jsonDecoder.decode(ApiCancelRequestResponseModel.self, from: daata)
                                let status = self.apiCancelRequestResponseModel?.cancelledData?.first?.success ?? 0
                                print(self.apiCancelRequestResponseModel?.cancelledData)
                                if status == 1 {
                                    print("Success")
                                    self.navigationController?.popViewController(animated: true)
                                    
                                }else {
                                
                                    
                                }
                            } catch{
                                self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                            self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                           
                        }
                    })}
        else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
     }
    func getAppointmentDetail(){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
        
        let urlString = APi.GetBlokedAppointmentDetailApi.url
        let companyID = GetPublicData.sharedInstance.companyID
        let userID = userDefaults.string(forKey: "userId") ?? ""//GetPublicData.sharedInstance.userID
        let userTypeId = GetPublicData.sharedInstance.userTypeID
        let searchString = "<INFO><UserID>\(userID)</UserID><AppointmentID>\(self.appointmentID)</AppointmentID><Companyid>\(companyID)</Companyid><USERTYPEID></USERTYPEID></INFO>"
        let parameter = [
            "strSearchString" : searchString
        ] as [String : String]
        print("url and parameter getCommonDetail ", urlString, parameter)
        AF.request(urlString, method: .post , parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success getCommonDetail ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiGetCustomerDetailResponseModel = try jsonDecoder.decode([ApiGetCustomerDetailResponseModel].self, from: daata)
                        print("Success getCommonDetail Model ",self.apiGetCustomerDetailResponseModel.first?.result ?? "")
                        let str = self.apiGetCustomerDetailResponseModel.first?.result ?? ""
                        let data = str.data(using: .utf8)!
                        do {
//
                            print("DATAAA ISSS \(data)")
                            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                            {

                                let newjson = jsonArray.first
                                let userInfo = newjson?["BlockedAppList"] as? [[String:Any]]
                                print("USER INFO DATA IS \(userInfo)")
                                let userIfo = userInfo?.first
                                print("USER INFO NEW DATA IS \(userIfo)")
                                userInfo?.forEach({ BlockedAppListApiData in
                                    let ClientCase = BlockedAppListApiData["ClientCase"] as? String
                                    let ReasonforBotch = BlockedAppListApiData["ReasonforBotch"] as? String
                                    let BookedBy = BlockedAppListApiData["BookedBy"] as? String
                                    let CaseNumber = BlockedAppListApiData["CaseNumber"] as? String
                                    let SpecialityName = BlockedAppListApiData["SpecialityName"] as? String
                                    let StartDateTimee = BlockedAppListApiData["StartDateTime"] as? String
                                    let StartDateTime = BlockedAppListApiData["StartDateTime"] as? String
                                    let AppointmentStatusType = BlockedAppListApiData["AppointmentStatusType"] as? String
                                    let JobType = BlockedAppListApiData["JobType"] as? String
                                    let CompanyEmail = BlockedAppListApiData["CompanyEmail"] as? String
                                    let ProviderName = BlockedAppListApiData["ProviderName"] as? String
                                    let ServiceTypeName = BlockedAppListApiData["ServiceTypeName"] as? String
                                    let AppointmentTypeCode = BlockedAppListApiData["AppointmentTypeCode"] as? String
                                    let Interpretername = BlockedAppListApiData["Interpretername"] as? String
                                    let CAptDetails = BlockedAppListApiData["CAptDetails"] as? String
                                    let VenueAddress = BlockedAppListApiData["VenueAddress"] as? String
                                    let DepartmentName = BlockedAppListApiData["DepartmentName"] as? String
                                    let StarEndDateTime = BlockedAppListApiData["StarEndDateTime"] as? String
                                    let BookedOn = BlockedAppListApiData["BookedOn"] as? String
                                    let LanguageName = BlockedAppListApiData["LanguageName"] as? String
                                    let UpdatedOn = BlockedAppListApiData["UpdatedOn"] as? String
                                    let CScheduleNotes = BlockedAppListApiData["CScheduleNotes"] as? String
                                    let CancelledOn = BlockedAppListApiData["CancelledOn"] as? String
                                    let VenueName = BlockedAppListApiData["VenueName"] as? String
                                    let CompanyLogo = BlockedAppListApiData["CompanyLogo"] as? String
                                    let CFinancialNotes = BlockedAppListApiData["CFinancialNotes"] as? String
                                    let AppointmentID = BlockedAppListApiData["AppointmentID"] as? Int
                                    let ConfirmedOn = BlockedAppListApiData["ConfirmedOn"] as? String
                                    let LanguageNameP = BlockedAppListApiData["LanguageNameP"] as? String
                                    let CompanyName = BlockedAppListApiData["CompanyName"] as? String
                                    let CText = BlockedAppListApiData["CText"] as? String
                                    let AppointmentStatusTypeID = BlockedAppListApiData["AppointmentStatusTypeID"] as? Int
                                    let authcode = BlockedAppListApiData["authcode"] as? String
                                    let ConfirmedBy = BlockedAppListApiData["ConfirmedBy"] as? String
                                    let CLocation = BlockedAppListApiData["CLocation"] as? String
                                    
                                    let aPVenueID = BlockedAppListApiData["aPVenueID"] as? Int
                                    let Gender = BlockedAppListApiData["Gender"] as? String
                                    let AppDate = BlockedAppListApiData["AppDate"] as? String
                                    let IsAssigned = BlockedAppListApiData["IsAssigned"] as? String
                                    let AppSTime = BlockedAppListApiData["AppSTime"] as? String
                                    let EndDateTime = BlockedAppListApiData["EndDateTime"] as? String
                                    let LoadedBy = BlockedAppListApiData["LoadedBy"] as? String
                                    let CancelledBy = BlockedAppListApiData["CancelledBy"] as? String
                                    let AcceptAndDeclineStatus = BlockedAppListApiData["AcceptAndDeclineStatus"] as? Int
                                    let VendorTimezoneshort = BlockedAppListApiData["VendorTimezoneshort"] as? String
                                    let num_row = BlockedAppListApiData["num_row"] as? String
                                    let ClientName = BlockedAppListApiData["ClientName"] as? String
                                    let AppETime = BlockedAppListApiData["AppETime"] as? String
                                    let AppointmentType = BlockedAppListApiData["AppointmentType"] as? String
                                    let RequestedOn = BlockedAppListApiData["RequestedOn"] as? String
                                    let CompanyPhone = BlockedAppListApiData["CompanyPhone"] as? String
                                    let Interpreterid = BlockedAppListApiData["Interpreterid"] as? Int
                                    let ISAUTHUSER = BlockedAppListApiData["ISAUTHUSER"] as? Int
                                    let itemA = ApiBlockedAppointmentResponseModelData(ClientCase: ClientCase, ReasonforBotch: ReasonforBotch, BookedBy: BookedBy, CaseNumber: CaseNumber, SpecialityName: SpecialityName, StartDateTimee: StartDateTimee, DepartmentName: DepartmentName, StartDateTime: StartDateTime, AppointmentStatusType: AppointmentStatusType, JobType: JobType, CompanyEmail: CompanyEmail, ProviderName: ProviderName, ServiceTypeName: ServiceTypeName, AppointmentTypeCode: AppointmentTypeCode, Interpretername: Interpretername, CAptDetails: CAptDetails, VenueAddress: VenueAddress, StarEndDateTime: StarEndDateTime, BookedOn: BookedOn, LanguageName: LanguageName, UpdatedOn: UpdatedOn, CScheduleNotes: CScheduleNotes, CancelledOn: CancelledOn, VenueName: VenueName, CompanyLogo: CompanyLogo, CFinancialNotes: CFinancialNotes, AppointmentID: AppointmentID, ConfirmedOn: ConfirmedOn, LanguageNameP: LanguageNameP, CompanyName: CompanyName, CText: CText, AppointmentStatusTypeID: AppointmentStatusTypeID, authcode: authcode, ConfirmedBy: ConfirmedBy, CLocation: CLocation, aPVenueID: aPVenueID, Gender: Gender, AppDate: AppDate, IsAssigned: IsAssigned, AppSTime: AppSTime, EndDateTime: EndDateTime, LoadedBy: LoadedBy, CancelledBy: CancelledBy, AcceptAndDeclineStatus: AcceptAndDeclineStatus, VendorTimezoneshort: VendorTimezoneshort, num_row: num_row, ClientName: ClientName, AppETime: AppETime, AppointmentType: AppointmentType, RequestedOn: RequestedOn, CompanyPhone: CompanyPhone, Interpreterid: Interpreterid, ISAUTHUSER: ISAUTHUSER)
                                    self.appointmentDataArray.append(itemA)
                                    
                                })
                                print("APPOINTMENT DATA ARRAY IS \(self.appointmentDataArray)")
                                
                                DispatchQueue.main.async {
                                    let rawTime = self.appointmentDataArray.first?.StartDateTime ?? ""
                                    let rawEndTime = self.appointmentDataArray.first?.EndDateTime ?? ""
                                    let newTime = convertTimeFormater(rawTime)
                                    let newDate = convertDateFormater(rawTime)
                                    let newEndDate = convertTimeFormater(rawEndTime)
                                    
//                                    self.startDate.text = newDate
//                                    self.startTimeLbl.text = newTime
//                                    self.endtimeLbl.text = newEndDate
                                    
                                    self.appointmentDetailTV.reloadData()
                                }
                                //updateAuthCode(authCode: authcode ?? "")
                            } else {
                                print("bad json")
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                    } catch{
                        
                        print("error block getCommonDetail " ,error)
                    }
                case .failure(_):
                    print("Respose getCommonDetail ")
                    
                }
            })}
        else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
    }
   

}
//MARK: - Table Work
extension BlockedAppointmentDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appointmentDataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockedAppointmentDetailTVC", for: indexPath) as! BlockedAppointmentDetailTVC
        let index = self.appointmentDataArray[indexPath.row]
        if index.collapsedStatus {
            cell.bottomDetailView.visibility = .visible
        }else {
            cell.bottomDetailView.visibility = .gone
        }
        cell.btnTitleView.tag = indexPath.row
        cell.btnTitleView.addTarget(self, action: #selector(openDetailView), for: .touchUpInside)
        
        
        
        cell.statusLbl.text =  ": \(index.AppointmentStatusType ?? "N/A")"
       
        cell.addressLbl.text =  ": \(index.VenueAddress ?? "N/A")"
        cell.jobTypeLbl.text = ": \(index.JobType ?? "N/A")"
        let appointmentType = index.AppointmentType ?? "N/A"
        if appointmentType == "Virtual Meeting" || appointmentType == "Telephone Conference" {
            //cell.venueDetailView.visibility = .gone
           // cell.saparationLbl.visibility = .gone
        }else {
            //cell.venueDetailView.visibility = .visible
            //cell.saparationLbl.visibility = .visible
        }
        if index.AppointmentType == "Schedule OPI" || index.AppointmentType == "Schedule VRI" {
           // cell.authCodeLbl.text = index?.IsAssigned
        }else {
            let str = index.authcode ?? "N/A"
            let components = str.components(separatedBy: " ")
            cell.authCodeLbl.text = ": \(components[0])"
            
        }
        let cancelStatus = self.cancelKey
        let appointmentStatusID = index.AppointmentStatusTypeID ?? 0
        if cancelStatus != nil && (cancelStatus == 0 || appointmentStatusID == 3 || appointmentStatusID == 5 || appointmentStatusID == 13 || appointmentStatusID == 7 || appointmentStatusID == 8 || appointmentStatusID == 4) {
        
            self.cancelBtn.isHidden = true
        
                
            
        }else{
            
            
            self.cancelBtn.isHidden = false
            
        }
        cell.languageLbl.text = ": \(index.LanguageName ?? "N/A")"
        cell.nameLbl.text = ": \(index.VenueName ?? "N/A")"
       // cell.cityLbl.text = index.city ?? "N/A"
       // cell.stateLbl.text = index.stateName ?? "N/A"
        cell.statusLbl.text = ": \(index.AppointmentStatusType ?? "N/A")"
       // cell.zipcodeLbl.text = index.zipcode ?? "N/A"
        cell.departmentLbl.text = ": \(index.DepartmentName ?? "N/A")"
        cell.genderLbl.text = ": \(index.Gender ?? "N/A")"
        cell.contactLbl.text = ": \(index.ProviderName ?? "N/A")"
        cell.titleAptCountLbl.text = "Appointment\(indexPath.row + 1)"
        
        
        cell.patientintialsLbl.text = ": N/A"//index.cPIntials ?? "N/A"
        cell.interpreterLbl.text = ": N/A"//index?.interpretorName ?? "N/A"
        let rawTime = index.StartDateTime ?? ""
        let rawEndTime = index.EndDateTime ?? ""
        let newTime = convertTimeFormater(rawTime)
        let newDate = convertDateFormater(rawTime)
        let newEndDate = convertTimeFormater(rawEndTime)
        cell.startTimeLbl.text = ": \(newTime)"
        cell.startDateLbl.text = ": \(index.StarEndDateTime ?? "")"//newDate
        cell.endTimeLbl.text = ": \(newEndDate)"
         print("new tew \(newTime)")
        self.apiScheduleAppointmentResponseModel?.appointmentStatus?.forEach({ data in
            if index.AppointmentStatusType == data.code {
                print("color is \(data.code)")
                let statusColor = data.color ?? ""
                cell.statusLbl.textColor = UIColor(hexString: statusColor )
                //self.appointStatusHeadingLbl.backgroundColor = UIColor(hexString: statusColor )
            }
        })
       // let cancelStatus = index.customerCancelRequest ?? nil
        
      /*  if cancelStatus != nil && (cancelStatus == 0 || appointmentStatusID == "3" || appointmentStatusID == "5" || appointmentStatusID == "13" || appointmentStatusID == "7" || appointmentStatusID == "8" || appointmentStatusID == "4") {
        
            cell.cancelBtn.isHidden = true
        
                
            
        }else{
            
            
            cell.cancelBtn.isHidden = false
            
        }*/
        
        if index.AppointmentType == "Schedule OPI" || index.AppointmentType == "Schedule VRI" {
            cell.interpreterLbl.attributedText =  index.Interpretername?.convertHtmlToAttributedStringWithCSS(font: UIFont.systemFont(ofSize: 10), csscolor: "black", lineheight: 5, csstextalign: "left")
        }else {
            
            cell.interpreterLbl.text = ": \(index.Interpretername ?? "N/A")"
            
        }
        
        
        
        
        return cell
    }
    @objc func openDetailView( sender : UIButton){
        let status = self.appointmentDataArray[sender.tag].collapsedStatus
        if status {
            self.appointmentDataArray[sender.tag].collapsedStatus = false
        }else {
            self.appointmentDataArray[sender.tag].collapsedStatus = true
        }
        self.appointmentDetailTV.reloadData()
    }
}

//MARK: - Table cell class
class BlockedAppointmentDetailTVC: UITableViewCell {
    @IBOutlet weak var jobTypeLbl: UILabel!
    @IBOutlet weak var authCodeLbl: UILabel!
    @IBOutlet weak var interpreterLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var titleAptCountLbl: UILabel!
    @IBOutlet weak var titleHeaderView: UIView!
    @IBOutlet weak var doenArrImg: UIImageView!
    @IBOutlet weak var bottomDetailView: UIView!
    @IBOutlet weak var btnTitleView: UIButton!
    @IBOutlet weak var appointStatusHeadingLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var venueDetailView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var patientintialsLbl: UILabel!
    @IBOutlet weak var saparationLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var zipcodeLbl: UILabel!
    @IBOutlet weak var departmentLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    override  func awakeFromNib() {
        //self.titleHeaderView.addShadowGrey()
        
    }
}

struct ApiBlockedAppointmentResponseModelData{
    var collapsedStatus = false
    let ClientCase : String?
    let ReasonforBotch : String?
    let BookedBy : String?
    let CaseNumber : String?
    let SpecialityName : String?
    let StartDateTimee : String?
    let DepartmentName : String?
    let StartDateTime : String?
    let AppointmentStatusType : String?
    let JobType : String?
    let CompanyEmail : String?
    let ProviderName : String?
    let ServiceTypeName : String?
    let AppointmentTypeCode : String?
    let Interpretername : String?
    let CAptDetails : String?
    let VenueAddress : String?
    let StarEndDateTime : String?
    let BookedOn : String?
    let LanguageName : String?
    let UpdatedOn : String?
    let CScheduleNotes : String?
    let CancelledOn : String?
    let VenueName : String?
    let CompanyLogo : String?
    let CFinancialNotes : String?
    let AppointmentID : Int?
    let ConfirmedOn : String?
    let LanguageNameP : String?
    let CompanyName : String?
    let CText : String?
    let AppointmentStatusTypeID : Int?
    let authcode : String?
    let ConfirmedBy : String?
    let CLocation : String?
    let aPVenueID : Int?
    let Gender : String?
    let AppDate : String?
    let IsAssigned : String?
    let AppSTime : String?
    let EndDateTime : String?
    let LoadedBy : String?
    let CancelledBy : String?
    let AcceptAndDeclineStatus : Int?
    let VendorTimezoneshort : String?
    let num_row : String?
    let ClientName : String?
    let AppETime : String?
    let AppointmentType : String?
    let RequestedOn : String?
    let CompanyPhone : String?
    let Interpreterid : Int?
    let ISAUTHUSER : Int?
    
}
