//
//  TelephonicRecurrenceNewVC.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 04/03/22.
//

import UIKit
import Alamofire
import iOSDropDown
class TelephonicRecurrenceNewVC: UIViewController, SelectDateForRecurrence {
    func SelectAppointmentDate(selectedDateArr: [SelectedDatesModel]) {
        for (indxx, itemm) in selectedDateArr.enumerated() {
            if indxx != 0 {}
                
                
                let dateFormatterDate = DateFormatter()
                dateFormatterDate.dateFormat = "MM/dd/yyyy"
                let dateFormatterTime = DateFormatter()
                dateFormatterTime.dateFormat = "h:mm a"
                let currentDateTime = itemm.selectedDate.nearestHour() ?? Date()
                print("current time before \(currentDateTime)")
                let tempTime = dateFormatterTime.string(from: currentDateTime)
                print("TEMP TIME : \(tempTime)")
                let endTimee = itemm.selectedDate.adding(minutes: 120).nearestHour() ?? Date()
                
                let itemA = BlockedAppointmentData(AppointmentDate: dateFormatterDate.string(from: currentDateTime), startTime: dateFormatterTime.string(from: currentDateTime), endTime: dateFormatterTime.string(from: endTimee), languageID: 0, genderID: "", clientName: "", ClientIntials: "", ClientRefrence: "", venueID: "", DepartmentID: 0, contactID: 0, location: "", SpecialNotes: "", rowIndex: indxx + 1, languageName: "",venueName: "", DepartmentName: "", genderType: "", conatctName: "", isVenueSelect: false, venueTitleName : "" , addressname : "" , cityName : "" , stateName : "" , zipcode: "",startTimeForPicker: Date() , endTimeForPicker: Date(), authCode: "",showClientName: "" , showClientIntials:"" , showClientRefrence: "")
                self.blockedAppointmentArr.append(itemA)
            
            self.recuringAppointmentTV.reloadData()
        }
        
    }
    
    @IBOutlet weak var serviceTypeTF: iOSDropDown!
    @IBOutlet weak var specialityTF: iOSDropDown!
    @IBOutlet weak var jobTypeTF: UITextField!
    @IBOutlet weak var authCodeTF: UITextField!
    @IBOutlet weak var subCustomerNameTF: iOSDropDown!
    @IBOutlet weak var customerNameTF: UITextField!
    @IBOutlet weak var optiontitleLbl: UILabel!
    
    @IBOutlet weak var loadedOnTF: UITextField!
    @IBOutlet weak var cancelledOnTF: UITextField!
    @IBOutlet weak var bookedONTF: UITextField!
    @IBOutlet weak var requestedONTF: UITextField!
    @IBOutlet weak var departmentOptionView: UIView!
    @IBOutlet weak var departmentOptionMajorView: UIView!
   
    @IBOutlet weak var recuringAppointmentTV: UITableView!
    @IBOutlet weak var DeactivateOptionView: UIView!
    @IBOutlet weak var activateOptionView: UIView!
    
    var specialityDetail = [SpecialityData]()
    var serviceDetail = [ServiceData]()
    var serviceArr:[String] = []
    var specialityArray:[String] = []
    var languageArray:[String] = []
    var genderArray :[String] = []
    
    
    var subcustomerList = [SubCustomerListData]()
   
    var subcustomerArr = [String]()
    var blockedAppointmentArr = [BlockedAppointmentData]()
    
    var selectTypeOFAppointment = "RC"
    
    var serviceId = ""
    var specialityID = ""
    var customerID = ""
   
    var isSpecialitySelect = false
    var isServiceSelect = false
    var isContactOption = false
    
    var authCode = ""
    var userID = ""
    var companyID = ""
    var userTypeID = ""
    var jobType = ""
    
