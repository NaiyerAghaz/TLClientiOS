//
//  OnsiteBlockedAppointmentVC.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 04/03/22.
//

import UIKit
import Alamofire
import iOSDropDown
class OnsiteBlockedAppointmentVC: UIViewController {
    @IBOutlet weak var serviceTypeTF: iOSDropDown!
    @IBOutlet weak var specialityTF: iOSDropDown!
    @IBOutlet weak var jobTypeTF: UITextField!
    @IBOutlet weak var authCodeTF: UITextField!
    @IBOutlet weak var subCustomerNameTF: iOSDropDown!
    @IBOutlet weak var customerNameTF: UITextField!
    @IBOutlet weak var optiontitleLbl: UILabel!
    @IBOutlet weak var appointmentDateTF: UITextField!
    @IBOutlet weak var starttimeTF: UITextField!
    @IBOutlet weak var loadedOnTF: UITextField!
    @IBOutlet weak var cancelledOnTF: UITextField!
    @IBOutlet weak var bookedONTF: UITextField!
    @IBOutlet weak var requestedONTF: UITextField!
    @IBOutlet weak var departmentOptionView: UIView!
    @IBOutlet weak var departmentOptionMajorView: UIView!
    @IBOutlet weak var endTimeTF: UITextField!
    @IBOutlet weak var genderTF: iOSDropDown!
    @IBOutlet weak var languageTF: iOSDropDown!
    @IBOutlet weak var blockedAppointmentTV: UITableView!
    @IBOutlet weak var DeactivateOptionView: UIView!
    @IBOutlet weak var activateOptionView: UIView!
    
    var specialityDetail = [SpecialityData]()
    var serviceDetail = [ServiceData]()
    var serviceArr:[String] = []
    var specialityArray:[String] = []
    var languageArray:[String] = []
    var genderArray :[String] = []
    
    var genderDetail = [GenderData]()
    var subcustomerList = [SubCustomerListData]()
    var languageDetail = [LanguageData]()
    var subcustomerArr = [String]()
    var blockedAppointmentArr = [BlockedAppointmentData]()
    
    var selectTypeOFAppointment = "B"
    var languageID = "0"
    var serviceId = ""
    var specialityID = ""
    var genderID = ""
    var customerID = ""
    var languageName = ""
    var BlockedLanguage = ""
    var selectedStartTimeForPicker = Date().nearestHour()!
    var selectedEndTimeForPicker = Date().adding(minutes: 120).nearestHour()!
    
    var isGenderSelect = false
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
        
        self.blockedAppointmentTV.delegate = self
        self.blockedAppointmentTV.dataSource = self
        self.departmentOptionMajorView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.departmentOptionMajorView.isHidden = true
        self.departmentOptionView.layer.cornerRadius = 15
        self.departmentOptionView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        self.userID = userDefaults.string(forKey: "userId") ?? ""
        self.companyID = userDefaults.string(forKey: "companyID") ?? ""
        self.userTypeID = userDefaults.string(forKey: "userTypeID") ?? ""
        NotificationCenter.default.addObserver(self, selector: #selector(updateVenueList), name: Notification.Name("updateVenueList"), object: nil)
        
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "MM/dd/yyyy"
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "h:mm a"
        let currentDateTime = Date().nearestHour() ?? Date()
        print("current time before \(currentDateTime)")
        let tempTime = dateFormatterTime.string(from: currentDateTime)
        print("TEMP TIME : \(tempTime)")
        
        self.starttimeTF.text = dateFormatterTime.string(from: currentDateTime)
        
        let endTimee = Date().adding(minutes: 120).nearestHour() ?? Date()
        self.appointmentDateTF.text = dateFormatterDate.string(from: currentDateTime)
        self.endTimeTF.text = dateFormatterTime.string(from: endTimee)
        
        let dateFormatterr = DateFormatter()
        dateFormatterr.dateFormat = "MM/dd/yyyy h:mm a"
        let startDatee =  dateFormatterr.string(from: Date().nearestHour() ?? Date ())
        
        self.requestedONTF.text = dateFormatterr.string(from: Date())
        self.loadedOnTF.text = dateFormatterr.string(from: Date())
        
        getCommonDetail()
        getCustomerDetail()
        let itemA = BlockedAppointmentData(AppointmentDate: dateFormatterDate.string(from: currentDateTime), startTime: dateFormatterTime.string(from: currentDateTime), endTime: dateFormatterTime.string(from: endTimee), languageID: 0, genderID: "", clientName: "", ClientIntials: "", ClientRefrence: "", venueID: "", DepartmentID: 0, contactID: 0, location: "", SpecialNotes: "", rowIndex: 0, languageName: "",venueName: "", DepartmentName: "", genderType: "", conatctName: "", isVenueSelect: false, venueTitleName : "" , addressname : "" , cityName : "" , stateName : "" , zipcode: "",startTimeForPicker: Date() , endTimeForPicker: Date(), authCode: "",showClientName: "" , showClientIntials:"" , showClientRefrence: "")
        
        blockedAppointmentArr.append(itemA)
        
        // Do any additional setup after loading the view.
    }
    @objc func updateVenueList(){
       getCustomerDetail()
        
    }
    //MARK: - show  Drop downs
    
