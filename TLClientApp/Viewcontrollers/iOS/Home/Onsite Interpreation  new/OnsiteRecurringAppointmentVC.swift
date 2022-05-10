//
//  OnsiteRecurringAppointmentVC.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 04/03/22.
//

import UIKit
import Alamofire
import iOSDropDown
import DropDown

class OnsiteRecurringAppointmentVC: UIViewController, SelectDateForRecurrence, UpdateOneTimeVenue {
    func updateOneTimeVenue(VenueName: String, cityName: String, Address: String, State: String, zipCode: String, venueID: Int, stateID: Int, address2: String) {
        print("Delegate Working ")
        let itemA = VenueData(Address: Address, Address2: address2, City: cityName, CompanyID: Int(GetPublicData.sharedInstance.companyID), CustomerCompany: GetPublicData.sharedInstance.companyName, CustomerName: GetPublicData.sharedInstance.usenName, Notes: "", State: State, StateID: stateID, VenueID: venueID, VenueName: VenueName, ZipCode: zipCode, isOneTime: true)
        self.venueDetail.append(itemA)
        self.venueArray.append(VenueName)
    }
    func reloadAppointmentData() {
        btnAddRecurrance.setTitle("Add Recurrence", for: .normal)
        self.recuringAppointmentTV.reloadData()
    }
    
    func SelectAppointmentDate(selectedDateArr: [SelectedDatesModel]) {
        for (indxx, itemm) in selectedDateArr.enumerated() {
            if indxx != 0 {}
                
            btnAddRecurrance.setTitle("Edit Recurrence", for: .normal)
                let dateFormatterDate = DateFormatter()
                dateFormatterDate.dateFormat = "MM/dd/yyyy"
                let dateFormatterTime = DateFormatter()
                dateFormatterTime.dateFormat = "h:mm a"
                let currentDateTime = itemm.selectedDate.nearestHour() ?? Date()
                print("current time before \(currentDateTime)")
                let tempTime = dateFormatterTime.string(from: currentDateTime)
                print("TEMP TIME : \(tempTime)")
                let endTimee = itemm.selectedDate.adding(minutes: 120)//.nearestHour() ?? Date()
                
           // let itemA = BlockedAppointmentData(AppointmentDate: dateFormatterDate.string(from: currentDateTime), startTime:self.blockedAppointmentArr[0].startTime!, endTime: self.blockedAppointmentArr[0].endTime!, languageID: 0, genderID: "", clientName: "", ClientIntials: "", ClientRefrence: "", venueID: "", DepartmentID: 0, contactID: 0, location: "", SpecialNotes: "", rowIndex: indxx + 1, languageName: "",venueName: "", DepartmentName: "", genderType: "", conatctName: "", isVenueSelect: false, venueTitleName : "" , addressname : "" , cityName : "" , stateName : "" , zipcode: "",startTimeForPicker: Date() , endTimeForPicker: Date(), authCode: "",showClientName: "" , showClientIntials:"" , showClientRefrence: "", isDepartmentSelect: false,isConatctSelect : false)
            let itemA = BlockedAppointmentData(AppointmentDate: dateFormatterDate.string(from: currentDateTime), startTime:self.blockedAppointmentArr[0].startTime!, endTime: self.blockedAppointmentArr[0].endTime!, languageID: self.blockedAppointmentArr[0].languageID!, genderID: self.blockedAppointmentArr[0].genderID ?? "0", clientName: self.blockedAppointmentArr[0].clientName ?? "", ClientIntials: self.blockedAppointmentArr[0].ClientIntials ?? "", ClientRefrence: self.blockedAppointmentArr[0].ClientRefrence ?? "", venueID: self.blockedAppointmentArr[0].venueID ?? "", DepartmentID: self.blockedAppointmentArr[0].DepartmentID ?? 0, contactID: self.blockedAppointmentArr[0].contactID ?? 0, location: self.blockedAppointmentArr[0].location ?? "", SpecialNotes: self.blockedAppointmentArr[0].SpecialNotes ?? "", rowIndex: indxx + 1, languageName: self.blockedAppointmentArr[0].languageName ?? "",venueName: self.blockedAppointmentArr[0].venueName ?? "", DepartmentName: self.blockedAppointmentArr[0].DepartmentName ?? "", genderType: self.blockedAppointmentArr[0].genderType ?? "", conatctName: self.blockedAppointmentArr[0].conatctName ?? "", isVenueSelect:  self.blockedAppointmentArr[0].isVenueSelect ?? false , venueTitleName : self.blockedAppointmentArr[0].venueTitleName ?? "" , addressname : self.blockedAppointmentArr[0].addressname ?? "" , cityName : self.blockedAppointmentArr[0].cityName ?? "" , stateName : self.blockedAppointmentArr[0].stateName ?? "" , zipcode: self.blockedAppointmentArr[0].zipcode ?? "",startTimeForPicker: Date() , endTimeForPicker: Date(), authCode: "",showClientName: self.blockedAppointmentArr[0].showClientName ?? "" , showClientIntials:self.blockedAppointmentArr[0].showClientIntials ?? "" , showClientRefrence: self.blockedAppointmentArr[0].showClientRefrence ?? "", isDepartmentSelect: self.blockedAppointmentArr[0].isDepartmentSelect ?? false ,isConatctSelect :  self.blockedAppointmentArr[0].isConatctSelect ?? false)
                self.blockedAppointmentArr.append(itemA)
            
            self.recuringAppointmentTV.reloadData()
        }
        
    }
    