    var apiEncryptedDataResponse:ApiEncryptedDataResponse?
    var apiGetCustomerDetailResponseModel = [ApiGetCustomerDetailResponseModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recuringAppointmentTV.delegate = self
        self.recuringAppointmentTV.dataSource = self
        self.departmentOptionMajorView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.departmentOptionMajorView.isHidden = true
        self.departmentOptionView.layer.cornerRadius = 15
        self.departmentOptionView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        self.userID = userDefaults.string(forKey: "userId") ?? ""
        self.companyID = userDefaults.string(forKey: "companyID") ?? ""
        self.userTypeID = userDefaults.string(forKey: "userTypeID") ?? ""
        NotificationCenter.default.addObserver(self, selector: #selector(updateVenueList), name: Notification.Name("updateVenueList"), object: nil)
        
       
       
      
        
        
        let dateFormatterr = DateFormatter()
        dateFormatterr.dateFormat = "MM/dd/yyyy h:mm a"
        let startDatee =  dateFormatterr.string(from: Date().nearestHour() ?? Date ())
        
        self.requestedONTF.text = dateFormatterr.string(from: Date())
        self.loadedOnTF.text = dateFormatterr.string(from: Date())
        
        getCommonDetail()
        getCustomerDetail()
        
        
        // Do any additional setup after loading the view.
    }
    @objc func updateVenueList(){
       getCustomerDetail()
        
    }
    //MARK: - show  Drop downs
    
   
    
    func updateServiceAndSpeciality(){
        serviceTypeTF.optionArray = self.serviceArr
        print("OPTIONS NEW ARRAY \(serviceTypeTF.optionArray)")
        serviceTypeTF.checkMarkEnabled = true
        serviceTypeTF.isSearchEnable = true
        serviceTypeTF.selectedRowColor = UIColor.clear
        serviceTypeTF.didSelect{(selectedText , index , id) in
            self.serviceTypeTF.text = "\(selectedText)"
            self.serviceDetail.forEach({ languageData in
                print("serviceDetail data \(languageData.DisplayValue ?? "")")
                if selectedText == languageData.DisplayValue ?? "" {
                    self.serviceId = "\(languageData.SpecialityID ?? 0)"
                    print("serviceDetail ID \(self.serviceId)")
                    self.isServiceSelect = true
                }
            })
        }
        
        
        
        
        specialityTF.optionArray = self.specialityArray
        print("OPTIONS NEW ARRAY \(specialityTF.optionArray)")
        specialityTF.checkMarkEnabled = true
        specialityTF.isSearchEnable = true
        specialityTF.selectedRowColor = UIColor.clear
        specialityTF.didSelect{(selectedText , index , id) in
            self.specialityTF.text = "\(selectedText)"
            self.specialityDetail.forEach({ languageData in
                print("specialityDetail data \(languageData.DisplayValue ?? "")")
                if selectedText == languageData.DisplayValue ?? "" {
                    self.specialityID = "\(languageData.SpecialityID ?? 0)"
                    print("specialityDetail id \(self.specialityID)")
                    self.isSpecialitySelect = true
                }
            })
        }
    }
    func showSubcustomerDropDown(){
        subCustomerNameTF.optionArray = self.subcustomerArr
        
        print("OPTIONS NEW ARRAY \(subCustomerNameTF.optionArray)")
        subCustomerNameTF.checkMarkEnabled = true
        subCustomerNameTF.isSearchEnable = true
        subCustomerNameTF.selectedRowColor = UIColor.clear
        subCustomerNameTF.didSelect{(selectedText , index , id) in
            self.subCustomerNameTF.text = "\(selectedText)"
            self.subcustomerList.forEach({ languageData in
                print("subcustomerList data \(languageData.CustomerFullName ?? "")")
                if selectedText == languageData.CustomerFullName ?? "" {
                    //self.languageID = "\(languageData.languageID ?? 0)"
                    print("subcustomerList id \(languageData.UniqueID)")
                }
            })
        }
    }
   

    //MARK: - Processing Detail Action
    @IBAction func actionProcessingDetail(_ sender: UIButton) {
        
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .dateAndTime, minDate: Date(), maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            let roundOff = selectedDate//.nearestHour() ?? selectedDate
            let selectedDate  = roundOff.dateString("MM/dd/YYYY hh:mm a")
            print("seleceted date \(selectedDate)")
            if sender.tag == 0 {
                self?.requestedONTF.text = selectedDate
            }else if sender.tag == 1 {
                self?.bookedONTF.text = selectedDate
            }else if sender.tag == 2 {
                self?.cancelledOnTF.text = selectedDate
            }else if sender.tag == 3 {
                self?.loadedOnTF.text = selectedDate
            }
            
        })
    }
    
    //MARK: - Create Request
    @IBAction func actionCreateRequest(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() {
        
            createBlockedAppointment()
        
        }else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
     
    }
    func createBlockedAppointment(){
        //"\(self.startDateTF.text ?? "") \(self.startTimeTimeTF.text ?? "")"
        
       
        
        if isSpecialitySelect {
            
        }else {
            self.specialityDetail.forEach({ languageData in
                print("specialityDetail data \(languageData.DisplayValue ?? "")")
                if specialityTF.text ?? "" == languageData.DisplayValue ?? "" {
                    self.specialityID = "\(languageData.SpecialityID ?? 0)"
                    
                }
            })
        }
        
        if isServiceSelect {
            
        }else {
            self.serviceDetail.forEach({ languageData in
                print("serviceDetail data \(languageData.DisplayValue ?? "")")
                if serviceTypeTF.text ?? "" == languageData.DisplayValue ?? "" {
                    self.serviceId = "\(languageData.SpecialityID ?? 0)"
                   
                }
            })
        }
        
       
        let userId = self.userID
        let authCode = self.authCodeTF.text ?? ""
        let newAuthCode = authCode.replacingOccurrences(of: "-OI", with: "-OIRC")
        
        let requestedOn = self.requestedONTF.text ?? ""
        
        self.jobType = "Onsite Interpretation"
        if blockedAppointmentArr.count == 0 {
            self.view.makeToast("Please fill  Details of atleast one Appointment.",duration: 1, position: .center)
            return
        }else {
             
            if self.blockedAppointmentArr.contains(where: {$0.languageID == 0 }){
                self.showAlertwithmessage(message: "Please fill Language name.")
            }else {
                self.hitApiCreateRequest(masterCustomerID: userId, authCode: newAuthCode, SpecialityID: self.specialityID, ServiceType: self.serviceId, startTime: "", endtime: "", gender: "" , caseNumber: "", clientName: "", clientIntial: "", location: "", textNote: "", SendingEndTimes: false, Travelling: "", CallTime: "", requestedOn: requestedOn, LoginUserId: userId, parameter: "srchString")
            }
        }
    }
    //MARK: - Select Type of Appointment method
    @IBAction func actionAddBlockedApt(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectRecurringDateVC") as! SelectRecurringDateVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
//        print("blocked Appointment Count ",blockedAppointmentArr.count)
//
//        var emptyField = ""
//        if self.blockedAppointmentArr.count < 4 {
//            if blockedAppointmentArr.allSatisfy({ BlockedAppointmentData in
//
//                if BlockedAppointmentData.languageID == 0 {
//                    print("language id not found at index \(BlockedAppointmentData.rowIndex)")
//                    emptyField = "Language"
//                    return false
//                }else if BlockedAppointmentData.venueID == "0" {
//                    print("venueID id not found \(BlockedAppointmentData.rowIndex)")
//                    emptyField = "venue"
//                    return false
//                }else if BlockedAppointmentData.venueID == "" {
//                    print("venueID id not found \(BlockedAppointmentData.rowIndex)")
//                    emptyField = "venue"
//                    return false
//                }else {
//                    //print("everythink okay , you can add Appointment.")
//                    return true
//                }
//            }){
//                let dateFormatterDate = DateFormatter()
//                dateFormatterDate.dateFormat = "MM/dd/yyyy"
//                let dateFormatterTime = DateFormatter()
//                dateFormatterTime.dateFormat = "h:mm a"
//                let currentDateTime = Date().nearestHour() ?? Date()
//                let endTimee = Date().adding(minutes: 120).nearestHour() ?? Date()
//
//                let itemA = BlockedAppointmentData(AppointmentDate: dateFormatterDate.string(from: currentDateTime), startTime: dateFormatterTime.string(from: currentDateTime), endTime: dateFormatterTime.string(from: endTimee), languageID: 0, genderID: "", clientName: "", ClientIntials: "", ClientRefrence: "", venueID: "", DepartmentID: 0, contactID: 0, location: "", SpecialNotes: "", rowIndex: blockedAppointmentArr.count, languageName: "",venueName: "", DepartmentName: "", genderType: "", conatctName: "", isVenueSelect: false , venueTitleName : "" , addressname : "" , cityName : "" , stateName : "" , zipcode: "",startTimeForPicker: Date() , endTimeForPicker: Date(), authCode: "")
//
//                  blockedAppointmentArr.append(itemA)
//               // let indexPath = IndexPath(row: self.blockedAppointmentArr.count-1, section: 0)
//                self.blockedAppointmentTV.reloadData()
//                //self.blockedAppointmentTV.scrollToRow(at: indexPath, at: .bottom, animated: true)
//
//                print("condition true ")
//            }else {
//
//                self.showAlertwithmessage(message: "Please fill \(emptyField) fields.")
//            }
//        }else {
//            self.showAlertwithmessage(message: "You cannot create more than 4 appointments.")
//        }

    }
    //MARK: - Action Venue options
    @IBAction func addOneTimeDepartment(_ sender: UIButton) {
        
            let type : [String : String] = ["actionType" : "OneTimeDepartment"]
            NotificationCenter.default.post(name: Notification.Name("selectActionType"), object: nil, userInfo: type)
            self.departmentOptionMajorView.isHidden = true
    }
    @IBAction func actionCloseDepartmentOption(_ sender: UIButton) {
        self.departmentOptionMajorView.isHidden = true
        
    }
    @IBAction func actionDeactivateDepartment(_ sender: UIButton) {
        
        
            let type : [String : String] = ["actionType" : "Deactivate"]
            NotificationCenter.default.post(name: Notification.Name("selectActionType"), object: nil, userInfo: type)
            self.departmentOptionMajorView.isHidden = true
        
        
        
        
        
        // 4 for deactivate Department
//        if  editDepartmentNameTF.text == ""{
//            self.view.makeToast("Please add Department Name. ")
//            return
//        } else {
//            //self.actionDepartmentType = 3
//            let departmentName = editDepartmentNameTF.text ?? ""
//           // self.addDepartmentData(Active: false, venueID: self.venueIDForDepartment, DepartmentName: departmentName, DeActive: true, departmentID: Int(self.departmentID) ?? 0)
//        }
    }
    
    @IBAction func actionActivateDepartment(_ sender: UIButton) {
        
       
            let type : [String : String] = ["actionType" : "Activate"]
            NotificationCenter.default.post(name: Notification.Name("selectActionType"), object: nil, userInfo: type)
            self.departmentOptionMajorView.isHidden = true
        
        
        
        
        
        // 3 for activate Department
//        if  editDepartmentNameTF.text == ""{
//            self.view.makeToast("Please add Department Name. ")
//            return
//        } else {
//
//            let departmentString = editDepartmentNameTF.text ?? ""
//
//            let departmentName = departmentString.replacingOccurrences(of: "(DeActivated)", with: "")
//            //self.addDepartmentData(Active: true, venueID: self.venueIDForDepartment, DepartmentName: departmentName, DeActive: false, departmentID: Int(self.departmentID) ?? 0)
//        }
    }
    @IBAction func actiopnDeleteDepartment(_ sender: UIButton) {
        
            let type : [String : String] = ["actionType" : "Delete"]
            NotificationCenter.default.post(name: Notification.Name("selectActionType"), object: nil, userInfo: type)
            self.departmentOptionMajorView.isHidden = true
       
        
       
    }
    
    @IBAction func actionEditDepartment(_ sender: UIButton) {
        
       
            let type : [String : String] = ["actionType" : "Edit"]
            NotificationCenter.default.post(name: Notification.Name("selectActionType"), object: nil, userInfo: type)
            self.departmentOptionMajorView.isHidden = true
       
    }
}
//MARK: - Api methoda
extension TelephonicRecurrenceNewVC{
    
