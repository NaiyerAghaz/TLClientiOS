//
//  OnsiteBlockedAppointmentVC.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 04/03/22.
//

import UIKit
import Alamofire
import iOSDropDown
import DropDown
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
    
    @IBOutlet weak var lblDepartment: UILabel!
    var specialityDetail = [SpecialityData]()
    var serviceDetail = [ServiceData]()
    var serviceArr:[String] = []
    var specialityArray:[String] = []
    var languageArray:[String] = []
    var genderArray :[String] = []
    var loginUserID = ""
    var genderDetail = [GenderData]()
    var subcustomerList = [SubCustomerListData]()
    var languageDetail = [LanguageData]()
    var subcustomerArr = [String]()
    var blockedAppointmentArr = [BlockedAppointmentData]()
    
    var selectTypeOFAppointment = "B"
    var languageID = "0"
    var serviceId = "0"
    var specialityID = "0"
    var genderID = ""
    var customerID = ""
    var masterCustomerID = "0"
    var languageName = ""
    var BlockedLanguage = ""
    var selectedStartTimeForPicker = Date().nearestHour()!
    var selectedEndTimeForPicker = Date().adding(minutes: 120).nearestHour()!
    var elementName = ""
    var elementID = 0
    var DepartmentIDForOperation = 0
    var isGenderSelect = false
    var isSpecialitySelect = false
    var isServiceSelect = false
    var isContactOption = false
    var dropDown = DropDown()
    var authCode = ""
    var userID = ""
    var companyID = ""
    var userTypeID = ""
    var jobType = ""
    var vanueID = "0"
    var selectedIndex:Int = 0
    var contactActiontype: Int?
    var depatmrntActionType: Int?
    
    var venueArray :[String] = []
    var departmentArray :[String] = []
    var providerArray :[String] = []
    var venueDetail = [VenueData]()
    var departmentDetail = [DepartmentData]()
    var providerDetail = [ProviderData]()
    var oneTimeDepartmentArr = [DepartmentData]()
    var oneTimeContactArr = [ProviderData]()
    var apiEncryptedDataResponse:ApiEncryptedDataResponse?
    var apiGetCustomerDetailResponseModel = [ApiGetCustomerDetailResponseModel]()
    var startTimeForAppointment = Date()
    var endTimeforAppointment = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blockedAppointmentTV.delegate = self
        self.blockedAppointmentTV.dataSource = self
        self.blockedAppointmentTV.separatorStyle = .none
        self.departmentOptionMajorView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.departmentOptionMajorView.isHidden = true
        self.departmentOptionView.layer.cornerRadius = 15
        self.departmentOptionView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        self.userID = userDefaults.string(forKey: "userId") ?? ""
        self.companyID = userDefaults.string(forKey: "companyID") ?? ""
        self.userTypeID = userDefaults.string(forKey: "userTypeID") ?? ""
        NotificationCenter.default.addObserver(self, selector: #selector(updateVenueList), name: Notification.Name("updateVenueList"), object: nil)
        
        //        let dateFormatterDate = DateFormatter()
        //        dateFormatterDate.dateFormat = "MM/dd/yyyy"
        //        let dateFormatterTime = DateFormatter()
        //        dateFormatterTime.dateFormat = "h:00 a"
        //        let currentDateTime = Date().nearestHour() ?? Date()
        self.startTimeForAppointment = CEnumClass.share.getCurrentTimeToDate(time: CEnumClass.share.getRoundCTime())//Date().nearestHour() ?? Date()
        //        print("current time before \(currentDateTime)")
        //        let tempTime = dateFormatterTime.string(from: currentDateTime)
        //        print("TEMP TIME : \(tempTime)")
        
        self.starttimeTF.text = CEnumClass.share.getRoundCTime()//dateFormatterTime.string(from: currentDateTime)
        
        // let endTimee = Date().adding(minutes: 120)//.nearestHour() ?? Date()
        
        self.endTimeforAppointment = CEnumClass.share.getCurrentTimeToDate(time: CEnumClass.share.getMinuteDiffers(startTime: CEnumClass.share.getRoundCTime(), differ: "120", companyId: self.companyID))//endTimee
        self.appointmentDateTF.text = CEnumClass.share.getCurrentDate()
        self.endTimeTF.text = CEnumClass.share.getMinuteDiffers(startTime: CEnumClass.share.getRoundCTime(), differ: "120", companyId: self.companyID)//dateFormatterTime.string(from: endTimee)
        
        //  let dateFormatterr = DateFormatter()
        // dateFormatterr.dateFormat = "MM/dd/yyyy h:mm a"
        
        self.requestedONTF.text = CEnumClass.share.getActualDateAndTime()//dateFormatterr.string(from: Date())
        self.loadedOnTF.text = CEnumClass.share.getActualDateAndTime()//dateFormatterr.string(from: Date())
        
        self.loginUserID = userDefaults.string(forKey: "LoginUserTypeID") ?? ""
        if self.loginUserID == "10" || self.loginUserID == "7" || self.loginUserID == "8" || self.loginUserID == "11" {
            self.subCustomerNameTF.isUserInteractionEnabled = false
        }else {
            self.subCustomerNameTF.isUserInteractionEnabled = true
        }
        
        getCommonDetail()
        getCustomerDetail()
        let itemA = BlockedAppointmentData(AppointmentDate: CEnumClass.share.getCurrentDate(), startTime: CEnumClass.share.getRoundCTime(), endTime:CEnumClass.share.getMinuteDiffers(startTime: CEnumClass.share.getRoundCTime(), differ: "120", companyId: self.companyID), languageID: 0, genderID: "", clientName: "", ClientIntials: "", ClientRefrence: "", venueID: "", DepartmentID: 0, contactID: 0, location: "", SpecialNotes: "", rowIndex: 0, languageName: "",venueName: "", DepartmentName: "", genderType: "", conatctName: "", isVenueSelect: false, venueTitleName : "" , addressname : "" , cityName : "" , stateName : "" , zipcode: "",startTimeForPicker: Date() , endTimeForPicker: Date(), authCode: "",showClientName: "" , showClientIntials:"" , showClientRefrence: "",isDepartmentSelect: false,isConatctSelect : false)
        
        blockedAppointmentArr.append(itemA)
       // NotificationCenter.default.addObserver(self, selector: #selector(self.updateOnsiteRegularScreen(notification:)), name: Notification.Name("updateOnsiteBlockedScreen"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateVenueInList(notification:)), name: Notification.Name("updateVenueInList"), object: nil)
        
    }
    @objc func updateVenueInList(notification: Notification){
        self.blockedAppointmentArr.forEach { BlockedAppointmentData in
            BlockedAppointmentData.venueName = ""
            BlockedAppointmentData.DepartmentName = ""
            BlockedAppointmentData.conatctName = ""
            BlockedAppointmentData.venueID = "0"
            BlockedAppointmentData.DepartmentID = 0
            BlockedAppointmentData.contactID = 0
            BlockedAppointmentData.venueTitleName = ""
            BlockedAppointmentData.isVenueSelect = false
            
        }
        self.blockedAppointmentTV.reloadData()
    }
