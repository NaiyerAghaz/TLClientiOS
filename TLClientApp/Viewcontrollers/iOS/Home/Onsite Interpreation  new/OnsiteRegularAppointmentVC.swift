//
//  OnsiteRegularAppointmentVC.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 04/03/22.
//

import UIKit
import iOSDropDown
import Alamofire
import DropDown
import Malert
class OnsiteRegularAppointmentVC: UIViewController ,UITextFieldDelegate, UpdateOneTimeVenue,UIScrollViewDelegate{
    func updateOneTimeVenue(VenueName: String, cityName: String, Address: String, State: String, zipCode: String, venueID: Int,stateID : Int , address2 : String) {
        print("Delegate Working ")
        let itemA = VenueData(Address: Address, Address2: address2, City: cityName, CompanyID: Int(GetPublicData.sharedInstance.companyID), CustomerCompany: GetPublicData.sharedInstance.companyName, CustomerName: GetPublicData.sharedInstance.usenName, Notes: "", State: State, StateID: stateID, VenueID: venueID, VenueName: VenueName, ZipCode: zipCode, isOneTime: true)
        self.venueDetail.append(itemA)
        self.venueArray.append(VenueName)
        //self.showVenueDropDown()
    }
    
    @IBOutlet weak var lblDepartment: UILabel!
    @IBOutlet weak var serviceTypeTF: iOSDropDown!
    @IBOutlet weak var specialityTF: iOSDropDown!
    @IBOutlet weak var jobTypeTF: UITextField!
    @IBOutlet weak var authCodeTF: UITextField!
    @IBOutlet weak var subCustomerNameTF: iOSDropDown!
    @IBOutlet weak var customerNameTF: UITextField!
    @IBOutlet weak var optiontitleLbl: UILabel!
    
    @IBOutlet weak var activateOptionView: UIView!
    @IBOutlet weak var venueNameTF: iOSDropDown!
    @IBOutlet weak var contactNameTF: iOSDropDown!
    @IBOutlet weak var departmentNameTF: iOSDropDown!
    @IBOutlet weak var appointmentDateTF: UITextField!
    
    @IBOutlet weak var caseRefrenceTF: UITextField!
    @IBOutlet weak var patientIntialTF: UITextField!
    
    @IBOutlet weak var starttimeTF: UITextField!
    @IBOutlet weak var loadedOnTF: UITextField!
    @IBOutlet weak var cancelledOnTF: UITextField!
    @IBOutlet weak var bookedONTF: UITextField!
    @IBOutlet weak var requestedONTF: UITextField!
    @IBOutlet weak var venueZipcodeLbl: UILabel!
    @IBOutlet weak var venueStateLbl: UILabel!
    @IBOutlet weak var venueCityLbl: UILabel!
    @IBOutlet weak var venueAddressLbl: UILabel!
    @IBOutlet weak var patientNameTF: UITextField!
    @IBOutlet weak var languageTF: iOSDropDown!
    @IBOutlet weak var endTimeTF: UITextField!
    @IBOutlet weak var editDepartmentNameTF: UITextField!
    @IBOutlet weak var editContactNameTF: UITextField!
    @IBOutlet weak var genderTF: iOSDropDown!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var specialNotesTF: UITextField!
    @IBOutlet weak var venueNameLbl: UILabel!
    @IBOutlet weak var departmentOptionView: UIView!
    @IBOutlet weak var departmentOptionMajorView: UIView!
    @IBOutlet weak var activateDeactivateView: UIView!
    @IBOutlet weak var contactUpdateView: UIView!
    @IBOutlet weak var venueDetailView: UIView!
    @IBOutlet weak var departmentDetailUpdate: UIView!
    @IBOutlet weak var DeactivateOptionView: UIView!
    @IBOutlet weak var dpTestView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var specialityDetail = [SpecialityData]()
    var serviceDetail = [ServiceData]()
    var serviceArr:[String] = []
    var specialityArray:[String] = []
    var languageArray:[String] = []
    var genderArray :[String] = []
    var venueArray :[String] = []
    var departmentArray :[String] = []
    var providerArray :[String] = []
    let dropDown = DropDown()
    @IBOutlet weak var contactStackView: UIStackView!
    var genderDetail = [GenderData]()
    var venueDetail = [VenueData]()
    @IBOutlet weak var departmentOptionStackView: UIStackView!
    var subcustomerList = [SubCustomerListData]()
    var departmentDetail = [DepartmentData]()
    var providerDetail = [ProviderData]()
    var languageDetail = [LanguageData]()
    var subcustomerArr = [String]()
    var oneTimeDepartmentArr = [DepartmentData]()
    var oneTimeContactArr = [ProviderData]()
    var blockedAppointmentArr = [BlockedAppointmentData]()
    var elementName = ""
    var oneTimeDepartmentID :
    Int?
    var oneTimeContactID :Int?
    var elementID = 0
    var DepartmentIDForOperation = 0
    var depatmrntActionType:Int? = nil
    var contactActiontype:Int? = nil
    var selectTypeOFAppointment = "R"
    var languageID = "0"
    var serviceId = "0"
    var specialityID = "0"
    var venueID = "0"
    var genderID = ""
    var customerID = ""
    var masterCustomerID = ""
    var providerID = 0
    var departmentID = 0
    var languageName = ""
    var selectedVenue = ""
    var selectedContact = ""
    var selectedDepartment = ""
    var jobType = ""
    var clinetName = ""
    var CIntials = ""
    var cRefrence = ""
    var authCode = ""
    var userID = ""
    var companyID = ""
    var userTypeID = ""
    var loginUserID = ""
    var selectedStartTimeForPicker = Date().nearestHour()!
    var selectedEndTimeForPicker = Date().adding(minutes: 120).nearestHour()!
    var isGenderSelect = false
    var isProviderSelect = false
    var isDepartmentSelect = false
    var isVenueSelect = false
    var isSpecialitySelect = false
    var isServiceSelect = false
    var isContactOption = false
    var refreshControl = UIRefreshControl()
    var apiEncryptedDataResponse:ApiEncryptedDataResponse?
    @IBOutlet weak var dView: UIView!
    var apiGetCustomerDetailResponseModel = [ApiGetCustomerDetailResponseModel]()
    var apiAddUpdateDepartmentResponseModel=[ApiAddUpdateDepartmentResponseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.departmentOptionMajorView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.departmentOptionMajorView.isHidden = true
        self.departmentOptionView.layer.cornerRadius = 50
        //self.dView.layer.cornerRadius = 50
        //self.dView.layer.maskedCorners = [ .layerMaxXMinYCorner]
        self.departmentOptionView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        self.userID = userDefaults.string(forKey: "userId") ?? ""
        self.companyID = userDefaults.string(forKey: "companyID") ?? ""
        self.userTypeID = userDefaults.string(forKey: "userTypeID") ?? ""
        self.loginUserID = userDefaults.string(forKey: "LoginUserTypeID") ?? ""
        if self.loginUserID == "10" || self.loginUserID == "7" || self.loginUserID == "8" || self.loginUserID == "11" {
            self.subCustomerNameTF.isUserInteractionEnabled = false
        }else {
            self.subCustomerNameTF.isUserInteractionEnabled = true
        }
        self.activateDeactivateView.visibility = .gone
        self.patientNameTF.delegate = self
        self.caseRefrenceTF.delegate = self
        
        contactUpdateView.visibility = .gone
        departmentDetailUpdate.visibility = .gone
        venueDetailView.visibility = .gone
        self.departmentOptionStackView.visibility = .gone
        self.contactStackView.visibility = .gone
        NotificationCenter.default.addObserver(self, selector: #selector(updateVenueList), name: Notification.Name("updateVenueList"), object: nil)
        self.starttimeTF.text = CEnumClass.share.getRoundCTime()
        self.appointmentDateTF.text = CEnumClass.share.getCurrentDate()
        self.endTimeTF.text = CEnumClass.share.getMinuteDiffers(startTime: CEnumClass.share.getRoundCTime(), differ: "120", companyId: self.companyID)
        self.requestedONTF.text = CEnumClass.share.getActualDateAndTime()
        self.loadedOnTF.text = CEnumClass.share.getActualDateAndTime()
        
        getCommonDetail()
        getCustomerDetail()
        
       // NotificationCenter.default.addObserver(self, selector: #selector(self.updateOnsiteRegularScreen(notification:)), name: Notification.Name("updateOnsiteRegularScreen"), object: nil)
        
        // Do any additional setup after loading the view.
    }
//    @objc func updateOnsiteRegularScreen(notification: Notification){
//        print("refreshing data in Onsite regular ")
//        getCommonDetail()
//        getCustomerDetail()
//    }
    
    @objc func updateVenueList(){
        print("method called for update venue")
        getCustomerDetail()
        
    }
    
    
    //MARK: - Text field Delegates
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.patientNameTF {
            
            let stringInput = textField.text?.trimmingCharacters(in: .whitespaces)
            let abc = stringInput ?? ""
            let stringInputArr = abc.components(separatedBy:" ")
            var stringNeed = ""
            let abcc:Character="C"
            for string in stringInputArr {
                stringNeed += String(string.first ?? abcc)
            }
            
            print(stringNeed)
            self.patientIntialTF.text = stringNeed.uppercased()
            let patientIntial = stringNeed.uppercased()
            hitApiEncryptValue(value: patientIntial) { completion, encryptedIntials in
                if completion ?? false {
                    self.CIntials = encryptedIntials ?? ""
                    print("client intials \(self.CIntials)")
                }else {
                    
                }
            }
            hitApiEncryptValue(value: textField.text ?? "") { completion, encryptedName in
                if completion ?? false {
                    self.clinetName = encryptedName ?? ""
                    print("client Name \(self.clinetName)")
                }else {
                    
                }
            }
        }
        if textField == self.caseRefrenceTF {
            hitApiEncryptValue(value: textField.text ?? "") { completion, encryptedRefrence in
                if completion ?? false {
                    self.cRefrence = encryptedRefrence ?? ""
                    print("case refrence \(self.cRefrence)")
                }else {
                    
                }
            }
        }
    }
    
