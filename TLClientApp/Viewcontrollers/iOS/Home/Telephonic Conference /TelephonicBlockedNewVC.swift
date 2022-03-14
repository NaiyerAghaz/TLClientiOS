//
//  TelephonicBlockedNewVC.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 04/03/22.
//

import UIKit
import Alamofire
import iOSDropDown
class TelephonicBlockedNewVC: UIViewController {
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
                
                
                
                
                let itemA = BlockedAppointmentData(AppointmentDate: dateFormatterDate.string(from: currentDateTime), startTime: nextstartTime ?? "", endTime: originalendTime, languageID: Int(self.languageID) ?? 0, genderID: "", clientName: "", ClientIntials: "", ClientRefrence: "", venueID: "", DepartmentID: 0, contactID: 0, location: "", SpecialNotes: "", rowIndex: blockedAppointmentArr.count, languageName: self.languageName,venueName: "", DepartmentName: "", genderType: "", conatctName: "", isVenueSelect: false , venueTitleName : "" , addressname : "" , cityName : "" , stateName : "" , zipcode: "",startTimeForPicker: Date() , endTimeForPicker: Date(), authCode: "",showClientName: "" , showClientIntials:"" , showClientRefrence: "")
                
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
extension TelephonicBlockedNewVC{
    
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
                                    self.authCodeTF.text = authcode?.replacingOccurrences(of: "-OI", with: "-OIBA") ??  ""
                                    self.jobTypeTF.text = "Telephone Conference"
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
            
               
                let prefixSrch = "<INFO><CustomerUserID>0</CustomerUserID><Action>A</Action><AppointmentID>0</AppointmentID><CustomerID>\(companyID)</CustomerID><Company>\(companyID)</Company><MasterCustomerID>\(userID)</MasterCustomerID><AppointmentTypeID>2</AppointmentTypeID><AuthCode>\(authCode)</AuthCode><SpecialityID>\(SpecialityID)</SpecialityID><ServiceType>\(ServiceType)</ServiceType><StartDateTime>\(startTime)</StartDateTime><EndDateTime>\(endtime)</EndDateTime><Distance>0.00</Distance><AppointmentFlag>B</AppointmentFlag><LanguageID>\(self.languageID)</LanguageID><Gender>\(gender)</Gender><CaseNumber></CaseNumber><ClientName></ClientName><cPIntials></cPIntials><VenueID></VenueID><VendorID></VendorID><DepartmentID></DepartmentID><ProviderID></ProviderID><Location></Location><Text></Text><SendingEndTimes>false</SendingEndTimes><AptDetails></AptDetails><FinancialNotes></FinancialNotes><ScheduleNotes></ScheduleNotes><AppointmentStatusID>2</AppointmentStatusID><Travelling>\(Travelling)</Travelling><Ranking></Ranking><ConfirmationBit>false</ConfirmationBit><VendorMileage>false</VendorMileage><Priority>false</Priority><CallServiceBit>false</CallServiceBit><Office></Office><Home></Home><Cell></Cell><Purpose></Purpose><CallTime>\(CallTime)</CallTime><AdditionTravelTimePay>00:00</AdditionTravelTimePay><ArrivalTime></ArrivalTime><DepartureTime></DepartureTime><RequestedOn>\(requestedOn)</RequestedOn><ConfirmedOn></ConfirmedOn><BookedOn></BookedOn><CancelledOn></CancelledOn><RequestedBy>\(userID)</RequestedBy><ConfirmedBy></ConfirmedBy><BookedBy></BookedBy><CancelledBy></CancelledBy><LoadedBy>\(userID)</LoadedBy><RequestorName></RequestorName><MgemilRist>false</MgemilRist><isChanged>false</isChanged><oneHremail></oneHremail><LoginUserId>\(userID)</LoginUserId><ReasonforBotch></ReasonforBotch><PurchaseOrder></PurchaseOrder><Claim></Claim><Reference></Reference><SecurityClearence></SecurityClearence><ExperienceOfVendor></ExperienceOfVendor><InterpreterType></InterpreterType><AssignToFieldStaff></AssignToFieldStaff><RequestorName></RequestorName><RequestorEmail></RequestorEmail><TierName>W</TierName><WaitingList></WaitingList><overrideSatus></overrideSatus><overrideauth></overrideauth><SaveFlag>0</SaveFlag><SUBAPPOINTMENT>"
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
                    let AptString = "<SUBAPPOINTMENT><StartDateTime>\(startTime)</StartDateTime><EndDateTime>\(endtime)</EndDateTime><LanguageID>\(lID)</LanguageID><CaseNumber>\( AptData.ClientRefrence ?? "")</CaseNumber><ClientName>\(AptData.clientName ?? "")</ClientName><cPIntials>\(AptData.ClientIntials ?? "")</cPIntials><VenueID></VenueID><DepartmentID></DepartmentID><ProviderID>\(cID)</ProviderID><Location>\(AptData.location ?? "")</Location><Text>\(AptData.SpecialNotes ?? "")</Text><SendingEndTimes>false</SendingEndTimes><AptDetails></AptDetails><FinancialNotes></FinancialNotes><ScheduleNotes></ScheduleNotes><aPVenueID></aPVenueID><Active></Active></SUBAPPOINTMENT>"
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
//MARK: - Table Work

extension TelephonicBlockedNewVC : UITableViewDelegate , UITableViewDataSource , TelephonicSaveBookedAppointmentData  , ReloadBlockedTable{
    
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
            self.blockedAppointmentTV.reloadData()
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
        print("DATA in CELL FOR ROW \(blockedAppointmentArr[indexPath.row])")
        cell.appointmentCancelBtn.tag = indexPath.row
        cell.appointmentCancelBtn.addTarget(self, action: #selector(CancelApt), for: .touchUpInside)
        if indexPath.row == 0 {
            cell.cancelImg.isHidden = true
            cell.appointmentCancelBtn.isHidden = true
        }else {
            cell.cancelImg.isHidden = false
            cell.appointmentCancelBtn.isHidden = false
        }
        cell.languageTF.isUserInteractionEnabled = false
       // cell.languageTF.arrowColor = UIColor.white
        cell.appointmentDateBtn.tag = indexPath.row
        cell.appointmentDateBtn.addTarget(self, action: #selector(showAppointmentDate), for: .touchUpInside)
        
        cell.startTimebtn.tag = indexPath.row
        cell.startTimebtn.addTarget(self, action: #selector(showStartTime), for: .touchUpInside)
        
        cell.endTimeBtn.tag = indexPath.row
        cell.endTimeBtn.addTarget(self, action: #selector(showEndTime), for: .touchUpInside)
        
        
        
        cell.delegate = self
        cell.tableDelegate = self
//        cell.addvenueBtn.tag = indexPath.row
//        cell.addvenueBtn.addTarget(self, action: #selector(actionAddVenueBtn), for: .touchUpInside)
        
        let aptNumber = indexPath.row + 1
        cell.AppointmentTitleLbl.text = "Appointment \(aptNumber)"
        
        let BlockedData = self.blockedAppointmentArr[indexPath.row]
        cell.rowIndex = BlockedData.rowIndex ?? 0
        cell.appointmentDateTF.text = BlockedData.AppointmentDate
        cell.startTimeTf.text = BlockedData.startTime
        cell.endTimeTF.text = BlockedData.endTime
        cell.languageTF.text = self.BlockedLanguage//BlockedData.languageName
        cell.genderTF.text = BlockedData.genderType
        cell.clientNameTF.text = BlockedData.showClientName
        cell.clientIntiaalTF.text = BlockedData.showClientIntials
        cell.clientRefrenceTF.text = BlockedData.showClientRefrence
        print("venue name  in  cell is \(BlockedData.venueName)")
        //cell.selectVenueTF.text = BlockedData.venueName
        print("department in cell  name \(BlockedData.DepartmentName)")
        //cell.selectDepartmentTF.text = BlockedData.DepartmentName
       // cell.selectContactTF.text = BlockedData.conatctName
        cell.locationTF.text = BlockedData.location
        cell.specialNoteTf.text = BlockedData.SpecialNotes
        //cell.venueNameLbl.text = BlockedData.venueTitleName
        //cell.addressnameLbl.text = BlockedData.addressname
       // cell.citynameLbl.text = BlockedData.cityName
       // cell.zipcodeLbl.text = BlockedData.zipcode
       // cell.stateLbl.text = BlockedData.stateName
        
        
//        if BlockedData.venueName != "" {
//            cell.venueDetailView.visibility = .visible
//        }else {
//            cell.venueDetailView.visibility = .gone
//        }
        
        
        
        
        return cell
        
    }
    @objc func actionAddVenueBtn(sender : UIButton){
        let vc = storyboard?.instantiateViewController(identifier: "AddNewVenueViewController") as! AddNewVenueViewController
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        
    }
    @objc func showAppointmentDate(sender : UIButton){
        //textfield.endEditing(true)
        let cell = blockedAppointmentTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! TelephonicAppointmentTVCell
        
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
        let selectedDateforPicker = self.blockedAppointmentArr[sender.tag].startTimeForPicker ?? Date()
        let cell = blockedAppointmentTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! TelephonicAppointmentTVCell
        let minDate = Date().dateByAddingYears(-5)
        RPicker.selectDate(title: "Select Start Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectedDateforPicker, minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.blockedAppointmentArr[sender.tag].startTimeForPicker = selectedDate
            self?.blockedAppointmentArr[sender.tag].endTimeForPicker = selectedDate.adding(minutes: 120)
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            let endTimee = roundoff.adding(minutes: 120)
            self?.blockedAppointmentArr[sender.tag].startTimeForPicker = selectedDate
            
            
            
            let startBookedTime = self?.starttimeTF.text ?? ""
            let startcellBookedTime = roundoff.dateString("hh:mm a")
            print("selected time \(startcellBookedTime), but blocked time \(startBookedTime)")
            
            let startmainTime = self?.timeConversion24(time12: startBookedTime)
            let startCellTime = self?.timeConversion24(time12: startcellBookedTime)
            
            
            //if startcellBookedTime < startBookedTime {
            if (startCellTime ?? "") < (startmainTime ?? "") {
                print("time should not exceed")
               self?.view.makeToast("Your appointment start time cannot be lesser the overall appointment's start time. Please adjust the overall appointment start time accordingly.",duration : 5.0 , position : .center)
              //  self?.showAlertwithmessage(message: "Your appointment start time cannot be lesser the overall appointment's start time. Please adjust the overall appointment start time accordingly.")
            }else {
                // do nothing
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

            }
            
        })
        
    }
    @objc func showEndTime(sender : UIButton){
       
        let cell = blockedAppointmentTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! TelephonicAppointmentTVCell
        let selectedDateforPicker = self.blockedAppointmentArr[sender.tag].endTimeForPicker ?? Date()
        let minDate = Date().dateByAddingYears(-5)
        RPicker.selectDate(title: "Select End Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectedDateforPicker,minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.blockedAppointmentArr[sender.tag].endTimeForPicker = selectedDate
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
           
            
            
            let startBookedTime = self?.endTimeTF.text ?? ""
            let startcellBookedTime = roundoff.dateString("hh:mm a")
            self?.blockedAppointmentArr[sender.tag].endTimeForPicker = selectedDate
            print("selected time \(startcellBookedTime), but blocked time \(startBookedTime)")
            let endMaintime = self?.timeConversion24(time12: startBookedTime)
            let endCellTime = self?.timeConversion24(time12: startcellBookedTime)
            
         
           // if startcellBookedTime < startBookedTime {
                if (endCellTime ?? "") < (endMaintime ?? "") {
                    
                     
                cell.endTimeTF.text = roundoff.dateString("hh:mm a")
                self?.blockedAppointmentArr.forEach({ BlockedAppointmentData in
                    if BlockedAppointmentData.rowIndex == sender.tag {
                        BlockedAppointmentData.endTime = roundoff.dateString("hh:mm a")
                        cell.endTime = roundoff.dateString("hh:mm a")
                    }
                })
            }else {
                self?.view.makeToast("Your last appointment end time cannot exceed the overall appointment end time. Please adjust the overall appointment end time accordingly." , duration : 5.0 , position : .center)
               // self?.showAlertwithmessage(message: "Your last appointment end time cannot exceed the overall appointment end time. Please adjust the overall appointment end time accordingly.")
            }
        })
    }
    
    @objc func CancelApt(sender : UIButton){
        if  self.blockedAppointmentArr.count > 1{
            if  self.blockedAppointmentArr.contains(where: {$0.rowIndex == sender.tag}){
                self.blockedAppointmentArr.remove(at: sender.tag)
            }else {
                print("no index found ")
            }
            
            
            self.blockedAppointmentTV.reloadData()
        }else {
            
        }
//        if self.blockedAtCount > 1 {
//            self.blockedAtCount = self.blockedAtCount - 1
//            self.blockedAppointmentTV.reloadData()
//        }else {
//
//        }
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


//MARK: - Telephonic Table Cell class
class TelephonicAppointmentTVCell : UITableViewCell , UITextFieldDelegate {
    @IBOutlet weak var cancelImg: UIImageView!
    @IBOutlet weak var appointmentCancelBtn: UIButton!
    @IBOutlet weak var AppointmentTitleLbl: UILabel!
    @IBOutlet weak var contactUpdateView: UIView!
    @IBOutlet weak var venueDetailView: UIView!
    @IBOutlet weak var departmentDetailUpdate: UIView!
    
    @IBOutlet weak var clientRefrenceTF: UITextField!
    @IBOutlet weak var appointmentDateTF: UITextField!
    @IBOutlet weak var appointmentDateBtn: UIButton!
    @IBOutlet weak var specialNoteTf: UITextField!
    
    @IBOutlet weak var showContactMoreOptionbtn: UIButton!
    @IBOutlet weak var addContactBtn: UIButton!
    @IBOutlet weak var selectContactTF: iOSDropDown!
    @IBOutlet weak var contactNameTF: UITextField!
    @IBOutlet weak var clearContactBtn: UIButton!
    @IBOutlet weak var addActualContactBtn: UIButton!
    @IBOutlet weak var departmentNameTF: UITextField!
    @IBOutlet weak var addActualDepartmentbtn: UIButton!
    @IBOutlet weak var clearDepartmentBtn: UIButton!
    @IBOutlet weak var activateDeactivateView: UIView!
    @IBOutlet weak var actionShowmoreDepartmentOption: UIButton!
    @IBOutlet weak var actionAddDepartMent: UIButton!
    @IBOutlet weak var selectDepartmentTF: iOSDropDown!
    @IBOutlet weak var zipcodeLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var citynameLbl: UILabel!
    @IBOutlet weak var addressnameLbl: UILabel!
    @IBOutlet weak var venueNameLbl: UILabel!
    @IBOutlet weak var addvenueBtn: UIButton!
    @IBOutlet weak var selectVenueTF: iOSDropDown!
    @IBOutlet weak var clientIntiaalTF: UITextField!
    @IBOutlet weak var clientNameTF: UITextField!
    @IBOutlet weak var genderTF: iOSDropDown!
    @IBOutlet weak var languageTF: iOSDropDown!
    @IBOutlet weak var locationTF: UITextField!
    
    @IBOutlet weak var travelMileStackView: UIStackView!
    @IBOutlet weak var startTimebtn: UIButton!
    
    @IBOutlet weak var endTimeBtn: UIButton!
    @IBOutlet weak var endTimeTF: UITextField!
    @IBOutlet weak var startTimeTf: UITextField!
    
    var apiGetCustomerDetailResponseModel = [ApiGetCustomerDetailResponseModel]()
    
    var delegate : TelephonicSaveBookedAppointmentData?
    var tableDelegate : ReloadBlockedTable?
    var genderDetail = [GenderData]()
    var venueDetail = [VenueData]()
    var departmentDetail = [DepartmentData]()
    var providerDetail = [ProviderData]()
    var oneTimeDepartmentArr = [DepartmentData]()
    var oneTimeContactArr = [ProviderData]()
    
    var genderArray :[String] = []
    var venueArray :[String] = []
    var departmentArray :[String] = []
    var providerArray :[String] = []
    
    var venueID = ""
    var genderID = ""
    var languageID = 0
    var selectedVenue = ""
    var selectedContact = ""
    var selectedDepartment = ""
    var AppointmentDate = ""
    var startTime = ""
    var endTime = ""
    var providerID = 0
    var departmentID = 0
    var languageName = ""
    
    var rowIndex = 0
    var specialNotes = ""
    var locationText = ""
    
    var clientName = ""
    var clientIntials = ""
    var Clientrefrence = ""
    
    var depatmrntActionType : Int?
    var contactActiontype : Int?
    
    var isAppointmentDateSelect = false
    var isGenderSelect = false
    var isProviderSelect = false
    var isStartTimeSelect = false
    var isEndtimeSelect = false
    var isDepartmentSelect = false
    var isVenueSelect = false
    var editDepatment = false
    
    var venueName = ""
    var departmentName = ""
    var ConatctName = ""
    var genderName = ""
    
    var venueTitleName = ""
    var addressName = ""
    var cityName = ""
    var stateName = ""
    var zipcodeName  = ""
    
    override  func awakeFromNib() {
       // self.languageTF.isUserInteractionEnabled = false
        self.contactUpdateView.visibility = .gone
        
        self.appointmentCancelBtn.isHidden = true
        //self.activateDeactivateView.visibility = .gone
        self.travelMileStackView.visibility = .gone
        showLanguageDropDown()
        self.cancelImg.isHidden = true
        self.clientNameTF.delegate = self
        self.clientRefrenceTF.delegate = self
        self.locationTF.delegate = self
        self.clientIntiaalTF.delegate = self
        self.specialNoteTf.delegate = self
        
        
        
        
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "MM/dd/yyyy"
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "h:mm a"
        let currentDateTime = Date().nearestHour() ?? Date()
        print("current time before \(currentDateTime)")
        let tempTime = dateFormatterTime.string(from: currentDateTime)
        print("TEMP TIME : \(tempTime)")
        self.startTimeTf.text = dateFormatterTime.string(from: currentDateTime)
        self.startTime = dateFormatterTime.string(from: currentDateTime)
        
        let endTimee = Date().adding(minutes: 120).nearestHour() ?? Date()
        self.appointmentDateTF.text = dateFormatterDate.string(from: currentDateTime)
        self.AppointmentDate = dateFormatterDate.string(from: currentDateTime)
        
        self.endTime = dateFormatterTime.string(from: endTimee)
        self.endTimeTF.text = dateFormatterTime.string(from: endTimee)
       
       getVenueDetail()
        
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
        
        showGenderDropdown()
        NotificationCenter.default.addObserver(self, selector: #selector(self.selectActionToPerform(notification:)), name: Notification.Name("selectActionType"), object: nil)


    }
    //MARK: - Method to perform Action according to selection
    
    @objc func selectActionToPerform(notification: Notification) {
        let actionType = notification.userInfo?["actionType"] as? String
        print("selected type is ", actionType)

        if actionType == "Edit"{
            if isDepartmentSelect {
                self.depatmrntActionType = 1
                self.departmentNameTF.text = self.selectedDepartment
            }else {
                self.contactActiontype = 1
                self.contactNameTF.text = self.selectedContact
            }
            
        }else if actionType == "Delete"{
            if isDepartmentSelect {
                self.depatmrntActionType = 2
                // 2 for delete Department
                if  self.selectDepartmentTF.text == ""{
                    //self.view.makeToast("Please add Department Name. ")
                    tableDelegate?.showAlertWithMessageInTable(message: "Please add Department Name.")
                    return
                }else {
                    let contactName = selectDepartmentTF.text ?? ""
                    self.hitApiAddDepartment(id: self.departmentID, departmentName: contactName, flag: "Delete", isOneTime: 0, deptID: self.departmentID, type: "Department", isChangeParameter: true)
                    //self.actionDepartmentType = 0
                }
            }else {
                self.contactActiontype = 2
                if  selectContactTF.text == ""{
                    //self.view.makeToast("Please add Contact Name. ")
                    tableDelegate?.showAlertWithMessageInTable(message: "Please add Contact Name.")
                    return
                }else if self.departmentID == 0 {
                   // self.view.makeToast("Please select Department Name. ")
                    tableDelegate?.showAlertWithMessageInTable(message: "Please add Department Name.")
                    return
                }else {
                    let contactName = selectContactTF.text ?? ""
                    self.hitApiAddDepartment(id: self.providerID, departmentName: contactName, flag: "Delete", isOneTime: 0, deptID: self.departmentID, type: "Contact", isChangeParameter: true)
                    //self.actionDepartmentType = 0
                }
            }
        }else if actionType == "Activate"{
            self.depatmrntActionType = 4
        }else if actionType == "OneTimeDepartment"{
            self.depatmrntActionType = 5
            // 5 for Add one time  Department
            //self.departmentNameTF.text = ""
        }else if actionType == "Deactivate"{
            self.depatmrntActionType = 3
        }
    }
    //MARK: - Text Field Delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       var isClientName = false
        var isclientIntials = false
        var isclientRef = false
        var islocatin = false
        var isNote = false
        
        if textField == self.clientNameTF {
          
            let stringInput = textField.text?.trimmingCharacters(in: .whitespaces)
            let abc = stringInput ?? ""
            let stringInputArr = abc.components(separatedBy:" ")
            var stringNeed = ""
            let abcc:Character="C"
            for string in stringInputArr {
                stringNeed += String(string.first ?? abcc)
            }
            
            print(stringNeed)
            self.clientIntiaalTF.text = stringNeed.uppercased()
            //let patientIntial = stringNeed.uppercased()
        }
        
        
        
        print("Function textViewDidEndEditing ")
               print("Row index is ",rowIndex)
               guard let txt = textField.text else { return }
               guard rowIndex != nil else { return }
             
               if textField == self.specialNoteTf {
                    isNote = true
                    self.specialNotes = txt
               }else if textField == self.locationTF {
                   islocatin = true
                    self.locationText = txt
               }else if textField == self.clientRefrenceTF {
                   isclientRef = true
                    self.Clientrefrence = txt
               }else if textField == self.clientIntiaalTF {
                   isclientIntials = true
                      self.clientIntials = txt
               }else if textField == self.clientNameTF{
                   isClientName = true
                      self.clientName = txt
                      self.clientIntials = self.clientIntiaalTF.text ?? ""
               }
        
               print("----text is ", txt)
            //print("all value are ",self.firstName,self.lastName , self.emailID,self.mobileNum,self.countryCode)
       
            self.AppointmentDate = self.appointmentDateTF.text ?? ""
            self.startTime = self.startTimeTf.text ?? ""
            self.endTime = self.endTimeTF.text ?? ""
//            self.venueName = self.selectVenueTF.text ?? ""
           // self.departmentName = self.selectDepartmentTF.text ?? ""
            self.ConatctName = self.selectContactTF.text ?? ""
            self.genderName = self.genderTF.text ?? ""
            self.languageName = self.languageTF.text ?? ""
            //self.addressName = self.addressnameLbl.text ?? ""
           // self.cityName = self.citynameLbl.text ?? ""
           // self.stateName = self.stateLbl.text ?? ""
            //self.zipcodeName = self.zipcodeLbl.text ?? ""
            self.clientName = self.clientNameTF.text ?? ""
            self.Clientrefrence = self.clientRefrenceTF.text ?? ""
            self.clientIntials = self.clientIntiaalTF.text ?? ""
            self.specialNotes = self.specialNoteTf.text ?? ""
            self.locationText = self.locationTF.text ?? ""
        
        
        
        
       
      
        
        delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: self.languageName,venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName,startTimeForPicker : Date() ,endTimeForPicker : Date(),   isproviderSelect :false, isDepartmentSlecet : false, isLanguageSelect : false,isgenderSelect : false,isCleintNameEnterd : isClientName ,isClientRefrenceEnyterd : isclientRef, IsNotesEntered : isNote , isLocationEneterd : islocatin,isvenueFlag : false)
    
    }
   
    func showGenderDropdown(){
       
        genderTF.optionArray = self.genderArray
        
        //print("OPTIONS NEW ARRAY \(languageTF.optionArray)")
        
        genderTF.checkMarkEnabled = true
        genderTF.isSearchEnable = true
        genderTF.listDidDisappear {
            print("list is disappering ")
            self.genderDetail.forEach({ languageData in
                print("language data \(languageData.Value )")
                if self.genderTF.text ?? ""  == languageData.Value {
                    self.genderID = languageData.Code
                    //print("languageId \(self.genderID)")
                    self.genderName = languageData.Value
                    self.AppointmentDate = self.appointmentDateTF.text ?? ""
                    self.startTime = self.startTimeTf.text ?? ""
                    self.endTime = self.endTimeTF.text ?? ""
                   
                    self.ConatctName = self.selectContactTF.text ?? ""
                    
                    self.languageName = self.languageTF.text ?? ""
                    
                    self.clientName = self.clientNameTF.text ?? ""
                    self.Clientrefrence = self.clientRefrenceTF.text ?? ""
                    self.clientIntials = self.clientIntiaalTF.text ?? ""
                    self.specialNotes = self.specialNoteTf.text ?? ""
                    self.locationText = self.locationTF.text ?? ""
                    
                    self.isGenderSelect = true
                    self.delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: self.rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: self.languageName,venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName,startTimeForPicker : Date() ,endTimeForPicker : Date(),isproviderSelect :false, isDepartmentSlecet : false, isLanguageSelect : false,isgenderSelect : true,isCleintNameEnterd : false ,isClientRefrenceEnyterd : false, IsNotesEntered : false , isLocationEneterd : false,isvenueFlag : false)
                }
            })
        }
        genderTF.selectedRowColor = UIColor.clear
        genderTF.didSelect{ [self](selectedText , index , id) in
           // self.genderTF.text = "\(selectedText)"
            self.genderDetail.forEach({ languageData in
                print("language data \(languageData.Value )")
                if selectedText == languageData.Value {
                    self.genderID = languageData.Code
                    //print("languageId \(self.genderID)")
                    self.genderName = languageData.Value
                    self.isGenderSelect = true
                    self.AppointmentDate = self.appointmentDateTF.text ?? ""
                    self.startTime = self.startTimeTf.text ?? ""
                    self.endTime = self.endTimeTF.text ?? ""
                    
                    self.ConatctName = self.selectContactTF.text ?? ""
                    
                    self.languageName = self.languageTF.text ?? ""
                   
                    self.clientName = self.clientNameTF.text ?? ""
                    self.Clientrefrence = self.clientRefrenceTF.text ?? ""
                    self.clientIntials = self.clientIntiaalTF.text ?? ""
                    self.specialNotes = self.specialNoteTf.text ?? ""
                    self.locationText = self.locationTF.text ?? ""
                    delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: self.languageName, venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName,startTimeForPicker : Date() ,endTimeForPicker : Date(),isproviderSelect :false, isDepartmentSlecet : false, isLanguageSelect : false,isgenderSelect : true,isCleintNameEnterd : false ,isClientRefrenceEnyterd : false, IsNotesEntered : false , isLocationEneterd : false,isvenueFlag : false)
                }
            })
        }
        
        
        
        
        
    }
    func showLanguageDropDown(){
        self.languageTF.optionArray = GetPublicData.sharedInstance.languageArray
        print("OPTIONS ARRYA \(GetPublicData.sharedInstance.languageArray)")
        print("OPTIONS NEW ARRAY \(languageTF.optionArray)")
        languageTF.checkMarkEnabled = false
        languageTF.isSearchEnable = true
        languageTF.selectedRowColor = UIColor.clear
        languageTF.didSelect{(selectedText , index , id) in
            self.languageTF.text = "\(selectedText)"
            GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
              //  print("language data \(languageData.languageName ?? "")")
                if selectedText == languageData.languageName ?? "" {
                    self.languageName = selectedText
                    self.languageID = languageData.languageID ?? 0
                    self.AppointmentDate = self.appointmentDateTF.text ?? ""
                    self.startTime = self.startTimeTf.text ?? ""
                    self.endTime = self.endTimeTF.text ?? ""
                   
                    self.ConatctName = self.selectContactTF.text ?? ""
                    self.genderName = self.genderTF.text ?? ""
                  
                    
                    self.clientName = self.clientNameTF.text ?? ""
                    self.Clientrefrence = self.clientRefrenceTF.text ?? ""
                    self.clientIntials = self.clientIntiaalTF.text ?? ""
                    self.specialNotes = self.specialNoteTf.text ?? ""
                    self.locationText = self.locationTF.text ?? ""
                    
                    print("languageId \(self.languageID)")
                    self.delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: self.rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: selectedText , venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName,startTimeForPicker : Date() ,endTimeForPicker : Date(),isproviderSelect :false, isDepartmentSlecet : false, isLanguageSelect : true,isgenderSelect : false,isCleintNameEnterd : false ,isClientRefrenceEnyterd : false, IsNotesEntered : false , isLocationEneterd : false,isvenueFlag : false)
                }
            })
        }
        languageTF.listDidDisappear {
            GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
              //  print("language data \(languageData.languageName ?? "")")
                if self.languageTF.text ?? "" == languageData.languageName ?? "" {
                    self.languageName = languageData.languageName ?? ""
                    self.languageID = languageData.languageID ?? 0
                    self.AppointmentDate = self.appointmentDateTF.text ?? ""
                    self.startTime = self.startTimeTf.text ?? ""
                    self.endTime = self.endTimeTF.text ?? ""
                    
                    self.ConatctName = self.selectContactTF.text ?? ""
                    self.genderName = self.genderTF.text ?? ""
                  
                   
                    self.clientName = self.clientNameTF.text ?? ""
                    self.Clientrefrence = self.clientRefrenceTF.text ?? ""
                    self.clientIntials = self.clientIntiaalTF.text ?? ""
                    self.specialNotes = self.specialNoteTf.text ?? ""
                    self.locationText = self.locationTF.text ?? ""
                    print("languageId \(self.languageID)")
                    self.delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: self.rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: self.languageTF.text ?? "",venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName,startTimeForPicker : Date() ,endTimeForPicker : Date(),isproviderSelect :false, isDepartmentSlecet : false, isLanguageSelect : true,isgenderSelect : false,isCleintNameEnterd : false ,isClientRefrenceEnyterd : false, IsNotesEntered : false , isLocationEneterd : false,isvenueFlag : false)
                }
            })
        }
      
    }
    func getVenueDetail(){
        
        SwiftLoader.show(animated: true)
        self.venueArray.removeAll()
        self.venueDetail.removeAll()
        self.departmentArray.removeAll()
        self.departmentDetail.removeAll()
        self.providerArray.removeAll()
        self.providerDetail.removeAll()
        let urlString = APi.GetVenueCommanddl.url
        let companyID = GetPublicData.sharedInstance.companyID
        let userID = GetPublicData.sharedInstance.userID
        let userTypeId = GetPublicData.sharedInstance.userTypeID
       // let customerID = GetPublicData.sharedInstance.TempCustomerID
        let searchString = "<INFO><CUSTOMERID>\(userID)</CUSTOMERID><USERTYPEID>\(userTypeId)</USERTYPEID><LOGINUSERID>\(userID)</LOGINUSERID><COMPANYID>\(companyID)</COMPANYID><FLAG>1</FLAG><AppointmentID>0</AppointmentID></INFO>"
        let parameter = [
            "strSearchString" : searchString
        ] as [String : String]
        print("url and parameter for venue in cell  ", urlString, parameter)
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
                        print("Success getvenueDetail Model ",self.apiGetCustomerDetailResponseModel.first?.result ?? "")
                        let str = self.apiGetCustomerDetailResponseModel.first?.result ?? ""
                        let data = str.data(using: .utf8)!
                        do {
//
                            print("DATAAA ISSS \(data)")
                            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                            {

                                let newjson = jsonArray.first
                                let venueList = newjson?["Venuelist"] as? [[String:Any]]
                                
                                let departmentList = newjson?["DepartmentList"] as? [[String:Any]] // use the json here
                                let providerList = newjson?["ProviderNameList"] as? [[String:Any]]
                                let customerPermision = newjson?["customerPermission"] as? [[String:Any]]
                                //let customerUserName = userIfo?["CustomerUserName"] as? String
                                print("venue Detail is ",newjson)
                                venueList?.forEach({ venueData in
                                    let address = venueData["Address"] as? String
                                    let address2 = venueData["Address2"] as? String
                                    let city = venueData["City"] as? String
                                    let companyID = venueData["CompanyID"] as? Int
                                    let customerCompany = venueData["CustomerCompany"] as? String
                                    let customerName = venueData["CustomerName"] as? String
                                    let notes = venueData["Notes"] as? String
                                    let state = venueData["State"] as? String
                                    let stateID = venueData["StateID"] as? Int
                                    let venueID = venueData["VenueID"] as? Int
                                    let venueName = venueData["VenueName"] as? String
                                    let zipCode = venueData["ZipCode"] as? String
                                     print("zipcode is \(zipCode)", "venueData is \(venueData)" )
                                    let itemA = VenueData(Address: address, Address2: address2, City: city, CompanyID: companyID, CustomerCompany: customerCompany, CustomerName: customerName, Notes: notes, State: state, StateID: stateID, VenueID: venueID, VenueName: venueName, ZipCode: zipCode)
                                    self.venueDetail.append(itemA)
                                    self.venueArray.append(venueName ?? "")
                                })
                               
                                departmentList?.forEach({ departmentData in
                                   
                                    let departmentName = departmentData["DepartmentName"] as? String
                                    let deActive = departmentData["DeActive"] as? Int
                                    let departmentID = departmentData["DepartmentID"] as? Int
                                    let itemA = DepartmentData(DeActive: deActive, DepartmentID: departmentID, DepartmentName: departmentName)
                                    self.departmentDetail.append(itemA)
                                    self.departmentArray.append(departmentName ?? "")
                                    
                                })
                                providerList?.forEach({ providerData in
                                    let providerID = providerData["ProviderID"] as? Int
                                    let providerName = providerData["ProviderName"] as? String
                                    let itemA = ProviderData(ProviderID: providerID, ProviderName: providerName)
                                    self.providerDetail.append(itemA)
                                    self.providerArray.append(providerName ?? "")
                                })
                              showVenueDropDown()
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
            })
       
    }
    func showVenueDropDown(){
        
        oneTimeContactArr.forEach { oneTimeDepart in
            self.providerDetail.append(oneTimeDepart)
            self.providerArray.append(oneTimeDepart.ProviderName ?? "")
        }
        
        selectContactTF.optionArray = self.providerArray
        print("OPTIONS NEW ARRAY \(selectContactTF.optionArray)")
        selectContactTF.checkMarkEnabled = false
        selectContactTF.isSearchEnable = true
        selectContactTF.selectedRowColor = UIColor.clear
        selectContactTF.didSelect{(selectedText , index , id) in
            //self.selectedContact = "\(selectedText)"
           // self.selectContactTF.text = "\(selectedText)"
            //self.editContactNameTF.text = "\(selectedText)"
           // self.venueName = self.selectVenueTF.text ?? ""
           // self.departmentName = self.selectDepartmentTF.text ?? ""
            self.AppointmentDate = self.appointmentDateTF.text ?? ""
            self.startTime = self.startTimeTf.text ?? ""
            self.endTime = self.endTimeTF.text ?? ""
            
          
            self.genderName = self.genderTF.text ?? ""
            self.languageName = self.languageTF.text ?? ""
            //self.addressName = self.addressnameLbl.text ?? ""
           // self.cityName = self.citynameLbl.text ?? ""
           // self.stateName = self.stateLbl.text ?? ""
           // self.zipcodeName = self.zipcodeLbl.text ?? ""
            self.clientName = self.clientNameTF.text ?? ""
            self.Clientrefrence = self.clientRefrenceTF.text ?? ""
            self.clientIntials = self.clientIntiaalTF.text ?? ""
            self.specialNotes = self.specialNoteTf.text ?? ""
            self.locationText = self.locationTF.text ?? ""
            self.contactUpdateView.visibility = .gone
            self.tableDelegate?.didReloadTable(performTableReload: true)
            self.providerDetail.forEach({ languageData in
                
                if selectedText == languageData.ProviderName ?? "" {
                    self.providerID = languageData.ProviderID ?? 0
                    print("languageId \(self.providerID)")
                    //self.isProviderSelect = true
                    self.ConatctName = selectedText
                    self.delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: self.rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: self.languageName,venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName,startTimeForPicker : Date() ,endTimeForPicker : Date(),isproviderSelect :true, isDepartmentSlecet : false, isLanguageSelect : false,isgenderSelect : false,isCleintNameEnterd : false ,isClientRefrenceEnyterd : false, IsNotesEntered : false , isLocationEneterd : false,isvenueFlag : false)
                }
            })
        }
        
        
    }
    func hitApiAddDepartment(id : Int, departmentName : String, flag: String, isOneTime:Int, deptID :Int , type :String, isChangeParameter : Bool){
        SwiftLoader.show(animated: true)
        let urlString = APi.AddUpdateDeptAndContactData.url
        let companyID = GetPublicData.sharedInstance.companyID
        let userID = GetPublicData.sharedInstance.userID
       // let userTypeId = GetPublicData.sharedInstance.userTypeID
        var searchString = ""
        if isChangeParameter {
            searchString = "<INFO><ID>\(id)</ID><Flag>\(flag)</Flag><Type>\(type)</Type></INFO>"
        }else {
            searchString = "<INFO><COMPANYID>\(companyID)</COMPANYID><ID>\(id)</ID><Name>\(departmentName)</Name><VenueID></VenueID><Flag>\(flag)</Flag><Type>\(type)</Type><CustomerID>\(userID)</CustomerID><OneTime>\(isOneTime)</OneTime><Deptid>\(deptID)</Deptid><LOGINUSERID>\(userID)</LOGINUSERID></INFO>"
        }
         
        let parameter = [
            "strSearchString" : searchString
        ] as [String : String]
        print("url and parameter are ", urlString, parameter)
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
                                let userInfo = newjson?["DepConatctData"] as? [[String:Any]]
                                //let statusInfo = newjson?["StatusInfo"] as? [[String:Any]] // use the json here
                                let userIfo = userInfo?.first
                                let success = userIfo?["success"] as? Int
                                let message = userIfo?["Message"] as? String
                                
                               let status = userIfo?["Status"] as? Int
                                
                                if success == 1 {
                                    //self.showDepartMentView.visibility = .gone
                                   // self.view.makeToast(message ?? "",duration: 2, position: .center)
                                    if contactActiontype != nil {
                                        self.selectContactTF.text = ""
                                        self.contactUpdateView.visibility = .gone
                                        self.ConatctName = ""
                                        tableDelegate?.didReloadTable(performTableReload: true)
                                        self.contactNameTF.text = ""
                                        
                                        if contactActiontype == 5 {
                                            let itemA = ProviderData(ProviderID: status, ProviderName: departmentName)
                                            oneTimeContactArr.append(itemA)
                                        }else {
                                            
                                        }
                                    }else if self.depatmrntActionType != nil  {
                                        self.departmentName = ""
                                        self.selectDepartmentTF.text = ""
                                        self.departmentNameTF.text = ""
                                        self.departmentDetailUpdate.visibility = .gone
                                        tableDelegate?.didReloadTable(performTableReload: true)
                                        if depatmrntActionType == 5 {
                                            let itemA = DepartmentData(DeActive: 0, DepartmentID: status, DepartmentName: departmentName)
                                            oneTimeDepartmentArr.append(itemA)
                                        }
                                    }else {
                                        
                                    }
                                    self.AppointmentDate = self.appointmentDateTF.text ?? ""
                                    self.startTime = self.startTimeTf.text ?? ""
                                    self.endTime = self.endTimeTF.text ?? ""
                                    self.venueName = self.selectVenueTF.text ?? ""
                                    self.departmentName = self.selectDepartmentTF.text ?? ""
                                    self.ConatctName = self.selectContactTF.text ?? ""
                                    self.genderName = self.genderTF.text ?? ""
                                    self.languageName = self.languageTF.text ?? ""
                                    self.addressName = self.addressnameLbl.text ?? ""
                                    self.cityName = self.citynameLbl.text ?? ""
                                    self.stateName = self.stateLbl.text ?? ""
                                    self.zipcodeName = self.zipcodeLbl.text ?? ""
                                    self.clientName = self.clientNameTF.text ?? ""
                                    self.Clientrefrence = self.clientRefrenceTF.text ?? ""
                                    self.clientIntials = self.clientIntiaalTF.text ?? ""
                                    self.specialNotes = self.specialNoteTf.text ?? ""
                                    self.locationText = self.locationTF.text ?? ""
                                    delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: self.languageName,venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName,startTimeForPicker : Date() ,endTimeForPicker : Date(),isproviderSelect :false, isDepartmentSlecet : false, isLanguageSelect : false,isgenderSelect : false,isCleintNameEnterd : false ,isClientRefrenceEnyterd : false, IsNotesEntered : false , isLocationEneterd : false,isvenueFlag : false)
                                    getVenueDetail()
                                }else {
                                   // self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
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
            })
    }
    @IBAction func actionClearContact(_ sender: UIButton) {
        self.contactNameTF.text = ""
        self.contactUpdateView.visibility = .gone
        tableDelegate?.didReloadTable(performTableReload: true)
    }
    @IBAction func addActualContact(_ sender: UIButton) {
        if self.contactActiontype == 0 {
            if  contactNameTF.text == ""{
                tableDelegate?.showAlertWithMessageInTable(message: "Please add Contact Name.")
               // self.view.makeToast("Please add Contact Name. ")
                return
            }else if self.departmentID == 0 {
                tableDelegate?.showAlertWithMessageInTable(message: "Please select Department Name. ")
                //self.view.makeToast("Please select Department Name. ")
                return
            } else {
                let contactName = contactNameTF.text ?? ""
                self.hitApiAddDepartment(id: 0, departmentName: contactName, flag: "Add", isOneTime: 0, deptID: self.departmentID, type: "Contact", isChangeParameter: false)
                //self.actionDepartmentType = 0
            }
        }else if contactActiontype == 1 {
            if  contactNameTF.text == ""{
                tableDelegate?.showAlertWithMessageInTable(message: "Please add Contact Name.")
                //self.view.makeToast("Please add Contact Name. ")
                return
            }else if self.departmentID == 0 {
                tableDelegate?.showAlertWithMessageInTable(message: "Please select Department Name. ")
               // self.view.makeToast("Please select Department Name. ")
                return
            }else {
                let contactName = contactNameTF.text ?? ""
                self.hitApiAddDepartment(id: self.providerID, departmentName: contactName, flag: "Update", isOneTime: 0, deptID: self.departmentID, type: "Contact", isChangeParameter: false)
                //self.actionDepartmentType = 0
            }
        }else if contactActiontype == 5 {
            // 5 for Add one time Departmnt
            if  contactNameTF.text == ""{
                tableDelegate?.showAlertWithMessageInTable(message: "Please add Contact Name.")
                //self.view.makeToast("Please add Contact Name. ")
                return
            }else if self.departmentID == 0 {
                tableDelegate?.showAlertWithMessageInTable(message: "Please select Department Name. ")
                //self.view.makeToast("Please select Department Name. ")
                return
            } else {
                let contactName = contactNameTF.text ?? ""
                self.hitApiAddDepartment(id: 0, departmentName: contactName, flag: "Add", isOneTime: 1, deptID: self.departmentID, type: "Contact", isChangeParameter: false)
                //self.actionDepartmentType = 0
            }
        }else {
            print("No action")
        }
    }
    @IBAction func actionContactMoreOptionBtn(_ sender: UIButton) {
        
        self.isDepartmentSelect = false
        if self.selectContactTF.text == "" {
            tableDelegate?.showAlertWithMessageInTable(message: "Please select any contact to perform action.")
        }else {
            tableDelegate?.didopenMoreoption(action: true, type: "Contact")
        }
        
    }
    @IBAction func actionAddContact(_ sender: UIButton) {
        self.contactActiontype = 0
        self.contactNameTF.text = ""
        self.contactUpdateView.visibility = .visible
        tableDelegate?.didReloadTable(performTableReload: true)
    }
    
    @IBAction func actionAddActualDepartment(_ sender: UIButton) {
        if self.depatmrntActionType == 0 {
            // 0 for Add Departmnt
            if  departmentNameTF.text == ""{
                tableDelegate?.showAlertWithMessageInTable(message: "Please add Department Name. ")
                //self.view.makeToast("Please add Department Name. ")
                return
            }else {
                let departmentName = departmentNameTF.text ?? ""
                self.hitApiAddDepartment(id: 0, departmentName: departmentName, flag: "Add", isOneTime: 0, deptID: 0, type: "Department", isChangeParameter: false)
                //self.actionDepartmentType = 0
            }
        }else if depatmrntActionType == 1 {
            // 1 for edit Department
            
            if  departmentNameTF.text == ""{
                tableDelegate?.showAlertWithMessageInTable(message: "Please add Department Name. ")
               // self.view.makeToast("Please add Department Name. ")
                return
            }else {
                let departmentName = departmentNameTF.text ?? ""
                self.hitApiAddDepartment(id: self.departmentID, departmentName: departmentName, flag: "Update", isOneTime: 0, deptID: 0, type: "Department", isChangeParameter: false)
                //self.actionDepartmentType = 0
            }
        }else if depatmrntActionType == 5 {
            // 5 for Add one time Departmnt
            if  departmentNameTF.text == ""{
                tableDelegate?.showAlertWithMessageInTable(message: "Please add Department Name. ")
                //self.view.makeToast("Please add Department Name. ")
                return
            }else {
                let departmentName = departmentNameTF.text ?? ""
                self.hitApiAddDepartment(id: 0, departmentName: departmentName, flag: "Add", isOneTime: 1, deptID: 0, type: "Department", isChangeParameter: false)
                //self.actionDepartmentType = 0
            }
        }else {
            
        }
    
    }
    @IBAction func actionClearDepartmentField(_ sender: UIButton) {
         self.departmentNameTF.text = ""
         self.departmentDetailUpdate.visibility = .gone
         tableDelegate?.didReloadTable(performTableReload: true)
    }
    @IBAction func actionAddDepartment(_ sender: UIButton) {
        self.departmentNameTF.text = ""
        self.depatmrntActionType = 0
        self.departmentDetailUpdate.visibility = .visible
        tableDelegate?.didReloadTable(performTableReload: true)
    }
    @IBAction func actionMoreDepartmentOption(_ sender: UIButton) {
        self.isDepartmentSelect = true
        if self.selectDepartmentTF.text == "" {
            tableDelegate?.showAlertWithMessageInTable(message: "Please select any department to perform action.")
        }else {
            tableDelegate?.didopenMoreoption(action: true, type: "Department")
        }
        
        
    }
}
