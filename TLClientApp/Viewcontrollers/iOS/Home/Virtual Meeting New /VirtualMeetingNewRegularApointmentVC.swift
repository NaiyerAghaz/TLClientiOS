//
//  VirtualMeetingNewRegularApointmentVC.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 07/03/22.
//

import UIKit
import iOSDropDown
import Alamofire
import DropDown
class VirtualMeetingNewRegularApointmentVC: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var serviceTypeTF: iOSDropDown!
    @IBOutlet weak var specialityTF: iOSDropDown!
    @IBOutlet weak var jobTypeTF: UITextField!
    @IBOutlet weak var authCodeTF: UITextField!
    @IBOutlet weak var subCustomerNameTF: iOSDropDown!
    @IBOutlet weak var customerNameTF: UITextField!
    @IBOutlet weak var optiontitleLbl: UILabel!
    
    @IBOutlet weak var activateOptionView: UIView!
    
    @IBOutlet weak var contactNameTF: iOSDropDown!
    
    @IBOutlet weak var appointmentDateTF: UITextField!
   
    @IBOutlet weak var caseRefrenceTF: UITextField!
    @IBOutlet weak var patientIntialTF: UITextField!
  
    @IBOutlet weak var starttimeTF: UITextField!
    @IBOutlet weak var loadedOnTF: UITextField!
    @IBOutlet weak var cancelledOnTF: UITextField!
    @IBOutlet weak var bookedONTF: UITextField!
    @IBOutlet weak var requestedONTF: UITextField!
   
    @IBOutlet weak var patientNameTF: UITextField!
    @IBOutlet weak var languageTF: iOSDropDown!
    @IBOutlet weak var endTimeTF: UITextField!
    
    @IBOutlet weak var editContactNameTF: UITextField!
    @IBOutlet weak var genderTF: iOSDropDown!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var specialNotesTF: UITextField!
    
    @IBOutlet weak var departmentOptionView: UIView!
    @IBOutlet weak var departmentOptionMajorView: UIView!
    
    @IBOutlet weak var contactUpdateView: UIView!
    
    @IBOutlet weak var DeactivateOptionView: UIView!
    var dropDown = DropDown()
    var specialityDetail = [SpecialityData]()
    var serviceDetail = [ServiceData]()
    var serviceArr:[String] = []
    var specialityArray:[String] = []
    var languageArray:[String] = []
    var genderArray :[String] = []
    var venueArray :[String] = []
    var departmentArray :[String] = []
    var providerArray :[String] = []
    var loginUserID = ""
    var genderDetail = [GenderData]()
    var venueDetail = [VenueData]()
    var subcustomerList = [SubCustomerListData]()
    var departmentDetail = [DepartmentData]()
    var providerDetail = [ProviderData]()
    var languageDetail = [LanguageData]()
    var subcustomerArr = [String]()
    var oneTimeDepartmentArr = [DepartmentData]()
    var oneTimeContactArr = [ProviderData]()
    var blockedAppointmentArr = [BlockedAppointmentData]()
    
    
    
    var depatmrntActionType:Int? = nil
    var contactActiontype:Int? = nil
    var selectTypeOFAppointment = "R"
    
    var languageID = "0"
    var serviceId = ""
    var specialityID = ""
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
    var jobType = "Virtual Meeting"
    var clinetName = ""
    var CIntials = ""
    var cRefrence = ""
    var authCode = ""
    var userID = ""
    var companyID = ""
    var userTypeID = ""
   
    var selectedStartTimeForPicker = Date().nearestHour()!
    var selectedEndTimeForPicker = Date().adding(minutes: 60).nearestHour()!
    
    var isGenderSelect = false
    var isProviderSelect = false
    var isDepartmentSelect = false
    var isVenueSelect = false
    var isSpecialitySelect = false
    var isServiceSelect = false
    var isContactOption = false
    
    var apiEncryptedDataResponse:ApiEncryptedDataResponse?
    var apiGetCustomerDetailResponseModel = [ApiGetCustomerDetailResponseModel]()
    var apiAddUpdateDepartmentResponseModel=[ApiAddUpdateDepartmentResponseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.departmentOptionMajorView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.departmentOptionMajorView.isHidden = true
        self.departmentOptionView.layer.cornerRadius = 15
        self.departmentOptionView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        self.userID = userDefaults.string(forKey: "userId") ?? ""
        self.companyID = userDefaults.string(forKey: "companyID") ?? ""
        self.userTypeID = userDefaults.string(forKey: "userTypeID") ?? ""
        
       // self.activateDeactivateView.visibility = .gone
        self.loginUserID = userDefaults.string(forKey: "LoginUserTypeID") ?? ""
        if self.loginUserID == "10" || self.loginUserID == "7" || self.loginUserID == "8" || self.loginUserID == "11" {
            self.subCustomerNameTF.isUserInteractionEnabled = false
        }else {
            self.subCustomerNameTF.isUserInteractionEnabled = true
        }
        contactUpdateView.visibility = .gone
        self.patientNameTF.delegate = self
        self.caseRefrenceTF.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateVenueList), name: Notification.Name("updateVenueList"), object: nil)
        
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "MM/dd/yyyy"
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "h:mm a"
        let currentDateTime = Date().nearestHour() ?? Date()
        print("current time before \(currentDateTime)")
        let tempTime = dateFormatterTime.string(from: currentDateTime)
        print("TEMP TIME : \(tempTime)")
        
        self.starttimeTF.text = CEnumClass.share.getRoundCTime()
        
        let endTimee = Date().adding(minutes: 60).nearestHour() ?? Date()
        self.appointmentDateTF.text = CEnumClass.share.getCurrentDate()//dateFormatterDate.string(from: currentDateTime)
        self.endTimeTF.text = CEnumClass.share.getMinuteDiffers(startTime: CEnumClass.share.getRoundCTime(), differ: "60", companyId: companyID)//dateFormatterTime.string(from: endTimee)
        
        let dateFormatterr = DateFormatter()
        dateFormatterr.dateFormat = "MM/dd/yyyy h:mm a"
        let startDatee =  dateFormatterr.string(from: Date().nearestHour() ?? Date ())
        
        self.requestedONTF.text = CEnumClass.share.getActualDateAndTime()
        self.loadedOnTF.text = CEnumClass.share.getActualDateAndTime()
        
       getCommonDetail()
       getCustomerDetail()
      

        // Do any additional setup after loading the view.
    }
   