//    @objc func updateOnsiteRegularScreen(notification: Notification){
//        print("refreshing data in Onsite blocked ")
//        getCommonDetail()
//        getCustomerDetail()
//    }
    @objc func updateVenueList(){
        getCustomerDetail()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }
    
    
    //MARK: - Common DropDown Method
    
    @IBAction func actionSubCustomerDropDown(_ sender: UIButton) {
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = self.subcustomerArr
        
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            self?.subCustomerNameTF.text = "\(item)"
            self?.subcustomerList.forEach({ languageData in
                print("subcustomerList data \(languageData.CustomerFullName ?? "")")
                if item == languageData.CustomerFullName ?? "" {
                    //self.languageID = "\(languageData.languageID ?? 0)"
                    let customerID = "\(languageData.CustomerID ?? 0 )"
                    self?.customerID = customerID
                    self?.getVenueDetail(customerId: customerID, isContact: "0", id: 0)
                    print("subcustomerList id \(languageData.UniqueID ?? 0)")
                }
            })
        }
    }
    @IBAction func actionSpecialityDropDown(_ sender: UIButton) {
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = self.specialityArray
        
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            self?.specialityTF.text = "\(item)"
            self?.specialityDetail.forEach({ languageData in
                print("specialityDetail data \(languageData.DisplayValue ?? "")")
                if item == languageData.DisplayValue ?? "" {
                    self?.specialityID = "\(languageData.SpecialityID ?? 0)"
                    print("specialityDetail id \(self?.specialityID ?? "")")
                    self?.isSpecialitySelect = true
                }
            })
            
            
        }
    }
    @IBAction func actionServiceDropDown(_ sender: UIButton) {
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = self.serviceArr
        
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            self?.serviceTypeTF.text = "\(item)"
            self?.serviceDetail.forEach({ languageData in
                print("serviceDetail data \(languageData.DisplayValue ?? "")")
                if item == languageData.DisplayValue ?? "" {
                    self?.serviceId = "\(languageData.SpecialityID ?? 0)"
                    print("serviceDetail ID \(self?.serviceId ?? "")")
                    self?.isServiceSelect = true
                }
            })
            
        }
    }
    @IBAction func actionGenderDropDown(_ sender: UIButton) {
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = self.genderArray
        
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            self?.genderTF.text = "\(item)"
            self?.genderDetail.forEach({ languageData in
                print("gender data  \(languageData.Value )")
                
                if item == languageData.Value {
                    self?.genderID = languageData.Code
                    print("genderId \(self?.genderID ?? "")")
                    self?.isGenderSelect = true
                }else if item == "Select Gender"{
                    self?.genderID = ""
                    self?.isGenderSelect = false
                }
            })
            
            
        }
    }
    //MARK: - show  Drop downs
    
    
    func showLnaguageDropdown(){
        self.languageTF.optionArray = self.languageArray
        
        languageTF.checkMarkEnabled = false
        languageTF.isSearchEnable = true
        self.languageTF.listWillAppear  {
            self.dropDown.direction = .top
        }
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
                        print(BlockedAppointmentData.languageName ?? "", BlockedAppointmentData.languageID ?? 0)
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
        // let authCode = self.authCodeTF.text ?? ""
        let newAuthCode = self.authCodeTF.text ?? ""
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
            
            
            
            self.hitApiCreateRequest(masterCustomerID: self.masterCustomerID, authCode: newAuthCode, SpecialityID: self.specialityID, ServiceType: self.serviceId, startTime: startDate, endtime: endDate, gender: self.genderID , caseNumber: "", clientName: "", clientIntial: "", location: "", textNote: "", SendingEndTimes: false, Travelling: "", CallTime: "", requestedOn: requestedOn, LoginUserId: userId, parameter: "srchString")
            
        }
    }
    //MARK: - Add Appointment method
    @IBAction func actionAddBlockedApt(_ sender: UIButton) {
        print("blocked Appointment Count ",blockedAppointmentArr.count)
        
        self.blockedAppointmentArr.forEach { BlockedAppointmentData in
            BlockedAppointmentData.languageName = self.BlockedLanguage
            BlockedAppointmentData.languageID = Int(self.languageID)
            
        }
        var emptyField = ""
        if self.blockedAppointmentArr.count < 4 {
            if blockedAppointmentArr.allSatisfy({ BlockedAppointmentData in
                
                if BlockedAppointmentData.languageID == 0 {
                    
                    emptyField = "Language"
                    return false
                }else if BlockedAppointmentData.venueID == "0" {
                    
                    emptyField = "venue"
                    return false
                }else if BlockedAppointmentData.venueID == "" {
                    
                    emptyField = "venue"
                    return false
                }else {
                    //print("everythink okay , you can add Appointment.")
                    return true
                }
            }){
                
                let nextstartTime = self.blockedAppointmentArr.last?.endTime
                
                /*changing start*/
                var appointmentStartTime2 = ""
                var appointmentEndtime2 = ""
                let new12HrFormatter2 = DateFormatter()
                new12HrFormatter2.dateFormat = "hh:mm a"
                let toatalEndTime2 = new12HrFormatter2.string(from: self.endTimeforAppointment)
                let cDateStartTime = "\(appointmentDateTF.text!) \(nextstartTime!)"
                let cDateEndTime = "\(appointmentDateTF.text!) \(toatalEndTime2)"
                print("cDateStartTime:",cDateStartTime, "cDateEndTime:",cDateEndTime)
                
                if CEnumClass.share.getCompleteDateAndTime(dateAndTime: cDateStartTime) < (CEnumClass.share.getCompleteDateAndTime(dateAndTime: cDateEndTime)){
                    let totalDiff = CEnumClass.share.findTimeDiff(time1Str:nextstartTime! , time2Str: toatalEndTime2, isInHours: true)
                    if totalDiff >= 2 {
                        let appointETime = CEnumClass.share.getCompleteTimeToDate(time: nextstartTime!).adding(minutes: 120)
                        appointmentEndtime2 = CEnumClass.share.getCompleteNextTimeToString(time: appointETime)
                        appointmentStartTime2 = nextstartTime!
                    }
                    
                    else {
                        appointmentEndtime2 = nextstartTime!
                        appointmentStartTime2 = nextstartTime!
                    }
                    
                }
                else {
                    appointmentEndtime2 = nextstartTime!
                    appointmentStartTime2 = nextstartTime!
                    
                }
                
                
                let itemA = BlockedAppointmentData(AppointmentDate: appointmentDateTF.text!, startTime:appointmentStartTime2 , endTime: appointmentEndtime2 , languageID: Int(self.languageID) ?? 0, genderID: "", clientName: "", ClientIntials: "", ClientRefrence: "", venueID: "", DepartmentID: 0, contactID: 0, location: "", SpecialNotes: "", rowIndex: blockedAppointmentArr.count, languageName: self.languageName,venueName: "", DepartmentName: "", genderType: "", conatctName: "", isVenueSelect: false , venueTitleName : "" , addressname : "" , cityName : "" , stateName : "" , zipcode: "",startTimeForPicker: Date() , endTimeForPicker: Date(), authCode: "",showClientName: "" , showClientIntials:"" , showClientRefrence: "",isDepartmentSelect: false,isConatctSelect : false)
                
                blockedAppointmentArr.append(itemA)
                // let indexPath = IndexPath(row: self.blockedAppointmentArr.count-1, section: 0)
                self.blockedAppointmentTV.reloadData()
                //self.blockedAppointmentTV.scrollToRow(at: indexPath, at: .bottom, animated: true)
                
            }else {
                
                self.showAlertwithmessage(message: "Please Select \(emptyField).")
            }
        }else {
            self.showAlertwithmessage(message: "You cannot create more than 4 appointments.")
        }
        
    }
    //MARK: - Action Venue options
    @IBAction func addOneTimeDepartment(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Storyboard_name.scheduleApnt, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDepartmentAndContactVC") as! UpdateDepartmentAndContactVC
        vc.modalPresentationStyle = .overCurrentContext
        if self.isContactOption {
            vc.isdepartSelect = false
            vc.contactActiontype = 5
        }else {
            vc.isdepartSelect = true
            vc.depatmrntActionType = 5
        }
        vc.venueID = self.vanueID
        vc.tableDelegate = self
        vc.actionType = "Add"
        vc.isAddOneTime = 1
       
        self.present(vc, animated: true, completion: nil)
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
      
    }
    @IBAction func actiopnDeleteDepartment(_ sender: UIButton) {
        
        if self.elementName == "" || self.elementName == "Select Contact" || self.elementName == "Select Department" {
            if self.isContactOption {
                self.showAlertwithmessage(message: "Please Select any Contact.")
            }else {
                self.showAlertwithmessage(message: "Please Select any Department.")
            }
            
            self.departmentOptionMajorView.isHidden = true
        }else {
            let storyboard = UIStoryboard(name: "SchedulingAppointments", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDepartmentAndContactVC") as! UpdateDepartmentAndContactVC
            vc.modalPresentationStyle = .overCurrentContext
            if self.isContactOption {
                vc.isdepartSelect = false
                vc.contactActiontype = 2
            }else {
                vc.isdepartSelect = true
                vc.depatmrntActionType = 2
            }
            vc.tableDelegate = self
            vc.actionType = "Delete"
            vc.elementID = self.elementID
            vc.elementName = self.elementName
            vc.DeptID = self.DepartmentIDForOperation
            vc.venueID = self.vanueID
            self.present(vc, animated: true, completion: nil)
            self.departmentOptionMajorView.isHidden = true
        }
        
    }
    //MARK: actionEditDepartment
    
    @IBAction func actionEditDepartment(_ sender: UIButton) {
        if self.elementName == "" || self.elementName == "Select Contact" || self.elementName == "Select Department" {
            if self.isContactOption {
                self.showAlertwithmessage(message: "Please Select any Contact.")
            }else {
                self.showAlertwithmessage(message: "Please Select any Department.")
            }
            
            self.departmentOptionMajorView.isHidden = true
        }else {
            //changes start
            let storyboard = UIStoryboard(name: Storyboard_name.scheduleApnt, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: Control_Name.updateDeptAndCont) as! UpdateDepartmentAndContactVC
            vc.modalPresentationStyle = .overCurrentContext
            if self.isContactOption{
                if oneTimeContactArr.count != 0 {
                    if let obj = oneTimeContactArr.firstIndex(where: {$0.ProviderName == self.elementName }){
                        vc.elementID = oneTimeContactArr[obj].ProviderID!
                        vc.isdepartSelect = false
                        vc.contactActiontype = 5
                        vc.elementName = self.elementName
                        vc.actionType = "Update"
                        vc.DeptID = oneTimeContactArr[obj].ProviderID!
                        vc.tableDelegate = self
                        vc.venueID = self.vanueID
                        self.present(vc, animated: true, completion: nil)
                        self.departmentOptionMajorView.isHidden = true
                        
                    }
                    else {
                        vc.elementID = self.elementID
                        vc.isdepartSelect = false
                        vc.contactActiontype = 1
                        vc.elementName = self.elementName
                        vc.actionType = "Update"
                        vc.DeptID = self.elementID
                        vc.tableDelegate = self
                        vc.venueID = self.vanueID
                        self.present(vc, animated: true, completion: nil)
                        self.departmentOptionMajorView.isHidden = true
                    }
                }
                else {
                    vc.elementID = self.elementID
                    vc.isdepartSelect = false
                    vc.contactActiontype = 1
                    vc.elementName = self.elementName
                    vc.actionType = "Update"
                    vc.DeptID = self.elementID
                    vc.tableDelegate = self
                    vc.venueID = self.vanueID
                    self.present(vc, animated: true, completion: nil)
                    self.departmentOptionMajorView.isHidden = true
                }
            }
            else {
                if oneTimeDepartmentArr.count != 0 {
                    if let obj = oneTimeDepartmentArr.firstIndex(where: {$0.DepartmentName == elementName }){
                        vc.elementID = oneTimeDepartmentArr[obj].DepartmentID!
                        vc.isdepartSelect = true
                        vc.depatmrntActionType = 5
                        vc.elementName = elementName
                        vc.tableDelegate = self
                        vc.actionType = "Update"
                        vc.venueID = self.vanueID
                        vc.DeptID = oneTimeDepartmentArr[obj].DepartmentID!
                        self.present(vc, animated: true, completion: nil)
                        self.departmentOptionMajorView.isHidden = true
                    }
                    
                    else {
                        vc.elementID = elementID
                        vc.isdepartSelect = true
                        vc.depatmrntActionType = 1
                        vc.elementName = elementName
                        vc.tableDelegate = self
                        vc.actionType = "Update"
                        vc.venueID = self.vanueID
                        vc.DeptID = self.DepartmentIDForOperation
                        self.present(vc, animated: true, completion: nil)
                        self.departmentOptionMajorView.isHidden = true
                    }
                }
                else {
                    vc.elementID = elementID
                    vc.isdepartSelect = true
                    vc.depatmrntActionType = 1
                    vc.elementName = elementName
                    vc.tableDelegate = self
                    vc.actionType = "Update"
                    vc.venueID = self.vanueID
                    vc.DeptID = self.DepartmentIDForOperation
                    self.present(vc, animated: true, completion: nil)
                    self.departmentOptionMajorView.isHidden = true
                }
                
            }
          }
        
        
    }
    
    //MARK: - Select Start Time
    @IBAction func selectStartDate(_ sender: UIButton) {
        let minDate = Date().dateByAddingYears(-5)
        RPicker.selectDate(title: "Select Start Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectedStartTimeForPicker, minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.selectedStartTimeForPicker = selectedDate
            self?.startTimeForAppointment = selectedDate
            self?.endTimeforAppointment = selectedDate.adding(minutes: 120)
           
            self?.selectedEndTimeForPicker = selectedDate.adding(minutes: 120)
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            let endTimee = roundoff.adding(minutes: 120)
            self?.starttimeTF.text = roundoff.dateString("hh:mm a")
            
            self?.endTimeTF.text = endTimee.dateString("hh:mm a")
            
            var firstTime = selectedDate
            
            var nextTime = firstTime.adding(minutes: 120)
            
            let new12HrFormatter = DateFormatter()
            new12HrFormatter.dateFormat = "HH:mm"
            
            let totalEndTime = new12HrFormatter.string(from: self?.endTimeforAppointment ?? Date())
            var currentEndTime = new12HrFormatter.string(from: nextTime)
            
            self?.blockedAppointmentArr.forEach({ appointmentData in
                if totalEndTime < currentEndTime {
                    print("first case")
                    print("totalEndTime: \(totalEndTime) \n currentEndTime: \(currentEndTime)")
                    appointmentData.startTime = firstTime.dateString("hh:mm a")
                    appointmentData.endTime = firstTime.dateString("hh:mm a")
                    
                    //firstTime = nextTime
                    
                    //nextTime = firstTime.adding(minutes: 120)
                }else {
                    print("last case")
                    print("totalEndTime: \(totalEndTime) \n currentEndTime: \(currentEndTime)")
                    appointmentData.startTime = firstTime.dateString("hh:mm a")
                    appointmentData.endTime = nextTime.dateString("hh:mm a")
                    firstTime = nextTime
                    nextTime = firstTime.adding(minutes: 120)
                    
                    currentEndTime = new12HrFormatter.string(from: nextTime)
                    print("new currentTime \(currentEndTime)")
                }
              })
            
            self?.blockedAppointmentTV.reloadData()
          })
    }
    //MARK: SELECT END TIME
    @IBAction func selectEndTime(_ sender: UIButton) {
     
        
        let sTime = appointmentDateTF.text! + " \(starttimeTF.text!)"
        let minDate = CEnumClass.share.getCompleteDateAndTime(dateAndTime: sTime)
        let endTime = appointmentDateTF.text! + " \(endTimeTF.text!)"
        let selectDate = CEnumClass.share.getCompleteDateAndTime(dateAndTime: endTime)
        
        RPicker.selectDate(title: "Select End Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectDate,minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.selectedEndTimeForPicker = selectedDate
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            self?.endTimeforAppointment = selectedDate
            self?.endTimeTF.text = roundoff.dateString("hh:mm a")
            
            
            var firstTime = self?.startTimeForAppointment
            
            var nextTime = firstTime?.adding(minutes: 120)
            
            let new12HrFormatter = DateFormatter()
            new12HrFormatter.dateFormat = "HH:mm"
            
            let totalEndTime = new12HrFormatter.string(from: self?.endTimeforAppointment ?? Date())
            var currentEndTime = new12HrFormatter.string(from: nextTime ?? Date())
            
            self?.blockedAppointmentArr.forEach({ appointmentData in
                if totalEndTime < currentEndTime {
                    print("first case")
                    print("totalEndTime: \(totalEndTime) \n currentEndTime: \(currentEndTime)")
                    appointmentData.startTime = firstTime?.dateString("hh:mm a")
                    appointmentData.endTime = firstTime?.dateString("hh:mm a")
                    //firstTime = nextTime
                    
                    //nextTime = firstTime.adding(minutes: 120)
                }else {
                    print("last case")
                    print("totalEndTime: \(totalEndTime) \n currentEndTime: \(currentEndTime)")
                    appointmentData.startTime = firstTime?.dateString("hh:mm a")
                    appointmentData.endTime = nextTime?.dateString("hh:mm a")
                    firstTime = nextTime
                    nextTime = firstTime?.adding(minutes: 120)
                    
                    currentEndTime = new12HrFormatter.string(from: nextTime ?? Date())
                    print("new currentTime \(currentEndTime)")
                }
                
            })
            
            self?.blockedAppointmentTV.reloadData()
            
            
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
    
    func getSubcustomerList(id: Int){
        if Reachability.isConnectedToNetwork() {
            SwiftLoader.show(animated: true)
            let urlString = APi.GetCustomerDetail.url
            let companyID = self.companyID//GetPublicData.sharedInstance.companyID
            let userID = self.userID//GetPublicData.sharedInstance.userID
            let userTypeId = self.userTypeID//GetPublicData.sharedInstance.userTypeID
            let searchString = "<INFO><COMPANYID>\(companyID)</COMPANYID><LOGINUSERID>\(userID)</LOGINUSERID><LOGINUSERTYPEID>\(userTypeId)</LOGINUSERTYPEID><USERTYPEID>10</USERTYPEID><CUSTOMERID>\(id)</CUSTOMERID><APPTYPE>1</APPTYPE><EDIT>1</EDIT></INFO>"
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
                                        print("Login user Type ID \(self.loginUserID)")
                                        if self.loginUserID == "10" || self.loginUserID == "7" || self.loginUserID == "8" || self.loginUserID == "11" {
                                            self.subCustomerNameTF.text = CustomerFullName ?? ""
                                            let customerID = "\(CustomerID ?? 0)"
                                            print("venue Function call for subcustom er ")
                                           
                                            
                                        }else {
                                            print("venue Function call for non subcustomer  ")
                                            self.subCustomerNameTF.text = ""
                                            
                                        }
                                        let itemA = SubCustomerListData(UniqueID: UniqueID ?? 0, Email: Email ?? "", CustomerUserName: CustomerUserName ?? "", Priority: Priority ?? 0, MasterUsertype: MasterUsertype ?? 0, Mobile: Mobile ?? "", PurchaseOrderNote: PurchaseOrderNote ?? "", CustomerID: CustomerID ?? 0, CustomerFullName: CustomerFullName ?? "", EmailToRequestor: EmailToRequestor ?? 0)
                                        self.subcustomerArr.append(CustomerFullName ?? "")
                                        self.subcustomerList.append(itemA)
                                        
                                    })
                                    GetPublicData.sharedInstance.TempCustomerID = self.customerID
                                    getVenueDetail(customerId: self.customerID, isContact: "0", id: 0)
                                    
                                    
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
            self.subcustomerArr.removeAll()
            self.subcustomerList.removeAll()
            let urlString = APi.GetCustomerDetail.url
            let companyID = self.companyID//GetPublicData.sharedInstance.companyID
            let userID = self.userID//GetPublicData.sharedInstance.userID
            let userTypeId = self.userTypeID//GetPublicData.sharedInstance.userTypeID
            let loginUserTypeId = userDefaults.string(forKey: "LoginUserTypeID")
            let searchString = "<INFO><COMPANYID>\(companyID)</COMPANYID><LOGINUSERID>\(userID)</LOGINUSERID><LOGINUSERTYPEID>\(loginUserTypeId ?? "")</LOGINUSERTYPEID><USERTYPEID>4</USERTYPEID><APPTYPE>1</APPTYPE><EDIT>1</EDIT><AUTHFLAG>2</AUTHFLAG></INFO>"
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
                                    self.masterCustomerID = "\(customerID ?? 0)"
                                    GetPublicData.sharedInstance.TempCustomerID = "\(customerID ?? 0)"
                                    
                                    let itemA = SubCustomerListData(UniqueID:  0, Email: "", CustomerUserName: "", Priority: 0, MasterUsertype: 0, Mobile: "", PurchaseOrderNote: "", CustomerID: customerID, CustomerFullName:  "Select Sub customer", EmailToRequestor: 0)
                                    self.subcustomerArr.append("Select Sub customer")
                                    self.subcustomerList.append(itemA)
                                    getSubcustomerList(id: customerID!)
                                    self.customerNameTF.text = customerFullName
                                    
                                    
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
                                        if DisplayValue == "Consecutive Interpretation" {
                                            self.serviceTypeTF.text = DisplayValue ?? ""
                                        }
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
                                    let itemD = GenderData(Id: 0, Code: "", Value: "Select Gender", type: "")
                                    let itemA = GenderData(Id: 19, Code: "M", Value: "Male", type: "Gender")
                                    let itemB = GenderData(Id: 18, Code: "F", Value: "Female", type: "Gender")
                                    let itemC = GenderData(Id: 28, Code: "NB", Value: "Non-binary", type: "Gender")
                                    genderDetail.append(itemD)
                                    genderDetail.append(itemA)
                                    genderDetail.append(itemB)
                                    genderDetail.append(itemC)
                                    genderDetail.forEach { GenderData in
                                        let name = GenderData.Value
                                        genderArray.append(name)
                                    }
                                    print("Language Array from common ",languageArray)
                                    print(specialityArray)
                                    //showGenderDropDown()
                                    showLnaguageDropdown()
                                    //updateServiceAndSpeciality()
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
            //  let userTypeId = self.userTypeID//GetPublicData.sharedInstance.userTypeID
            var customerUserID = ""
            if self.userTypeID == "4" || self.userTypeID == "10" {
                customerUserID = "0"
            }
            else {
                customerUserID = userID
            }
            
            let prefixSrch = "<INFO><CustomerUserID>\(customerUserID)</CustomerUserID><Action>A</Action><AppointmentID>0</AppointmentID><CustomerID>\(self.customerID)</CustomerID><Company>\(companyID)</Company><MasterCustomerID>\(masterCustomerID)</MasterCustomerID><AppointmentTypeID>1</AppointmentTypeID><AuthCode>\(authCode)</AuthCode><SpecialityID>\(SpecialityID)</SpecialityID><ServiceType>\(ServiceType)</ServiceType><StartDateTime>\(startTime)</StartDateTime><EndDateTime>\(endtime)</EndDateTime><Distance>0.00</Distance><AppointmentFlag>B</AppointmentFlag><LanguageID>\(self.languageID)</LanguageID><Gender>\(gender)</Gender><CaseNumber></CaseNumber><ClientName></ClientName><cPIntials></cPIntials><VenueID></VenueID><VendorID></VendorID><DepartmentID></DepartmentID><ProviderID></ProviderID><Location></Location><Text></Text><SendingEndTimes>false</SendingEndTimes><AptDetails></AptDetails><FinancialNotes></FinancialNotes><ScheduleNotes></ScheduleNotes><AppointmentStatusID>2</AppointmentStatusID><Travelling>\(Travelling)</Travelling><Ranking></Ranking><ConfirmationBit>false</ConfirmationBit><VendorMileage>false</VendorMileage><Priority>false</Priority><CallServiceBit>false</CallServiceBit><Office></Office><Home></Home><Cell></Cell><Purpose></Purpose><CallTime>\(CallTime)</CallTime><AdditionTravelTimePay>00:00</AdditionTravelTimePay><ArrivalTime></ArrivalTime><DepartureTime></DepartureTime><RequestedOn>\(requestedOn)</RequestedOn><ConfirmedOn></ConfirmedOn><BookedOn></BookedOn><CancelledOn></CancelledOn><RequestedBy>\(userID)</RequestedBy><ConfirmedBy></ConfirmedBy><BookedBy></BookedBy><CancelledBy></CancelledBy><LoadedBy>\(userID)</LoadedBy><RequestorName></RequestorName><MgemilRist>false</MgemilRist><isChanged>false</isChanged><oneHremail></oneHremail><LoginUserId>\(userID)</LoginUserId><ReasonforBotch></ReasonforBotch><PurchaseOrder></PurchaseOrder><Claim></Claim><Reference></Reference><SecurityClearence></SecurityClearence><ExperienceOfVendor></ExperienceOfVendor><InterpreterType></InterpreterType><AssignToFieldStaff></AssignToFieldStaff><RequestorName></RequestorName><RequestorEmail></RequestorEmail><TierName>W</TierName><WaitingList></WaitingList><overrideSatus></overrideSatus><overrideauth></overrideauth><SaveFlag>0</SaveFlag><SUBAPPOINTMENT>"
            var middelePart = ""
            
            blockedAppointmentArr.forEach { AptData in
                let languageID = AptData.languageID ?? 0
                let departmentID = AptData.DepartmentID ?? 0
                let contactID = AptData.contactID ?? 0
                let startTime = "\(AptData.AppointmentDate ?? "") \(AptData.startTime ?? "")"
                let appointmentEndTime = "\(AptData.AppointmentDate ?? "") \(AptData.endTime ?? "")"
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
                let AptString = "<SUBAPPOINTMENT><StartDateTime>\(startTime)</StartDateTime><EndDateTime>\(appointmentEndTime)</EndDateTime><LanguageID>\(lID)</LanguageID><CaseNumber>\(AptData.ClientRefrence ?? "")</CaseNumber><ClientName>\(AptData.clientName ?? "")</ClientName><cPIntials>\(AptData.ClientIntials ?? "")</cPIntials><VenueID>\(AptData.venueID ?? "")</VenueID><DepartmentID>\(vID)</DepartmentID><ProviderID>\(cID)</ProviderID><Location>\(CEnumClass.share.replaceSpecialCharacters(str: AptData.location ?? "") )</Location><Text>\(CEnumClass.share.replaceSpecialCharacters(str: AptData.SpecialNotes ?? "") )</Text><SendingEndTimes>false</SendingEndTimes><AptDetails></AptDetails><FinancialNotes></FinancialNotes><ScheduleNotes></ScheduleNotes><aPVenueID></aPVenueID><Active></Active></SUBAPPOINTMENT>"
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
                                    let emailResponse = newjson?["EmailNotification"] as? [[String:Any]]
                                    let matchAuth = emailResponse?.first!["AuthCode"] as? String
                                    //let statusInfo = newjson?["StatusInfo"] as? [[String:Any]] // use the json here
                                    let userIfo = userInfo?.first
                                    //  let AppointmentID = userIfo?["AppointmentID"] as? Int
                                    let success = userIfo?["success"] as? Int
                                    let msz = userIfo?["Message"] as? String
                                    // let AuthCode = userIfo?["AuthCode"] as? String
                                    
                                    if success == 1 {
                                        
                                        self.appointmentBookedCalls(message: msz ?? "", authcode: matchAuth ?? "")
                                        //                                        self.view.makeToast(Message,duration: 1, position: .center)
                                        //                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                                        //                                            self.navigationController?.popViewController(animated: true)
                                        //}
                                    }else {
                                        self.view.makeToast("Please try after sometime.",duration: 1, position: .center)
                                    }
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
            // let companyID = self.companyID//GetPublicData.sharedInstance.companyID
            //let userID = self.userID//GetPublicData.sharedInstance.userID
            // let userTypeId = self.userTypeID//GetPublicData.sharedInstance.userTypeID
            
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
    func getVenueDetail(customerId : String, isContact:String, id: Int){
        if Reachability.isConnectedToNetwork() {
            SwiftLoader.show(animated: true)
            self.venueArray.removeAll()
            self.venueDetail.removeAll()
            self.departmentArray.removeAll()
            self.departmentDetail.removeAll()
            self.providerArray.removeAll()
            self.providerDetail.removeAll()
            
            let itemA = VenueData(Address: "", Address2: "", City: "", CompanyID: 0, CustomerCompany: "", CustomerName: "", Notes: "", State: "", StateID: 0, VenueID: 0, VenueName: "Select Venue", ZipCode: "")
            self.venueDetail.append(itemA)
            self.venueArray.append("Select Venue")
            
            let itemD = DepartmentData(DeActive: 0, DepartmentID: 0, DepartmentName: "Select Department",isOneTime: false)
            self.departmentDetail.append(itemD)
            self.departmentArray.append( "Select Department")
            
            let itemP = ProviderData(ProviderID: 0, ProviderName: "Select Contact",isOneTime: false)
            self.providerDetail.append(itemP)
            self.providerArray.append("Select Contact")
            
            oneTimeDepartmentArr.forEach { oneTimeDepart in
                self.departmentDetail.append(oneTimeDepart)
                self.departmentArray.append(oneTimeDepart.DepartmentName ?? "")
            }
            oneTimeContactArr.forEach { oneTimeDepart in
                self.providerDetail.append(oneTimeDepart)
                self.providerArray.append(oneTimeDepart.ProviderName ?? "")
            }
            
            let urlString = APi.GetVenueCommanddl.url
            let companyID = self.companyID //GetPublicData.sharedInstance.companyID
            let userID = self.userID//GetPublicData.sharedInstance.userID
            let userTypeId = self.userTypeID//GetPublicData.sharedInstance.userTypeID
            let searchString = "<INFO><CUSTOMERID>\(customerId)</CUSTOMERID><USERTYPEID>\(userTypeId)</USERTYPEID><LOGINUSERID>\(userID)</LOGINUSERID><COMPANYID>\(companyID)</COMPANYID><FLAG>1</FLAG><AppointmentID>0</AppointmentID></INFO>"
            let parameter = [
                "strSearchString" : searchString
            ] as [String : String]
            print("url and parameter for venue ", urlString, parameter)
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
                                        let itemA = VenueData(Address: address, Address2: address2, City: city, CompanyID: companyID, CustomerCompany: customerCompany, CustomerName: customerName, Notes: notes, State: state, StateID: stateID, VenueID: venueID, VenueName: venueName, ZipCode: zipCode,isOneTime: false)
                                        self.venueDetail.append(itemA)
                                        self.venueArray.append(venueName ?? "")
                                        print("venueArray Count is \(venueArray)")
                                    })
                                    
                                    departmentList?.forEach({ departmentData in
                                        
                                        let departmentName = departmentData["DepartmentName"] as? String
                                        let deActive = departmentData["DeActive"] as? Int
                                        let departmentID = departmentData["DepartmentID"] as? Int
                                        let itemA = DepartmentData(DeActive: deActive, DepartmentID: departmentID, DepartmentName: departmentName,isOneTime: false)
                                        self.departmentDetail.append(itemA)
                                        self.departmentArray.append(departmentName ?? "")
                                        
                                    })
                                    providerList?.forEach({ providerData in
                                        let providerID = providerData["ProviderID"] as? Int
                                        let providerName = providerData["ProviderName"] as? String
                                        let itemA = ProviderData(ProviderID: providerID, ProviderName: providerName,isOneTime: false)
                                        self.providerDetail.append(itemA)
                                        self.providerArray.append(providerName ?? "")
                                    })
                                    if isContact == "1"{
                                        if let obj = self.blockedAppointmentArr.firstIndex(where: {$0.contactID == id}){
                                            if let nObj = self.providerDetail.first(where: {$0.ProviderID == id}){
                                                self.blockedAppointmentArr[obj].conatctName = nObj.ProviderName
                                            }
                                        }
                                    }
                                    else if isContact == "2" {
                                        if let obj = self.blockedAppointmentArr.firstIndex(where: {$0.DepartmentID == id}){
                                            if let nObj = self.departmentDetail.first(where: {$0.DepartmentID == id}){
                                                self.blockedAppointmentArr[obj].DepartmentName = nObj.DepartmentName
                                            }
                                        }
                                    }
                                    DispatchQueue.main.async {
                                       
                                        self.blockedAppointmentTV.reloadData()
                                    }
                                   
                                    // showVenueDropDown()
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
    
    
}
extension OnsiteBlockedAppointmentVC {
    func appointmentBookedCalls(message: String, authcode: String){
        
        
        let callVC = UIStoryboard(name: Storyboard_name.scheduleApnt, bundle: nil)
        let vcontrol = callVC.instantiateViewController(identifier: "BookedStatusVC") as! BookedStatusVC
        vcontrol.height = 230
        vcontrol.topCornerRadius = 30
        vcontrol.presentDuration = 0.5
        vcontrol.dismissDuration = 0.5
        vcontrol.shouldDismissInteractivelty = false
        vcontrol.popupDismisAlphaVal = 0.4
        vcontrol.msz = message
        vcontrol.delegate = self
        vcontrol.authcode = authcode
        
        present(vcontrol, animated: true, completion: nil)
    }
}
