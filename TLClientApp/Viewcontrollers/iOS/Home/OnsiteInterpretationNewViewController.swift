//
//  OnsiteInterpretationNewViewController.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 19/01/22.
//

import UIKit
import iOSDropDown
import Alamofire
import DropDown
import MaterialComponents.MaterialTextControls_OutlinedTextFields
class OnsiteInterpretationNewViewController: UIViewController {

    @IBOutlet weak var patientIntialsView: UIView!
    @IBOutlet weak var patientNameView: UIView!
    @IBOutlet weak var recurringTypeLbl: UILabel!
    @IBOutlet weak var blockedTypeLbl: UILabel!
    @IBOutlet weak var regularTypeLbl: UILabel!
    @IBOutlet weak var recurringTypeView: UIView!
    @IBOutlet weak var blockedTypeView: UIView!
    @IBOutlet weak var regularTypeView: UIView!
    
    @IBOutlet weak var showVenueView: UIView!
    @IBOutlet weak var jobTypeView: UIView!
    
    @IBOutlet weak var authcodeView: UIView!
    
    
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var bookedOnView: UIView!
    @IBOutlet weak var requestedONView: UIView!
    @IBOutlet weak var subcustomerNameView: UIView!
    @IBOutlet weak var customerNameView: UIView!
    @IBOutlet weak var specialityView: UIView!
    @IBOutlet weak var serviceTypeView: UIView!
    @IBOutlet weak var canceledOnView: UIView!
    @IBOutlet weak var travelMileView: UIView!
    @IBOutlet weak var specialNotesView: UIView!
    @IBOutlet weak var loadedOnView: UIView!
    @IBOutlet weak var locatonView: UIView!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var caseRefrenceView: UIView!
    @IBOutlet weak var appointmentDateView: UIView!
    var selectTypeOFAppointment = ""
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var contactUpdateView: UIView!
    @IBOutlet weak var venueDetailView: UIView!
    @IBOutlet weak var departmentDetailUpdate: UIView!
    @IBOutlet weak var venueNameTF: iOSDropDown!
    @IBOutlet weak var contactShowView: UIView!
    @IBOutlet weak var showDepartMentView: UIView!
    @IBOutlet weak var contactNameTF: UITextField!
    @IBOutlet weak var departmentNameTF: UITextField!
    @IBOutlet weak var appointmentDateTF: UITextField!
    
    @IBOutlet weak var travelMileTF: UITextField!
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
    
    
    @IBOutlet weak var genderTF: iOSDropDown!
    
    @IBOutlet weak var locationTF: UITextField!
    
    @IBOutlet weak var specialNotesTF: UITextField!
    @IBOutlet weak var venueNameLbl: UILabel!
    