//    @objc func updateVirtualRegularScreen(notification: Notification){
//        print("refreshing data in updateVirtualRegularScreen regular ")
//        getCommonDetail()
//        getCustomerDetail()
//    }
    @objc func updateVenueList(){
       getCustomerDetail()
        
    }
    @IBAction func actionRefreshData(_ sender: UIButton) {
        
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
              print("subcustomerList data \(languageData.CustomerFullName ?? "")")
              if item == languageData.CustomerFullName ?? "" {
                  //self.languageID = "\(languageData.languageID ?? 0)"
                  let cid = "\(languageData.CustomerID ?? 0 )"
                  self?.customerID = cid
                  self?.getVenueDetail(customerId: cid)
                 // print("subcustomerList id \(languageData.UniqueID)")
                  
                  
              }
          })
      }
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
    
    //MARK: - show  Drop downs
    
    func showGenderDropDown(){
        
        genderTF.optionArray = self.genderArray
        
        print("OPTIONS NEW ARRAY \(languageTF.optionArray)")
        
        genderTF.checkMarkEnabled = false
        genderTF.isSearchEnable = false
        genderTF.selectedRowColor = UIColor.clear
        genderTF.didSelect{(selectedText , index , id) in
            self.genderTF.text = "\(selectedText)"
            self.genderDetail.forEach({ languageData in
                print("gender data  \(languageData.Value )")
                if selectedText == languageData.Value {
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
        print("OPTIONS ARRYA \(GetPublicData.sharedInstance.languageArray)")
        print("OPTIONS NEW ARRAY \(languageTF.optionArray)")
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
            print("selectedStartTimeForPicker \(self?.selectedStartTimeForPicker)")
            self?.selectedEndTimeForPicker = selectedDate.adding(minutes: 60)
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            let endTimee = roundoff.adding(minutes: 60)
            self?.starttimeTF.text = roundoff.dateString("hh:mm a")
             
            self?.endTimeTF.text = endTimee.dateString("hh:mm a")
        })
        
    }
    @IBAction func selectEndTime(_ sender: UIButton) {
        let minDate = selectedStartTimeForPicker.adding(minutes: 60)//Date().adding(minutes: 120)
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
        self.present(vc, animated: true, completion: nil)
        self.departmentOptionMajorView.isHidden = true
        
//
//            if isContactOption {
//                self.departmentOptionMajorView.isHidden = true
//                self.contactActiontype = 5
//                // 5 for Add one time  Department
//                self.editContactNameTF.text = ""
//                self.contactUpdateView.visibility = .visible
//            }else {
//                self.departmentOptionMajorView.isHidden = true
//                self.depatmrntActionType = 5
//                // 5 for Add one time  Department
//
//            }
        
        
    }
    
    
    @IBAction func actionCloseDepartmentOption(_ sender: UIButton) {
        self.departmentOptionMajorView.isHidden = true
        
    }
    @IBAction func actionOpenDepartmentoption(_ sender: UIButton) {
        
        self.departmentOptionMajorView.isHidden = false
        self.optiontitleLbl.text = "Department"
        self.isContactOption = false
        self.activateOptionView.visibility = .visible
        self.DeactivateOptionView.visibility = .visible
    }
    @IBAction func actionDeactivateDepartment(_ sender: UIButton) {
        
       
            self.departmentOptionMajorView.isHidden = true
            self.depatmrntActionType = 4
        
        
        
        
        
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
        
       
            self.departmentOptionMajorView.isHidden = true
            self.depatmrntActionType = 3
        
        
        
        
        
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
        self.departmentOptionMajorView.isHidden = true
            if isContactOption {
                self.contactActiontype = 2
                if  contactNameTF.text == ""{
                    self.view.makeToast("Please add Contact Name. ")
                    return
                }else {
                    let contactName = contactNameTF.text ?? ""
                    self.hitApiAddDepartment(id: self.providerID, departmentName: contactName, flag: "Delete", isOneTime: 0, deptID: self.departmentID, type: "Contact", isChangeParameter: true)
                    //self.actionDepartmentType = 0
                }
            }else {
               
            }
        
        
       
    }
    
    @IBAction func actionEditDepartment(_ sender: UIButton) {
        
        /*changes start*/
        
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
                    vc.tableDelegate = self
                    self.present(vc, animated: true, completion: nil)
                    self.departmentOptionMajorView.isHidden = true
                }
                }
            else {
                self.showAlertwithmessage(message: "Please Select any Contact.")
            }
        }
       