    func showGenderDropDown(){
        
        genderTF.optionArray = self.genderArray
        
        print("OPTIONS NEW ARRAY \(genderTF.optionArray)")
        
        genderTF.checkMarkEnabled = true
        genderTF.isSearchEnable = true
        genderTF.selectedRowColor = UIColor.clear
        genderTF.didSelect{(selectedText , index , id) in
            self.genderTF.text = "\(selectedText)"
            self.genderDetail.forEach({ languageData in
                print("gender data  \(languageData.Value ?? "")")
                if selectedText == languageData.Value ?? "" {
                    self.genderID = languageData.Code ?? ""
                    print("genderId \(self.genderID)")
                    self.isGenderSelect = true
                }
            })
        }
    }
    
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
    func showLnaguageDropdown(){
        self.languageTF.optionArray = self.languageArray
        print("OPTIONS ARRYA \(GetPublicData.sharedInstance.languageArray)")
        print("OPTIONS NEW ARRAY \(languageTF.optionArray)")
        languageTF.checkMarkEnabled = true
        languageTF.isSearchEnable = true
        languageTF.selectedRowColor = UIColor.clear
        languageTF.didSelect{(selectedText , index , id) in
            self.languageTF.text = "\(selectedText)"
            self.BlockedLanguage = "\(selectedText)"
            self.blockedAppointmentTV.reloadData()
            self.languageDetail.forEach({ languageData in
                print("language data.... \(languageData.languageName ?? "")")
                if selectedText == languageData.languageName ?? "" {
                    self.languageID = "\(languageData.languageID ?? 0)"
                    print("languageId \(self.languageID)")
                    self.languageName = languageData.languageName ?? ""
                    self.blockedAppointmentArr.forEach { BlockedAppointmentData in
                        BlockedAppointmentData.languageName = selectedText
                        BlockedAppointmentData.languageID = languageData.languageID ?? 0
                        print(BlockedAppointmentData.languageName, BlockedAppointmentData.languageID)
                    }
                    
                    
                    
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
        
       
        let selectedText = languageTF.text ?? ""
        GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
            print("language data abcd \(languageData.languageName ?? "")")
            if selectedText == languageData.languageName ?? "" {
                self.languageID = "\(languageData.languageID ?? 0)"
                print("languageId  abcd \(self.languageID)")
            }
        })
        if isGenderSelect {
            
        }else {
            self.genderDetail.forEach({ languageData in
                print("genderDetail data \(languageData.Value )")
                
                if genderTF.text ?? "" == languageData.Value {
                    self.genderID = languageData.Code
                   
                }
            })
        }
        
        
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
        let newAuthCode = authCode.replacingOccurrences(of: "-OI", with: "-OIBA")
        let startDate = "\(self.appointmentDateTF.text ?? "") \(self.starttimeTF.text ?? "")"
        let endDate = "\(self.appointmentDateTF.text ?? "") \(self.endTimeTF.text ?? "")"
        let requestedOn = self.requestedONTF.text ?? ""
        
        self.jobType = "Onsite Interpretation"
        
        if self.appointmentDateTF.text!.isEmpty {
            self.view.makeToast("Please fill Start Date.",duration: 1, position: .center)
            return
            
        }else if self.starttimeTF.text!.isEmpty {
            self.view.makeToast("Please fill Start Time.",duration: 1, position: .center)
            return
            
        }else if self.endTimeTF.text!.isEmpty {
            self.view.makeToast("Please fill End Time.",duration: 1, position: .center)
            return
            
        }else if self.languageID == "0" {
            self.view.makeToast("Please fill Language Detail.",duration: 1, position: .center)
            return
            
        }else if blockedAppointmentArr.count == 0 {
            self.view.makeToast("Please fill  Details of atleast one Appointment.",duration: 1, position: .center)
            return
        }else {
           
         
            
            self.hitApiCreateRequest(masterCustomerID: userId, authCode: newAuthCode, SpecialityID: self.specialityID, ServiceType: self.serviceId, startTime: startDate, endtime: endDate, gender: self.genderID , caseNumber: "", clientName: "", clientIntial: "", location: "", textNote: "", SendingEndTimes: false, Travelling: "", CallTime: "", requestedOn: requestedOn, LoginUserId: userId, parameter: "srchString")
            
        }
    }
    //MARK: - Select Type of Appointment method
    @IBAction func actionAddBlockedApt(_ sender: UIButton) {
        print("blocked Appointment Count ",blockedAppointmentArr.count)
       
        self.blockedAppointmentArr.forEach { BlockedAppointmentData in
            BlockedAppointmentData.languageName = self.BlockedLanguage
            BlockedAppointmentData.languageID = Int(self.languageID)
            print(BlockedAppointmentData.languageName, BlockedAppointmentData.languageID)
        }
        var emptyField = ""
        if self.blockedAppointmentArr.count < 4 {
            if blockedAppointmentArr.allSatisfy({ BlockedAppointmentData in
                
                if BlockedAppointmentData.languageID == 0 {
                    print("language id not found at index \(BlockedAppointmentData.rowIndex)")
                    emptyField = "Language"
                    return false
                }else if BlockedAppointmentData.venueID == "0" {
                    print("venueID id not found \(BlockedAppointmentData.rowIndex)")
                    emptyField = "venue"
                    return false
                }else if BlockedAppointmentData.venueID == "" {
                    print("venueID id not found \(BlockedAppointmentData.rowIndex)")
                    emptyField = "venue"
                    return false
                }else {
                    //print("everythink okay , you can add Appointment.")
                    return true
                }
            }){
                
                
                let nextstartTime = self.blockedAppointmentArr.last?.endTime
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                let item = "7:00 PM"
                let endDate = dateFormatter.date(from: nextstartTime ?? "")
                print("Start: \(endDate)")
                
                let dateFormatterDate = DateFormatter()
                dateFormatterDate.dateFormat = "MM/dd/yyyy"
                let dateFormatterTime = DateFormatter()
                dateFormatterTime.dateFormat = "h:mm a"
                let currentDateTime = endDate?.nearestHour() ?? Date()
                let endTimee = Date().adding(minutes: 120).nearestHour() ?? Date()
                let originalendTime = dateFormatterTime.string(from: endTimee)
                
                
                
                
                let itemA = BlockedAppointmentData(AppointmentDate: dateFormatterDate.string(from: currentDateTime), startTime: nextstartTime ?? "", endTime: originalendTime ?? "", languageID: Int(self.languageID) ?? 0, genderID: "", clientName: "", ClientIntials: "", ClientRefrence: "", venueID: "", DepartmentID: 0, contactID: 0, location: "", SpecialNotes: "", rowIndex: blockedAppointmentArr.count, languageName: self.languageName,venueName: "", DepartmentName: "", genderType: "", conatctName: "", isVenueSelect: false , venueTitleName : "" , addressname : "" , cityName : "" , stateName : "" , zipcode: "",startTimeForPicker: Date() , endTimeForPicker: Date(), authCode: "",showClientName: "" , showClientIntials:"" , showClientRefrence: "")
                
                  blockedAppointmentArr.append(itemA)
               // let indexPath = IndexPath(row: self.blockedAppointmentArr.count-1, section: 0)
                self.blockedAppointmentTV.reloadData()
                //self.blockedAppointmentTV.scrollToRow(at: indexPath, at: .bottom, animated: true)
                
                print("condition true ",itemA.rowIndex)
            }else {
               
                self.showAlertwithmessage(message: "Please fill \(emptyField) fields.")
            }
        }else {
            self.showAlertwithmessage(message: "You cannot create more than 4 appointments.")
        }
        
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
    
    //MARK: - Date time Method
    @IBAction func selectStartDate(_ sender: UIButton) {
        let minDate = Date().dateByAddingYears(-5)
        RPicker.selectDate(title: "Select Start Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectedStartTimeForPicker, minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.selectedStartTimeForPicker = selectedDate
            print("selectedStartTimeForPicker \(self?.selectedStartTimeForPicker)")
            self?.selectedEndTimeForPicker = selectedDate.adding(minutes: 120)
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            let endTimee = roundoff.adding(minutes: 120)
            self?.starttimeTF.text = roundoff.dateString("hh:mm a")
             
            self?.endTimeTF.text = endTimee.dateString("hh:mm a")
        })
        
    }
    @IBAction func selectEndTime(_ sender: UIButton) {
        let minDate = selectedStartTimeForPicker.adding(minutes: 120)//Date().adding(minutes: 120)
        RPicker.selectDate(title: "Select End Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectedEndTimeForPicker,minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.selectedEndTimeForPicker = selectedDate
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
           
            self?.endTimeTF.text = roundoff.dateString("hh:mm a")
        })
    }

    @IBAction func actionAppointmentDate(_ sender: UIButton) {
        //textfield.endEditing(true)
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .date, minDate: Date(), maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            print("selected startDat e",selectedDate)
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            self?.appointmentDateTF.text = roundoff.dateString("MM/dd/YYYY")
           
            
        })
    }
}
//MARK: - Api methoda
extension OnsiteBlockedAppointmentVC{
    
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
            self.languageDetail.removeAll()
            self.genderArray.removeAll()
            self.genderDetail.removeAll()
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
                                        self.languageDetail.append(ItemA)
                                        
                                    })
                                    let itemA = GenderData(Id: 19, Code: "M", Value: "Male", type: "Gender")
                                    let itemB = GenderData(Id: 18, Code: "F", Value: "Female", type: "Gender")
                                    let itemC = GenderData(Id: 28, Code: "NB", Value: "Non-binary", type: "Gender")
                                    genderDetail.append(itemA)
                                    genderDetail.append(itemB)
                                    genderDetail.append(itemC)
                                    genderDetail.forEach { GenderData in
                                        let name = GenderData.Value
                                        genderArray.append(name)
                                    }
                                    print("Language Array from common ",languageArray)
                                    print(specialityArray)
                                    showGenderDropDown()
                                    showLnaguageDropdown()
                                    updateServiceAndSpeciality()
                                    self.authCodeTF.text = authcode?.replacingOccurrences(of: "-OI", with: "-OIBA") ?? ""
                                    self.jobTypeTF.text = "Onsite Interpretation"
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
            
               
                let prefixSrch = "<INFO><CustomerUserID>0</CustomerUserID><Action>A</Action><AppointmentID>0</AppointmentID><CustomerID>\(companyID)</CustomerID><Company>\(companyID)</Company><MasterCustomerID>\(userID)</MasterCustomerID><AppointmentTypeID>1</AppointmentTypeID><AuthCode>\(authCode)</AuthCode><SpecialityID>\(SpecialityID)</SpecialityID><ServiceType>\(ServiceType)</ServiceType><StartDateTime>\(startTime)</StartDateTime><EndDateTime>\(endtime)</EndDateTime><Distance>0.00</Distance><AppointmentFlag>B</AppointmentFlag><LanguageID>\(self.languageID)</LanguageID><Gender>\(gender)</Gender><CaseNumber></CaseNumber><ClientName></ClientName><cPIntials></cPIntials><VenueID></VenueID><VendorID></VendorID><DepartmentID></DepartmentID><ProviderID></ProviderID><Location></Location><Text></Text><SendingEndTimes>false</SendingEndTimes><AptDetails></AptDetails><FinancialNotes></FinancialNotes><ScheduleNotes></ScheduleNotes><AppointmentStatusID>2</AppointmentStatusID><Travelling>\(Travelling)</Travelling><Ranking></Ranking><ConfirmationBit>false</ConfirmationBit><VendorMileage>false</VendorMileage><Priority>false</Priority><CallServiceBit>false</CallServiceBit><Office></Office><Home></Home><Cell></Cell><Purpose></Purpose><CallTime>\(CallTime)</CallTime><AdditionTravelTimePay>00:00</AdditionTravelTimePay><ArrivalTime></ArrivalTime><DepartureTime></DepartureTime><RequestedOn>\(requestedOn)</RequestedOn><ConfirmedOn></ConfirmedOn><BookedOn></BookedOn><CancelledOn></CancelledOn><RequestedBy>\(userID)</RequestedBy><ConfirmedBy></ConfirmedBy><BookedBy></BookedBy><CancelledBy></CancelledBy><LoadedBy>\(userID)</LoadedBy><RequestorName></RequestorName><MgemilRist>false</MgemilRist><isChanged>false</isChanged><oneHremail></oneHremail><LoginUserId>\(userID)</LoginUserId><ReasonforBotch></ReasonforBotch><PurchaseOrder></PurchaseOrder><Claim></Claim><Reference></Reference><SecurityClearence></SecurityClearence><ExperienceOfVendor></ExperienceOfVendor><InterpreterType></InterpreterType><AssignToFieldStaff></AssignToFieldStaff><RequestorName></RequestorName><RequestorEmail></RequestorEmail><TierName>W</TierName><WaitingList></WaitingList><overrideSatus></overrideSatus><overrideauth></overrideauth><SaveFlag>0</SaveFlag><SUBAPPOINTMENT>"
                var middelePart = ""
                
                blockedAppointmentArr.forEach { AptData in
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
                    let AptString = "<SUBAPPOINTMENT><StartDateTime>\(startTime)</StartDateTime><EndDateTime>\(endtime)</EndDateTime><LanguageID>\(lID)</LanguageID><CaseNumber>\( AptData.ClientRefrence ?? "")</CaseNumber><ClientName>\(AptData.clientName ?? "")</ClientName><cPIntials>\(AptData.ClientIntials ?? "")</cPIntials><VenueID>\(AptData.venueID ?? "")</VenueID><DepartmentID>\(vID)</DepartmentID><ProviderID>\(cID)</ProviderID><Location>\(AptData.location ?? "")</Location><Text>\(AptData.SpecialNotes ?? "")</Text><SendingEndTimes>false</SendingEndTimes><AptDetails></AptDetails><FinancialNotes></FinancialNotes><ScheduleNotes></ScheduleNotes><aPVenueID></aPVenueID><Active></Active></SUBAPPOINTMENT>"
                    middelePart = middelePart + AptString
                    print("Apt String -> ",AptString)
                }
                let postFixSrch = "</SUBAPPOINTMENT><InterpreterBookedId></InterpreterBookedId></INFO>"
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