        func getSubcustomerList(){
            if Reachability.isConnectedToNetwork() {
            SwiftLoader.show(animated: true)
            let urlString = APi.GetCustomerDetail.url
            let companyID = self.companyID//GetPublicData.sharedInstance.companyID
            let userID = self.userID//GetPublicData.sharedInstance.userID
            let userTypeId = self.userTypeID//GetPublicData.sharedInstance.userTypeID
            let searchString = "<INFO><COMPANYID>\(companyID)</COMPANYID><LOGINUSERID>\(userID)</LOGINUSERID><LOGINUSERTYPEID>\(userTypeId)</LOGINUSERTYPEID><USERTYPEID>10</USERTYPEID><CUSTOMERID>\(customerID)</CUSTOMERID><APPTYPE>1</APPTYPE><EDIT>1</EDIT></INFO>"
            let parameter = [
                "strSearchString" : searchString
            ] as [String : String]
            print("url and parameter for subcutomer Detail are ", urlString, parameter)
            AF.request(urlString, method: .post , parameters: parameter, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseData(completionHandler: { [self] (response) in
                    SwiftLoader.hide()
                    switch(response.result){
                        
                    case .success(_):
                        print("Respose Success getCustomerDetail ")
                        guard let daata = response.data else { return }
                        do {
                            let jsonDecoder = JSONDecoder()
                            self.apiGetCustomerDetailResponseModel = try jsonDecoder.decode([ApiGetCustomerDetailResponseModel].self, from: daata)
                            print("Success getCustomerDetail Model ",self.apiGetCustomerDetailResponseModel.first?.result ?? "")
                            let str = self.apiGetCustomerDetailResponseModel.first?.result ?? ""
                            let data = str.data(using: .utf8)!
                            do {
    //
                                print("DATAAA ISSS \(data)")
                                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                                {

                                    let newjson = jsonArray.first
                                    let userInfo = newjson?["Userdata"] as? [[String:Any]]
                                    //let statusInfo = newjson?["StatusInfo"] as? [[String:Any]] // use the json here
                                    
                                    userInfo?.forEach({ subcustomerData in
                                        let CustomerID = subcustomerData["CustomerID"] as? Int
                                        let Email = subcustomerData["Email"] as? String
                                        let MasterUsertype = subcustomerData["MasterUsertype"] as? Int
                                        let EmailToRequestor = subcustomerData["EmailToRequestor"] as? Int
                                        let PurchaseOrderNote = subcustomerData["PurchaseOrderNote"] as? String
                                        let UniqueID = subcustomerData["UniqueID"] as? Int
                                        let CustomerFullName = subcustomerData["CustomerFullName"] as? String
                                        let Priority = subcustomerData["Priority"] as? Int
                                        let CustomerUserName = subcustomerData["CustomerUserName"] as? String
                                        let Mobile = subcustomerData["Mobile"] as? String
                                   //  print("user sub customerlist \(userInfo), customerName is \(CustomerUserName)")
                                        
                                        let itemA = SubCustomerListData(UniqueID: UniqueID ?? 0, Email: Email ?? "", CustomerUserName: CustomerUserName ?? "", Priority: Priority ?? 0, MasterUsertype: MasterUsertype ?? 0, Mobile: Mobile ?? "", PurchaseOrderNote: PurchaseOrderNote ?? "", CustomerID: CustomerID ?? 0, CustomerFullName: CustomerFullName ?? "", EmailToRequestor: EmailToRequestor ?? 0)
                                        self.subcustomerArr.append(CustomerFullName ?? "")
                                        self.subcustomerList.append(itemA)
                                    })
                                   
                                    showSubcustomerDropDown()
                                } else {
                                    print("bad json")
                                }
                            } catch let error as NSError {
                                print(error)
                            }
                        } catch{
                            
                            print("error block getCustomerDetail " ,error)
                        }
                    case .failure(_):
                        print("Respose getCustomerDetail ")
                        
                    }
                })}
                else {
                    self.view.makeToast(ConstantStr.noItnernet.val)
                }
        }
        func getCustomerDetail(){
            if Reachability.isConnectedToNetwork() {
            SwiftLoader.show(animated: true)
            let urlString = APi.GetCustomerDetail.url
            let companyID = self.companyID//GetPublicData.sharedInstance.companyID
            let userID = self.userID//GetPublicData.sharedInstance.userID
            let userTypeId = self.userTypeID//GetPublicData.sharedInstance.userTypeID
            let searchString = "<INFO><COMPANYID>\(companyID)</COMPANYID><LOGINUSERID>\(userID)</LOGINUSERID><LOGINUSERTYPEID>\(userTypeId)</LOGINUSERTYPEID><USERTYPEID>\(userTypeId)</USERTYPEID><APPTYPE>1</APPTYPE><EDIT>1</EDIT><AUTHFLAG>2</AUTHFLAG></INFO>"
            let parameter = [
                "strSearchString" : searchString
            ] as [String : String]
            print("url and parameter for customer Detail are ", urlString, parameter)
            AF.request(urlString, method: .post , parameters: parameter, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseData(completionHandler: { [self] (response) in
                    SwiftLoader.hide()
                    switch(response.result){
                        
                    case .success(_):
                        print("Respose Success getCustomerDetail ")
                        guard let daata = response.data else { return }
                        do {
                            let jsonDecoder = JSONDecoder()
                            self.apiGetCustomerDetailResponseModel = try jsonDecoder.decode([ApiGetCustomerDetailResponseModel].self, from: daata)
                            print("Success getCustomerDetail Model ",self.apiGetCustomerDetailResponseModel.first?.result ?? "")
                            let str = self.apiGetCustomerDetailResponseModel.first?.result ?? ""
                            let data = str.data(using: .utf8)!
                            do {
    //
                                print("DATAAA ISSS \(data)")
                                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                                {

                                    let newjson = jsonArray.first
                                    let userInfo = newjson?["Userdata"] as? [[String:Any]]
                                    //let statusInfo = newjson?["StatusInfo"] as? [[String:Any]] // use the json here
                                    let userIfo = userInfo?.first
                                    let customerUserName = userIfo?["CustomerUserName"] as? String
                                    let customerEmail = userIfo?["Email"] as? String
                                    let customerFullName = userIfo?["CustomerFullName"] as? String
                                    let customerID = userIfo?["CustomerID"] as? Int
                                    self.customerID = "\(customerID ?? 0)"
                                    GetPublicData.sharedInstance.TempCustomerID = "\(customerID ?? 0)"
                                   // print("userInfo ", userInfo,customerUserName , customerEmail , customerFullName)
                                   // getVenueDetail()
                                    getSubcustomerList()
                                    self.customerNameTF.text = customerFullName
                                    self.subCustomerNameTF.text = ""
                                    if (userID == "10") || (userID == "7") || (userID == "8") || (userID == "11") {
                                        self.subCustomerNameTF.isUserInteractionEnabled = false
                                    }else {
                                        self.subCustomerNameTF.isUserInteractionEnabled = true
                                    }
                                    
                                    //    updateUI(customerName: customerFullName ?? "", subcustomerName: "Select Subcustomer Name")
                                } else {
                                    print("bad json")
                                }
                            } catch let error as NSError {
                                print(error)
                            }
                        } catch{
                            
                            print("error block getCustomerDetail " ,error)
                        }
                    case .failure(_):
                        print("Respose getCustomerDetail ")
                        
                    }
                })}
                else {
                    self.view.makeToast(ConstantStr.noItnernet.val)
                }
        }
     
        func getCommonDetail(){
            if Reachability.isConnectedToNetwork() {
            SwiftLoader.show(animated: true)
            self.specialityArray.removeAll()
            self.specialityDetail.removeAll()
            self.serviceDetail.removeAll()
            self.serviceArr.removeAll()
           
            self.languageArray.removeAll()
           
            self.genderArray.removeAll()
           
            let urlString = APi.GetCommonDetail.url
            let companyID = self.companyID//GetPublicData.sharedInstance.companyID
            let userID = userDefaults.string(forKey: "userId") ?? ""//GetPublicData.sharedInstance.userID
            let userTypeId = self.userTypeID//GetPublicData.sharedInstance.userTypeID
            let searchString = "<INFO><COMPANYID>\(companyID)</COMPANYID><LOGINUSERID>\(userID)</LOGINUSERID><LOGINUSERTYPEID>\(userTypeId)</LOGINUSERTYPEID><AUTHFLAG>2</AUTHFLAG><JobtypeID>1</JobtypeID></INFO>"
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
                                    let getAuthCode = newjson?["GetAuthCode"] as? [[String:Any]]
                                    let SpecialityList = newjson?["SpecialityList"] as? [[String:Any]]// use the json here ServiceTypeList
                                    let serviceTypeList = newjson?["ServiceTypeList"] as? [[String:Any]]
                                    let languageList = newjson?["LanguageList"] as? [[String:Any]]
                                    
                                    let AppointmentStatus = newjson?["AppointmentStatus"] as? [[String:Any]]
                                    let stateList = newjson?["Statelist"] as? [[String:Any]]
                                    let vendorRanking = newjson?["VendorRanking"] as? [[String:Any]]
                                    let travelMiles = newjson?["TravelMiles"] as? [[String:Any]]
                                    let companyData = newjson?["CompanyData"] as? [[String:Any]]
                                    
                                    let getAuthCodeDetail = getAuthCode?.first
                                    let authcode = getAuthCodeDetail?["authcode"] as? String
                                    let appointmentid = getAuthCodeDetail?["appointmentid"] as? String
                                   
                                    print("get AuthCode Detail Info ", SpecialityList,serviceTypeList ,languageList,AppointmentStatus , stateList , vendorRanking , travelMiles, companyData)
                                    
                                    let dateFormatterDate = DateFormatter()
                                    dateFormatterDate.dateFormat = "MM/dd/yyyy"
                                    let dateFormatterTime = DateFormatter()
                                    dateFormatterTime.dateFormat = "h:mm a"
                                    let currentDateTime = Date().nearestHour() ?? Date()
                                    print("current time before \(currentDateTime)")
                                    let tempTime = dateFormatterTime.string(from: currentDateTime)
                                    print("TEMP TIME : \(tempTime)")
                                    
                                   
                                    
                                    let endTimee = Date().adding(minutes: 120).nearestHour() ?? Date()
                                    let authCodeNew = "\(authcode ?? "")-1"
                                    let itemA = BlockedAppointmentData(AppointmentDate: dateFormatterDate.string(from: currentDateTime), startTime: dateFormatterTime.string(from: currentDateTime), endTime: dateFormatterTime.string(from: endTimee), languageID: 0, genderID: "", clientName: "", ClientIntials: "", ClientRefrence: "", venueID: "", DepartmentID: 0, contactID: 0, location: "", SpecialNotes: "", rowIndex: 0, languageName: "",venueName: "", DepartmentName: "", genderType: "", conatctName: "", isVenueSelect: false, venueTitleName : "" , addressname : "" , cityName : "" , stateName : "" , zipcode: "",startTimeForPicker: Date() , endTimeForPicker: Date(), authCode: authCodeNew,showClientName: "" , showClientIntials:"" , showClientRefrence: "")
                                    
                                    blockedAppointmentArr.append(itemA)
                                    
                                    SpecialityList?.forEach({ specialData in
                                        let specialityID = specialData["SpecialityID"] as? Int
                                        let DisplayValue = specialData["DisplayValue"] as? String
                                        let Duration = specialData["Duration"] as? Int
                                        //print("specialityID : \(specialityID) \n  DisplayValue : \(DisplayValue) \n  Duration : \(Duration) \n")
                                        let ItemA = SpecialityData(SpecialityID: specialityID ?? 0 , DisplayValue: DisplayValue ?? "", Duration: Duration ?? 0)
                                        specialityDetail.append(ItemA)
                                        specialityArray.append(DisplayValue ?? "")
                                    })
                                    
                                    
                                    serviceTypeList?.forEach({ specialData in
                                        let specialityID = specialData["SpecialityID"] as? Int
                                        let DisplayValue = specialData["DisplayValue"] as? String
                                        let Duration = specialData["Duration"] as? Int
                                        //print("specialityID : \(specialityID) \n  DisplayValue : \(DisplayValue) \n  Duration : \(Duration) \n")
                                        let ItemA = ServiceData(SpecialityID: specialityID ?? 0 , DisplayValue: DisplayValue ?? "", Duration: Duration ?? 0)
                                        serviceDetail.append(ItemA)
                                        serviceArr.append(DisplayValue ?? "")
                                    })
                                    languageList?.forEach({ languageData in
                                        let languageName = languageData["LanguageName"] as? String
                                        let languageID = languageData["LanguageID"] as? Int
                                        let rate = languageData["Rate"] as? Double
                                        let ItemA = LanguageData(languageID: languageID ?? 0, languageName: languageName ?? "", rate: rate)
                                        self.languageArray.append(languageName ?? "")
                                       
                                        
                                    })
                                    print("Language Array from common ",languageArray)
                                    print(specialityArray)
                                   
                                    updateServiceAndSpeciality()
                                    self.authCodeTF.text = authcode?.replacingOccurrences(of: "-OI", with: "-OIRC") ?? ""
                                    self.authCode = authcode?.replacingOccurrences(of: "-OI", with: "-OIRC") ?? ""
                                    self.jobTypeTF.text = "Telephone Conference"
                                    DispatchQueue.main.async {
                                        self.recuringAppointmentTV.reloadData()
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
        func hitApiCreateRequest(masterCustomerID : String,authCode :String , SpecialityID: String, ServiceType : String, startTime : String , endtime : String, gender : String , caseNumber : String, clientName :String, clientIntial: String, location : String , textNote : String,SendingEndTimes:Bool, Travelling: String, CallTime:String , requestedOn : String , LoginUserId: String , parameter : String){
            if Reachability.isConnectedToNetwork() {
            SwiftLoader.show(animated: true)
            // start time 01/10/2022 3:00 PM
            //end time  01/10/2022 5:00 PM
            //caseNumber = !=!enc!=!3zDmVRxZfFGKEYuhfLH2eg==
            //clientName !=!enc!=!zU1WqmB1oAz4eTSjWS+okA==
            //clientintial !=!enc!=!Gtw5BSTuJr7hSqaNje7nyg==
            // call time  01/10/2022 12:00 AM
            // requested on 01/10/2022 03:14 PM
            let urlString = APi.tladdupdateappointment.url
            let companyID = self.companyID//GetPublicData.sharedInstance.companyID
            let userID = self.userID//GetPublicData.sharedInstance.userID
            let userTypeId = self.userTypeID//GetPublicData.sharedInstance.userTypeID
            let arrayValue = self.blockedAppointmentArr.first
                let startTime = "\(arrayValue?.AppointmentDate ?? "") \(arrayValue?.startTime ?? "")"
                let endTime = "\(arrayValue?.AppointmentDate ?? "") \(arrayValue?.endTime ?? "")"
                print("auth code is \(arrayValue?.authCode ?? "")")
                let prefixSrch = "<INFO><CustomerUserID>0</CustomerUserID><Action>A</Action><AppointmentID>0</AppointmentID><CustomerID>\(self.customerID)</CustomerID><Company>\(companyID)</Company><MasterCustomerID>\(masterCustomerID)</MasterCustomerID><AppointmentTypeID>2</AppointmentTypeID><AuthCode>\(arrayValue?.authCode ?? "")</AuthCode><SpecialityID>\(SpecialityID)</SpecialityID><ServiceType>\(ServiceType)</ServiceType><StartDateTime>\(startTime)</StartDateTime><EndDateTime>\(endtime)</EndDateTime><Distance>0.0</Distance><AppointmentFlag>RC</AppointmentFlag><LanguageID>\(arrayValue?.languageID ?? 0)</LanguageID><Gender>\(arrayValue?.genderID ?? "" )</Gender><CaseNumber>\(arrayValue?.ClientRefrence ?? "")</CaseNumber><ClientName>\(arrayValue?.clientName ?? "")</ClientName><cPIntials>\(arrayValue?.ClientIntials ?? "")</cPIntials><VenueID></VenueID><VendorID></VendorID><DepartmentID></DepartmentID><ProviderID>\(arrayValue?.contactID ?? 0)</ProviderID><Location>\(arrayValue?.location ?? "")</Location><Text>\(arrayValue?.SpecialNotes ?? "")</Text><SendingEndTimes>false</SendingEndTimes><AptDetails></AptDetails><FinancialNotes></FinancialNotes><ScheduleNotes></ScheduleNotes><AppointmentStatusID>2</AppointmentStatusID><Travelling>\(Travelling)</Travelling><Ranking></Ranking><ConfirmationBit>false</ConfirmationBit><VendorMileage>false</VendorMileage><Priority>false</Priority><CallServiceBit>false</CallServiceBit><Office></Office><Home></Home><Cell></Cell><Purpose></Purpose><CallTime>\(CallTime)</CallTime><AdditionTravelTimePay>00:00</AdditionTravelTimePay><ArrivalTime></ArrivalTime><DepartureTime></DepartureTime><RequestedOn>\(requestedOn)</RequestedOn><ConfirmedOn></ConfirmedOn><BookedOn></BookedOn><CancelledOn></CancelledOn><RequestedBy></RequestedBy><ConfirmedBy></ConfirmedBy><BookedBy></BookedBy><CancelledBy></CancelledBy><LoadedBy>\(userID)</LoadedBy><RequestorName></RequestorName><MgemilRist>false</MgemilRist><isChanged>false</isChanged><oneHremail></oneHremail><LoginUserId>\(LoginUserId)</LoginUserId><ReasonforBotch></ReasonforBotch><PurchaseOrder></PurchaseOrder><Claim></Claim><Reference></Reference><SecurityClearence></SecurityClearence><ExperienceOfVendor></ExperienceOfVendor><InterpreterType></InterpreterType><AssignToFieldStaff></AssignToFieldStaff><RequestorName></RequestorName><RequestorEmail></RequestorEmail><TierName>W</TierName><WaitingList></WaitingList><overrideSatus></overrideSatus><overrideauth></overrideauth><InterpreterBookedId></InterpreterBookedId><RECURRAPPOINTMENT>"
                var middelePart = ""
                for (indexx, AptData) in blockedAppointmentArr.enumerated(){
                    if indexx == 0 {
                        
                    }else {
                        AptData.authCode = "\(authCode)-\(indexx + 1)"
                        let languageID = AptData.languageID ?? 0
                        let departmentID = AptData.DepartmentID ?? 0
                        let contactID = AptData.contactID ?? 0
                        let startTime = "\(AptData.AppointmentDate ?? "") \(AptData.startTime ?? "")"
                        let EndTime = "\(AptData.AppointmentDate ?? "") \(AptData.endTime ?? "")"
                        var vID = ""
                        var lID = ""
                        var cID = ""
                        if languageID == 0 {
                            lID = ""
                        }else {
                            lID = "\(languageID)"
                        }
                        if departmentID == 0 {
                            vID = ""
                        }else {
                            vID = "\(departmentID)"
                        }
                        if contactID == 0 {
                            cID = ""
                        }else {
                            cID = "\(contactID)"
                        }
                        let AptString = "<RECURRAPPOINTMENT><AuthCode>\(AptData.authCode ?? "")</AuthCode><StartDateTime>\(startTime)</StartDateTime><EndDateTime>\(endtime)</EndDateTime><LanguageID>\(lID)</LanguageID><CaseNumber>\( AptData.ClientRefrence ?? "")</CaseNumber><ClientName>\(AptData.clientName ?? "")</ClientName><cPIntials>\(AptData.ClientIntials ?? "")</cPIntials><VenueID>\(AptData.venueID ?? "")</VenueID><DepartmentID>\(vID)</DepartmentID><ProviderID>\(cID)</ProviderID><SendingEndTimes>false</SendingEndTimes><Location>\(AptData.location ?? "")</Location><Text>\(AptData.SpecialNotes ?? "")</Text><AptDetails></AptDetails><FinancialNotes></FinancialNotes><ScheduleNotes></ScheduleNotes><aPVenueID></aPVenueID><Active></Active></RECURRAPPOINTMENT>"
                         middelePart = middelePart + AptString
                    }
                }
                let postFixSrch = "</RECURRAPPOINTMENT></INFO>"
                let searchString = prefixSrch + middelePart + postFixSrch
            
            let parameter = [
                "strSearchString" : searchString
            ] as [String : String]
            print("url and parameter for customer Detail are ", urlString, parameter)
            AF.request(urlString, method: .post , parameters: parameter, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseData(completionHandler: { [self] (response) in
                    SwiftLoader.hide()
                    switch(response.result){
                        
                    case .success(_):
                        print("Respose Success getCustomerDetail ")
                        guard let daata = response.data else { return }
                        do {
                            let jsonDecoder = JSONDecoder()
                            self.apiGetCustomerDetailResponseModel = try jsonDecoder.decode([ApiGetCustomerDetailResponseModel].self, from: daata)
                            print("Success getCustomerDetail Model ",self.apiGetCustomerDetailResponseModel.first?.result ?? "")
                            let str = self.apiGetCustomerDetailResponseModel.first?.result ?? ""
                            let data = str.data(using: .utf8)!
                            do {
    //
                                print("DATAAA ISSS \(data)")
                                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                                {

                                    let newjson = jsonArray.first
                                    let userInfo = newjson?["AppointmentResponce"] as? [[String:Any]]
                                    //let statusInfo = newjson?["StatusInfo"] as? [[String:Any]] // use the json here
                                    let userIfo = userInfo?.first
                                    let AppointmentID = userIfo?["AppointmentID"] as? Int
                                    let success = userIfo?["success"] as? Int
                                    let Message = userIfo?["Message"] as? String
                                    let AuthCode = userIfo?["AuthCode"] as? String
                                  
                                    if success == 1 {
                                        self.view.makeToast(Message,duration: 1, position: .center)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                    }else {
                                        self.view.makeToast("Please try after sometime.",duration: 1, position: .center)
                                    }
                                    
                                    
                                } else {
                                    print("bad json")
                                }
                            } catch let error as NSError {
                                print(error)
                            }
                        } catch{
                            
                            print("error block getCustomerDetail " ,error)
                        }
                    case .failure(_):
                        print("Respose getCustomerDetail ")
                        
                    }
                })}
            else {
                self.view.makeToast(ConstantStr.noItnernet.val)
            }
        }
    func hitApiEncryptValue(value : String , encryptedValue : @escaping(Bool? , String?) -> ()){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
        
        let urlString = APi.encryptdecryptvalue.url
        let companyID = self.companyID//GetPublicData.sharedInstance.companyID
        let userID = self.userID//GetPublicData.sharedInstance.userID
        let userTypeId = self.userTypeID//GetPublicData.sharedInstance.userTypeID
    
        let parameter = [
            "value": value, "key": "Ecrpt"
        ] as [String : Any]
        print("url and parameter apiEncryptedDataResponse ", urlString, parameter)
        AF.request(urlString, method: .post , parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success apiEncryptedDataResponse ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiEncryptedDataResponse = try jsonDecoder.decode(ApiEncryptedDataResponse.self, from: daata)
                        print("Success apiEncryptedDataResponse Model ",self.apiEncryptedDataResponse)
                        let encrypValue = self.apiEncryptedDataResponse?.value ?? ""
                        encryptedValue(true , encrypValue)
                        
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
//MARK: - Recurring Table work
extension TelephonicRecurrenceNewVC : UITableViewDelegate , UITableViewDataSource , TelephonicSaveBookedAppointmentData  , ReloadBlockedTable{
    

    func showAlertWithMessageInTable(message: String) {
        self.showAlertwithmessage(message: message)
    }
    
    
     
    func didopenMoreoption(action : Bool , type : String) {
         
        if type == "Contact" {
            self.departmentOptionMajorView.isHidden = false
            self.optiontitleLbl.text = "Contact"
            self.isContactOption = true
            self.activateOptionView.visibility = .gone
            self.DeactivateOptionView.visibility = .gone
        }else {
            self.departmentOptionMajorView.isHidden = false
            self.optiontitleLbl.text = "Department"
            self.isContactOption = false
            self.activateOptionView.visibility = .visible
            self.DeactivateOptionView.visibility = .visible
        }
    
    }
    
    func didReloadTable(performTableReload: Bool) {
        if performTableReload {
            self.recuringAppointmentTV.reloadData()
        }else {
            
        }
    }
    
    
    func didSave(_ class: TelephonicAppointmentTVCell, flag: Bool, AppointmentDate: String, index: Int, startTime: String, EndTime: String, languageID: Int, GenderID: String, ClientName: String, clientIntials: String, clientRefrence: String, venueID: String, departmentID: Int, contactID: Int, location: String, Notes: String, isAppointmentDateSelect: Bool, isStartTimeSelect: Bool, isEndtimeSelect: Bool , languageName: String ,venueName: String, DepartmentName: String, genderType: String, conatctName: String, isVenueSelect: Bool,venueTitleName: String, addressname: String, cityName: String, stateName: String, zipcode: String,startTimeForPicker: Date , endTimeForPicker: Date,isproviderSelect: Bool, isDepartmentSlecet: Bool, isLanguageSelect: Bool, isgenderSelect: Bool, isCleintNameEnterd: Bool, isClientRefrenceEnyterd: Bool, IsNotesEntered: Bool, isLocationEneterd: Bool,isvenueFlag : Bool) {
        
        print("Delegate  working \(languageID)")
        print("DATA IS THERE \(languageID)on index ")
    let BookedAppoinmentData = BlockedAppointmentData(AppointmentDate: AppointmentDate, startTime: startTime, endTime: EndTime, languageID: languageID, genderID: GenderID, clientName: ClientName, ClientIntials: clientIntials, ClientRefrence: clientRefrence, venueID: venueID, DepartmentID: departmentID, contactID: contactID, location: location, SpecialNotes: Notes, rowIndex: index, languageName: languageName,venueName: venueName, DepartmentName: DepartmentName, genderType: genderType, conatctName: conatctName, isVenueSelect: isVenueSelect,venueTitleName: venueTitleName, addressname: addressname, cityName: cityName, stateName: stateName, zipcode: zipcode,startTimeForPicker: Date() , endTimeForPicker: Date(), authCode: "",showClientName: ClientName , showClientIntials:clientIntials , showClientRefrence: clientRefrence)
        
           
        
        if self.blockedAppointmentArr.count == 0 {
            self.blockedAppointmentArr.append(BookedAppoinmentData)
        }else {
            
            if  self.blockedAppointmentArr.contains(where: {$0.rowIndex == index}) {
                //found
                print("DATA IN DELEGATE Index\(index)")
                print("DATA IN DELEGATE \(blockedAppointmentArr[index].rowIndex)")
                for itemm in self.blockedAppointmentArr {
                    print("Deparment key for testing \(itemm.DepartmentName)")
                    if itemm.rowIndex == index {
                        
                        if isDepartmentSlecet {
                            itemm.DepartmentID = departmentID//BookedAppoinmentData.DepartmentID
                            itemm.DepartmentName = DepartmentName//BookedAppoinmentData.DepartmentName
                        }else if isproviderSelect {
                            itemm.contactID = contactID//BookedAppoinmentData.contactID
                            itemm.conatctName = conatctName//BookedAppoinmentData.conatctName
                        }else if isgenderSelect {
                            itemm.genderID = GenderID//BookedAppoinmentData.genderID
                            itemm.genderType = genderType//BookedAppoinmentData.genderType
                        }else if isClientRefrenceEnyterd{
                            itemm.ClientRefrence = clientRefrence//BookedAppoinmentData.ClientRefrence
                            itemm.showClientRefrence = clientRefrence//BookedAppoinmentData.ClientRefrence
                        }else if isCleintNameEnterd {
                            itemm.clientName = ClientName//BookedAppoinmentData.clientName
                            itemm.ClientIntials = clientIntials//BookedAppoinmentData.ClientIntials
                            itemm.showClientName = ClientName//BookedAppoinmentData.clientName
                            itemm.showClientIntials = clientIntials//BookedAppoinmentData.ClientIntials ?? ""
                        }else if isLocationEneterd {
                            itemm.location = location//BookedAppoinmentData.location
                        }else if IsNotesEntered {
                            itemm.SpecialNotes = Notes//BookedAppoinmentData.SpecialNotes
                        }else if isvenueFlag {
                            itemm.isVenueSelect = isVenueSelect//BookedAppoinmentData.isVenueSelect
                            itemm.venueName = venueName//BookedAppoinmentData.venueName
                            itemm.venueID = venueID//BookedAppoinmentData.venueID
                            itemm.venueTitleName = venueName//BookedAppoinmentData.venueTitleName
                            itemm.addressname = addressname //BookedAppoinmentData.addressname
                            itemm.cityName = cityName//BookedAppoinmentData.cityName
                            itemm.stateName = stateName//BookedAppoinmentData.stateName
                            itemm.zipcode = zipcode//BookedAppoinmentData.zipcode
                        }else if isLanguageSelect{
                            itemm.languageID = languageID//BookedAppoinmentData.languageID
                            itemm.languageName = languageName//BookedAppoinmentData.languageName
                        }else {
                            print("field not found ")
                        }
                    }else {
                        print("Index not found ")
                    }
                   
                }
            }else {
                // not found
                print("new entry append ")
                self.blockedAppointmentArr.append(BookedAppoinmentData)
            }

        }
        if isCleintNameEnterd {
            for item in blockedAppointmentArr {
                if item.rowIndex == index {
                    hitApiEncryptValue(value: item.clientName ?? "") { completionc, encrptValue in
                        if completionc ?? false {
                            item.clientName = encrptValue
                            print("encryptedValue ",item.ClientRefrence  )
                        }
                    }
                    
                    
                    hitApiEncryptValue(value: item.ClientIntials ?? "") { completionc, encrptValue in
                        if completionc ?? false {
                            item.ClientIntials = encrptValue
                            print("encryptedValue ",item.ClientRefrence  )
                        }
                    }
                    
                }
            }
         }else if isClientRefrenceEnyterd {
             for item in blockedAppointmentArr {
                 if item.rowIndex == index {
                     hitApiEncryptValue(value: item.ClientRefrence ?? "") { completionc, encrptValue in
                         if completionc ?? false {
                             item.ClientRefrence = encrptValue
                             print("encryptedValue ",item.ClientRefrence  )
                         }
                     }
                 }
             }
         }
   // let newIndexPath = IndexPath(row: index, section: 0)
   // self.blockedAppointmentTV.reloadRows(at: [newIndexPath], with: .automatic)
    
}
    
    func showAlertwithmessage(message :String){
        print("Alert printing ")
        let  refreshAlert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    print("Handle Ok logic here")
                   
                  }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blockedAppointmentArr.count //blockedAtCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TelephonicAppointmentTVCell", for: indexPath) as! TelephonicAppointmentTVCell
        cell.AppointmentTitleLbl.text = "Appointment (\(self.authCode)-\(indexPath.row + 1))"
        cell.appointmentCancelBtn.tag = indexPath.row
        cell.appointmentCancelBtn.addTarget(self, action: #selector(CancelApt), for: .touchUpInside)
        if indexPath.row == 0 {
            cell.cancelImg.isHidden = true
            cell.appointmentCancelBtn.isHidden = true
        }else {
            cell.cancelImg.isHidden = false
            cell.appointmentCancelBtn.isHidden = false
        }
        cell.appointmentDateBtn.tag = indexPath.row
        cell.appointmentDateBtn.addTarget(self, action: #selector(showAppointmentDate), for: .touchUpInside)
        
        cell.startTimebtn.tag = indexPath.row
        cell.startTimebtn.addTarget(self, action: #selector(showStartTime), for: .touchUpInside)
        
        cell.endTimeBtn.tag = indexPath.row
        cell.endTimeBtn.addTarget(self, action: #selector(showEndTime), for: .touchUpInside)
        
        
        
        cell.delegate = self
        cell.tableDelegate = self
        
        
        let aptNumber = indexPath.row + 1
       // cell.AppointmentTitleLbl.text = "Appointment \(aptNumber)"
        
        let BlockedData = self.blockedAppointmentArr[indexPath.row]
        cell.rowIndex = BlockedData.rowIndex ?? 0
        cell.appointmentDateTF.text = BlockedData.AppointmentDate
        cell.startTimeTf.text = BlockedData.startTime
        cell.endTimeTF.text = BlockedData.endTime
        cell.languageTF.text = BlockedData.languageName
        cell.genderTF.text = BlockedData.genderType
        cell.clientNameTF.text = BlockedData.showClientName
        cell.clientIntiaalTF.text = BlockedData.showClientIntials
        cell.clientRefrenceTF.text = BlockedData.showClientRefrence
        print("venue name \(BlockedData.venueName)")
        
        cell.selectContactTF.text = BlockedData.conatctName
        cell.locationTF.text = BlockedData.location
        cell.specialNoteTf.text = BlockedData.SpecialNotes
        
        return cell
        
    }
    @objc func actionAddVenueBtn(sender : UIButton){
        let vc = storyboard?.instantiateViewController(identifier: "AddNewVenueViewController") as! AddNewVenueViewController
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        
    }
    @objc func showAppointmentDate(sender : UIButton){
        //textfield.endEditing(true)
        let cell = recuringAppointmentTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! TelephonicAppointmentTVCell
        
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .date, minDate: Date(), maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            print("selected startDat e",selectedDate)
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            cell.appointmentDateTF.text = roundoff.dateString("MM/dd/YYYY")
           
            self?.blockedAppointmentArr.forEach({ BlockedAppointmentData in
                
                if BlockedAppointmentData.rowIndex == sender.tag {
                    BlockedAppointmentData.AppointmentDate = roundoff.dateString("MM/dd/YYYY")
                    print("appointment date ",BlockedAppointmentData.AppointmentDate, BlockedAppointmentData.rowIndex)
                }
            })
        })
    }
    @objc func showStartTime(sender : UIButton){
        var selectedDateforPicker = self.blockedAppointmentArr[sender.tag].startTimeForPicker ?? Date()
        let cell = recuringAppointmentTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! TelephonicAppointmentTVCell
        let minDate = Date().dateByAddingYears(-5)
        RPicker.selectDate(title: "Select Start Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectedDateforPicker, minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.blockedAppointmentArr[sender.tag].startTimeForPicker = selectedDate
            self?.blockedAppointmentArr[sender.tag].endTimeForPicker = selectedDate.adding(minutes: 120)
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            let endTimee = roundoff.adding(minutes: 120)
            self?.blockedAppointmentArr[sender.tag].startTimeForPicker = selectedDate

                print("do nothing")
                cell.startTimeTf.text = roundoff.dateString("hh:mm a")
                 
                cell.endTimeTF.text = endTimee.dateString("hh:mm a")
                if self?.blockedAppointmentArr.count != 0 {
                    self?.blockedAppointmentArr.forEach({ BlockedAppointmentData in
                        if BlockedAppointmentData.rowIndex == sender.tag {
                            BlockedAppointmentData.startTime = roundoff.dateString("hh:mm a")
                            cell.startTime = roundoff.dateString("hh:mm a")
                        }
                    })
                }else {
                    
                }

            
            
        })
        
    }
    @objc func showEndTime(sender : UIButton){
       
        let cell = recuringAppointmentTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! TelephonicAppointmentTVCell
        var selectedDateforPicker = self.blockedAppointmentArr[sender.tag].endTimeForPicker ?? Date()
        let minDate = Date().dateByAddingYears(-5)
        RPicker.selectDate(title: "Select End Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectedDateforPicker,minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.blockedAppointmentArr[sender.tag].endTimeForPicker = selectedDate
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
           
            
                cell.endTimeTF.text = roundoff.dateString("hh:mm a")
                self?.blockedAppointmentArr.forEach({ BlockedAppointmentData in
                    if BlockedAppointmentData.rowIndex == sender.tag {
                        BlockedAppointmentData.endTime = roundoff.dateString("hh:mm a")
                        cell.endTime = roundoff.dateString("hh:mm a")
                    }
                })
        })
    }
    
    @objc func CancelApt(sender : UIButton){
        if  self.blockedAppointmentArr.count > 1{
            self.blockedAppointmentArr.forEach { abc in
                print("total row index ",abc.rowIndex)
            }
            if  self.blockedAppointmentArr.contains(where: {$0.rowIndex == sender.tag}){
                self.blockedAppointmentArr.remove(at: sender.tag)
            }else {
               
                print("no index found ")
            }
            
        }else {
            
        }
        self.recuringAppointmentTV.reloadData()
    }
    func timeConversion24(time12: String) -> String {
        let dateAsString = time12
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"

        let date = df.date(from: dateAsString)
        df.dateFormat = "HH:mm"

        let time24 = df.string(from: date!)
        //print(time24)
        return time24
    }
    
}