//            if isContactOption {
//                self.departmentOptionMajorView.isHidden = true
//                self.contactActiontype = 1
//                self.editContactNameTF.text = self.selectedContact
//                self.contactUpdateView.visibility = .visible
//            }else {
//                self.departmentOptionMajorView.isHidden = true
//                self.depatmrntActionType = 1
//
//            }
            
        
    }
    func showAlertwithmessage(message :String){
       
        let  refreshAlert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    print("Handle Ok logic here")
                   
                  }))
        self.present(refreshAlert, animated: true, completion: nil)
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
            } else {
                let contactName = editContactNameTF.text ?? ""
                self.hitApiAddDepartment(id: 0, departmentName: contactName, flag: "Add", isOneTime: 0, deptID: self.departmentID, type: "Contact", isChangeParameter: false)
                //self.actionDepartmentType = 0
            }
        }else if contactActiontype == 1 {
            if  editContactNameTF.text == ""{
                self.view.makeToast("Please add Contact Name. ")
                return
            }else {
                let contactName = editContactNameTF.text ?? ""
                self.hitApiAddDepartment(id: self.providerID, departmentName: contactName, flag: "Update", isOneTime: 0, deptID: self.departmentID, type: "Contact", isChangeParameter: false)
                //self.actionDepartmentType = 0
            }
        }else if contactActiontype == 5 {
            // 5 for Add one time Departmnt
            if  editContactNameTF.text == ""{
                self.view.makeToast("Please add Contact Name. ")
                return
            } else {
                let contactName = editContactNameTF.text ?? ""
                self.hitApiAddDepartment(id: 0, departmentName: contactName, flag: "Add", isOneTime: 1, deptID: self.departmentID, type: "Contact", isChangeParameter: false)
                //self.actionDepartmentType = 0
            }
        }else {
            print("No action")
        }
    }
   
   
    @IBAction func actionAddContact(_ sender: UIButton) {
        print("show contact  ")
        
        let storyboard = UIStoryboard(name: Storyboard_name.scheduleApnt, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDepartmentAndContactVC") as! UpdateDepartmentAndContactVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.isdepartSelect = false
        vc.tableDelegate = self
        vc.actionType = "Add"
        vc.contactActiontype = 0
        self.present(vc, animated: true, completion: nil)
        
//        self.contactActiontype = 0
//        self.editContactNameTF.text = ""
//        self.contactUpdateView.visibility = .visible
    }
    
    
    @IBAction func actionOpenContactOPtion(_ sender: UIButton) {
        
        self.departmentOptionMajorView.isHidden = false
        self.optiontitleLbl.text = "Contact"
        self.isContactOption = true
        self.activateOptionView.visibility = .gone
        self.DeactivateOptionView.visibility = .gone
        
    }
    
    //MARK: - Add venue Method
    @IBAction func actionAddVenue(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Storyboard_name.home, bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddNewVenueViewController") as! AddNewVenueViewController
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
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
        let startDate = "\(self.appointmentDateTF.text ?? "") \(self.starttimeTF.text ?? "")"
        let endDate = "\(self.appointmentDateTF.text ?? "") \(self.endTimeTF.text ?? "")"
        
        let requestedOn = self.requestedONTF.text ?? ""
        let location = self.locationTF.text ?? "" //(CEnumClass.share.replaceSpecialCharacters(str: self.locationTF.text ?? ""))
        let textnote = self.specialNotesTF.text ?? "" //(CEnumClass.share.replaceSpecialCharacters(str: self.specialNotesTF.text ?? ""))
        self.jobType = "Virtual Meeting"
        
        if self.appointmentDateTF.text!.isEmpty {
            self.view.makeToast("Please fill Start Date.",duration: 1, position: .center)
            
        }else if self.starttimeTF.text!.isEmpty {
            self.view.makeToast("Please fill End Date.",duration: 1, position: .center)
            
        }else if self.languageID == "0" {
            self.view.makeToast("Please fill Language Detail.",duration: 1, position: .center)
            
        }else {
            
            self.hitApiCreateRequest(masterCustomerID: self.masterCustomerID, authCode: authCode, SpecialityID: self.specialityID, ServiceType: self.serviceId, startTime: startDate, endtime: endDate, gender: self.genderID , caseNumber: self.cRefrence, clientName: self.clinetName, clientIntial: self.CIntials, location: location, textNote: textnote, SendingEndTimes: false, Travelling: "", CallTime: "", requestedOn: requestedOn, LoginUserId: userId, parameter: "")
            
        }
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
              print("providerDetail data \(languageData.ProviderName ?? "")")
              if item == languageData.ProviderName ?? "" {
                  self?.providerID = languageData.ProviderID ?? 0
                  print("providerDetail id \(self?.providerID)")
                  self?.isProviderSelect = true
              }
          })
      }
    }
}
//MARK: - Api methoda
extension VirtualMeetingNewRegularApointmentVC{
    
