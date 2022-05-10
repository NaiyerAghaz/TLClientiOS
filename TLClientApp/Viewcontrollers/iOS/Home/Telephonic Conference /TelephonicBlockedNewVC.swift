//
//  TelephonicBlockedNewVC.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 04/03/22.
//
import UIKit
import Alamofire
import iOSDropDown
import DropDown
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
    
    
    var elementName = ""
    var elementID = 0
    var providerArray :[String] = []
    var providerDetail = [ProviderData]()
    var DepartmentIDForOperation = 0
    var oneTimeContactArr = [ProviderData]()
    
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
    var masterCustomerID = ""
    var languageName = ""
    var BlockedLanguage = ""
    var selectedStartTimeForPicker = Date()
    var selectedEndTimeForPicker = Date().adding(minutes: 10)
    var startTimeForAppointment = Date()
    var endTimeforAppointment = Date()
    
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
    var loginUserID = ""
    var apiEncryptedDataResponse:ApiEncryptedDataResponse?
    var apiGetCustomerDetailResponseModel = [ApiGetCustomerDetailResponseModel]()
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
        
        //let dateFormatterDate = DateFormatter()
        // dateFormatterDate.dateFormat = "MM/dd/yyyy"
        //let dateFormatterTime = DateFormatter()
        //dateFormatterTime.dateFormat = "h:mm a"
        // let currentDateTime = Date()
        self.startTimeForAppointment = CEnumClass.share.getCurrentTimeToDate(time: CEnumClass.share.getRoundCTime())
        // print("current time before \(currentDateTime)")
        // let tempTime = dateFormatterTime.string(from: currentDateTime)
        //  print("TEMP TIME : \(tempTime)")
        
        self.starttimeTF.text = CEnumClass.share.getRoundCTime()//dateFormatterTime.string(from: currentDateTime)
        
        let endTimee = Date().adding(minutes: 10)
        self.endTimeforAppointment = CEnumClass.share.getCurrentTimeToDate(time: CEnumClass.share.getMinuteDiffers(startTime: CEnumClass.share.getRoundCTime(), differ: "10", companyId: self.companyID))
        self.appointmentDateTF.text = CEnumClass.share.getCurrentDate()//dateFormatterDate.string(from: currentDateTime)
        self.endTimeTF.text = CEnumClass.share.getMinuteDiffers(startTime:  CEnumClass.share.getRoundCTime(), differ: "10", companyId: self.companyID)//dateFormatterTime.string(from: endTimee)
        
        // let dateFormatterr = DateFormatter()
        // dateFormatterr.dateFormat = "MM/dd/yyyy h:mm a"
        // let startDatee =  dateFormatterr.string(from: Date().nearestHour() ?? Date ())
        self.loginUserID = userDefaults.string(forKey: "LoginUserTypeID") ?? ""
        if self.loginUserID == "10" || self.loginUserID == "7" || self.loginUserID == "8" || self.loginUserID == "11" {
            self.subCustomerNameTF.isUserInteractionEnabled = false
        }else {
            self.subCustomerNameTF.isUserInteractionEnabled = true
        }
        self.requestedONTF.text = CEnumClass.share.getActualDateAndTime()
        self.loadedOnTF.text = CEnumClass.share.getActualDateAndTime()
        
        getCommonDetail()
        getCustomerDetail()
        let itemA = BlockedAppointmentData(AppointmentDate: CEnumClass.share.getCurrentDate(), startTime:CEnumClass.share.getRoundCTime(), endTime: CEnumClass.share.getMinuteDiffers(startTime: CEnumClass.share.getRoundCTime(), differ: "10", companyId: self.companyID), languageID: 0, genderID: "", clientName: "", ClientIntials: "", ClientRefrence: "", venueID: "", DepartmentID: 0, contactID: 0, location: "", SpecialNotes: "", rowIndex: 0, languageName: "",venueName: "", DepartmentName: "", genderType: "", conatctName: "", isVenueSelect: false, venueTitleName : "" , addressname : "" , cityName : "" , stateName : "" , zipcode: "",startTimeForPicker: Date() , endTimeForPicker: Date(), authCode: "",showClientName: "" , showClientIntials:"" , showClientRefrence: "", isDepartmentSelect: false,isConatctSelect : false)
        
        blockedAppointmentArr.append(itemA)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTelephonicBlockedScreen(notification:)), name: Notification.Name("updateTelephonicBlockedScreen"), object: nil)
        
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
    @objc func updateTelephonicBlockedScreen(notification: Notification){
        print("refreshing data in Onsite regular ")
        getCommonDetail()
        getCustomerDetail()
    }
    @objc func updateVenueList(){
        getCustomerDetail()
        
    }
    
    //MARK: - show  Drop downs
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
                    print("specialityDetail id \(self?.specialityID)")
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
                    print("serviceDetail ID \(self?.serviceId)")
                    self?.isServiceSelect = true
                }
            })
            
        }
    }
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
                    let cID = "\(languageData.CustomerID ?? 0 )"
                    self?.customerID = cID
                    self?.getVenueDetail(customerId: cID)
                   
                    
                    
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
    func showGenderDropDown(){
        
        genderTF.optionArray = self.genderArray
        
        print("OPTIONS NEW ARRAY \(genderTF.optionArray)")
        
        genderTF.checkMarkEnabled = false
        genderTF.isSearchEnable = false
        genderTF.selectedRowColor = UIColor.clear
        genderTF.didSelect{(selectedText , index , id) in
            self.genderTF.text = "\(selectedText)"
            self.genderDetail.forEach({ languageData in
                print("gender data  \(languageData.Value )")
                if selectedText == languageData.Value ?? "" {
                    self.genderID = languageData.Code ?? ""
                    print("genderId \(self.genderID)")
                    self.isGenderSelect = true
                }else if selectedText == "Select Gender"{
                    self.genderID = ""
                    self.isGenderSelect = false
                }
            })
        }
    }
    
    func updateServiceAndSpeciality(){
        serviceTypeTF.optionArray = self.serviceArr
        print("OPTIONS NEW ARRAY \(serviceTypeTF.optionArray)")
        serviceTypeTF.checkMarkEnabled = false
        serviceTypeTF.isSearchEnable = false
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
        specialityTF.checkMarkEnabled = false
        specialityTF.isSearchEnable = false
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
        subCustomerNameTF.checkMarkEnabled = false
        subCustomerNameTF.isSearchEnable = false
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
        languageTF.checkMarkEnabled = false
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
        
        let newAuthCode = self.authCodeTF.text ?? ""//authCode.replacingOccurrences(of: "-OI", with: "-OIBA")
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
    //MARK: - Select Add Blocked Appointment method
    @IBAction func actionAddBlockedApt(_ sender: UIButton) {
      
        
        self.blockedAppointmentArr.forEach { BlockedAppointmentData in
            BlockedAppointmentData.languageName = self.BlockedLanguage
            BlockedAppointmentData.languageID = Int(self.languageID)
           
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
                    let totalDiff = CEnumClass.share.findTimeDiff(time1Str:nextstartTime! , time2Str: toatalEndTime2, isInHours: false)
                    if totalDiff >= 10 {
                        let appointETime = CEnumClass.share.getCompleteTimeToDate(time: nextstartTime!).adding(minutes: 10)
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
                /*changing end*/
                
                /*
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                
                // let item = "7:00 PM"
                let endDate = dateFormatter.date(from: nextstartTime ?? "")
                 print("Last Index Start: \(endDate)")
                
                
                
                
                let dateFormatterDate = DateFormatter()
                dateFormatterDate.dateFormat = "MM/dd/yyyy"
                let dateFormatterTime = DateFormatter()
                dateFormatterTime.dateFormat = "h:mm a"
                let currentDateTime = endDate
                
                
                let endTimee = currentDateTime?.adding(minutes: 10)
                let originalendTime = dateFormatterTime.string(from: endTimee ?? Date())
                var AppointmentStartTime =  ""//nextstartTime ?? ""
                var AppointmentEndtime = ""//CEnumClass.share.getMinuteDiffers(startTime: CEnumClass.share.getRoundCTime(), differ: "10", companyId: self.companyID)
                
                
                
                
                let new12HrFormatter = DateFormatter()
                new12HrFormatter.dateFormat = "HH:mm"
                let toatalEndTime = new12HrFormatter.string(from: self.endTimeforAppointment)
                let currentAppointmentStartTime = new12HrFormatter.string(from: currentDateTime ?? Date())
                let currentAppointmentEndTime = new12HrFormatter.string(from: endTimee ?? Date())
                
                //New changes :
//                let newEndDate = endDate?.adding(minutes: 10)
//                print("endTimeforAppointment-->",endTimeforAppointment)
//
//                if endDate! < endTimeforAppointment {
//
//                    AppointmentStartTime = dateFormatterTime.string(from: endDate!)
//                    let newEnd = endDate?.adding(minutes: 10)
//                    AppointmentEndtime = dateFormatterTime.string(from: newEnd!)
//                }
//                else {
//                    AppointmentStartTime = dateFormatterTime.string(from: self.startTimeForAppointment)
//                    AppointmentEndtime = dateFormatterTime.string(from: self.endTimeforAppointment)
//                }
              //End
                
                if toatalEndTime < currentAppointmentStartTime {
                    print("first case")
                    print("toatalEndTime  : \(toatalEndTime)\n currentAppointmentStartTime: \(currentAppointmentStartTime)")
                    
                    AppointmentStartTime = dateFormatterTime.string(from: self.startTimeForAppointment)
                    AppointmentEndtime = dateFormatterTime.string(from: self.endTimeforAppointment)
                    
                    
                    
                }
                
                
                else if toatalEndTime < currentAppointmentEndTime {
                    print("2nd  case" )
                    print("toatalEndTime  : \(toatalEndTime)\n currentAppointmentEndTime: \(currentAppointmentEndTime)")
                    
                    AppointmentStartTime = dateFormatterTime.string(from: currentDateTime ?? Date())
                    AppointmentEndtime = dateFormatterTime.string(from: currentDateTime ?? Date())
                    
                    
                }else {
                    print("both caes ")
                    print("toatalEndTime  : \(toatalEndTime)\n currentAppointmentStartTime: \(currentAppointmentStartTime)")
                    print("toatalEndTime  : \(toatalEndTime)\n currentAppointmentEndTime: \(currentAppointmentEndTime)")
                    AppointmentStartTime =  nextstartTime ?? ""
                    AppointmentEndtime = originalendTime
                }*/
                
                let itemA = BlockedAppointmentData(AppointmentDate: appointmentDateTF.text!, startTime:appointmentStartTime2 , endTime: appointmentEndtime2 , languageID: Int(self.languageID) ?? 0, genderID: "", clientName: "", ClientIntials: "", ClientRefrence: "", venueID: "", DepartmentID: 0, contactID: 0, location: "", SpecialNotes: "", rowIndex: blockedAppointmentArr.count, languageName: self.languageName,venueName: "", DepartmentName: "", genderType: "", conatctName: "", isVenueSelect: false , venueTitleName : "" , addressname : "" , cityName : "" , stateName : "" , zipcode: "",startTimeForPicker: Date() , endTimeForPicker: Date(), authCode: "",showClientName: "" , showClientIntials:"" , showClientRefrence: "",isDepartmentSelect: false,isConatctSelect : false)
                
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
        let storyboard = UIStoryboard(name: "SchedulingAppointments", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDepartmentAndContactVC") as! UpdateDepartmentAndContactVC
        vc.modalPresentationStyle = .overCurrentContext
        if self.isContactOption {
            vc.isdepartSelect = false
            vc.contactActiontype = 5
        }else {
            vc.isdepartSelect = true
            vc.depatmrntActionType = 5
        }
        vc.tableDelegate = self
        vc.actionType = "Add"
        vc.isAddOneTime = 1
        self.present(vc, animated: true, completion: nil)
        self.departmentOptionMajorView.isHidden = true
        
        
        
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
            self.present(vc, animated: true, completion: nil)
            self.departmentOptionMajorView.isHidden = true
        }
        
        
        
    }
    
    @IBAction func actionEditDepartment(_ sender: UIButton) {
        
        
        if self.elementName == "" || self.elementName == "Select Contact" {
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
                    self.present(vc, animated: true, completion: nil)
                    self.departmentOptionMajorView.isHidden = true
                }
            }

            
            /*end changes
            if self.isContactOption {
                vc.isdepartSelect = false
                vc.contactActiontype = 1
            }else {
                vc.isdepartSelect = true
                vc.depatmrntActionType = 1
            }
            vc.tableDelegate = self
            vc.actionType = "Update"
            vc.elementID = self.elementID
            vc.elementName = self.elementName
            vc.DeptID = self.DepartmentIDForOperation
            self.present(vc, animated: true, completion: nil)
            self.departmentOptionMajorView.isHidden = true*/
            
        }
        
    }
    
    //MARK: - IBACTION  selectStartDate
    @IBAction func selectStartDate(_ sender: UIButton) {
       
        let sTime = appointmentDateTF.text! + " \(starttimeTF.text!)"
        let sDate = CEnumClass.share.getCompleteDateAndTime(dateAndTime: sTime)
       
        let minDate = Date().dateByAddingYears(-5)
        RPicker.selectDate(title: "Select Start Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: sDate, minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.selectedStartTimeForPicker = selectedDate
            self?.startTimeForAppointment = selectedDate
            self?.endTimeforAppointment = selectedDate.adding(minutes: 10)
            print("selectedStartTimeForPicker \(self?.selectedStartTimeForPicker)")
            self?.selectedEndTimeForPicker = selectedDate.adding(minutes: 10)
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            let endTimee = roundoff.adding(minutes: 10)
            self?.starttimeTF.text = roundoff.dateString("hh:mm a")
            
            self?.endTimeTF.text = endTimee.dateString("hh:mm a")
            
            var firstTime = selectedDate
            
            var nextTime = firstTime.adding(minutes: 10)
            
            let new12HrFormatter = DateFormatter()
            new12HrFormatter.dateFormat = "HH:mm"
            
            let totalEndTime = new12HrFormatter.string(from: self?.endTimeforAppointment ?? Date())
            var currentEndTime = new12HrFormatter.string(from: nextTime ?? Date())
            
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
                    nextTime = firstTime.adding(minutes: 10)
                    
                    currentEndTime = new12HrFormatter.string(from: nextTime ?? Date())
                    print("new currentTime \(currentEndTime)")
                }
                
            })
            
            self?.blockedAppointmentTV.reloadData()
            
            
        })
        
    }
    @IBAction func selectEndTime(_ sender: UIButton) {
        let sTime = appointmentDateTF.text! + " \(endTimeTF.text!)"
        let sDate = CEnumClass.share.getCompleteDateAndTime(dateAndTime: sTime)
        let minTimes = appointmentDateTF.text! + " \(starttimeTF.text!)"
        let minDate = CEnumClass.share.getCompleteDateAndTime(dateAndTime: minTimes)
        
        //let minDate = selectedStartTimeForPicker.adding(minutes: 10)//Date().adding(minutes: 120)
        RPicker.selectDate(title: "Select End Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: sDate,minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.selectedEndTimeForPicker = selectedDate
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            self?.endTimeforAppointment = selectedDate
            self?.endTimeTF.text = roundoff.dateString("hh:mm a")
            
            
            var firstTime = self?.startTimeForAppointment
            
            var nextTime = firstTime?.adding(minutes: 10)
            
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
                    nextTime = firstTime?.adding(minutes: 10)
                    
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
extension TelephonicBlockedNewVC{
    func getVenueDetail(customerId: String){
        if Reachability.isConnectedToNetwork() {
            SwiftLoader.show(animated: true)
            
            self.providerArray.removeAll()
            self.providerDetail.removeAll()
            
            
            
            let itemP = ProviderData(ProviderID: 0, ProviderName: "Select Contact",isOneTime: false)
            self.providerDetail.append(itemP)
            self.providerArray.append("Select Contact")
            
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
                                    
                                    
                                    
                                    providerList?.forEach({ providerData in
                                        let providerID = providerData["ProviderID"] as? Int
                                        let providerName = providerData["ProviderName"] as? String
                                        let itemA = ProviderData(ProviderID: providerID, ProviderName: providerName)
                                        self.providerDetail.append(itemA)
                                        self.providerArray.append(providerName ?? "")
                                    })
                                    
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
                                        
                                        if self.loginUserID == "10" || self.loginUserID == "7" || self.loginUserID == "8" || self.loginUserID == "11" {
                                            self.subCustomerNameTF.text = CustomerFullName ?? ""
//                                            let customerID = "\(CustomerID ?? 0)"
//                                            print("venue Function call for subcustom er ")
//                                            self.customerID = customerID
                                            
                                        }else {
                                            print("venue Function call for non subcustomer  ")
                                            self.subCustomerNameTF.text = ""
                                            
                                        }
                                        let itemA = SubCustomerListData(UniqueID: UniqueID ?? 0, Email: Email ?? "", CustomerUserName: CustomerUserName ?? "", Priority: Priority ?? 0, MasterUsertype: MasterUsertype ?? 0, Mobile: Mobile ?? "", PurchaseOrderNote: PurchaseOrderNote ?? "", CustomerID: CustomerID ?? 0, CustomerFullName: CustomerFullName ?? "", EmailToRequestor: EmailToRequestor ?? 0)
                                        self.subcustomerArr.append(CustomerFullName ?? "")
                                        self.subcustomerList.append(itemA)
                                    })
                                    getVenueDetail(customerId: self.customerID)
                                    
                                    //showSubcustomerDropDown()
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
                                    getSubcustomerList()
                                    self.customerNameTF.text = customerFullName
                                    
                                    
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
            let searchString = "<INFO><COMPANYID>\(companyID)</COMPANYID><LOGINUSERID>\(userID)</LOGINUSERID><LOGINUSERTYPEID>\(userTypeId)</LOGINUSERTYPEID><AUTHFLAG>2</AUTHFLAG><JobtypeID>2</JobtypeID></INFO>"
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
                                    
                                    print("get AuthCode Detail Info in telephonic  blocked  ", SpecialityList,serviceTypeList ,languageList,AppointmentStatus , stateList , vendorRanking , travelMiles, companyData)
                                    
                                    
                                    
                                    SpecialityList?.forEach({ specialData in
                                        let specialityID = specialData["SpecialityID"] as? Int
                                        let DisplayValue = specialData["DisplayValue"] as? String
                                        let Duration = specialData["Duration"] as? Int
                                        //print("specialityID : \(specialityID) \n  DisplayValue : \(DisplayValue) \n  Duration : \(Duration) \n")
                                        if  DisplayValue == "Conference Call" || DisplayValue == "Virtual Meeting" || DisplayValue == "Select Specialty" {
                                            let ItemA = SpecialityData(SpecialityID: specialityID ?? 0 , DisplayValue: DisplayValue ?? "", Duration: Duration ?? 0)
                                            specialityDetail.append(ItemA)
                                            specialityArray.append(DisplayValue ?? "")
                                        }else {
                                            
                                        }
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
                                    // showGenderDropDown()
                                    showLnaguageDropdown()
                                    // updateServiceAndSpeciality()
                                    self.authCodeTF.text = authcode?.replacingOccurrences(of: "-TC", with: "-TCBA") ??  ""
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
            //let userTypeId = self.userTypeID//GetPublicData.sharedInstance.userTypeID
            
            var customerUserID = ""
            if self.userTypeID == "4" || self.userTypeID == "10" {
                customerUserID = "0"
            }
            else {
                customerUserID = userID
            }
            
            let prefixSrch = "<INFO><CustomerUserID>\(customerUserID)</CustomerUserID><Action>A</Action><AppointmentID>0</AppointmentID><CustomerID>\(self.customerID)</CustomerID><Company>\(companyID)</Company><MasterCustomerID>\(masterCustomerID)</MasterCustomerID><AppointmentTypeID>2</AppointmentTypeID><AuthCode>\(authCode)</AuthCode><SpecialityID>\(SpecialityID)</SpecialityID><ServiceType>\(ServiceType)</ServiceType><StartDateTime>\(startTime)</StartDateTime><EndDateTime>\(endtime)</EndDateTime><Distance>0.00</Distance><AppointmentFlag>B</AppointmentFlag><LanguageID>\(self.languageID)</LanguageID><Gender>\(gender)</Gender><CaseNumber></CaseNumber><ClientName></ClientName><cPIntials></cPIntials><VenueID></VenueID><VendorID></VendorID><DepartmentID></DepartmentID><ProviderID></ProviderID><Location></Location><Text></Text><SendingEndTimes>false</SendingEndTimes><AptDetails></AptDetails><FinancialNotes></FinancialNotes><ScheduleNotes></ScheduleNotes><AppointmentStatusID>2</AppointmentStatusID><Travelling>\(Travelling)</Travelling><Ranking></Ranking><ConfirmationBit>false</ConfirmationBit><VendorMileage>false</VendorMileage><Priority>false</Priority><CallServiceBit>false</CallServiceBit><Office></Office><Home></Home><Cell></Cell><Purpose></Purpose><CallTime>\(CallTime)</CallTime><AdditionTravelTimePay>00:00</AdditionTravelTimePay><ArrivalTime></ArrivalTime><DepartureTime></DepartureTime><RequestedOn>\(requestedOn)</RequestedOn><ConfirmedOn></ConfirmedOn><BookedOn></BookedOn><CancelledOn></CancelledOn><RequestedBy>\(userID)</RequestedBy><ConfirmedBy></ConfirmedBy><BookedBy></BookedBy><CancelledBy></CancelledBy><LoadedBy>\(userID)</LoadedBy><RequestorName></RequestorName><MgemilRist>false</MgemilRist><isChanged>false</isChanged><oneHremail></oneHremail><LoginUserId>\(userID)</LoginUserId><ReasonforBotch></ReasonforBotch><PurchaseOrder></PurchaseOrder><Claim></Claim><Reference></Reference><SecurityClearence></SecurityClearence><ExperienceOfVendor></ExperienceOfVendor><InterpreterType></InterpreterType><AssignToFieldStaff></AssignToFieldStaff><RequestorName></RequestorName><RequestorEmail></RequestorEmail><TierName>W</TierName><WaitingList></WaitingList><overrideSatus></overrideSatus><overrideauth></overrideauth><SaveFlag>0</SaveFlag><SUBAPPOINTMENT>"
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
                let AptString = "<SUBAPPOINTMENT><StartDateTime>\(startTime)</StartDateTime><EndDateTime>\(appointmentEndTime)</EndDateTime><LanguageID>\(lID)</LanguageID><CaseNumber>\( AptData.ClientRefrence ?? "")</CaseNumber><ClientName>\(AptData.clientName ?? "")</ClientName><cPIntials>\(AptData.ClientIntials ?? "")</cPIntials><VenueID></VenueID><DepartmentID></DepartmentID><ProviderID>\(cID)</ProviderID><Location>\(AptData.location ?? "")</Location><Text>\(AptData.SpecialNotes ?? "")</Text><SendingEndTimes>false</SendingEndTimes><AptDetails></AptDetails><FinancialNotes></FinancialNotes><ScheduleNotes></ScheduleNotes><aPVenueID></aPVenueID><Active></Active></SUBAPPOINTMENT>"
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
                                    let userIfo = userInfo?.first
                                  //  let AppointmentID = userIfo?["AppointmentID"] as? Int
                                    let success = userIfo?["success"] as? Int
                                    let message = userIfo?["Message"] as? String
                                    //let AuthCode = userIfo?["AuthCode"] as? String
                                    
                                    if success == 1 {
                                        DispatchQueue.main.async {
                                            self.appointmentBookedCalls(message: message ?? "", authcode: matchAuth!)
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
//MARK: - Table Work

extension TelephonicBlockedNewVC : UITableViewDelegate , UITableViewDataSource , TelephonicSaveBookedAppointmentData  , ReloadBlockedTable{
    func bookedAppointment() {
        self.navigationController?.popViewController(animated: true)
    }
    func updateOneTimeDepartment(departmentData: DepartmentData , isDelete: Bool) {
        
        if isDelete {
            
            self.blockedAppointmentTV.reloadData()
        }else {
            
            getVenueDetail(customerId: self.customerID)
        }
        
    }
    
    func updateOneTimeConatct(ConatctData: ProviderData, isDelete: Bool) {
        
        /*if isDelete {
            
            print("Delete Action ")
            for (indexx , itemm) in blockedAppointmentArr.enumerated() {
                if itemm.contactID == ConatctData.ProviderID {
                    self.blockedAppointmentArr[indexx].contactID = 0
                    self.blockedAppointmentArr[indexx].conatctName = ""
                    self.blockedAppointmentArr[indexx].isConatctSelect = false
                }else {
                    
                }
                
                
            }
            for (indexx , itemm) in oneTimeContactArr.enumerated() {
                if itemm.ProviderID == ConatctData.ProviderID {
                    self.oneTimeContactArr.remove(at: indexx)
                    
                }else {
                    
                }
                
                
            }
            for (indexx , itemm) in providerDetail.enumerated() {
                if itemm.ProviderID == ConatctData.ProviderID {
                    self.providerDetail.remove(at: indexx)
                    
                }else {
                    
                }
                
                
            }
            
            if let index = providerArray.firstIndex(of: ConatctData.ProviderName ?? "") {
                //index has the position of first match
                self.providerArray.remove(at: index)
            } else {
                //element is not present in the array
            }
            self.blockedAppointmentTV.reloadData()
            
        }else {
            self.oneTimeContactArr.append(ConatctData)
            getVenueDetail(customerId: self.customerID)
        }*/
        /*start shanges*/
        if oneTimeContactArr.count != 0{
        
        if isDelete {
      
            if let obj = oneTimeContactArr.firstIndex(where: {$0.ProviderID == ConatctData.ProviderID}){
                oneTimeContactArr.remove(at: obj)
            }
            for  itemm in blockedAppointmentArr {
                itemm.conatctName = ""
                itemm.contactID = 0
              }
            getVenueDetail(customerId: self.customerID)
           
        }
        
        else {
            
            if let obj = oneTimeContactArr.firstIndex(where: {$0.ProviderID == ConatctData.ProviderID}){
                oneTimeContactArr.remove(at: obj)
            }
            for  itemm in blockedAppointmentArr {
                 itemm.conatctName = ""
                 itemm.contactID = 0
                        
             
            }
               self.oneTimeContactArr.append(ConatctData)
                getVenueDetail(customerId: self.customerID)
           
        }
            self.blockedAppointmentTV.reloadData()
        }
        else {
        if isDelete {
            
            for  itemm in blockedAppointmentArr {
                itemm.conatctName = ""
                itemm.contactID = 0
                        
             
            }
            getVenueDetail(customerId: self.customerID)
        }
        else {
           self.oneTimeContactArr.append(ConatctData)
            getVenueDetail(customerId: self.customerID)
        }
            self.blockedAppointmentTV.reloadData()
        }
        /*changes end*/
    }
    
    
    
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
    
    func didReloadTable(performTableReload: Bool,elemntID: Int,isConatctUpdate: Bool) {
        if performTableReload {
            self.blockedAppointmentTV.reloadData()
        }else {
            print("Delegate in didReloadTable Data updated is \(elemntID) and is it conatct \(isConatctUpdate)")
            for  itemm in blockedAppointmentArr {
                
                
                if isConatctUpdate {
                    //if itemm.contactID == elemntID { }
                    itemm.conatctName = ""
                    itemm.contactID = 0
                    
                }else {
                    // if itemm.DepartmentID == elemntID { }
                    itemm.DepartmentName = ""
                    itemm.DepartmentID = 0
                    
                    
                }
            }
            self.blockedAppointmentTV.reloadData()
            getVenueDetail(customerId: self.customerID)
        }
    }
    
    
    func didSave(_ class: TelephonicAppointmentTVCell, flag: Bool, AppointmentDate: String, index: Int, startTime: String, EndTime: String, languageID: Int, GenderID: String, ClientName: String, clientIntials: String, clientRefrence: String, venueID: String, departmentID: Int, contactID: Int, location: String, Notes: String, isAppointmentDateSelect: Bool, isStartTimeSelect: Bool, isEndtimeSelect: Bool , languageName: String ,venueName: String, DepartmentName: String, genderType: String, conatctName: String, isVenueSelect: Bool,venueTitleName: String, addressname: String, cityName: String, stateName: String, zipcode: String,startTimeForPicker: Date , endTimeForPicker: Date,isproviderSelect: Bool, isDepartmentSlecet: Bool, isLanguageSelect: Bool, isgenderSelect: Bool, isCleintNameEnterd: Bool, isClientRefrenceEnyterd: Bool, IsNotesEntered: Bool, isLocationEneterd: Bool,isvenueFlag : Bool) {
        
        print("Delegate  working \(languageID)")
        print("DATA IS THERE \(languageID)on index ")
        let BookedAppoinmentData = BlockedAppointmentData(AppointmentDate: AppointmentDate, startTime: startTime, endTime: EndTime, languageID: languageID, genderID: GenderID, clientName: ClientName, ClientIntials: clientIntials, ClientRefrence: clientRefrence, venueID: venueID, DepartmentID: departmentID, contactID: contactID, location: location, SpecialNotes: Notes, rowIndex: index, languageName: languageName,venueName: venueName, DepartmentName: DepartmentName, genderType: genderType, conatctName: conatctName, isVenueSelect: isVenueSelect,venueTitleName: venueTitleName, addressname: addressname, cityName: cityName, stateName: stateName, zipcode: zipcode,startTimeForPicker: Date() , endTimeForPicker: Date(), authCode: "",showClientName: ClientName , showClientIntials:clientIntials , showClientRefrence: clientRefrence,isDepartmentSelect: isDepartmentSlecet,isConatctSelect : isproviderSelect)
        
        
        
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
        
        
        let aptNumber = indexPath.row + 1
        cell.AppointmentTitleLbl.text = "Appointment \(aptNumber)"
        
        let BlockedData = self.blockedAppointmentArr[indexPath.row]
        cell.rowIndex = indexPath.row
        cell.appointmentDateTF.text = BlockedData.AppointmentDate
        cell.startTimeTf.text = BlockedData.startTime
        cell.endTimeTF.text = BlockedData.endTime
        cell.languageTF.text = self.BlockedLanguage//BlockedData.languageName
        cell.genderTF.text = BlockedData.genderType
        cell.clientNameTF.text = BlockedData.showClientName
        cell.clientIntiaalTF.text = BlockedData.showClientIntials
        cell.clientRefrenceTF.text = BlockedData.showClientRefrence
        print("venue name  in  cell is \(BlockedData.venueName)")
        
        print("Contact in cell  name \(BlockedData.conatctName)")
        
        cell.locationTF.text = BlockedData.location
        cell.specialNoteTf.text = BlockedData.SpecialNotes
        cell.isProviderSelect = BlockedData.isConatctSelect ?? false
        print("contact in cell  name \(BlockedData.conatctName)")
        if BlockedData.conatctName == "Select Contact" {
            print("deselect")
            cell.selectContactTF.text = ""
        }else {
            print("Select")
            cell.selectContactTF.text = BlockedData.conatctName ?? ""
        }
        
        cell.genderDropDownBtn.tag = indexPath.row
        cell.genderDropDownBtn.addTarget(self, action: #selector(actionSelectGender), for: .touchUpInside)
        
        cell.contactDropDownBtn.tag = indexPath.row
        cell.contactDropDownBtn.addTarget(self, action: #selector(actionSelectConatct), for: .touchUpInside)
        
        cell.addContactBtn.tag = indexPath.row
        cell.addContactBtn.addTarget(self, action: #selector(actionAddContact), for: .touchUpInside)
        
        cell.showContactMoreOptionbtn.tag = indexPath.row
        cell.showContactMoreOptionbtn.addTarget(self, action: #selector(openConatctOption), for: .touchUpInside)
        
        return cell
        
    }
    @objc func openConatctOption(sender : UIButton){
        
        self.departmentOptionMajorView.isHidden = false
        self.optiontitleLbl.text = "Contact"
        self.isContactOption = true
        self.activateOptionView.visibility = .gone
        self.DeactivateOptionView.visibility = .gone
        self.elementName = blockedAppointmentArr[sender.tag].conatctName ?? ""
        self.elementID = blockedAppointmentArr[sender.tag].contactID ?? 0
        self.DepartmentIDForOperation = blockedAppointmentArr[sender.tag].DepartmentID ?? 0
        
        
    }
    @objc func actionSelectConatct(sender : UIButton){
        
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = providerArray
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            self?.blockedAppointmentArr[sender.tag].conatctName = item
            self?.providerDetail.forEach({ languageData in
                print("providerDetail data \(languageData.ProviderName ?? "")")
                if item == languageData.ProviderName ?? "" {
                    self?.blockedAppointmentArr[sender.tag].contactID = languageData.ProviderID ?? 0
                }
            })
            self?.blockedAppointmentTV.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        }
    }
    @objc func actionAddContact(sender : UIButton){
        let storyboard = UIStoryboard(name: "SchedulingAppointments", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDepartmentAndContactVC") as! UpdateDepartmentAndContactVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.isdepartSelect = false
        vc.tableDelegate = self
        vc.actionType = "Add"
        vc.contactActiontype = 0
        self.present(vc, animated: true, completion: nil)
    }
    @objc func actionSelectGender(sender : UIButton){
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = self.genderArray
        
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            self?.blockedAppointmentArr[sender.tag].genderType = item
            self?.genderDetail.forEach({ languageData in
                print("gender data  \(languageData.Value )")
                
                if item == languageData.Value {
                    self?.blockedAppointmentArr[sender.tag].genderID = languageData.Code
                }else if item == "Select Gender"{
                    self?.blockedAppointmentArr[sender.tag].genderID = ""
                }
            })
            self?.blockedAppointmentTV.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        }
        
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
       // let selectedDateforPicker = self.blockedAppointmentArr[sender.tag].startTimeForPicker ?? Date()
        let cell = blockedAppointmentTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! TelephonicAppointmentTVCell
        //let minDate = Date().dateByAddingYears(-5)
        
        //changes start
        let sTime = appointmentDateTF.text! + " \(starttimeTF.text!)"
        let minTimes = CEnumClass.share.getCompleteDateAndTime(dateAndTime: sTime)
        let endTime = appointmentDateTF.text! + " \(endTimeTF.text!)"
        let maxTimes = CEnumClass.share.getCompleteDateAndTime(dateAndTime: endTime)
        
        let selectedDateAntime = appointmentDateTF.text! + " \(blockedAppointmentArr[sender.tag].startTime!)"
        let selectDate = CEnumClass.share.getCompleteDateAndTime(dateAndTime: selectedDateAntime)
        //changes end
        
        RPicker.selectDate(title: "Select Start Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectDate, minDate: minTimes, maxDate: maxTimes, didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.blockedAppointmentArr[sender.tag].startTimeForPicker = selectedDate
            self?.blockedAppointmentArr[sender.tag].endTimeForPicker = selectedDate.adding(minutes: 10)
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            let endTimee = roundoff.adding(minutes: 10)
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
       // let selectedDateforPicker = self.blockedAppointmentArr[sender.tag].endTimeForPicker ?? Date()
       // let minDate = Date().dateByAddingYears(-5)
        
        
        //changes start
        let sTime = appointmentDateTF.text! + " \(starttimeTF.text!)"
        let minTimes = CEnumClass.share.getCompleteDateAndTime(dateAndTime: sTime)
        let endTime = appointmentDateTF.text! + " \(endTimeTF.text!)"
        let maxTimes = CEnumClass.share.getCompleteDateAndTime(dateAndTime: endTime)
        
        let selectedDateAntime = appointmentDateTF.text! + " \(blockedAppointmentArr[sender.tag].endTime!)"
        let selectDate = CEnumClass.share.getCompleteDateAndTime(dateAndTime: selectedDateAntime)
        //changes end

        
        RPicker.selectDate(title: "Select End Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectDate,minDate: minTimes, maxDate: maxTimes, didSelectDate: {[weak self] (selectedDate) in
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
            if (endCellTime ?? "") <= (endMaintime ?? "") {
                
                
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
    @IBOutlet weak var contactDropDownBtn : UIButton!
    @IBOutlet weak var genderDropDownBtn: UIButton!
    
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
        
        
        
        
        
        
        
        
        
        
        // NotificationCenter.default.addObserver(self, selector: #selector(self.selectActionToPerform(notification:)), name: Notification.Name("selectActionType"), object: nil)
        
        
    }
    //MARK: - Method to perform Action according to selection
    
    /* @objc func selectActionToPerform(notification: Notification) {
     let actionType = notification.userInfo?["actionType"] as? String
     print("selected type is telephonic ", actionType)
     
     if actionType == "Edit"{
     if isDepartmentSelect {
     self.depatmrntActionType = 1
     }else {
     self.contactActiontype = 1
     self.contactNameTF.text = self.selectedContact
     }
     
     }else if actionType == "Delete"{
     if isDepartmentSelect {
     self.depatmrntActionType = 2
     // 2 for delete Department
     
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
     }*/
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
    
}