    @IBOutlet weak var btnAddRecurrance: UIButton!
    
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
    var masterCustomerID = ""
    var dropDown = DropDown()
    var isSpecialitySelect = false
    var isServiceSelect = false
    var isContactOption = false
    
    var authCode = ""
    var userID = ""
    var companyID = ""
    var userTypeID = ""
    var jobType = ""
    var loginUserID = ""
    var apiEncryptedDataResponse:ApiEncryptedDataResponse?
    var apiGetCustomerDetailResponseModel = [ApiGetCustomerDetailResponseModel]()
    var elementName = ""
    var elementID = 0
    var venueID = "0"
    var DepartmentIDForOperation = 0
    var genderDetail = [GenderData]()
    var venueArray :[String] = []
    var departmentArray :[String] = []
    var providerArray :[String] = []
    var venueDetail = [VenueData]()
    var departmentDetail = [DepartmentData]()
    var providerDetail = [ProviderData]()
    var oneTimeDepartmentArr = [DepartmentData]()
    var oneTimeContactArr = [ProviderData]()
    
    
    @IBOutlet weak var lblDepartment: UILabel!
    
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
        
        self.activateOptionView.visibility = .gone
        self.DeactivateOptionView.visibility = .gone
        
        let dateFormatterr = DateFormatter()
        dateFormatterr.dateFormat = "MM/dd/yyyy h:mm a"
        let startDatee =  dateFormatterr.string(from: Date().nearestHour() ?? Date ())
        