        func hitApiAddDepartment(id : Int, departmentName : String, flag: String, isOneTime:Int, deptID :Int , type :String, isChangeParameter : Bool){
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
                searchString = "<INFO><COMPANYID>\(companyID)</COMPANYID><ID>\(id)</ID><Name>\(departmentName)</Name><VenueID></VenueID><Flag>\(flag)</Flag><Type>\(type)</Type><CustomerID>\(self.customerID)</CustomerID><OneTime>\(isOneTime)</OneTime><Deptid>\(deptID)</Deptid><LOGINUSERID>\(userID)</LOGINUSERID></INFO>"
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
                                            
                                            if contactActiontype == 5 {
                                                let itemA = ProviderData(ProviderID: status, ProviderName: departmentName)
                                                oneTimeContactArr.append(itemA)
                                            }else  if contactActiontype == 2 {
                                              
                                                
                                                for (indexx , itemm) in oneTimeContactArr.enumerated() {
                                                    if itemm.ProviderID == id {
                                                        self.oneTimeContactArr.remove(at: indexx)
                                                        
                                                    }else {
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                for (indexx , itemm) in providerDetail.enumerated() {
                                                    if itemm.ProviderID == id {
                                                        self.providerDetail.remove(at: indexx)
                                                        
                                                    }else {
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                
                                                if let index = providerArray.firstIndex(of: departmentName) {
                                                    //index has the position of first match
                                                    self.providerArray.remove(at: index)
                                                } else {
                                                    //element is not present in the array
                                                }
                                                
                                            }else {
                                                
                                            }
                                        }else if depatmrntActionType != nil  {
                                            
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
                                  //  showSubcustomerDropDown()
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
                                   // print("userInfo ", userInfo,customerUserName , customerEmail , customerFullName)
                                    let itemA = SubCustomerListData(UniqueID:  0, Email: "", CustomerUserName: "", Priority: 0, MasterUsertype: 0, Mobile: "", PurchaseOrderNote: "", CustomerID: customerID, CustomerFullName:  "Select Sub customer", EmailToRequestor: 0)
                                    self.subcustomerArr.append("Select Sub customer")
                                    self.subcustomerList.append(itemA)
                                    getSubcustomerList()
                                    self.customerNameTF.text = customerFullName
//                                    self.subCustomerNameTF.text = ""
//                                    if (userID == "10") || (userID == "7") || (userID == "8") || (userID == "11") {
//                                        self.subCustomerNameTF.isUserInteractionEnabled = false
//                                    }else {
//                                        self.subCustomerNameTF.isUserInteractionEnabled = true
//                                    }
                                    
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
    func getVenueDetail(customerId: String){
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
                                  //showVenueDropDown()
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
            let searchString = "<INFO><COMPANYID>\(companyID)</COMPANYID><LOGINUSERID>\(userID)</LOGINUSERID><LOGINUSERTYPEID>\(userTypeId)</LOGINUSERTYPEID><AUTHFLAG>2</AUTHFLAG><JobtypeID>13</JobtypeID></INFO>"
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
                                        if  DisplayValue == "Virtual Meeting" || DisplayValue == "Select Specialty" {
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
                                    showGenderDropDown()
                                    showLnaguageDropdown()
                                  //  updateServiceAndSpeciality()
                                    self.authCodeTF.text = authcode ?? ""
                                    self.jobTypeTF.text = "Virtual Meeting"
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
           // let userTypeId = self.userTypeID//GetPublicData.sharedInstance.userTypeID
                var customerUserID = ""
                if self.userTypeID == "4" || self.userTypeID == "10" {
                    customerUserID = "0"
                }
                else {
                    customerUserID = userID
                }
               
                let searchString = "<INFO><CustomerUserID>\(customerUserID)</CustomerUserID><Action>A</Action><AppointmentID>0</AppointmentID><CustomerID>\(self.customerID)</CustomerID><Company>\(companyID)</Company><MasterCustomerID>\(masterCustomerID)</MasterCustomerID><AppointmentTypeID>13</AppointmentTypeID><AuthCode>\(authCode)</AuthCode><SpecialityID>\(SpecialityID)</SpecialityID><ServiceType>\(ServiceType)</ServiceType><StartDateTime>\(startTime)</StartDateTime><EndDateTime>\(endtime)</EndDateTime><Distance>0.00</Distance><AppointmentFlag>R</AppointmentFlag><LanguageID>\(self.languageID)</LanguageID><Gender>\(gender)</Gender><CaseNumber>\(caseNumber)</CaseNumber><ClientName>\(clientName)</ClientName><cPIntials>\(clientIntial)</cPIntials><VenueID>\(self.venueID)</VenueID><VendorID></VendorID><DepartmentID>\(self.departmentID)</DepartmentID><ProviderID>\(self.providerID)</ProviderID><Location>\(location)</Location><Text>\(textNote)</Text><SendingEndTimes>\(SendingEndTimes)</SendingEndTimes><AptDetails></AptDetails><FinancialNotes></FinancialNotes><ScheduleNotes></ScheduleNotes><AppointmentStatusID>2</AppointmentStatusID><Travelling>\(Travelling)</Travelling><Ranking></Ranking><ConfirmationBit>false</ConfirmationBit><VendorMileage>false</VendorMileage><Priority>false</Priority><CallServiceBit>false</CallServiceBit><Office></Office><Home></Home><Cell></Cell><Purpose></Purpose><CallTime>\(CallTime)</CallTime><AdditionTravelTimePay>00:00</AdditionTravelTimePay><ArrivalTime></ArrivalTime><DepartureTime></DepartureTime><RequestedOn>\(requestedOn)</RequestedOn><ConfirmedOn></ConfirmedOn><BookedOn></BookedOn><CancelledOn></CancelledOn><RequestedBy>\(userID)</RequestedBy><ConfirmedBy></ConfirmedBy><BookedBy></BookedBy><CancelledBy></CancelledBy><LoadedBy>\(userID)</LoadedBy><RequestorName></RequestorName><MgemilRist>false</MgemilRist><isChanged>false</isChanged><oneHremail></oneHremail><LoginUserId>\(LoginUserId)</LoginUserId><ReasonforBotch></ReasonforBotch><PurchaseOrder></PurchaseOrder><Claim></Claim><Reference></Reference><SecurityClearence></SecurityClearence><ExperienceOfVendor></ExperienceOfVendor><InterpreterType></InterpreterType><AssignToFieldStaff></AssignToFieldStaff><RequestorName></RequestorName><RequestorEmail></RequestorEmail><TierName>W</TierName><WaitingList></WaitingList><overrideSatus></overrideSatus><overrideauth></overrideauth><SaveFlag>0</SaveFlag><SUBAPPOINTMENT></SUBAPPOINTMENT><InterpreterBookedId></InterpreterBookedId></INFO>"
            
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
                                    //let AppointmentID = userIfo?["AppointmentID"] as? Int
                                    let success = userIfo?["success"] as? Int
                                    let msz = userIfo?["Message"] as? String
                                   // let AuthCode = userIfo?["AuthCode"] as? String
                                  
                                    if success == 1 {
                                        DispatchQueue.main.async {
                                            self.appointmentBookedCalls(message: msz ?? "", authcode: matchAuth!)
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
extension VirtualMeetingNewRegularApointmentVC:ReloadBlockedTable{
    func didReloadTable(performTableReload: Bool, elemntID: Int, isConatctUpdate: Bool) {
        if isConatctUpdate {
            self.contactNameTF.text = ""
        }
        
        getVenueDetail(customerId: self.customerID)
    }
    
    func didopenMoreoption(action: Bool, type: String) {
        print("")
    }
    
    func updateOneTimeDepartment(departmentData: DepartmentData, isDelete: Bool) {
        print("")
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
    
    func bookedAppointment() {
        self.navigationController?.popViewController(animated: true)
    }
}