    var dropDown = DropDown()
    var specialityDetail = [SpecialityData]()
    var serviceDetail = [ServiceData]()
    var serviceArr:[String] = []
    var specialityArray:[String] = []
    var apiGetCustomerDetailResponseModel = [ApiGetCustomerDetailResponseModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        getCommonDetail()
        getCustomerDetail()
        updateService(serviceType: nil)
        updateSpeciality(SpecialityName: nil)
      
        contactUpdateView.visibility = .gone
        departmentDetailUpdate.visibility = .gone
        venueDetailView.visibility = .gone
        contactShowView.layer.borderColor = UIColor.lightGray.cgColor
        showVenueView.layer.borderColor = UIColor.lightGray.cgColor
        showVenueView.layer.borderColor = UIColor.lightGray.cgColor
        showVenueView.layer.cornerRadius = 5
       // showProcessingDetail()
       // showLocationDetail()
        //showAppointmentDetailSection()

        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "MM/dd/yyyy"
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "h:mm a"
        let currentDateTime = Date().nearestHour() ?? Date()
        self.starttimeTF.text = dateFormatterTime.string(from: currentDateTime)
        let endTimee = Date().adding(minutes: 120).nearestHour() ?? Date()
        self.appointmentDateTF.text = dateFormatterDate.string(from: currentDateTime)
        self.endTimeTF.text = dateFormatterTime.string(from: endTimee)
          
        
        let dateFormatterr = DateFormatter()
        dateFormatterr.dateFormat = "MM/dd/yyyy h:mm a"
        let startDatee =  dateFormatterr.string(from: Date().nearestHour() ?? Date ())
        self.requestedONTF.text = startDatee
        self.loadedOnTF.text = startDatee
        
    }
    func showAppointmentDetailSection(){
        
        let estimatedFrame = CGRect(x: 0, y: 0, width: patientNameView.frame.width - 30  , height: 10)
        let textField = MDCOutlinedTextField(frame: estimatedFrame)
        textField.label.text = "Client/Patient/Student Name"
        textField.textColor = UIColor.lightGray
        textField.text = ""
        textField.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        textField.setOutlineColor(UIColor.lightGray, for: .normal)
        textField.font = UIFont.systemFont(ofSize: 14)
        
        textField.sizeToFit()
        patientNameView.addSubview(textField)
        
        let estimatedFrame1 = CGRect(x: 0, y: 0, width: patientIntialsView.frame.width - 30  , height: 10)
        let textField1 = MDCOutlinedTextField(frame: estimatedFrame1)
        textField1.label.text = "Client/Patient/Student Intials"
        textField1.textColor = UIColor.lightGray
        textField1.text = ""
        textField1.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        textField1.setOutlineColor(UIColor.lightGray, for: .normal)
        textField1.font = UIFont.systemFont(ofSize: 14)
        
        textField1.sizeToFit()
        patientIntialsView.addSubview(textField1)
        
        let estimatedFrame2 = CGRect(x: 0, y: 0, width: caseRefrenceView.frame.width - 30  , height: 10)
        let textField2 = MDCOutlinedTextField(frame: estimatedFrame2)
        textField2.label.text = "Client/Patient/Case/Reference #"
        textField2.textColor = UIColor.lightGray
        textField2.text = ""
        textField2.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        textField2.setOutlineColor(UIColor.lightGray, for: .normal)
        textField2.font = UIFont.systemFont(ofSize: 14)
        
        textField2.sizeToFit()
        caseRefrenceView.addSubview(textField2)
        
        let estimatedFrame3 = CGRect(x: 0, y: 0, width: genderView.frame.width - 30  , height: 10)
        let textField3 = MDCOutlinedTextField(frame: estimatedFrame3)
        textField3.label.text = "Gender"
        textField3.textColor = UIColor.lightGray
        textField3.text = ""
        textField3.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        textField3.setOutlineColor(UIColor.lightGray, for: .normal)
        textField3.font = UIFont.systemFont(ofSize: 14)
        
        textField3.sizeToFit()
        genderView.addSubview(textField3)
        
        
        
        let estimatedFrame5 = CGRect(x: 0, y: 0, width: travelMileView.frame.width - 30  , height: 10)
        let textField5 = MDCOutlinedTextField(frame: estimatedFrame5)
        textField5.label.text = "Travel Miles"
        textField5.textColor = UIColor.lightGray
        textField5.text = ""
        textField5.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        textField5.setOutlineColor(UIColor.lightGray, for: .normal)
        textField5.font = UIFont.systemFont(ofSize: 14)
        
        textField5.sizeToFit()
        travelMileView.addSubview(textField5)
        
        
        
        let estimatedFrame6 = CGRect(x: 0, y: 0, width: startDateView.frame.width - 30  , height: 10)
        let textField6 = MDCOutlinedTextField(frame: estimatedFrame6)
        textField6.label.text = "Start Time"
        textField6.textColor = UIColor.lightGray
       // textField6.text =
        textField6.tag = 6
        textField6.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        textField6.setOutlineColor(UIColor.lightGray, for: .normal)
        textField6.font = UIFont.systemFont(ofSize: 14)
        textField6.addTarget(self, action: #selector(selectAppointmentStartTime), for: .editingDidBegin)
        textField6.sizeToFit()
        startDateView.addSubview(textField6)
        
        
        
        let estimatedFrame8 = CGRect(x: 0, y: 0, width: appointmentDateView.frame.width - 30  , height: 10)
        let textField8 = MDCOutlinedTextField(frame: estimatedFrame8)
        textField8.label.text = "Appointment Date"
        textField8.textColor = UIColor.lightGray
        //textField8.text =
        textField8.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        textField8.setOutlineColor(UIColor.lightGray, for: .normal)
        textField8.font = UIFont.systemFont(ofSize: 14)
        textField8.addTarget(self, action: #selector(selectAppointmentDate), for: .editingDidBegin)
        textField8.sizeToFit()
        appointmentDateView.addSubview(textField8)
    }
    func showLocationDetail(){
        let estimatedFrame = CGRect(x: 0, y: 0, width: locatonView.frame.width - 30  , height: 10)
        let textField = MDCOutlinedTextField(frame: estimatedFrame)
        textField.label.text = "Location - be Specific"
        textField.textColor = UIColor.lightGray
        textField.text = ""
        textField.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        textField.setOutlineColor(UIColor.lightGray, for: .normal)
        textField.font = UIFont.systemFont(ofSize: 14)
        
        textField.sizeToFit()
        locatonView.addSubview(textField)
        
        let estimatedFrame1 = CGRect(x: 0, y: 0, width: specialNotesView.frame.width - 30  , height: 10)
        let textField1 = MDCOutlinedTextField(frame: estimatedFrame1)
        textField1.label.text = "Special Request/Details/Notes"
        textField1.textColor = UIColor.lightGray
        textField1.text = ""
        textField1.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        textField1.setOutlineColor(UIColor.lightGray, for: .normal)
        textField1.font = UIFont.systemFont(ofSize: 14)
        
        textField1.sizeToFit()
        specialNotesView.addSubview(textField1)
    }
   /* func showProcessingDetail(){
        
        
        
        
        let estimatedFrame = CGRect(x: 0, y: 0, width: requestedONView.frame.width - 30  , height: 10)
        let textField = MDCOutlinedTextField(frame: estimatedFrame)
        textField.label.text = "Requested On"
        textField.textColor = UIColor.lightGray
       // textField.text =
        textField.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        textField.setOutlineColor(UIColor.lightGray, for: .normal)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(selectProcessingDetail), for: .editingDidBegin)
        textField.sizeToFit()
        requestedONView.addSubview(textField)
        
        let estimatedFrame1 = CGRect(x: 0, y: 0, width: bookedOnView.frame.width - 30  , height: 10)
        let textField1 = MDCOutlinedTextField(frame: estimatedFrame1)
        textField1.label.text = "Booked On"
        textField1.textColor = UIColor.lightGray
        textField1.text = startDatee
        textField1.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        textField1.setOutlineColor(UIColor.lightGray, for: .normal)
        textField1.font = UIFont.systemFont(ofSize: 14)
        textField1.addTarget(self, action: #selector(selectProcessingDetail), for: .editingDidBegin)
        textField1.sizeToFit()
        bookedOnView.addSubview(textField1)
        
        let estimatedFrame2 = CGRect(x: 0, y: 0, width: loadedOnView.frame.width - 30  , height: 10)
        let textField2 = MDCOutlinedTextField(frame: estimatedFrame2)
        textField2.label.text = "Loaded On"
        textField2.textColor = UIColor.lightGray
        textField2.text = startDatee
        textField2.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        textField2.setOutlineColor(UIColor.lightGray, for: .normal)
        textField2.font = UIFont.systemFont(ofSize: 14)
        textField2.addTarget(self, action: #selector(selectProcessingDetail), for: .editingDidBegin)
        textField2.sizeToFit()
        loadedOnView.addSubview(textField2)
        
        let estimatedFrame3 = CGRect(x: 0, y: 0, width: canceledOnView.frame.width - 30  , height: 10)
        let textField3 = MDCOutlinedTextField(frame: estimatedFrame3)
        textField3.label.text = "Cancelled On"
        textField3.textColor = UIColor.lightGray
        textField3.text = startDatee
        textField3.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        textField3.setOutlineColor(UIColor.lightGray, for: .normal)
        textField3.font = UIFont.systemFont(ofSize: 14)
        textField3.addTarget(self, action: #selector(selectProcessingDetail), for: .editingDidBegin)
        textField3.sizeToFit()
        canceledOnView.addSubview(textField3)
    }*/
    @objc func selectProcessingDetail(_ textfield : UITextField){
        print("abcd ")
        textfield.endEditing(true)
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .dateAndTime, minDate: Date(), maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            let roundOff = selectedDate//.nearestHour() ?? selectedDate
            let selectedDate  = roundOff.dateString("MM/dd/YYYY hh:mm a")
            print("seleceted date \(selectedDate)")
            textfield.text = selectedDate
        
        })
    }
    @objc func selectAppointmentDate(_ textfield : UITextField){
        print("abcd ")
        textfield.endEditing(true)
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .date, minDate: Date(), maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            print("selected startDat e",selectedDate)
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            textfield.text = roundoff.dateString("MM/dd/YYYY")
           
            
        })
        
    }
    @objc func selectAppointmentStartTime(_ textfield : UITextField){
        print("abcd ")
        textfield.endEditing(true)
        let minDate = Date()//.adding(minutes: 120)

        RPicker.selectDate(title: "Select Start Time", cancelText: "Cancel", datePickerMode: .time, minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            let endTimee = roundoff.adding(minutes: 120)
            textfield.text = roundoff.dateString("hh:mm a")
             let showEndTime = endTimee.dateString("hh:mm a")
             self?.showEndTimeFeild(endTime: showEndTime)
        })
            
        
    }
    func showEndTimeFeild(endTime : String){
        
        endDateView.subviews.forEach { (item) in
            if item.tag == 1 {
                item.removeFromSuperview()
            }
        }
        
            let width =  (self.endDateView.frame.width - 30 )
            let estimatedFrame7 = CGRect(x: 0, y: 0,width: width  , height: 10)
            let textField7 = MDCOutlinedTextField(frame: estimatedFrame7)
            textField7.label.text = "End Time"
            textField7.textColor = UIColor.lightGray
            textField7.text = endTime
            textField7.tag = 1
            textField7.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
            textField7.setOutlineColor(UIColor.lightGray, for: .normal)
            textField7.font = UIFont.systemFont(ofSize: 14)
            textField7.addTarget(self, action: #selector(self.selectAppointmentEndTime), for: .editingDidBegin)
            textField7.sizeToFit()
            self.endDateView.addSubview(textField7)
            
       
    }
    @objc func selectAppointmentEndTime(_ textfield : UITextField){
        print("abcd ")
        textfield.endEditing(true)
        let minDate = Date().adding(minutes: 120)
        RPicker.selectDate(title: "Select End Time", cancelText: "Cancel", datePickerMode: .time, minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            let showEndTime = roundoff.dateString("hh:mm a")
            self?.showEndTimeFeild(endTime: showEndTime)
        })
        
    }
    func updateUI(customerName : String,subcustomerName : String){
        self.blockedTypeView.layer.borderWidth = 0.6
        self.recurringTypeView.layer.borderWidth = 0.6
        
        let estimatedFrame = CGRect(x: 0, y: 0, width: jobTypeView.frame.width , height: 10)
        let textField = MDCOutlinedTextField(frame: estimatedFrame)
        textField.label.text = "Job Type"
        textField.textColor = UIColor.lightGray
        textField.text = "Onsite Interpretation"
        textField.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        textField.setOutlineColor(UIColor.lightGray, for: .normal)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.sizeToFit()
        jobTypeView.addSubview(textField)
        
        
        
        let estimatedFrame3 = CGRect(x: 0, y: 0, width: customerNameView.frame.width , height: 10)
        let customerNameTF = MDCOutlinedTextField(frame: estimatedFrame3)
        customerNameTF.label.text = "Customer Name"
        print("Customer Name ", customerName)
        customerNameTF.text = customerName
        customerNameTF.textColor = UIColor.lightGray
        customerNameTF.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        customerNameTF.setOutlineColor(UIColor.lightGray, for: .normal)
        customerNameTF.font = UIFont.systemFont(ofSize: 14)
        customerNameTF.sizeToFit()
        customerNameView.addSubview(customerNameTF)
        
        let estimatedFrame4 = CGRect(x: 0, y: 0, width: subcustomerNameView.frame.width , height: 10)
        let subcustomerNameTF = MDCOutlinedTextField(frame: estimatedFrame4)
        print("sub customer detail ", subcustomerName)
        subcustomerNameTF.label.text = "SubCustomer Name"
        subcustomerNameTF.text = subcustomerName
        subcustomerNameTF.placeholder = "Select Subcustomer Name"
        subcustomerNameTF.textColor = UIColor.lightGray
        subcustomerNameTF.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        subcustomerNameTF.font = UIFont.systemFont(ofSize: 14)
        subcustomerNameTF.setOutlineColor(UIColor.lightGray, for: .normal)
        subcustomerNameTF.sizeToFit()
        subcustomerNameView.addSubview(subcustomerNameTF)
        
    }
    func updateSpeciality(SpecialityName: String?){
        specialityView.subviews.forEach { (item) in
            if item.tag == 1 {
                item.removeFromSuperview()
            }
        }
        let estimatedFrame2 = CGRect(x: 0, y: 0, width: specialityView.frame.width - 30  , height: 10)
        let specialityTF = MDCOutlinedTextField(frame: estimatedFrame2)
        specialityTF.label.text = "Speciality"
        specialityTF.textColor = UIColor.lightGray
        specialityTF.text = SpecialityName ?? "Select Speciality"
        specialityTF.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        specialityTF.setOutlineColor(UIColor.lightGray, for: .normal)
        specialityTF.font = UIFont.systemFont(ofSize: 14)
        specialityTF.tag = 1
        specialityTF.isUserInteractionEnabled = false
        specialityTF.sizeToFit()
        specialityView.addSubview(specialityTF)
    }
    func updateService(serviceType : String? ){
        serviceTypeView.subviews.forEach { (item) in
            if item.tag == 1 {
                item.removeFromSuperview()
            }
        }
        
        
        
        let estimatedFrame = CGRect(x: 0, y: 0, width: serviceTypeView.frame.width - 30 , height: 10)
        let serviceTF = MDCOutlinedTextField(frame: estimatedFrame)
        serviceTF.label.text = "Service Type"
        serviceTF.textColor = UIColor.lightGray
        serviceTF.text = serviceType ?? "Select Service Type"
        serviceTF.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        serviceTF.setOutlineColor(UIColor.lightGray, for: .normal)
        serviceTF.font = UIFont.systemFont(ofSize: 14)
        serviceTF.sizeToFit()
        serviceTF.tag = 1
        serviceTF.isUserInteractionEnabled = false
        
        serviceTypeView.addSubview(serviceTF)
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
    func showVenueDropDown(venueName : String ){
        let estimatedFrame2 = CGRect(x: 0, y: 0, width: showVenueView.frame.width  , height: 10)
        let showVenue = MDCOutlinedTextField(frame: estimatedFrame2)
        showVenue.label.text = "Venue"
        
        showVenue.textColor = UIColor.lightGray
        showVenue.text = venueName
        
        showVenue.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        showVenue.setOutlineColor(UIColor.lightGray, for: .normal)
        showVenue.font = UIFont.systemFont(ofSize: 14)
        showVenue.sizeToFit()
        showVenueView.addSubview(showVenue)
    }
    func updateAuthCode(authCode : String){
        let estimatedFrame2 = CGRect(x: 0, y: 0, width: authcodeView.frame.width , height: 10)
        let authCodeTF = MDCOutlinedTextField(frame: estimatedFrame2)
        authCodeTF.label.text = "Authentication Code"
        authCodeTF.textColor = UIColor.lightGray
        authCodeTF.text = authCode
        authCodeTF.setFloatingLabelColor(UIColor(hexString: "33A5ff"), for: .normal)
        authCodeTF.setOutlineColor(UIColor.lightGray, for: .normal)
        authCodeTF.font = UIFont.systemFont(ofSize: 14)
        authCodeTF.sizeToFit()
        authcodeView.addSubview(authCodeTF)
    }

    @IBAction func actionProcessingDetail(_ sender: UIButton) {
    }
    @IBAction func actionClearDepartmentField(_ sender: UIButton) {
    }
    @IBAction func actionAddActualDepartment(_ sender: UIButton) {
    }
    @IBAction func actionClearContactField(_ sender: UIButton) {
    }
    @IBAction func actionAddActualContact(_ sender: UIButton) {
    }
    @IBAction func actionDeactivateDepartment(_ sender: UIButton) {
    }
    @IBAction func actionActivateDepartment(_ sender: UIButton) {
    }
    @IBAction func actionDeleteContact(_ sender: UIButton) {
    }
    @IBAction func actionEditContact(_ sender: UIButton) {
    }
    @IBAction func actionAddContact(_ sender: UIButton) {
    }
    @IBAction func actionEditDepartment(_ sender: UIButton) {
    }
    @IBAction func actionAddDepartment(_ sender: UIButton) {
    }
    @IBAction func actionAddVenue(_ sender: UIButton) {
    }
    @IBAction func actionRegularType(_ sender: UIButton) {
        self.selectTypeOFAppointment = "R"
        self.regularTypeView.backgroundColor = UIColor(hexString: "33A5ff")
        self.blockedTypeView.backgroundColor = UIColor.white
        self.recurringTypeView.backgroundColor = UIColor.white
        self.regularTypeLbl.textColor = UIColor.white
        self.blockedTypeLbl.textColor = UIColor.black
        self.recurringTypeLbl.textColor = UIColor.black
        self.regularTypeView.layer.borderWidth = 0
        self.blockedTypeView.layer.borderWidth = 0.6
        self.recurringTypeView.layer.borderWidth = 0.6
    }
    @IBAction func actionBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func selectSpeciality(_ sender: UIButton) {
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        //dropDown.textFont = UIFont(name: "ProximaNova-Regular", size: 14.0)!
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = specialityArray
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            self?.updateSpeciality(SpecialityName: item)

        }
    }
    @IBAction func selectService(_ sender: UIButton) {
        print("button tapped ")
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        //dropDown.textFont = UIFont(name: "ProximaNova-Regular", size: 14.0)!
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = serviceArr
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            self?.updateService(serviceType: item)
           // sender.setTitleColor(UIColor.black, for: .normal)
            //sender.setTitle(item, for: .normal)
//            self?.apiGetSpecialityDataModel?.speciality?.forEach({ languageData in
//                if item == languageData.displayValue ?? "" {
//                    self?.serviceId = "\(languageData.specialityID ?? 0)"
//                }
//            })
        }
    }
    @IBAction func actionRecurringType(_ sender: UIButton) {
        self.selectTypeOFAppointment = "RC"
        self.regularTypeView.backgroundColor = UIColor.white
        self.blockedTypeView.backgroundColor = UIColor.white
        self.recurringTypeView.backgroundColor = UIColor(hexString: "33A5ff")
        self.regularTypeLbl.textColor = UIColor.black
        self.blockedTypeLbl.textColor = UIColor.black
        self.recurringTypeLbl.textColor = UIColor.white
        self.regularTypeView.layer.borderWidth = 0.6
        self.blockedTypeView.layer.borderWidth = 0.6
        self.recurringTypeView.layer.borderWidth = 0
    }
    
    
    
    @IBAction func actionBlockedType(_ sender: UIButton) {
        self.selectTypeOFAppointment = "B"
        self.regularTypeView.backgroundColor = UIColor.white
        self.blockedTypeView.backgroundColor = UIColor(hexString: "33A5ff")
        self.recurringTypeView.backgroundColor = UIColor.white
        self.regularTypeLbl.textColor = UIColor.black
        self.blockedTypeLbl.textColor = UIColor.white
        self.recurringTypeLbl.textColor = UIColor.black
        self.regularTypeView.layer.borderWidth = 0.6
        self.blockedTypeView.layer.borderWidth = 0
        self.recurringTypeView.layer.borderWidth = 0.6
    }
    
}