    //MARK: - CommonDropdown
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
                print("subcustomerList data \(languageData.CustomerFullName ?? ""), item \(item)")
                if item == languageData.CustomerFullName ?? "" {
                    //self.languageID = "\(languageData.languageID ?? 0)"
                    let customerID = "\(languageData.CustomerID ?? 0 )"
                    self?.customerID = customerID
                    GetPublicData.sharedInstance.TempCustomerID = customerID
                    self?.getVenueDetail(customerId: customerID)
                    
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
               
                
                if item == languageData.Value {
                    self?.genderID = languageData.Code
                   
                    self?.isGenderSelect = true
                }else if item == "Select Gender"{
                    self?.genderID = ""
                    self?.isGenderSelect = false
                }
            })
            
            
        }
    }
    //MARK: - show  Drop downs
    
    func showGenderDropDown(){
        
        genderTF.optionArray = self.genderArray
        
        
        
        genderTF.checkMarkEnabled = false
        genderTF.isSearchEnable = false
        genderTF.selectedRowColor = UIColor.clear
        genderTF.didSelect{(selectedText , index , id) in
            self.genderTF.text = "\(selectedText)"
            self.genderDetail.forEach({ languageData in
                print("gender data  \(languageData.Value )")
                
                if selectedText == languageData.Value ?? "" {
                    self.genderID = languageData.Code
                    print("genderId \(self.genderID)")
                    self.isGenderSelect = true
                }else if selectedText == "Select Gender"{
                    self.genderID = ""
                    self.isGenderSelect = false
                }
            })
        }
    }
    
    
   
    
    func showLnaguageDropdown(){
        
        languageTF.optionArray = self.languageArray
       
        languageTF.listDidAppear {
            self.dropDown.direction = .top
        }
        languageTF.checkMarkEnabled = false
        languageTF.isSearchEnable = true
        languageTF.selectedRowColor = UIColor.clear
        languageTF.didSelect{(selectedText , index , id) in
            self.languageTF.text = "\(selectedText)"
            self.languageDetail.forEach({ languageData in
                print("language data language .. \(languageData.languageName ?? "")")
                if selectedText == languageData.languageName ?? "" {
                    self.languageID = "\(languageData.languageID ?? 0)"
                    print("languageId  \(self.languageID)")
                    
                    
                    
                }
            })
        }
    }
    
    //MARK: - Show Date and Time Method
    
    
    @IBAction func selectStartDate(_ sender: UIButton) {
        let minDate = Date().dateByAddingYears(-5)
        RPicker.selectDate(title: "Select Start Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectedStartTimeForPicker, minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.selectedStartTimeForPicker = selectedDate
            
            self?.selectedEndTimeForPicker = selectedDate.adding(minutes: 120)
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            let endTimee = roundoff.adding(minutes: 120)
            self?.starttimeTF.text = roundoff.dateString("hh:mm a")
            
            self?.endTimeTF.text = endTimee.dateString("hh:mm a")
        })
        
    }
    @IBAction func selectEndTime(_ sender: UIButton) {
        let sTime = appointmentDateTF.text! + " \(starttimeTF.text!)"
        let minDate = CEnumClass.share.getCompleteDateAndTime(dateAndTime: sTime)
       
        let endTime = appointmentDateTF.text! + " \(endTimeTF.text!)"
        let selectDate = CEnumClass.share.getCompleteDateAndTime(dateAndTime: endTime)
       // let minDate = selectedStartTimeForPicker.adding(minutes: 120)//Date().adding(minutes: 120)
        RPicker.selectDate(title: "Select End Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectDate,minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
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
    
    //MARK: - DepartMent Action method
    
    @IBAction func addOneTimeDepartment(_ sender: UIButton) {
        
        
        /* if isContactOption {
         self.departmentOptionMajorView.isHidden = true
         self.contactActiontype = 5
         // 5 for Add one time  Department
         self.editContactNameTF.text = ""
         self.contactUpdateView.visibility = .visible
         }else {
         self.departmentOptionMajorView.isHidden = true
         self.depatmrntActionType = 5
         // 5 for Add one time  Department
         self.editDepartmentNameTF.text = ""
         self.departmentDetailUpdate.visibility = .visible
         }*/
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
        vc.tableDelegate = self
        vc.actionType = "Add"
        vc.isAddOneTime = 1
        vc.venueID = venueID
        self.present(vc, animated: true, completion: nil)
        self.departmentOptionMajorView.isHidden = true
        
        
        
    }
    @IBAction func actionClearDepartmentField(_ sender: UIButton) {
        self.editDepartmentNameTF.text = ""
        self.departmentDetailUpdate.visibility = .gone
    }
    @IBAction func actionContactDropDown(_ sender: UIButton) {
        
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = providerArray
        
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            
            self?.selectedContact = "\(item)"
            self?.contactNameTF.text = "\(item)"
            //self.editContactNameTF.text = "\(selectedText)"
            self?.contactUpdateView.visibility = .gone
            self?.providerDetail.forEach({ languageData in
                
                if item == languageData.ProviderName ?? "" {
                    self?.providerID = languageData.ProviderID ?? 0
                    
                    self?.isProviderSelect = true
                }
            })
        }
    }
    @IBAction func actionDepartmentDropDown(_ sender: UIButton) {
        
        
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = departmentArray
        
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            
            self?.departmentNameTF.text = "\(item)"
            
            // self.editDepartmentNameTF.text = "\(selectedText)"
            self?.selectedDepartment = "\(item)"
            self?.departmentDetailUpdate.visibility = .gone
            self?.departmentDetail.forEach({ languageData in
                print("departmentDetail data \(languageData.DepartmentName ?? "")")
                if item == languageData.DepartmentName ?? "" {
                    self?.DepartmentIDForOperation = languageData.DepartmentID ?? 0
                    self?.departmentID = languageData.DepartmentID ?? 0
                    print("departmentDetail id \(self?.departmentID)")
                    self?.isDepartmentSelect = true
                }
            })
        }
    }
    @IBAction func actionVenueDropDown(_ sender: UIButton) {
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = venueArray
        print("Data in venue Array ,\(venueArray)")
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            if item == "Select Venue" {
                self?.venueDetailView.visibility = .gone
                self?.departmentOptionStackView.visibility = .gone
                self?.contactStackView.visibility = .gone
                self?.venueNameTF.text = "\(item)"
                self?.selectedVenue = "\(item)"
                self?.venueID = "0"
                self?.venueNameLbl.text =  ""
                self?.venueCityLbl.text =  "N/A"
                self?.venueStateLbl.text =  "N/A"
                self?.venueAddressLbl.text = "N/A"
                self?.venueZipcodeLbl.text = "N/A"
                self?.isVenueSelect = false
            }else {
                self?.venueDetailView.visibility = .visible
                self?.departmentOptionStackView.visibility = .visible
                self?.contactStackView.visibility = .visible
                self?.venueNameTF.text = "\(item)"
                self?.selectedVenue = "\(item)"
                self?.venueDetail.forEach({ languageData in
                    print("selected Venue name  \(languageData.VenueName ?? "")")
                    if item == languageData.VenueName ?? "N/A" {
                        self?.venueID = "\(languageData.VenueID ?? 0)"
                        self?.venueNameLbl.text = languageData.VenueName ?? "N/A"
                        self?.venueCityLbl.text = languageData.City ?? "N/A"
                        self?.venueStateLbl.text = languageData.State ?? "N/A"
                        self?.venueAddressLbl.text = languageData.Address ?? "N/A"
                        self?.venueZipcodeLbl.text = "\(languageData.ZipCode ?? "N/A")"
                        self?.isVenueSelect = true
                        print("selected venue ",languageData)
                    }
                })
            }
        }
    }
    @IBAction func actionAddActualDepartment(_ sender: UIButton) {
        if self.depatmrntActionType == 0 {
            //2 for delete
            //3 activate
            //4 deactivate
            // 0 for Add Departmnt
            if  editDepartmentNameTF.text == ""{
                self.view.makeToast("Please add Department Name.")
                return
            }else {
                let departmentName = editDepartmentNameTF.text ?? ""
                self.hitApiAddDepartment(id: 0, departmentName: departmentName, flag: "Add", isOneTime: 0, deptID: 0, type: "Department", venueID:  venueID, isChangeParameter: false)
                //self.actionDepartmentType = 0
            }
        }else if depatmrntActionType == 1 {
            // 1 for edit Department
            
            if  editDepartmentNameTF.text == ""{
                self.view.makeToast("Please add Department Name. ")
                return
            }else {
                let departmentName = editDepartmentNameTF.text ?? ""
                self.hitApiAddDepartment(id: self.departmentID, departmentName: departmentName, flag: "Update", isOneTime: 0, deptID: 0, type: "Department", venueID: venueID, isChangeParameter: false)
                //self.actionDepartmentType = 0
            }
        }else if depatmrntActionType == 5 {
            // 5 for Add one time Departmnt
            if  editDepartmentNameTF.text == ""{
                self.view.makeToast("Please add Department Name. ")
                return
            }else {
                let departmentName = editDepartmentNameTF.text ?? ""
                self.hitApiAddDepartment(id: 0, departmentName: departmentName, flag: "Add", isOneTime: 1, deptID: 0, type: "Department", venueID: venueID, isChangeParameter: false)
                //self.actionDepartmentType = 0
            }
        }else {
            
        }
    }
    @IBAction func actionOneTimeVenueBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Storyboard_name.home, bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddNewVenueViewController") as! AddNewVenueViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.userCustomerId = self.customerID
        vc.isOneTime = true
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBOutlet weak var actionOneTimeVenue: UIView!
    @IBAction func actionCloseDepartmentOption(_ sender: UIButton) {
        self.departmentOptionMajorView.isHidden = true
        
    }
    @IBAction func actionOpenDepartmentoption(_ sender: UIButton) {
        
        lblDepartment.text = "Add One Time Department"
        self.departmentOptionMajorView.isHidden = false
        self.optiontitleLbl.text = "Department"
        self.isContactOption = false
        self.activateOptionView.visibility = .gone
        self.DeactivateOptionView.visibility = .gone
    }
    
    
    @IBAction func actionDeactivateDepartment(_ sender: UIButton) {
        self.departmentOptionMajorView.isHidden = true
        self.depatmrntActionType = 4
    }
    
    @IBAction func actionActivateDepartment(_ sender: UIButton) {
        self.departmentOptionMajorView.isHidden = true
        self.depatmrntActionType = 3
    }
    //MARK: DELETE DEPARTMENT AND CONTACT
    
    @IBAction func actiopnDeleteDepartment(_ sender: UIButton) {
        
        
        
        if isContactOption {
            if self.contactNameTF.text != "" && self.contactNameTF.text != "Select Contact" {
                let storyboard = UIStoryboard(name: Storyboard_name.scheduleApnt, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDepartmentAndContactVC") as! UpdateDepartmentAndContactVC
                vc.modalPresentationStyle = .overCurrentContext
                vc.elementID = self.providerID
                vc.isdepartSelect = false
                vc.contactActiontype = 2
                vc.elementName = self.contactNameTF.text!
                vc.actionType = "Delete"
                vc.DeptID = self.providerID
                vc.tableDelegate = self
                vc.venueID = venueID
                self.present(vc, animated: true, completion: nil)
                self.departmentOptionMajorView.isHidden = true
                
            }
            else {
                self.showAlertwithmessage(message: "Please Select any Contact.")
            }
        }
        else {
            if self.departmentNameTF.text != "" && self.departmentNameTF.text != "Select Department" {
                let storyboard = UIStoryboard(name: Storyboard_name.scheduleApnt, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDepartmentAndContactVC") as! UpdateDepartmentAndContactVC
                vc.modalPresentationStyle = .overCurrentContext
                vc.elementID = self.DepartmentIDForOperation
                vc.isdepartSelect = true
                vc.depatmrntActionType = 2
                vc.elementName = self.departmentNameTF.text!
                vc.tableDelegate = self
                vc.actionType = "Delete"
                vc.venueID = venueID
                vc.DeptID = self.DepartmentIDForOperation
                self.present(vc, animated: true, completion: nil)
                self.departmentOptionMajorView.isHidden = true
            }
            else {
                self.showAlertwithmessage(message: "Please Select any Department.")
            }
        }
        
        
        
        
    }
    //MARK:  UPDATE Department and contact ONETIME
    
    @IBAction func actionEditDepartment(_ sender: UIButton) {
        
        
        //            if isContactOption {
        //                self.contactActiontype = 1
        //                self.editContactNameTF.text = self.selectedContact
        //                self.contactUpdateView.visibility = .visible
        //                self.departmentOptionMajorView.isHidden = true
        //
        //            }else {
        //                self.departmentOptionMajorView.isHidden = true
        //                self.depatmrntActionType = 1
        //                self.editDepartmentNameTF.text = self.selectedDepartment
        //                self.departmentDetailUpdate.visibility = .visible
        //            }
        //changes:
        
        if isContactOption {
            if self.contactNameTF.text != "" && self.contactNameTF.text != "Select Contact" {
                let storyboard = UIStoryboard(name: Storyboard_name.scheduleApnt, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDepartmentAndContactVC") as! UpdateDepartmentAndContactVC
                vc.modalPresentationStyle = .overCurrentContext
                if oneTimeContactArr.count != 0 {
                    if let obj = oneTimeContactArr.firstIndex(where: {$0.ProviderName == self.contactNameTF.text }){
                        vc.elementID = oneTimeContactArr[obj].ProviderID!
                        vc.isdepartSelect = false
                        vc.contactActiontype = 5
                        vc.elementName = self.contactNameTF.text!
                        vc.actionType = "Update"
                        vc.DeptID = oneTimeContactArr[obj].ProviderID!
                        vc.tableDelegate = self
                        vc.venueID = venueID
                        self.present(vc, animated: true, completion: nil)
                        self.departmentOptionMajorView.isHidden = true
                        
                    }
                    else {
                        vc.elementID = self.providerID
                        vc.isdepartSelect = false
                        vc.contactActiontype = 1
                        vc.elementName = self.contactNameTF.text!
                        vc.actionType = "Update"
                        vc.DeptID = self.providerID
                        vc.tableDelegate = self
                        vc.venueID = venueID
                        self.present(vc, animated: true, completion: nil)
                        self.departmentOptionMajorView.isHidden = true
                    }
                }
                else {
                    vc.elementID = self.providerID
                    vc.isdepartSelect = false
                    vc.contactActiontype = 1
                    vc.elementName = self.contactNameTF.text!
                    vc.actionType = "Update"
                    vc.DeptID = self.providerID
                    vc.venueID = venueID
                    vc.tableDelegate = self
                    self.present(vc, animated: true, completion: nil)
                    self.departmentOptionMajorView.isHidden = true
                }
            }
            else {
                self.showAlertwithmessage(message: "Please Select any Contact.")
            }
        }
        else {
            if self.departmentNameTF.text != "" && self.departmentNameTF.text != "Select Department" {
                let storyboard = UIStoryboard(name: Storyboard_name.scheduleApnt, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDepartmentAndContactVC") as! UpdateDepartmentAndContactVC
                vc.modalPresentationStyle = .overCurrentContext
                if oneTimeDepartmentArr.count != 0 {
                    if let obj = oneTimeDepartmentArr.firstIndex(where: {$0.DepartmentName == self.departmentNameTF.text }){
                        vc.elementID = oneTimeDepartmentArr[obj].DepartmentID!
                        vc.isdepartSelect = true
                        vc.depatmrntActionType = 5
                        vc.elementName = self.departmentNameTF.text!
                        vc.tableDelegate = self
                        vc.actionType = "Update"
                        vc.venueID = venueID
                        vc.DeptID = oneTimeDepartmentArr[obj].DepartmentID!
                        self.present(vc, animated: true, completion: nil)
                        self.departmentOptionMajorView.isHidden = true
                    }
                    
                    else {
                        vc.elementID = self.DepartmentIDForOperation
                        vc.isdepartSelect = true
                        vc.depatmrntActionType = 1
                        vc.elementName = self.departmentNameTF.text!
                        vc.tableDelegate = self
                        vc.actionType = "Update"
                        vc.venueID = venueID
                        vc.DeptID = self.DepartmentIDForOperation
                        self.present(vc, animated: true, completion: nil)
                        self.departmentOptionMajorView.isHidden = true
                    }
                }
                else {
                    vc.elementID = self.DepartmentIDForOperation
                    vc.isdepartSelect = true
                    vc.depatmrntActionType = 1
                    vc.elementName = self.departmentNameTF.text!
                    vc.tableDelegate = self
                    vc.actionType = "Update"
                    vc.venueID = venueID
                    vc.DeptID = self.DepartmentIDForOperation
                    self.present(vc, animated: true, completion: nil)
                    self.departmentOptionMajorView.isHidden = true
                }
                
            }
            else {
                self.showAlertwithmessage(message: "Please Select any Department.")
            }
        }
        
        
        
        //}
        
    }
    
    //MARK: ADD DEPARTMENT
    @IBAction func actionAddDepartment(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Storyboard_name.scheduleApnt, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDepartmentAndContactVC") as! UpdateDepartmentAndContactVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.isdepartSelect = true
        vc.actionType = "Add"
        vc.tableDelegate = self
        vc.depatmrntActionType = 0
        vc.venueID = venueID
        self.present(vc, animated: true, completion: nil)
        
    
    }
    
    //MARK: - Contact Action method
    
    @IBAction func actionClearContactField(_ sender: UIButton) {
        self.editContactNameTF.text = ""
        self.contactUpdateView.visibility = .gone
    }
    
    @IBAction func actionAddActualContact(_ sender: UIButton) {
        if self.contactActiontype == 0 {
            if  editContactNameTF.text == ""{
                self.view.makeToast("Please add Contact Name. ")
                return
            }else if self.departmentID == 0 {
                self.view.makeToast("Please select Department Name. ")
                return
            } else {
                let contactName = editContactNameTF.text ?? ""
                self.hitApiAddDepartment(id: 0, departmentName: contactName, flag: "Add", isOneTime: 0, deptID: self.departmentID, type: "Contact", venueID: venueID, isChangeParameter: false)
                //self.actionDepartmentType = 0
            }
        }else if contactActiontype == 1 {
            if  editContactNameTF.text == ""{
                self.view.makeToast("Please add Contact Name. ")
                return
            }else if self.departmentID == 0 {
                self.view.makeToast("Please select Department Name. ")
                return
            }else {
                let contactName = editContactNameTF.text ?? ""
                self.hitApiAddDepartment(id: self.providerID, departmentName: contactName, flag: "Update", isOneTime: 0, deptID: self.departmentID, type: "Contact", venueID: venueID, isChangeParameter: false)
                //self.actionDepartmentType = 0
            }
        }else if contactActiontype == 5 {
            // 5 for Add one time Departmnt
            if  editContactNameTF.text == ""{
                self.view.makeToast("Please add Contact Name. ")
                return
            }else if self.departmentID == 0 {
                self.view.makeToast("Please select Department Name. ")
                return
            } else {
                let contactName = editContactNameTF.text ?? ""
                self.hitApiAddDepartment(id: 0, departmentName: contactName, flag: "Add", isOneTime: 1, deptID: self.departmentID, type: "Contact", venueID: venueID, isChangeParameter: false)
                //self.actionDepartmentType = 0
            }
        }else {
            print("No action")
        }
    }
    
    //MARK: ADD CONTACT
    @IBAction func actionAddContact(_ sender: UIButton) {
      
        
        let storyboard = UIStoryboard(name: Storyboard_name.scheduleApnt, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDepartmentAndContactVC") as! UpdateDepartmentAndContactVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.isdepartSelect = false
        vc.tableDelegate = self
        vc.actionType = "Add"
        vc.contactActiontype = 0
        vc.venueID = venueID
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func actionOpenContactOPtion(_ sender: UIButton) {
        lblDepartment.text = "Add One Time Contact"
        self.departmentOptionMajorView.isHidden = false
        self.optiontitleLbl.text = "Contact"
        self.isContactOption = true
        self.activateOptionView.visibility = .gone
        self.DeactivateOptionView.visibility = .gone
        
    }
    
    //MARK: - Add venue Method
    @IBAction func actionAddVenue(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(identifier: "AddUpdateVenueVC") as! AddUpdateVenueVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //MARK: - Create Request method
    
    @IBAction func actionCreateRequest(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() {
            
            createRegularAppointment()
            
        }else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
        
    }
    func createRegularAppointment(){
        //"\(self.startDateTF.text ?? "") \(self.startTimeTimeTF.text ?? "")"
        let selectedText = languageTF.text ?? ""
        GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
            print("language data regular\(languageData.languageName ?? "")")
            if selectedText == languageData.languageName ?? "" {
                self.languageID = "\(languageData.languageID ?? 0)"
                print("languageId regular \(self.languageID)")
            }
        })
        if isGenderSelect {
            
        }else {
            self.genderDetail.forEach({ languageData in
                print("language data gender \(languageData.Value )")
                if genderTF.text ?? "" == languageData.Value {
                    self.genderID = languageData.Code
                    
                }
            })
        }
        
        if isProviderSelect {
            
        }else {
            self.providerDetail.forEach({ languageData in
                print("language data provider \(languageData.ProviderName ?? "")")
                if contactNameTF.text ?? "" == languageData.ProviderName ?? "" {
                    self.providerID = languageData.ProviderID ?? 0
                    
                }
            })
        }
        
        
        if isDepartmentSelect {
            
        }else {
            self.departmentDetail.forEach({ languageData in
                print("language data  department\(languageData.DepartmentName ?? "")")
                if departmentNameTF.text ?? "" == languageData.DepartmentName ?? "" {
                    self.departmentID = languageData.DepartmentID ?? 0
                    
                }
            })
        }
        if isVenueSelect {
            
        }else {
            self.venueDetail.forEach({ languageData in
                print("selected Venue name  \(languageData.VenueName ?? "")")
                if venueNameTF.text ?? "" == languageData.VenueName ?? "N/A" {
                    self.venueID = "\(languageData.VenueID ?? 0)"
                    
                    
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
        
        
        let userId = self.userID//GetPublicData.sharedInstance.userID
        //let companyID = GetPublicData.sharedInstance.companyID
        //let userTypeID = GetPublicData.sharedInstance.userTypeID
        //let userName = GetPublicData.sharedInstance.usenName
        let authCode = self.authCodeTF.text ?? ""
        let startDate = "\(self.appointmentDateTF.text ?? "") \(self.starttimeTF.text ?? "")"
        let endDate = "\(self.appointmentDateTF.text ?? "") \(self.endTimeTF.text ?? "")"
        
        let requestedOn = self.requestedONTF.text ?? ""
        let location = CEnumClass.share.replaceSpecialCharacters(str: self.locationTF.text ?? "")
        let textnote = CEnumClass.share.replaceSpecialCharacters(str: self.specialNotesTF.text ?? "")
        self.jobType = "Onsite Interpretation"
        print("venueID , language ID \(venueID ),\(languageID)")
        if self.appointmentDateTF.text!.isEmpty {
            self.view.makeToast("Please fill Start Date.",duration: 1, position: .center)
            
        }else if self.starttimeTF.text!.isEmpty {
            self.view.makeToast("Please fill End Date.",duration: 1, position: .center)
            
        }else if self.venueID == "0"  {
            self.view.makeToast("Please fill Venue Detail.",duration: 1, position: .center)
            
        }else if self.languageID == "0" {
            self.view.makeToast("Please fill Language Detail.",duration: 1, position: .center)
            
        }else {
            
            self.hitApiCreateRequest(masterCustomerID: self.masterCustomerID, authCode: authCode, SpecialityID: self.specialityID, ServiceType: self.serviceId, startTime: startDate, endtime: endDate, gender: self.genderID , caseNumber: self.cRefrence, clientName: self.clinetName, clientIntial: self.CIntials, location: location, textNote: textnote, SendingEndTimes: false, Travelling: "", CallTime: "", requestedOn: requestedOn, LoginUserId: userId, parameter: "")
            //self.createRequestForAppointment(userID: userId, companyID: companyID, AuthCode: authCode, AppointStatusID: appointStatusID, startDate: startDate, EndDate: endDate, AppointTypeID: appointTypeId, languageID: languageID, userTypeID: userTypeID, jobType: jobType, clientName: clientName, venueID: self.venueID, updatedOn: updatedOn, requestedON: requestedOn, loadedON: loadedOn, cpInitials: cpIntial, serviceTypeID: serviceId, genderID: genderId, userName: userName)
        }
    }
    
}
//MARK: - Api methoda
extension OnsiteRegularAppointmentVC{
    
    func hitApiAddDepartment(id : Int, departmentName : String, flag: String, isOneTime:Int, deptID :Int , type :String, venueID: String, isChangeParameter : Bool){
        if Reachability.isConnectedToNetwork() {
            SwiftLoader.show(animated: true)
            let urlString = APi.AddUpdateDeptAndContactData.url
            let companyID = self.companyID//GetPublicData.sharedInstance.companyID
            let userID = self.userID//GetPublicData.sharedInstance.userID
            // let userTypeId = GetPublicData.sharedInstance.userTypeID
            var searchString = ""
            if isChangeParameter {
                searchString = "<INFO><ID>\(id)</ID><Flag>\(flag)</Flag><Type>\(type)</Type></INFO>"
            }else {
                searchString = "<INFO><COMPANYID>\(companyID)</COMPANYID><ID>\(id)</ID><Name>\(departmentName)</Name><VenueID>\(venueID)</VenueID><Flag>\(flag)</Flag><Type>\(type)</Type><CustomerID>\(self.customerID)</CustomerID><OneTime>\(isOneTime)</OneTime><Deptid>\(deptID)</Deptid><LOGINUSERID>\(userID)</LOGINUSERID></INFO>"
            }
            
            let parameter = [
                "strSearchString" : searchString
            ] as [String : String]
            print("url and parameter are for department ", urlString, parameter)
            AF.request(urlString, method: .post , parameters: parameter, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseData(completionHandler: { [self] (response) in
                    SwiftLoader.hide()
                    switch(response.result){
                        
                    case .success(_):
                       
                        guard let daata = response.data else { return }
                        do {
                            let jsonDecoder = JSONDecoder()
                            self.apiGetCustomerDetailResponseModel = try jsonDecoder.decode([ApiGetCustomerDetailResponseModel].self, from: daata)
                            
                            let str = self.apiGetCustomerDetailResponseModel.first?.result ?? ""
                            let data = str.data(using: .utf8)!
                            do {
                                
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
                                        
                                        self.view.makeToast(message ?? "",duration: 2, position: .center)
                                        if contactActiontype != nil {
                                            self.contactNameTF.text = ""
                                            self.contactUpdateView.visibility = .gone
                                            self.editContactNameTF.text = ""
                                            
                                            if contactActiontype  == 5 {
                                                let itemA = ProviderData(ProviderID: status, ProviderName: departmentName,isOneTime: true)
                                                oneTimeContactArr.append(itemA)
                                            }else  if contactActiontype == 2 {
                                                print("Delete Action ")
                                                
                                                for (indexx , itemm) in oneTimeContactArr.enumerated() {
                                                    if itemm.ProviderID == id {
                                                        self.oneTimeContactArr.remove(at: indexx)
                                                        
                                                    }else {
                                                        
                                                    }}
                                                for (indexx , itemm) in providerDetail.enumerated() {
                                                    if itemm.ProviderID == id {
                                                        self.providerDetail.remove(at: indexx)
                                                        
                                                    }else {
                                                        
                                                    }}
                                                
                                                if let index = providerArray.firstIndex(of: departmentName) {
                                                    //index has the position of first match
                                                    self.providerArray.remove(at: index)
                                                } else {
                                                    //element is not present in the array
                                                }
                                                
                                            }else {
                                                
                                            }
                                        }else if depatmrntActionType != nil  {
                                            
                                            self.departmentNameTF.text = ""
                                            self.editDepartmentNameTF.text = ""
                                            self.departmentDetailUpdate.visibility = .gone
                                            if depatmrntActionType == 5 {
                                                let itemA = DepartmentData(DeActive: 0, DepartmentID: status, DepartmentName: departmentName,isOneTime: true)
                                                oneTimeDepartmentArr.append(itemA)
                                            }else  if depatmrntActionType == 2 {
                                                print("Delete Action ")
                                                
                                                for (indexx , itemm) in oneTimeDepartmentArr.enumerated() {
                                                    if itemm.DepartmentID == id {
                                                        self.oneTimeDepartmentArr.remove(at: indexx)
                                                        
                                                    }else {
                                                        
                                                    }
                                                   }
                                                for (indexx , itemm) in departmentDetail.enumerated() {
                                                    if itemm.DepartmentID == id {
                                                        self.departmentDetail.remove(at: indexx)
                                                        
                                                    }else {
                                                        
                                                    }
                                                  }
                                                
                                                if let index = departmentArray.firstIndex(of: departmentName) {
                                                    //index has the position of first match
                                                    self.departmentArray.remove(at: index)
                                                } else {
                                                    //element is not present in the array
                                                }
                                                
                                            }
                                        }else {
                                            
                                        }
                                        getVenueDetail(customerId: self.customerID)
                                    }else {
                                        self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
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
                        print("Respose Success getSubcustomerList ")
                        guard let daata = response.data else { return }
                        do {
                            let jsonDecoder = JSONDecoder()
                            self.apiGetCustomerDetailResponseModel = try jsonDecoder.decode([ApiGetCustomerDetailResponseModel].self, from: daata)
                            print("Success getCustomerDetail Model ",self.apiGetCustomerDetailResponseModel.first?.result ?? "")
                            let str = self.apiGetCustomerDetailResponseModel.first?.result ?? ""
                            let data = str.data(using: .utf8)!
                            do {
                                //
                                print("DATAAA ISSSv in  getSubcustomerList \(data)")
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
                                            self.customerID = customerID
                                            
                                        }else {
                                            print("venue Function call for non subcustomer  ")
                                            self.subCustomerNameTF.text = ""
                                            
                                        }
                                        let itemA = SubCustomerListData(UniqueID: UniqueID ?? 0, Email: Email ?? "", CustomerUserName: CustomerUserName ?? "", Priority: Priority ?? 0, MasterUsertype: MasterUsertype ?? 0, Mobile: Mobile ?? "", PurchaseOrderNote: PurchaseOrderNote ?? "", CustomerID: CustomerID ?? 0, CustomerFullName: CustomerFullName ?? "", EmailToRequestor: EmailToRequestor ?? 0)
                                        self.subcustomerArr.append(CustomerFullName ?? "")
                                        self.subcustomerList.append(itemA)
                                        
                                    })
                                    GetPublicData.sharedInstance.TempCustomerID = self.customerID
                                    getVenueDetail(customerId: self.customerID)
                                    
                                    // showSubcustomerDropDown()
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
            //GetGetAppointmentCommanddl
            self.subcustomerArr.removeAll()
            self.subcustomerList.removeAll()
            let companyID = self.companyID//GetPublicData.sharedInstance.companyID
            let userID = self.userID//GetPublicData.sharedInstance.userID
            let userTypeId = self.userTypeID//GetPublicData.sharedInstance.userTypeID
            //LoginuserType ID
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
                                    print("Customer ID in Customer Detail \(customerID ?? 0)")
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
    func getVenueDetail(customerId : String){
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
            
            oneTimeContactArr.forEach { oneTimeDepart in
                self.providerDetail.append(oneTimeDepart)
                self.providerArray.append(oneTimeDepart.ProviderName ?? "")
            }
            
            oneTimeDepartmentArr.forEach { oneTimeDepart in
                self.departmentDetail.append(oneTimeDepart)
                self.departmentArray.append(oneTimeDepart.DepartmentName ?? "")
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
                      
                        guard let daata = response.data else { return }
                        do {
                            let jsonDecoder = JSONDecoder()
                            self.apiGetCustomerDetailResponseModel = try jsonDecoder.decode([ApiGetCustomerDetailResponseModel].self, from: daata)
                            
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
                                    // self.venueNameTF.text = ""
                                    // self.venueDetailView.visibility = .gone
                                    //self.departmentOptionStackView.visibility = .gone
                                    // self.contactStackView.visibility = .gone
                                    //  self.departmentNameTF.text = ""
                                    //  self.departmentDetailUpdate.visibility = .gone
                                    //  self.contactNameTF.text = ""
                                    //  self.contactUpdateView.visibility = .gone
                                    // showVenueDropDown()
                                    
                                    /*if isContact == "1"{
                                        if let obj = self.providerDetail.firstIndex(where: {$0.ProviderID == id}){
                                            self.contactNameTF.text = self.providerDetail[obj].ProviderName
                                        }
                                        else {
                                            self.contactNameTF.text = ""
                                        }
                                    }
                                    else if isContact == "2" {
                                        
                                        if let obj = self.departmentDetail.firstIndex(where: {$0.DepartmentID == id}){
                                            self.departmentNameTF.text = self.departmentDetail[obj].DepartmentName
                                          }
                                        else {
                                            self.departmentNameTF.text = ""
                                        }
                                    }*/
                                   
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
                                    print("Auth code is \(getAuthCode)")
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
                                    // showGenderDropDown()
                                    showLnaguageDropdown()
                                    // updateServiceAndSpeciality()
                                    self.authCodeTF.text = authcode ?? ""
                                    self.jobTypeTF.text = "Onsite Interpretation "
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
            
            let searchString = "<INFO><CustomerUserID>\(customerUserID)</CustomerUserID><Action>A</Action><AppointmentID>0</AppointmentID><CustomerID>\(self.customerID)</CustomerID><Company>\(companyID)</Company><MasterCustomerID>\(masterCustomerID)</MasterCustomerID><AppointmentTypeID>1</AppointmentTypeID><AuthCode>\(authCode)</AuthCode><SpecialityID>\(SpecialityID)</SpecialityID><ServiceType>\(ServiceType)</ServiceType><StartDateTime>\(startTime)</StartDateTime><EndDateTime>\(endtime)</EndDateTime><Distance>0.00</Distance><AppointmentFlag>R</AppointmentFlag><LanguageID>\(self.languageID)</LanguageID><Gender>\(gender)</Gender><CaseNumber>\(caseNumber)</CaseNumber><ClientName>\(clientName)</ClientName><cPIntials>\(clientIntial)</cPIntials><VenueID>\(self.venueID)</VenueID><VendorID></VendorID><DepartmentID>\(self.departmentID)</DepartmentID><ProviderID>\(self.providerID)</ProviderID><Location>\(location)</Location><Text>\(textNote)</Text><SendingEndTimes>\(SendingEndTimes)</SendingEndTimes><AptDetails></AptDetails><FinancialNotes></FinancialNotes><ScheduleNotes></ScheduleNotes><AppointmentStatusID>2</AppointmentStatusID><Travelling>\(Travelling)</Travelling><Ranking></Ranking><ConfirmationBit>false</ConfirmationBit><VendorMileage>false</VendorMileage><Priority>false</Priority><CallServiceBit>false</CallServiceBit><Office></Office><Home></Home><Cell></Cell><Purpose></Purpose><CallTime>\(CallTime)</CallTime><AdditionTravelTimePay>00:00</AdditionTravelTimePay><ArrivalTime></ArrivalTime><DepartureTime></DepartureTime><RequestedOn>\(requestedOn)</RequestedOn><ConfirmedOn></ConfirmedOn><BookedOn></BookedOn><CancelledOn></CancelledOn><RequestedBy>\(userID)</RequestedBy><ConfirmedBy></ConfirmedBy><BookedBy></BookedBy><CancelledBy></CancelledBy><LoadedBy>\(userID)</LoadedBy><RequestorName></RequestorName><MgemilRist>false</MgemilRist><isChanged>false</isChanged><oneHremail></oneHremail><LoginUserId>\(LoginUserId)</LoginUserId><ReasonforBotch></ReasonforBotch><PurchaseOrder></PurchaseOrder><Claim></Claim><Reference></Reference><SecurityClearence></SecurityClearence><ExperienceOfVendor></ExperienceOfVendor><InterpreterType></InterpreterType><AssignToFieldStaff></AssignToFieldStaff><RequestorName></RequestorName><RequestorEmail></RequestorEmail><TierName>W</TierName><WaitingList></WaitingList><overrideSatus></overrideSatus><overrideauth></overrideauth><SaveFlag>0</SaveFlag><SUBAPPOINTMENT></SUBAPPOINTMENT><InterpreterBookedId></InterpreterBookedId></INFO>"
            
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
                                    let emailResponse = newjson?["EmailNotification"] as? [[String:Any]]
                                    let matchAuth = emailResponse?.first!["AuthCode"] as? String
                                    let userInfo = newjson?["AppointmentResponce"] as? [[String:Any]]
                                    //let statusInfo = newjson?["StatusInfo"] as? [[String:Any]] // use the json here
                                    let userIfo = userInfo?.first
                                    let AppointmentID = userIfo?["AppointmentID"] as? Int
                                    let success = userIfo?["success"] as? Int
                                    let message = userIfo?["Message"] as? String
                                    let AuthCode = userIfo?["AuthCode"] as? String
                                    
                                    
                                    if success == 1 {
                                        DispatchQueue.main.async {
                                            self.appointmentBookedCalls(message: message ?? "", authcode: matchAuth!)
                                        }
                                        
                                        /* self.view.makeToast(Message,duration: 1, position: .center)
                                         DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                                         self.navigationController?.popViewController(animated: true)
                                         }*/
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
            // let companyID = self.companyID//GetPublicData.sharedInstance.companyID
            // let userID = self.userID//GetPublicData.sharedInstance.userID
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
                            // print("Success apiEncryptedDataResponse Model ",self.apiEncryptedDataResponse)
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
extension OnsiteRegularAppointmentVC:ReloadBlockedTable {
    func bookedAppointment() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didReloadTable(performTableReload: Bool, elemntID: Int, isConatctUpdate: Bool) {
        
        //"Delegate12 in didReloadTable Data updated is \(elemntID) and is it conatct \(isConatctUpdate)")
        if isConatctUpdate {
            self.contactNameTF.text = ""
        }
        else {
            self.departmentNameTF.text = ""
        }
        getVenueDetail(customerId: self.customerID)
      
    }
    
    func didopenMoreoption(action: Bool, type: String) {
      
    }
    
    func updateOneTimeDepartment(departmentData: DepartmentData, isDelete: Bool) {
        if oneTimeDepartmentArr.count != 0 {
            if isDelete {
                if let obj = oneTimeDepartmentArr.firstIndex(where: {$0.DepartmentID == departmentData.DepartmentID}){
                    oneTimeDepartmentArr.remove(at: obj)
                }
                
                self.departmentNameTF.text = ""
                getVenueDetail(customerId: self.customerID)
                
            }
            else {
                if let obj = oneTimeDepartmentArr.firstIndex(where: {$0.DepartmentID == departmentData.DepartmentID}){
                    oneTimeDepartmentArr.remove(at: obj)
                }
                self.departmentNameTF.text = ""
                
                
                self.oneTimeDepartmentArr.append(departmentData)
                getVenueDetail(customerId: self.customerID)
            }
        }
        else {
            if isDelete {
                
                self.departmentNameTF.text = ""
                getVenueDetail(customerId: self.customerID)
            }
            else {
                self.departmentNameTF.text = ""
                
                self.oneTimeDepartmentArr.append(departmentData)
                getVenueDetail(customerId: self.customerID)
            }
        }
    }
    
    func updateOneTimeConatct(ConatctData: ProviderData, isDelete: Bool) {
        
        if oneTimeContactArr.count != 0 {
            if isDelete {
                if let obj = oneTimeContactArr.firstIndex(where: {$0.ProviderID == ConatctData.ProviderID}){
                    oneTimeContactArr.remove(at: obj)
                }
                
                self.contactNameTF.text = ""
                getVenueDetail(customerId: self.customerID)
                
            }
            else {
                if let obj = oneTimeContactArr.firstIndex(where: {$0.ProviderID == ConatctData.ProviderID}){
                    oneTimeContactArr.remove(at: obj)
                }
                self.contactNameTF.text = ""
                
                
                self.oneTimeContactArr.append(ConatctData)
                getVenueDetail(customerId: self.customerID)
            }
        }
        else {
            if isDelete {
                self.contactNameTF.text = ""
                getVenueDetail(customerId: self.customerID)
            }
            else {
                self.contactNameTF.text = ""
                
                self.oneTimeContactArr.append(ConatctData)
                getVenueDetail(customerId: self.customerID)
            }
        }
    }
    
    func showAlertWithMessageInTable(message: String) {
        print("")
    }
    func showAlertwithmessage(message :String){
        print("Alert printing ")
        let  refreshAlert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    
}
extension OnsiteRegularAppointmentVC {
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