        self.requestedONTF.text = dateFormatterr.string(from: Date())
        self.loadedOnTF.text = dateFormatterr.string(from: Date())
        self.loginUserID = userDefaults.string(forKey: "LoginUserTypeID") ?? ""
        print("LoginuserTypeID \(self.loginUserID)")
        if self.loginUserID == "10" || self.loginUserID == "7" || self.loginUserID == "8" || self.loginUserID == "11" {
            self.subCustomerNameTF.isUserInteractionEnabled = false
        }else {
            self.subCustomerNameTF.isUserInteractionEnabled = true
        }
       // getCommonDetail()
       // getCustomerDetail()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateOnsiteRegularScreen(notification:)), name: Notification.Name("updateOnsiteRecurrenceScreen"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    @objc func updateOnsiteRegularScreen(notification: Notification){
        print("refreshing data in Onsite recurrence ")
        getCommonDetail()
        getCustomerDetail()
    }
    @objc func updateVenueList(){
       getCustomerDetail()
        
    }
    
    
    //MARK: - Common Method DropDown
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
                  self?.getVenueDetail(customerId: customerID)
                  print("subcustomerList id \(languageData.UniqueID)")
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
        let newAuthCode = authCode//.replacingOccurrences(of: "-OI", with: "-OIRC")
        
        let requestedOn = self.requestedONTF.text ?? ""
        
        self.jobType = "Onsite Interpretation"
        if blockedAppointmentArr.count == 0 {
            self.view.makeToast("Please fill  Details of atleast one Appointment.",duration: 1, position: .center)
            return
        }else {
             
            if self.blockedAppointmentArr.contains(where: {$0.languageID == 0 }){
                self.showAlertwithmessage(message: "Please fill Language name.")
            }else {
                self.hitApiCreateRequest(masterCustomerID: self.masterCustomerID, authCode: newAuthCode, SpecialityID: self.specialityID, ServiceType: self.serviceId, startTime: "", endtime: "", gender: "" , caseNumber: "", clientName: "", clientIntial: "", location: "", textNote: "", SendingEndTimes: false, Travelling: "", CallTime: "", requestedOn: requestedOn, LoginUserId: userId, parameter: "srchString")
            }
        }
    }
    //MARK: - SelectRecurringDateVC Controller
    @IBAction func actionAddBlockedApt(_ sender: UIButton) {
        //self.blockedAppointmentArr[0].languageID
        //languageName
        if btnAddRecurrance.titleLabel?.text == "Edit Recurrence" {
            let alertC = UIAlertController(title: "Appointment", message: ConstantStr.editRecurrence.val, preferredStyle: .actionSheet)
            alertC.addAction(UIAlertAction(title: "Cancel", style: .destructive))
            alertC.addAction(UIAlertAction(title: "Okay", style: .default, handler: { data in
               let tCount = self.blockedAppointmentArr.count
                let temArr:BlockedAppointmentData = self.blockedAppointmentArr.first!
                self.blockedAppointmentArr.removeAll()
                self.blockedAppointmentArr.append(temArr)
                
                //NotificationCenter.default.post(name: Notification.Name("updateOnsiteRecurrenceScreen"), object: nil, userInfo: nil)
//                for i in 0...tCount {
//                    if i == 0 {
//                      print("0 index here...")
//                    }
//                    else {
//                        self.blockedAppointmentArr.remove(at: i)
//                    }
//
               // }
                self.getRecurrenceData()
                
            }))
            self.present(alertC, animated: true)
            
        }
        else {
            if self.blockedAppointmentArr[0].languageName == "" || self.blockedAppointmentArr[0].languageID == 0 {
                return self.view.makeToast("Please select the language", position: .center)
                
            }
            else if self.blockedAppointmentArr[0].venueName == ""{
                return self.view.makeToast("Please select the venue", position: .center)
            }
            else {
                getRecurrenceData()
            }
        }
        
      }
    func getRecurrenceData(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectRecurringDateVC") as! SelectRecurringDateVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.appointmentDate = self.blockedAppointmentArr[0].AppointmentDate
        vc.appointmentStartTime = self.blockedAppointmentArr[0].startTime
        vc.AppointmentEndTIme = self.blockedAppointmentArr[0].endTime
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
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
        vc.venueID = venueID
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
            vc.venueID = venueID
            self.present(vc, animated: true, completion: nil)
            self.departmentOptionMajorView.isHidden = true
        }
       
        
       
    }
    
    @IBAction func actionEditDepartment(_ sender: UIButton) {
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
            vc.venueID = venueID
            self.present(vc, animated: true, completion: nil)
            self.departmentOptionMajorView.isHidden = true
           
        }
       
    }
}
//MARK: - Api methoda
extension OnsiteRecurringAppointmentVC{
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
                                        print("Login user Type ID \(self.loginUserID)")
                                        if self.loginUserID == "10" || self.loginUserID == "7" || self.loginUserID == "8" || self.loginUserID == "11" {
                                            self.subCustomerNameTF.text = CustomerFullName ?? ""
                                            let customerID = "\(CustomerID ?? 0)"
                                            print("venue Function call for subcustom er ")
                                          //  self.customerID = customerID
                                            
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
            self.blockedAppointmentArr.removeAll()
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
                                    dateFormatterTime.dateFormat = "h:00 a"
                                    let currentDateTime = Date()//.nearestHour() ?? Date()
                                    print("current time before \(currentDateTime)")
                                    let tempTime = dateFormatterTime.string(from: currentDateTime)
                                    print("TEMP TIME : \(tempTime)")
                                    
                                   
                                    
                                   // let endTimee = Date().adding(minutes: 120)
                                    let authCodeNew = "\(authcode ?? "")"//-1
                                    let newAuthCode = authCodeNew.replacingOccurrences(of: "-OI", with: "-OIRC")
                                    let itemA = BlockedAppointmentData(AppointmentDate: dateFormatterDate.string(from: currentDateTime), startTime: dateFormatterTime.string(from: currentDateTime), endTime: CEnumClass.share.getMinuteDiffers(startTime: CEnumClass.share.getRoundCTime(), differ: "120", companyId: self.companyID), languageID: 0, genderID: "", clientName: "", ClientIntials: "", ClientRefrence: "", venueID: "", DepartmentID: 0, contactID: 0, location: "", SpecialNotes: "", rowIndex: 0, languageName: "",venueName: "", DepartmentName: "", genderType: "", conatctName: "", isVenueSelect: false, venueTitleName : "" , addressname : "" , cityName : "" , stateName : "" , zipcode: "",startTimeForPicker: Date() , endTimeForPicker: Date(), authCode: newAuthCode,showClientName: "" , showClientIntials:"" , showClientRefrence: "", isDepartmentSelect: false,isConatctSelect : false)
                                    
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
                                       
                                        
                                    })
                                    let itemD = GenderData(Id: 0, Code: "", Value: "Select Gender", type: "")
                                    let itemM = GenderData(Id: 19, Code: "M", Value: "Male", type: "Gender")
                                    let itemB = GenderData(Id: 18, Code: "F", Value: "Female", type: "Gender")
                                    let itemC = GenderData(Id: 28, Code: "NB", Value: "Non-binary", type: "Gender")
                                    genderDetail.append(itemD)
                                    genderDetail.append(itemM)
                                    genderDetail.append(itemB)
                                    genderDetail.append(itemC)
                                    genderDetail.forEach { GenderData in
                                        let name = GenderData.Value
                                        genderArray.append(name)
                                    }
                                   
                                    
                                    print("Language Array from common ",languageArray)
                                    print(specialityArray)
                                   
                                    //updateServiceAndSpeciality()
                                    self.authCodeTF.text = authcode?.replacingOccurrences(of: "-OI", with: "-OIRC") ??  ""
                                    self.authCode = authcode?.replacingOccurrences(of: "-OI", with: "-OIRC") ??  ""
                                    self.jobTypeTF.text = "Onsite Interpretation"
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
            let urlString = APi.tladdupdateRecurringappointment.url
            let companyID = self.companyID//GetPublicData.sharedInstance.companyID
            let userID = self.userID//GetPublicData.sharedInstance.userID
                var customerUserID = ""
                if self.userTypeID == "4" || self.userTypeID == "10" {
                    customerUserID = "0"
                }
                else {
                    customerUserID = userID
                }
            let arrayValue = self.blockedAppointmentArr.first
                let startTime = "\(arrayValue?.AppointmentDate ?? "") \(arrayValue?.startTime ?? "")"
                let endTime = "\(arrayValue?.AppointmentDate ?? "") \(arrayValue?.endTime ?? "")"
                let newAOuthCode = "\(arrayValue?.authCode ?? "")"
                print("Auth code in create API \(arrayValue?.authCode ?? "") ")
                let prefixSrch = "<INFO><CustomerUserID>\(customerUserID)</CustomerUserID><Action>A</Action><AppointmentID>0</AppointmentID><CustomerID>\(self.customerID)</CustomerID><Company>\(companyID)</Company><MasterCustomerID>\(masterCustomerID)</MasterCustomerID><AppointmentTypeID>1</AppointmentTypeID><AuthCode>\(newAOuthCode)</AuthCode><SpecialityID>\(SpecialityID)</SpecialityID><ServiceType>\(ServiceType)</ServiceType><StartDateTime>\(startTime)</StartDateTime><EndDateTime>\(endTime)</EndDateTime><Distance>0.0</Distance><AppointmentFlag>RC</AppointmentFlag><LanguageID>\(arrayValue?.languageID ?? 0)</LanguageID><Gender>\(arrayValue?.genderID ?? "" )</Gender><CaseNumber>\(arrayValue?.ClientRefrence ?? "")</CaseNumber><ClientName>\(arrayValue?.clientName ?? "")</ClientName><cPIntials>\(arrayValue?.ClientIntials ?? "")</cPIntials><VenueID>\(arrayValue?.venueID ?? "")</VenueID><VendorID></VendorID><DepartmentID>\(arrayValue?.DepartmentID ?? 0)</DepartmentID><ProviderID>\(arrayValue?.contactID ?? 0)</ProviderID><Location>\(arrayValue?.location ?? "")</Location><Text>\(arrayValue?.SpecialNotes ?? "")</Text><SendingEndTimes>false</SendingEndTimes><AptDetails></AptDetails><FinancialNotes></FinancialNotes><ScheduleNotes></ScheduleNotes><AppointmentStatusID>2</AppointmentStatusID><Travelling>\(Travelling)</Travelling><Ranking></Ranking><ConfirmationBit>false</ConfirmationBit><VendorMileage>false</VendorMileage><Priority>false</Priority><CallServiceBit>false</CallServiceBit><Office></Office><Home></Home><Cell></Cell><Purpose></Purpose><CallTime>\(CallTime)</CallTime><AdditionTravelTimePay>00:00</AdditionTravelTimePay><ArrivalTime></ArrivalTime><DepartureTime></DepartureTime><RequestedOn>\(requestedOn)</RequestedOn><ConfirmedOn></ConfirmedOn><BookedOn></BookedOn><CancelledOn></CancelledOn><RequestedBy></RequestedBy><ConfirmedBy></ConfirmedBy><BookedBy></BookedBy><CancelledBy></CancelledBy><LoadedBy>\(userID)</LoadedBy><RequestorName></RequestorName><MgemilRist>false</MgemilRist><isChanged>false</isChanged><oneHremail></oneHremail><LoginUserId>\(LoginUserId)</LoginUserId><ReasonforBotch></ReasonforBotch><PurchaseOrder></PurchaseOrder><Claim></Claim><Reference></Reference><SecurityClearence></SecurityClearence><ExperienceOfVendor></ExperienceOfVendor><InterpreterType></InterpreterType><AssignToFieldStaff></AssignToFieldStaff><RequestorName></RequestorName><RequestorEmail></RequestorEmail><TierName>W</TierName><WaitingList></WaitingList><overrideSatus></overrideSatus><overrideauth></overrideauth><InterpreterBookedId></InterpreterBookedId><RECURRAPPOINTMENT>"
                var middelePart = ""
                
                for (indexx, AptData) in blockedAppointmentArr.enumerated(){
                    if indexx == 0 {
                        print("index is zero \(indexx)")
                    }else {
                        print("index is \(indexx)")
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
                        let AptString = "<RECURRAPPOINTMENT><AuthCode>\(AptData.authCode ?? "")</AuthCode><StartDateTime>\(startTime)</StartDateTime><EndDateTime>\(EndTime)</EndDateTime><LanguageID>\(lID)</LanguageID><CaseNumber>\( AptData.ClientRefrence ?? "")</CaseNumber><ClientName>\(AptData.clientName ?? "")</ClientName><cPIntials>\(AptData.ClientIntials ?? "")</cPIntials><VenueID>\(AptData.venueID ?? "")</VenueID><DepartmentID>\(vID)</DepartmentID><ProviderID>\(cID)</ProviderID><SendingEndTimes>false</SendingEndTimes><Location>\(AptData.location ?? "")</Location><Text>\(AptData.SpecialNotes ?? "")</Text><AptDetails></AptDetails><FinancialNotes></FinancialNotes><ScheduleNotes></ScheduleNotes><aPVenueID></aPVenueID><Active></Active></RECURRAPPOINTMENT>"
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
                                    let emailResponse = newjson?["EmailNotification"] as? [[String:Any]]
                                    let matchAuth = emailResponse?.first!["AuthCode"] as? String
                                    let userIfo = userInfo?.first
                                   // let AppointmentID = userIfo?["AppointmentID"] as? Int
                                    let success = userIfo?["success"] as? Int
                                    let msz = userIfo?["Message"] as? String
                                   // let AuthCode = userIfo?["AuthCode"] as? String
                                  
                                    if success == 1 {
                                      //  print("AuthCode:\(matchAuth):: Message\(msz) ::emailResponse:\(emailResponse)")
                                        self.appointmentBookedCalls(message: msz ?? "", authcode: matchAuth ?? "", totalAppointment: blockedAppointmentArr.count)
//                                        self.view.makeToast(Message,duration: 1, position: .center)
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
//                                            self.navigationController?.popViewController(animated: true)
//                                        }
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
extension OnsiteRecurringAppointmentVC : UITableViewDelegate , UITableViewDataSource , SaveBookedAppointmentData  , ReloadBlockedTable{
    func bookedAppointment() {
        self.navigationController?.popViewController(animated: true)
    }
    func updateOneTimeDepartment(departmentData: DepartmentData , isDelete: Bool) {
        
        if isDelete {
            
            for (indexx , itemm) in blockedAppointmentArr.enumerated() {
               if itemm.DepartmentID == departmentData.DepartmentID {
                   self.blockedAppointmentArr[indexx].DepartmentID = 0
                   self.blockedAppointmentArr[indexx].DepartmentName = ""
                   self.blockedAppointmentArr[indexx].isDepartmentSelect = false
               }else {
                   
               }
               
               
           }
            
            for (indexx , itemm) in oneTimeDepartmentArr.enumerated() {
                if itemm.DepartmentID == departmentData.DepartmentID {
                    self.oneTimeDepartmentArr.remove(at: indexx)
                    
                }else {
                    
                }
                
                
            }
            for (indexx , itemm) in departmentDetail.enumerated() {
                if itemm.DepartmentID == departmentData.DepartmentID {
                    self.departmentDetail.remove(at: indexx)
                    
                }else {
                    
                }
             }
            
            if let index = departmentArray.firstIndex(of: departmentData.DepartmentName ?? "") {
                //index has the position of first match
                self.departmentArray.remove(at: index)
            } else {
                //element is not present in the array
            }
            self.recuringAppointmentTV.reloadData()
        }else {
            self.oneTimeDepartmentArr.append(departmentData)
            getVenueDetail(customerId: self.customerID)
        }
   
    }
    
    func updateOneTimeConatct(ConatctData: ProviderData, isDelete: Bool) {
        
        if isDelete {
              
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
            self.recuringAppointmentTV.reloadData()
            
        }else {
            self.oneTimeContactArr.append(ConatctData)
            getVenueDetail(customerId: self.customerID)
        }
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
            self.activateOptionView.visibility = .gone
            self.DeactivateOptionView.visibility = .gone
        }
    
    }
    func didReloadTable(performTableReload: Bool,elemntID: Int,isConatctUpdate: Bool) {
        if performTableReload {
            self.recuringAppointmentTV.reloadData()
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
            self.recuringAppointmentTV.reloadData()
            getVenueDetail(customerId: self.customerID)
        }
    }
    
    
    func didSave(_ class: BlockedAppointmentTVCell, flag: Bool, AppointmentDate: String, index: Int, startTime: String, EndTime: String, languageID: Int, GenderID: String, ClientName: String, clientIntials: String, clientRefrence: String, venueID: String, departmentID: Int, contactID: Int, location: String, Notes: String, isAppointmentDateSelect: Bool, isStartTimeSelect: Bool, isEndtimeSelect: Bool , languageName: String ,venueName: String, DepartmentName: String, genderType: String, conatctName: String, isVenueSelect: Bool,venueTitleName: String, addressname: String, cityName: String, stateName: String, zipcode: String,startTimeForPicker: Date , endTimeForPicker: Date,isproviderSelect: Bool, isDepartmentSlecet: Bool, isLanguageSelect: Bool, isgenderSelect: Bool, isCleintNameEnterd: Bool, isClientRefrenceEnyterd: Bool, IsNotesEntered: Bool, isLocationEneterd: Bool,isvenueFlag : Bool) {
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockedAppointmentTVCell", for: indexPath) as! BlockedAppointmentTVCell
        cell.AppointmentTitleLbl.text = "Appointment \(indexPath.row + 1) (\(self.authCode)-\(indexPath.row + 1))"
        cell.appointmentCancelBtn.isHidden = true
        cell.cancelImg.isHidden = true
       /* cell.appointmentCancelBtn.tag = indexPath.row
        cell.appointmentCancelBtn.addTarget(self, action: #selector(CancelApt), for: .touchUpInside)
        if indexPath.row == 0 {
            cell.cancelImg.isHidden = true
            cell.appointmentCancelBtn.isHidden = true
        }else {
            cell.cancelImg.isHidden = false
            cell.appointmentCancelBtn.isHidden = false
        }*/
        cell.appointmentDateBtn.tag = indexPath.row
        cell.appointmentDateBtn.addTarget(self, action: #selector(showAppointmentDate), for: .touchUpInside)
        
        cell.startTimebtn.tag = indexPath.row
        cell.startTimebtn.addTarget(self, action: #selector(showStartTime), for: .touchUpInside)
        
        cell.endTimeBtn.tag = indexPath.row
        cell.endTimeBtn.addTarget(self, action: #selector(showEndTime), for: .touchUpInside)
        
        
        
        cell.delegate = self
        cell.tableDelegate = self
        cell.addvenueBtn.tag = indexPath.row
        cell.addvenueBtn.addTarget(self, action: #selector(actionAddVenueBtn), for: .touchUpInside)
        
        let aptNumber = indexPath.row + 1
       // cell.AppointmentTitleLbl.text = "Appointment \(aptNumber)"
        
        let BlockedData = self.blockedAppointmentArr[indexPath.row]
        cell.rowIndex = indexPath.row//BlockedData.rowIndex ?? 0
        cell.appointmentDateTF.text = BlockedData.AppointmentDate
        cell.startTimeTf.text = BlockedData.startTime
        cell.endTimeTF.text = BlockedData.endTime
        cell.languageTF.text = BlockedData.languageName
        cell.genderTF.text = BlockedData.genderType
        cell.clientNameTF.text = BlockedData.showClientName
        cell.clientIntiaalTF.text = BlockedData.showClientIntials
        cell.clientRefrenceTF.text = BlockedData.showClientRefrence
       
        cell.selectVenueTF.text = BlockedData.venueName
        cell.selectDepartmentTF.text = BlockedData.DepartmentName
        cell.selectContactTF.text = BlockedData.conatctName
        cell.locationTF.text = BlockedData.location
        cell.specialNoteTf.text = BlockedData.SpecialNotes
        cell.venueNameLbl.text = BlockedData.venueTitleName
        cell.addressnameLbl.text = BlockedData.addressname
        cell.citynameLbl.text = BlockedData.cityName
        cell.zipcodeLbl.text = BlockedData.zipcode
        cell.stateLbl.text = BlockedData.stateName
        
        cell.isDepartmentSelect = BlockedData.isDepartmentSelect ?? false
        cell.isProviderSelect = BlockedData.isConatctSelect ?? false
        
        if BlockedData.isVenueSelect ?? false {
            cell.venueDetailView.visibility = .visible
            cell.addDepartmentStackView.visibility = .visible
            cell.addContactStackView.visibility = .visible
        }else {
            cell.venueDetailView.visibility = .gone
            cell.addDepartmentStackView.visibility = .gone
            cell.addContactStackView.visibility = .gone
        }
        if BlockedData.DepartmentName == "Select Department" {
            cell.departmentNameTF.text = ""
        }else {
            cell.departmentNameTF.text = BlockedData.DepartmentName ?? ""
        }
        if BlockedData.conatctName == "Select Contact" {
            cell.contactNameTF.text = ""
        }else {
            cell.contactNameTF.text = BlockedData.conatctName ?? ""
        }
        cell.departmentID = BlockedData.DepartmentID ?? 0
        cell.actionVenueDropDown.tag = indexPath.row
        cell.actionVenueDropDown.addTarget(self, action: #selector(actionSelectVenue), for: .touchUpInside)
        
        cell.genderDropDownBtn.tag = indexPath.row
        cell.genderDropDownBtn.addTarget(self, action: #selector(actionSelectGender), for: .touchUpInside)
        
        cell.actionDepartmentDropDown.tag = indexPath.row
        cell.actionDepartmentDropDown.addTarget(self, action: #selector(actionSelectDepartment), for: .touchUpInside)
        
        cell.actionContactDropdown.tag = indexPath.row
        cell.actionContactDropdown.addTarget(self, action: #selector(actionSelectConatct), for: .touchUpInside)
        
        cell.addOneTimeVenueBtn.tag = indexPath.row
        cell.addOneTimeVenueBtn.addTarget(self, action: #selector(actionOneTimevenue), for: .touchUpInside)
        
        cell.actionAddDepartMent.tag = indexPath.row
        cell.actionAddDepartMent.addTarget(self, action: #selector(actionAddDepartment), for: .touchUpInside)
      
        cell.addContactBtn.tag = indexPath.row
        cell.addContactBtn.addTarget(self, action: #selector(actionAddContact), for: .touchUpInside)
        
        cell.actionShowmoreDepartmentOption.tag = indexPath.row
        cell.actionShowmoreDepartmentOption.addTarget(self, action: #selector(openDepartmentOption), for: .touchUpInside)
        
        cell.showContactMoreOptionbtn.tag = indexPath.row
        cell.showContactMoreOptionbtn.addTarget(self, action: #selector(openConatctOption), for: .touchUpInside)
        
        return cell
        
    }
    @objc func openConatctOption(sender : UIButton){
        lblDepartment.text = "Add One Time Contact"
            self.departmentOptionMajorView.isHidden = false
            self.optiontitleLbl.text = "Contact"
            self.isContactOption = true
            self.activateOptionView.visibility = .gone
            self.DeactivateOptionView.visibility = .gone
            self.elementName = blockedAppointmentArr[sender.tag].conatctName ?? ""
            self.elementID = blockedAppointmentArr[sender.tag].contactID ?? 0
            self.DepartmentIDForOperation = blockedAppointmentArr[sender.tag].DepartmentID ?? 0
        
        
    }
    @objc func openDepartmentOption(sender : UIButton){
        lblDepartment.text = "Add One Time Department"
        self.departmentOptionMajorView.isHidden = false
        self.optiontitleLbl.text = "Department"
        self.isContactOption = false
        self.activateOptionView.visibility = .gone
        self.DeactivateOptionView.visibility = .gone
        self.elementName = blockedAppointmentArr[sender.tag].DepartmentName ?? ""
        self.elementID = blockedAppointmentArr[sender.tag].DepartmentID ?? 0
        self.venueID = blockedAppointmentArr[sender.tag].venueID ?? "0"
        self.DepartmentIDForOperation = blockedAppointmentArr[sender.tag].DepartmentID ?? 0
    }
    @objc func actionAddContact(sender : UIButton){
        let storyboard = UIStoryboard(name: "SchedulingAppointments", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDepartmentAndContactVC") as! UpdateDepartmentAndContactVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.isdepartSelect = false
        vc.tableDelegate = self
        vc.actionType = "Add"
        vc.venueID = venueID
        vc.contactActiontype = 0
        self.present(vc, animated: true, completion: nil)
    }
    @objc func actionAddDepartment(sender : UIButton){
        let storyboard = UIStoryboard(name: "SchedulingAppointments", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDepartmentAndContactVC") as! UpdateDepartmentAndContactVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.isdepartSelect = true
        vc.actionType = "Add"
        vc.tableDelegate = self
        vc.depatmrntActionType = 0
        vc.venueID = venueID
        self.present(vc, animated: true, completion: nil)
    }
    @objc func actionOneTimevenue(sender: UIButton){
        let storyboard = UIStoryboard(name: Storyboard_name.home, bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddNewVenueViewController") as! AddNewVenueViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.userCustomerId = self.customerID
        vc.isOneTime = true
        vc.delegate = self
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
           self?.recuringAppointmentTV.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
      }
        
    }
    @objc func actionSelectDepartment(sender : UIButton){
        
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = departmentArray
       
       dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
           self?.blockedAppointmentArr[sender.tag].DepartmentName = item
           print("departmentDetail data \(item)")
          self?.departmentDetail.forEach({ languageData in
              
              if item == languageData.DepartmentName ?? "" {
                  self?.blockedAppointmentArr[sender.tag].DepartmentID = languageData.DepartmentID ?? 0
                  self?.blockedAppointmentArr[sender.tag].isDepartmentSelect = true
                 
              }
              
          })
           self?.recuringAppointmentTV.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
      }
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
            self?.recuringAppointmentTV.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
      }
    }
    @objc func actionSelectVenue(sender : UIButton){
        
       // let cell = self.blockedAppointmentTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BlockedAppointmentTVCell
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = venueArray
       print("Data in venue Array ,\(venueArray)")
       dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
           print("item selected in cell \(item)")
           if item == "Select Venue" {
               self?.blockedAppointmentArr[sender.tag].venueName = item
               self?.blockedAppointmentArr[sender.tag].venueTitleName = item
               self?.blockedAppointmentArr[sender.tag].venueID = ""
               self?.blockedAppointmentArr[sender.tag].cityName =  "N/A"
               self?.blockedAppointmentArr[sender.tag].stateName =  "N/A"
               self?.blockedAppointmentArr[sender.tag].addressname =  "N/A"
               self?.blockedAppointmentArr[sender.tag].zipcode =  "N/A"
               self?.blockedAppointmentArr[sender.tag].isVenueSelect = false
           }else {
               self?.venueDetail.forEach({ languageData in
                   print("selected Venue name  \(languageData.VenueName ?? "")")
                   if item == languageData.VenueName ?? "N/A" {
                       self?.blockedAppointmentArr[sender.tag].venueName = item
                       self?.blockedAppointmentArr[sender.tag].venueID = "\(languageData.VenueID ?? 0)"
                       self?.blockedAppointmentArr[sender.tag].cityName =  languageData.City ?? "N/A"
                       self?.blockedAppointmentArr[sender.tag].venueTitleName = item
                       self?.blockedAppointmentArr[sender.tag].stateName =  languageData.State ?? "N/A"
                       self?.blockedAppointmentArr[sender.tag].addressname =  languageData.Address ?? "N/A"
                       self?.blockedAppointmentArr[sender.tag].zipcode = "\(languageData.ZipCode ?? "N/A")"
                       self?.blockedAppointmentArr[sender.tag].isVenueSelect = true
                   }
               })
           }
           self?.recuringAppointmentTV.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
      }
    }
    @objc func actionAddVenueBtn(sender : UIButton){
        let vc = storyboard?.instantiateViewController(identifier: "AddUpdateVenueVC") as! AddUpdateVenueVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func showAppointmentDate(sender : UIButton){
        //textfield.endEditing(true)
        let cell = recuringAppointmentTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BlockedAppointmentTVCell
        
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
        let cell = recuringAppointmentTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BlockedAppointmentTVCell
        let minDate = Date().dateByAddingYears(-5)
        let selectedDateAntime = blockedAppointmentArr[sender.tag].AppointmentDate! + " \(blockedAppointmentArr[sender.tag].startTime!)"
        let selectDate = CEnumClass.share.getCompleteDateAndTime(dateAndTime: selectedDateAntime)
        
        RPicker.selectDate(title: "Select Start Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectDate, minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.blockedAppointmentArr[sender.tag].startTimeForPicker = selectedDate
            self?.blockedAppointmentArr[sender.tag].endTimeForPicker = selectedDate.adding(minutes: 120)
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            let endTimee = roundoff.adding(minutes: 120)
            self?.blockedAppointmentArr[sender.tag].startTimeForPicker = selectedDate

                print("do nothing")
            self?.blockedAppointmentArr[sender.tag].startTime = roundoff.dateString("hh:mm a")
                cell.startTimeTf.text = roundoff.dateString("hh:mm a")
            self?.blockedAppointmentArr[sender.tag].endTime = endTimee.dateString("hh:mm a")
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
       
        let cell = recuringAppointmentTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BlockedAppointmentTVCell
        var selectedDateforPicker = self.blockedAppointmentArr[sender.tag].endTimeForPicker ?? Date()
        let minDate = Date().dateByAddingYears(-5)
        
        let selectedDateAntime = blockedAppointmentArr[sender.tag].AppointmentDate! + " \(blockedAppointmentArr[sender.tag].endTime!)"
        let selectDate = CEnumClass.share.getCompleteDateAndTime(dateAndTime: selectedDateAntime)
        
        RPicker.selectDate(title: "Select End Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectDate,minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
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
extension OnsiteRecurringAppointmentVC {
    func appointmentBookedCalls(message: String, authcode: String, totalAppointment: Int){
        print("authcode::--->",authcode)
        let splitArr = authcode.components(separatedBy: ",")
            let callVC = UIStoryboard(name: Storyboard_name.scheduleApnt, bundle: nil)
            let vcontrol = callVC.instantiateViewController(identifier: "BookedStatusVC") as! BookedStatusVC
        
        if totalAppointment == 1 {
            vcontrol.height = 310
            vcontrol.tblHeighConstant = 50
        }
        else if totalAppointment == 2{
            vcontrol.height = 330
            vcontrol.tblHeighConstant = 80
        }
        else if totalAppointment == 3 {
            vcontrol.height = 380
            vcontrol.tblHeighConstant = 120
        }
        else if totalAppointment == 4 {
            vcontrol.height = 430
            vcontrol.tblHeighConstant = 170
        }
        else if totalAppointment == 5 {
            vcontrol.height = 480
            vcontrol.tblHeighConstant = 220
        }
        else {
            vcontrol.height = 550
            vcontrol.tblHeighConstant = 250
        }
        if totalAppointment > 1 {
            print("splitArr.first--",splitArr.first)
            vcontrol.authcode = splitArr.first
        }
        else {
            vcontrol.authcode = authcode
        }
        print("splitArr--->", splitArr)
        vcontrol.apntArr = splitArr
        vcontrol.ismultiple = true
            vcontrol.topCornerRadius = 30
            vcontrol.presentDuration = 0.5
            vcontrol.dismissDuration = 0.5
            vcontrol.shouldDismissInteractivelty = false
            vcontrol.popupDismisAlphaVal = 0.4
        vcontrol.msz = message.trimHTMLTags()
        vcontrol.delegate = self
       
       
            
            present(vcontrol, animated: true, completion: nil)
  }
}