//MARK: -

extension OnsiteInterpretationNewViewController {
    func getCustomerDetail(){
        let urlString = APi.GetCustomerDetail.url
        let companyID = GetPublicData.sharedInstance.companyID
        let userID = GetPublicData.sharedInstance.userID
        let userTypeId = GetPublicData.sharedInstance.userTypeID
        let searchString = "<INFO><COMPANYID>\(companyID)</COMPANYID><LOGINUSERID>\(userID)</LOGINUSERID><LOGINUSERTYPEID>\(userTypeId)</LOGINUSERTYPEID><USERTYPEID>\(userTypeId)</USERTYPEID><APPTYPE>1</APPTYPE><EDIT>1</EDIT><AUTHFLAG>2</AUTHFLAG></INFO>"
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
                                let userInfo = newjson?["Userdata"] as? [[String:Any]]
                                //let statusInfo = newjson?["StatusInfo"] as? [[String:Any]] // use the json here
                                let userIfo = userInfo?.first
                                let customerUserName = userIfo?["CustomerUserName"] as? String
                                let customerEmail = userIfo?["Email"] as? String
                                let customerFullName = userIfo?["CustomerFullName"] as? String
                                print("userInfo ", userInfo,customerUserName , customerEmail , customerFullName)
                                updateUI(customerName: customerFullName ?? "", subcustomerName: "Select Subcustomer Name")
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
    func getCommonDetail(){
        let urlString = APi.GetCommonDetail.url
        let companyID = GetPublicData.sharedInstance.companyID
        let userID = GetPublicData.sharedInstance.userID
        let userTypeId = GetPublicData.sharedInstance.userTypeID
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
                                
                                print(specialityArray)
                                updateAuthCode(authCode: authcode ?? "")
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
            })
    }
}


struct SpecialityData {
    var SpecialityID : Int?
    var DisplayValue : String?
    var Duration : Int?
}
struct ServiceData {
    var SpecialityID : Int?
    var DisplayValue : String?
    var Duration : Int?
}
