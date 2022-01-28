//
//  OnSiteInterpretationAppointmentVC.swift
//  TLClientApp
//
//  Created by Mac on 25/10/21.
//

import UIKit
import Alamofire
import DropDown
import iOSDropDown
import CoreLocation
class OnSiteInterpretationAppointmentVC: UIViewController , UITextFieldDelegate  {
    
    
    @IBOutlet weak var startTimeTimeTF: UITextField!
    @IBOutlet weak var endTimeTimeTF: UITextField!
    @IBOutlet weak var departmentActivateView: UIView!
    @IBOutlet var clientRefrenceTF: UITextField!
    @IBOutlet var companyNameLbl: UILabel!
    @IBOutlet var clientInitialTF: UITextField!
    @IBOutlet var clientNameTf: UITextField!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var authCodeLbl: UILabel!
    @IBOutlet var clientInitialsTF: UITextField!
    @IBOutlet var studentNameTF: UITextField!
    @IBOutlet var selectvenueBtn: UIButton!
    @IBOutlet var selectConatctBtn: UIButton!
    @IBOutlet var selectDepartmentbtn: UIButton!
    @IBOutlet var departmentSelectBtn: UIButton!
    @IBOutlet var selectContactBtn: UIButton!
    @IBOutlet var venueDetailBtn: UIButton!
    @IBOutlet var erviceTypebtn: UIButton!
    @IBOutlet var bookedONTF: UITextField!
    @IBOutlet var loadedONTF: UITextField!
    @IBOutlet var canceledONTF: UITextField!
    @IBOutlet var requestONTF: UITextField!
    @IBOutlet var specialRequestTF: UITextField!
    @IBOutlet var sendEndTimeSwitch: UISwitch!
    @IBOutlet var locationTF: UITextField!
    @IBOutlet var startDateTF: UITextField!
    @IBOutlet var endDateTF: UITextField!
    @IBOutlet var btnDeactivate: UIButton!
    @IBOutlet var addDepartMentView: UIView!
    @IBOutlet var venueAddressMainView: UIView!
    @IBOutlet var departmentNameTF: UITextField!
    @IBOutlet var contactNameTF: UITextField!
    @IBOutlet var cityLbl: UILabel!
    @IBOutlet var stateLbl: UILabel!
    @IBOutlet var zipCodeLbl: UILabel!
    @IBOutlet var locationImg: UIImageView!
    @IBOutlet var addContactView: UIView!
    @IBOutlet var venueNameLbl: UILabel!
    @IBOutlet var addressNameLbl: UILabel!
    var venueIDForDepartment = "0"
    var apiAddProviderDataresponse:ApiAddProviderDataresponse?
    @IBOutlet weak var jobTypeTF: ACFloatingTextfield!
    var apiAddDepartmentDataResponse:ApiAddDepartmentDataResponse?
    var apiGetAuthCoderesponseModel:ApiGetAuthCoderesponseModel?
    var apiGetSpecialityDataModel :ApiGetSpecialityDataModel?
    var apiGetAllVenueDataResponseModel:ApiGetAllVenueDataResponseModel?
    var apiCreateAppointmentResponseModel:ApiCreateAppointmentResponseModel?
    var venueID = "0"
    var languageID = "0"
    var actionDepartmentType = 0
    var dropDown = DropDown()
    @IBOutlet var contactNameLbl: UILabel!
    @IBOutlet var departmentNameLbl: UILabel!
    @IBOutlet weak var RequestInfoView: UIView!
    @IBOutlet var languageTF: iOSDropDown!
    var venueArray:[String] = []
    var departmentArray:[String] = []
    var contactArray:[String] = []
    var genderArray:[String] = []
    var specialityArray:[String] = []
    var jobType = ""
    var appointTypeId = 1
    var appointStatusID = 0
    var venueIDForContact = "0"
    var authCode = ""
    var genderId = ""
  //  @IBOutlet weak var jobTypeTF: ACFloatingTextfield!
    var serviceId = ""
    @IBOutlet weak var customerNameTF: ACFloatingTextfield!
    @IBOutlet weak var CompanyNameTF: ACFloatingTextfield!
    @IBOutlet weak var AuthCodeTF: ACFloatingTextfield!
    @IBOutlet weak var venueDetailView: UIView!
    @IBOutlet weak var AppointmentDetailView: UIView!
    @IBOutlet weak var basicInfoView: UIView!
    @IBOutlet weak var processingDetailView: UIView!
    @IBOutlet weak var serviceTypeTF: iOSDropDown!
    var providerID = "0"
    var departmentID = "0"
    var departmentAction = 0
    var contactAction = 0
    var selectedVenue = ""
    var selectedContact = ""
    var selectedDepartment = ""
    var sendEndTimevar = false
    override func viewDidLoad() {
        super.viewDidLoad()
        RequestInfoView.addShadowGrey()
        endDateTF.isUserInteractionEnabled = false
        getAuthCode()
        getServiceType()
        self.sendEndTimeSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.70)
        self.btnDeactivate.layer.borderColor = UIColor(hexString: "33A5FF").cgColor
        self.btnDeactivate.layer.borderWidth = 0.6
        self.sendEndTimeSwitch.isOn = false
        self.sendEndTimeSwitch.addTarget(self, action: #selector(sendEndTime), for: .valueChanged)
        self.venueDetailView.addShadowGrey()
        self.AppointmentDetailView.addShadowGrey()
        self.basicInfoView.addShadowGrey()
        self.processingDetailView.addShadowGrey()
        self.clientNameTf.delegate = self
        self.addDepartMentView.visibility = .gone
        self.addContactView.visibility = .gone
        self.venueAddressMainView.visibility = .gone
        getVenuList()
       // self.erviceTypebtn.setTitle("Select Service Type", for: .normal)
        GetPublicData.sharedInstance.getAllLanguage()
        //self.userNameLbl.text = GetPublicData.sharedInstance.usenName
        //self.companyNameLbl.text = GetPublicData.sharedInstance.companyName
        self.CompanyNameTF.text = GetPublicData.sharedInstance.companyName
        self.customerNameTF.text = GetPublicData.sharedInstance.usenName
        NotificationCenter.default.addObserver(self, selector: #selector(updateVenueList), name: Notification.Name("updateVenueList"), object: nil)
        
        let dateFormatter = DateFormatter()
//        MM/dd/yyyy
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "MM/dd/yyyy"
        
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "h:mm a"
        
        let currentDateTime = Date().nearestHour() ?? Date()
        startDateTF.text = dateFormatterDate.string(from: currentDateTime)
        startTimeTimeTF.text = dateFormatterTime.string(from: currentDateTime)
        
        let endTimee = Date().adding(minutes: 120).nearestHour() ?? Date()
        endDateTF.text = dateFormatterDate.string(from: endTimee)
        endTimeTimeTF.text = dateFormatterTime.string(from: endTimee)
        
        let startDate =  dateFormatterTime.string(from: Date().nearestHour() ?? Date ())
        let endDate = Date().adding(minutes: 120)
        let newEndDate = endDate.nearestHour() ?? Date ()
        let showEndDate = dateFormatterTime.string(from: newEndDate)

        
//
        
        let dateFormatterr = DateFormatter()
        dateFormatterr.dateFormat = "MM/dd/yyyy h:mm a"
                let startDatee =  dateFormatterr.string(from: Date().nearestHour() ?? Date ())
                 let endDatee = Date().adding(minutes: 120)
                let newEndDatee = endDate.nearestHour() ?? Date ()
                let showEndDatee = dateFormatter.string(from: newEndDate)
              
                self.requestONTF.text = startDatee
                self.loadedONTF.text = startDatee

//
        languageTF.optionArray = GetPublicData.sharedInstance.languageArray
        print("OPTIONS ARRYA \(GetPublicData.sharedInstance.languageArray)")
        print("OPTIONS NEW ARRAY \(languageTF.optionArray)")
        languageTF.checkMarkEnabled = true
        languageTF.isSearchEnable = true
        languageTF.selectedRowColor = UIColor.clear
        languageTF.didSelect{(selectedText , index , id) in
            self.languageTF.text = "\(selectedText)"
            GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
                print("language data \(languageData.languageName ?? "")")
                if selectedText == languageData.languageName ?? "" {
                    self.languageID = "\(languageData.languageID ?? 0)"
                    print("languageId \(self.languageID)")
                }
            })
        }
        
        // self.languageTF.delegate = self
        // Do any additional setup after loading the view.
    }
    func openServiceType(){
        print("speciality array ", specialityArray)
        serviceTypeTF.optionArray = specialityArray
        serviceTypeTF.checkMarkEnabled = true
        
        serviceTypeTF.selectedRowColor = UIColor.clear
        serviceTypeTF.didSelect{(selectedText , index , id) in
           self.serviceTypeTF.text = "\(selectedText)"
            self.apiGetSpecialityDataModel?.speciality?.forEach({ languageData in
                if selectedText == languageData.displayValue ?? "" {
                    self.serviceId = "\(languageData.specialityID ?? 0)"
                }
            })
        }
    }
    @IBAction func actionActivateDepartment(_ sender: UIButton) {
        if  departmentNameTF.text == ""{
            self.view.makeToast("Please add Department Name. ")
            return
        } else {
            self.actionDepartmentType = 2
            let departmentString = departmentNameTF.text ?? ""
            
            let departmentName = departmentString.replacingOccurrences(of: "(DeActivated)", with: "")
            self.addDepartmentData(Active: true, venueID: self.venueIDForDepartment, DepartmentName: departmentName, DeActive: false, departmentID: Int(self.departmentID) ?? 0)
        }
    }
    @objc func sendEndTime(){
        print("switch ")
        if sendEndTimevar {
            sendEndTimevar = false
            print("send end time \(sendEndTimevar)")
        }else {
            sendEndTimevar = true
            print("send end time \(sendEndTimevar)")
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == clientNameTf {
            //            let textS = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            //            let initials = textS?.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
            //            print(initials)
            let stringInput = textField.text?.trimmingCharacters(in: .whitespaces)
            let abc = stringInput ?? ""
            let stringInputArr = abc.components(separatedBy:" ")
            var stringNeed = ""
            let abcc:Character="C"
            for string in stringInputArr {
                stringNeed += String(string.first ?? abcc)
            }
            
            print(stringNeed)
            self.clientInitialTF.text = stringNeed.uppercased()
        }else if textField == languageTF {
            //            let selectedText = languageTF.text ?? ""
            //            GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
            //              print("language data \(languageData.languageName ?? "")")
            //               if selectedText == languageData.languageName ?? "" {
            //                       self.languageID = "\(languageData.languageID ?? 0)"
            //                      print("languageId \(self.languageID)")
            //                }
            //            })
        }
        
        
        
        
        
    }
    
    
    @IBAction func findLocationBtn(_ sender: UIButton) {
        let zipcode = self.zipCodeLbl.text ?? ""
        let city = self.cityLbl.text ?? ""
        let state = self.stateLbl.text ?? ""
        let address = self.addressNameLbl.text ?? ""
        let location: String = "\(zipcode) \(address), \(city), \(state)"
        print("location string is ",location)
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                self.view.makeToast("Please Enter Specific Location.")
                print("Error to get location coordinate ", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                print("location coordinates \(coordinates)")
                self.openGoogleMap(latitude: "\(coordinates.latitude)", longitude: "\(coordinates.longitude)", address: "Testing Address")
            }
            
            
        })
    }
    func openGoogleMap(latitude:String, longitude:String, address:String) {
        let lat = latitude
        let latDouble =  Double(lat)
        let long = longitude
        let longDouble =  Double(long)
        let url = URL(string: "comgooglemaps://?daddr=\(latDouble ?? 0.0),\(longDouble ?? 0.0)&directionsmode=driving&zoom=14&views=traffic")!
        print("location url is \(url)")
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    print("Succes \(success)")
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }else{
            self.view.makeToast("The operation couldn’t be completed.")
            print("url can't be opened")
        }
        // UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    @objc func updateVenueList(){
        reloadScreen()
        
    }
    func reloadScreen() {
        venueID = "0"
        languageID = "0"
        jobType = ""
        appointTypeId = 1
        appointStatusID = 0
        authCode = ""
        genderId = ""
        serviceId = ""
        providerID = "0"
        departmentID = "0"
        departmentAction = 0
        contactAction = 0
        selectedVenue = ""
        selectedContact = ""
        selectedDepartment = ""
        getAuthCode()
        getServiceType()
        self.venueDetailBtn.setTitle("", for: .normal)
        //self.selectContactBtn.setTitle("", for: .normal)
        self.contactNameLbl.text = ""
        self.departmentNameLbl.text = ""
        // self.departmentSelectBtn.setTitle("", for: .normal)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm a"
        let startDate =  dateFormatter.string(from: Date())
        self.requestONTF.text = startDate
        
        self.addDepartMentView.visibility = .gone
        self.addContactView.visibility = .gone
        self.venueAddressMainView.visibility = .gone
        getVenuList()
        self.erviceTypebtn.setTitle("Select Service Type", for: .normal)
        GetPublicData.sharedInstance.getAllLanguage()
        self.userNameLbl.text = GetPublicData.sharedInstance.usenName
        self.companyNameLbl.text = GetPublicData.sharedInstance.companyName
        NotificationCenter.default.addObserver(self, selector: #selector(updateVenueList), name: Notification.Name("updateVenueList"), object: nil)
        languageTF.optionArray = GetPublicData.sharedInstance.languageArray
        //              languageTF.checkMarkEnabled = true
        languageTF.selectedRowColor = UIColor.clear
        languageTF.didSelect{(selectedText , index , id) in
            self.languageTF.text = "\(selectedText)"
            GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
                print("language data \(languageData.languageName ?? "")")
                if selectedText == languageData.languageName ?? "" {
                    self.languageID = "\(languageData.languageID ?? 0)"
                    print("languageId \(self.languageID)")
                }
            })
        }
    }
    @IBAction func addVenueAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "AddNewVenueViewController") as! AddNewVenueViewController
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addActualDepartment(_ sender: UIButton) {
        if departmentAction == 0 {
            
            // add department
            print("venueid \(venueIDForDepartment)")
            if  departmentNameTF.text == ""{
                self.view.makeToast("Please add Department Name. ")
                return
            }else  if self.venueID == "0"{
                self.view.makeToast("Please add venue. ")
            }else {
                self.actionDepartmentType = 0
                let departmentName = departmentNameTF.text ?? ""
                self.addDepartmentData(Active: true, venueID: self.venueID, DepartmentName: departmentName, DeActive: false, departmentID: 0)
                
            }
        }else if departmentAction == 1 {
            //update department
            
            if  departmentNameTF.text == ""{
                self.view.makeToast("Please add Department Name. ")
                return
            } else {
                self.actionDepartmentType = 1
                let departmentName = departmentNameTF.text ?? ""
                self.addDepartmentData(Active: true, venueID: self.venueIDForDepartment, DepartmentName: departmentName, DeActive: false, departmentID: Int(self.departmentID) ?? 0)
            }
        }else if departmentAction == 2 {
            //delete department
            
        }else {
            
        }
    }
    @IBAction func addActualConatct(_ sender: UIButton) {
        if contactAction == 0 {
            // add department
            if  contactNameTF.text == ""{
                self.view.makeToast("Please add Contact Name. ")
            }else  if self.venueID == "0"{
                self.view.makeToast("Please add venue. ")
            }else {
                let departmentName = contactNameTF.text ?? ""
                self.addProviderData(Active: true, venueID: self.venueID, providerName: departmentName, DeActive: false, departmentID: self.departmentID, providerID: 0)
                
            }
        }else if contactAction == 1 {
            //update department
            if  contactNameTF.text == ""{
                self.view.makeToast("Please add Contact Name. ")
            }else {
                let departmentName = contactNameTF.text ?? ""
                self.addProviderData(Active: true, venueID: self.venueIDForContact, providerName: departmentName, DeActive: false, departmentID: self.departmentID, providerID: Int(self.providerID) ?? 0)
                
            }
        }else if contactAction == 2 {
            //delete department
            
        }else {
            
        }
    }
    @IBAction func deleteContactAction(_ sender: UIButton) {
        //  addContactView.visibility = .visible
        self.contactAction = 2
        
        if  contactNameTF.text == ""{
            self.view.makeToast("Please add Contact Name. ")
        }else {
            let departmentName = contactNameTF.text ?? ""
            self.contactNameTF.text = self.selectedContact
            self.addProviderData(Active: false, venueID: self.venueIDForContact, providerName: departmentName, DeActive: true, departmentID: self.departmentID, providerID: Int(self.providerID) ?? 0)
            
        }
    }
    @IBAction func editContactAction(_ sender: UIButton) {
        addContactView.visibility = .visible
        self.contactAction = 1
        self.contactNameTF.text = self.selectedContact
        
    }
    @IBAction func addContactAction(_ sender: UIButton) {
        addContactView.visibility = .visible
        self.contactNameTF.text = ""
        self.contactNameLbl.text = ""
        self.contactAction = 0
        
        // self.contactNameTF.text = self.selectedContact
    }
    @IBAction func deleteDepartmentAction(_ sender: UIButton) {
        //addDepartMentView.visibility = .visible
        self.departmentAction = 2
        self.departmentNameTF.text = self.selectedDepartment
        
        if  departmentNameTF.text != ""{
            let departmentName = departmentNameTF.text ?? ""
            self.addDepartmentData(Active: false, venueID: self.venueIDForDepartment, DepartmentName: departmentName, DeActive: true, departmentID: Int(self.departmentID) ?? 0)
        }else {
            self.view.makeToast("Please add Department Name. ")
        }
    }
    @IBAction func EditDepartmentAction(_ sender: UIButton) {
        addDepartMentView.visibility = .visible
        self.departmentAction = 1
        self.departmentNameTF.text = self.selectedDepartment
        self.departmentActivateView.visibility = .visible
    }
    @IBAction func addDepartmentAction(_ sender: UIButton) {
        addDepartMentView.visibility = .visible
        self.departmentAction = 0
        self.departmentNameTF.text = ""
        self.departmentActivateView.visibility = .gone
    }
    
    @IBAction func selectContact(_ sender: UIButton) {
        if contactArray.count == 0 {
            self.view.makeToast("No contact available, Please add a contact.")
            return
        }else {
            
        }
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        //dropDown.textFont = UIFont(name: "ProximaNova-Regular", size: 14.0)!
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = contactArray
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            self?.contactNameLbl.text = item
            self?.contactNameTF.text = item
            // sender.setTitleColor(UIColor.black, for: .normal)
            // sender.setTitle(item, for: .normal)
            self?.selectedContact = item
            self?.apiGetAllVenueDataResponseModel?.providerData?.forEach({ languageData in
                if item == languageData.providerName ?? "" {
                    self?.venueIDForContact = "\(languageData.venueID ?? 0)"
                    self?.providerID = "\(languageData.providerID ?? 0)"
                }
            })
        }
    }
    @IBAction func selectDepartment(_ sender: UIButton) {
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        //dropDown.textFont = UIFont(name: "ProximaNova-Regular", size: 14.0)!
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = departmentArray
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            self?.selectedDepartment = item
            self?.departmentNameLbl.text = item
            //sender.setTitleColor(UIColor.black, for: .normal)
            //sender.setTitle(item, for: .normal)
            self?.apiGetAllVenueDataResponseModel?.departmentData?.forEach({ languageData in
                if item == languageData.departmentName ?? "" {
                    self?.departmentID = "\(languageData.departmentID ?? 0)"
                    self?.venueIDForDepartment = "\(languageData.venueID ?? 0)"
                }
            })
        }
    }
    
    @IBAction func selectVenueDetail(_ sender: UIButton) {
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        //dropDown.textFont = UIFont(name: "ProximaNova-Regular", size: 14.0)!
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = venueArray
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            self?.venueAddressMainView.visibility = .visible
            self?.selectedVenue = item
            sender.setTitleColor(UIColor.black, for: .normal)
            sender.setTitle(item, for: .normal)
            self?.apiGetAllVenueDataResponseModel?.venueData?.forEach({ languageData in
                if item == languageData.venueName ?? "" {
                    self?.venueNameLbl.text = languageData.venueName ?? ""
                    self?.stateLbl.text = languageData.state ?? ""
                    self?.cityLbl.text = languageData.city ?? ""
                    self?.zipCodeLbl.text = languageData.zipCode ?? ""
                    self?.addressNameLbl.text = languageData.address ?? ""
                    self?.venueID = "\(languageData.venueID ?? 0)"
                }
            })
        }
    }
    @IBAction func selectServiceType(_ sender: UIButton) {
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        //dropDown.textFont = UIFont(name: "ProximaNova-Regular", size: 14.0)!
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = specialityArray
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            sender.setTitleColor(UIColor.black, for: .normal)
            sender.setTitle(item, for: .normal)
            self?.apiGetSpecialityDataModel?.speciality?.forEach({ languageData in
                if item == languageData.displayValue ?? "" {
                    self?.serviceId = "\(languageData.specialityID ?? 0)"
                }
            })
        }
    }
    @IBAction func actionBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionLanguageBtn(_ sender: UIButton) {
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        //dropDown.textFont = UIFont(name: "ProximaNova-Regular", size: 14.0)!
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.direction = .any
        dropDown.dataSource = GetPublicData.sharedInstance.languageArray
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            sender.setTitleColor(UIColor.black, for: .normal)
            sender.setTitle(item, for: .normal)
            GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
                print("language data \(languageData.languageName ?? "")")
                if item == languageData.languageName ?? "" {
                    self?.languageID = "\(languageData.languageID ?? 0)"
                    print("languageId \(self?.languageID)")
                }
            })
        }
    }
    
    @IBAction func actionStartTime(_ sender: UIButton) {
        let minDate = Date()//.adding(minutes: 120)

        RPicker.selectDate(title: "Select Start Time", cancelText: "Cancel", datePickerMode: .time, minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            let endTimee = roundoff.adding(minutes: 120)
            self?.startTimeTimeTF.text = roundoff.dateString("hh:mm a")
            self?.endTimeTimeTF.text = endTimee.dateString("hh:mm a")
        })
    }
    
    
    
    @IBAction func actionEndTime(_ sender: UIButton) {
        let minDate = Date().adding(minutes: 120)
        RPicker.selectDate(title: "Select End Time", cancelText: "Cancel", datePickerMode: .time, minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            self?.endTimeTimeTF.text = roundoff.dateString("hh:mm a")
        })
    }
    
    
    
    
    
    @IBAction func actionEndDate(_ sender: UIButton) {
        let minDate = Date().adding(minutes: 120)
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .date, minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            self?.endDateTF.text = roundoff.dateString("MM/dd/YYYY")
        })
    }
    
    
    @IBAction func actionStartDate(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .date, minDate: Date(), maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            print("selected startDat e",selectedDate)
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            self?.startDateTF.text = roundoff.dateString("MM/dd/YYYY")
            let endDate = roundoff.adding(minutes: 120)
         
            self?.endDateTF.text = endDate.dateString("MM/dd/YYYY")
            
        })
    }
    @IBAction func cancelDepartmentView(_ sender: UIButton) {
        self.addDepartMentView.visibility = .gone
        self.departmentNameTF.text = ""
    }
    
    @IBAction func cancelConatctView(_ sender: UIButton) {
        self.addContactView.visibility = .gone
        self.contactNameTF.text = ""
    }
    @IBAction func actionDeactivate(_ sender: UIButton) {
        if  departmentNameTF.text == ""{
            self.view.makeToast("Please add Department Name. ")
            return
        } else {
            self.actionDepartmentType = 3
            let departmentName = departmentNameTF.text ?? ""
            self.addDepartmentData(Active: false, venueID: self.venueIDForDepartment, DepartmentName: departmentName, DeActive: true, departmentID: Int(self.departmentID) ?? 0)
        }
    }
    
    func actionActivate(_ sender: UIButton) {
        if  departmentNameTF.text == ""{
            self.view.makeToast("Please add Department Name. ")
            return
        } else {
            self.actionDepartmentType = 2
            let departmentString = departmentNameTF.text ?? ""
            
            let departmentName = departmentString.replacingOccurrences(of: "(DeActivated)", with: "")
            self.addDepartmentData(Active: true, venueID: self.venueIDForDepartment, DepartmentName: departmentName, DeActive: false, departmentID: Int(self.departmentID) ?? 0)
        }
    }
    @IBAction func genderBtnPressed(_ sender: UIButton) {
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        //dropDown.textFont = UIFont(name: "ProximaNova-Regular", size: 14.0)!
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 20
        dropDown.clipsToBounds = true
        dropDown.show() //7
        dropDown.dataSource = genderArray
        dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            sender.setTitleColor(UIColor.black, for: .normal)
            sender.setTitle(item, for: .normal)
            
            self?.apiGetAuthCoderesponseModel?.gender?.forEach({ typeData  in
                let type = typeData.value ?? ""
                if type == item {
                    self?.genderId = "\(typeData.code ?? "")"
                }
            })
        }
    }
    
    @IBAction func actionProcessingDetailCalender(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .dateAndTime, minDate: Date(), maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            let roundOff = selectedDate//.nearestHour() ?? selectedDate
            let selectedDate  = roundOff.dateString("MM/dd/YYYY hh:mm a")
            print("seleceted date \(selectedDate)")
            if sender.tag == 0 {
                self?.requestONTF.text = selectedDate
            }else if sender.tag == 1 {
                self?.bookedONTF.text = selectedDate
            }else if sender.tag == 2 {
                self?.canceledONTF.text = selectedDate
            }else if sender.tag == 3 {
                self?.loadedONTF.text = selectedDate
            }
            
        })
    }
    @IBAction func actionCreateRequest(_ sender: UIButton) {
        let selectedText = languageTF.text ?? ""
        GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
            print("language data \(languageData.languageName ?? "")")
            if selectedText == languageData.languageName ?? "" {
                self.languageID = "\(languageData.languageID ?? 0)"
                print("languageId \(self.languageID)")
            }
        })
        
        let userId = GetPublicData.sharedInstance.userID
        let companyID = GetPublicData.sharedInstance.companyID
        let userTypeID = GetPublicData.sharedInstance.userTypeID
        let userName = GetPublicData.sharedInstance.usenName
        let clientName = self.clientNameTf.text ?? ""
        let startDate = "\(self.startDateTF.text ?? "") \(self.startTimeTimeTF.text ?? "")"
        let endDate = "\(self.endDateTF.text ?? "") \(self.endTimeTimeTF.text ?? "")"
        let cpIntial = self.clientInitialTF.text ?? ""
        let requestedOn = self.requestONTF.text ?? ""
        let loadedOn = self.loadedONTF.text ?? ""
        let updatedOn = self.requestONTF.text ?? ""
        self.jobType = "Onsite Interpretation"
        print("venueID , language ID \(venueID ),\(languageID)")
        if self.startDateTF.text!.isEmpty {
            self.view.makeToast("Please fill Start Date.",duration: 1, position: .center)
            
        }else if self.endDateTF.text!.isEmpty {
            self.view.makeToast("Please fill End Date.",duration: 1, position: .center)
            
        }else if self.venueID == "0"  {
            self.view.makeToast("Please fill Venue Detail.",duration: 1, position: .center)
            
        }else if self.languageID == "0" {
            self.view.makeToast("Please fill Language Detail.",duration: 1, position: .center)
            
        }else {
            self.createRequestForAppointment(userID: userId, companyID: companyID, AuthCode: authCode, AppointStatusID: appointStatusID, startDate: startDate, EndDate: endDate, AppointTypeID: appointTypeId, languageID: languageID, userTypeID: userTypeID, jobType: jobType, clientName: clientName, venueID: self.venueID, updatedOn: updatedOn, requestedON: requestedOn, loadedON: loadedOn, cpInitials: cpIntial, serviceTypeID: serviceId, genderID: genderId, userName: userName)
        }
    }
    /*func getAllLanguage(){
     SwiftLoader.show(animated: true)
     
     
     let urlString  = "https://lsp.totallanguage.com/Security/GetData?methodType=LanguageData"
     AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
     .validate()
     .responseData(completionHandler: { [self] (response) in
     SwiftLoader.hide()
     switch(response.result){
     
     case .success(_):
     print("Respose Success ")
     guard let daata = response.data else { return }
     do {
     let jsonDecoder = JSONDecoder()
     self.apiGetAllLanguageResponse = try jsonDecoder.decode(ApiGetAllLanguageResponse.self, from: daata)
     print("Success")
     self.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
     let languageString = languageData.languageName ?? ""
     languageDataSource.append(languageString)
     })
     
     } catch{
     
     print("error block forgot password " ,error)
     }
     case .failure(_):
     print("Respose Failure ")
     
     }
     })
     }*/
    func getAuthCode(){
        SwiftLoader.show(animated: true)
        genderArray.removeAll()
        //   https://lsp.totallanguage.com/Appointment/GetData?methodType=AuthenticationCode&UserID=219490&UserType=Customer&CompanyID=55
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let companyId = userDefaults.string(forKey: "companyID") ?? ""
        let userTypeID = userDefaults.string(forKey: "userTypeID") ?? ""
        let urlPostFix = "UserID=\(userId)&UserType=\(userTypeID)&CompanyID=\(companyId)"
        
        let urlString = "\(APi.getAuthCode.url)" + urlPostFix
        print("url for auth code ",urlString)
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success get auth code ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiGetAuthCoderesponseModel = try jsonDecoder.decode(ApiGetAuthCoderesponseModel.self, from: daata)
                        print("Success")
                        self.authCode = apiGetAuthCoderesponseModel?.authenticationCode?.first?.authCode ?? ""
                        
                        self.apiGetAuthCoderesponseModel?.appointmentStatus?.forEach({ typeData  in
                            let type = typeData.code ?? ""
                            if type == "NOTBOOKED" {
                                self.appointStatusID = typeData.id ?? 0
                            }
                        })
                        self.apiGetAuthCoderesponseModel?.appointmentType?.forEach({ typeData  in
                            let type = typeData.code ?? ""
                            if type == "ONSITE" {
                                self.appointTypeId = typeData.id ?? 0
                            }
                        })
                        let authCode = apiGetAuthCoderesponseModel?.authenticationCode?.first?.authCode ?? ""
                        var authcodeComponent =  authCode.components(separatedBy: "-")
                        authcodeComponent[1].add(prefix: "CR")
                        let newAuthCode = authcodeComponent.joined(separator: "-")
                       // self.authCodeLbl.text = newAuthCode
                        self.AuthCodeTF.text = newAuthCode
                        //apiGetAuthCoderesponseModel?.authenticationCode?.first?.authCode ?? ""
                        
                        self.apiGetAuthCoderesponseModel?.gender?.forEach({ genderData in
                            let title = genderData.value ?? ""
                            self.genderArray.append(title)
                        })
                        
                    } catch{
                        
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure ")
                    
                }
            })
    }
    func getServiceType(){
        SwiftLoader.show(animated: true)
        specialityArray.removeAll()
        //Appointment/GetData?methodType=Speciality&CompanyId=55&SpType1=1
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let companyId = userDefaults.string(forKey: "companyID") ?? ""
        let userTypeID = userDefaults.string(forKey: "userTypeID") ?? ""
        let urlPostFix = "&CompanyId=\(companyId)&SpType1=1"
        
        let urlString = "\(APi.speciality.url)" + urlPostFix
        print("url for service  \(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiGetSpecialityDataModel = try jsonDecoder.decode(ApiGetSpecialityDataModel.self, from: daata)
                        print("Success")
                        let btnTitle = self.apiGetSpecialityDataModel?.speciality?.first?.displayValue ?? ""
                        //self.erviceTypebtn.setTitle(btnTitle, for: .normal)
                        self.apiGetSpecialityDataModel?.speciality?.forEach({ genderData in
                            let title = genderData.displayValue ?? ""
                            self.specialityArray.append(title)
                        })
                        openServiceType()
                        
                    } catch{
                        
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure service ")
                    
                }
            })
    }
    func getVenuList(){
        SwiftLoader.show(animated: true)
        self.venueArray.removeAll()
        self.departmentArray.removeAll()
        self.contactArray.removeAll()
        self.apiGetAllVenueDataResponseModel = nil
        let userId = userDefaults.string(forKey: "userId") ?? ""
        //let urlParam = "CustomerID=\(userId)&UserType=Customer&Type=EDITTIME"
        //let urABC = "\(APi.getVenueData.url)" + urlParam
        let urlString = "https://lsp.totallanguage.com/Controls/Venue/GetData?methodType=VenueData%2CDepartmentData%2CProviderData%2CStates&CustomerID=\(userId)&UserType=Customer&Type=EDITTIME"
        //print("url to get schedule \(urABC)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success venue")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiGetAllVenueDataResponseModel = try jsonDecoder.decode(ApiGetAllVenueDataResponseModel.self, from: daata)
                        print("Success")
                        self.apiGetAllVenueDataResponseModel?.venueData?.forEach({ venueData in
                            let venueString = venueData.venueName ?? ""
                            self.venueArray.append(venueString)
                        })
                        self.apiGetAllVenueDataResponseModel?.departmentData?.forEach({ venueData in
                            let venueString = venueData.departmentName ?? ""
                            print("department  name is \(venueString )")
                            self.departmentArray.append(venueString)
                        })
                        self.apiGetAllVenueDataResponseModel?.providerData?.forEach({ venueData in
                            
                            let venueString = venueData.providerName ?? ""
                            print("provider name is \(venueString )")
                            self.contactArray.append(venueString)
                        })
                        
                        
                    } catch{
                        
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure ")
                    
                }
            })
    }
    func addDepartmentData(Active:Bool , venueID: String ,DepartmentName : String , DeActive:Bool, departmentID:Int  ){
        SwiftLoader.show(animated: true)
        let urlString = APi.addDepartment.url
        let parameters = [
            "DepartmentDetails": [
                "DepartmentName":DepartmentName,
                "DepartmentID":departmentID,
                "VenueID":venueID,
                "Active" : Active,
                "DeActive":DeActive
            ]
        ] as [String:Any]
        print("url to create Appointment \(urlString),\(parameters)")
        AF.request(urlString, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success update department Detail ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiAddDepartmentDataResponse = try jsonDecoder.decode(ApiAddDepartmentDataResponse.self, from: daata)
                        let status = self.apiAddDepartmentDataResponse?.departments?.first?.success ?? 0
                        if status == 2 {
                            print("Success")
                            self.view.makeToast("Department Name Already Exist.",duration: 2, position: .center)
                            
                            
                        }else {
                            // reloadScreen()
                            self.departmentNameTF.text = ""
                            self.departmentNameLbl.text = ""
                            //self.departmentSelectBtn.setTitle("", for: .normal)
                            self.addDepartMentView.visibility = .gone
                            getVenuList()
                            if self.actionDepartmentType == 0 {
                                self.view.makeToast("Department Name Saved.",duration: 2, position: .center)
                                
                            }else if self.actionDepartmentType == 1{
                                self.view.makeToast("Department Name Updated.",duration: 2, position: .center)
                            }else if self.actionDepartmentType == 2{
                                self.view.makeToast("Department Name Activated.",duration: 2, position: .center)
                            }else if self.actionDepartmentType == 3{
                                self.view.makeToast("Department Name Deactivated.",duration: 2, position: .center)
                            }
                            
                            
                        }
                    } catch{
                        self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure ")
                    self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                    
                }
            })
    }
    func createRequestForAppointment(userID:String,companyID:String,AuthCode:String , AppointStatusID:Int , startDate:String, EndDate:String , AppointTypeID:Int , languageID :String , userTypeID:String ,jobType : String , clientName:String , venueID: String , updatedOn:String , requestedON:String, loadedON:String , cpInitials:String ,serviceTypeID : String , genderID : String, userName : String ){
        SwiftLoader.show(animated: true)
        let urlString = APi.addAppointment.url
        var donotSend = ""
        if self.sendEndTimevar {
            donotSend = "true"
        }else {
            donotSend = "false"
        }
        
        let parameters = [
            "appointmentDetails": [
                "efale": true,
                "BookedByName": userName ,
                "CustomerUserID": userID,
                "UpdateUser": 0,
                "AppointmentID": 0,
                "AuthCode": AuthCode,
                "CompanyID": companyID,
                "CustomerID": userID,
                "ProviderID": self.providerID,
                "AppointmentStatusID": AppointStatusID,
                "overrideSatus": "0",
                "overrideauth": "",
                "UnicFlag": "Request",
                "cPIntials": cpInitials,
                "filecode": "",
                "InvoiceBit": false,
                "ConfirmationBit": false,
                "WaitingList": false,
                "StartDateTime": startDate,
                "EndDateTime": EndDate,
                "Priority": true,
                "Gender": genderID,
                "AppointmentTypeID": AppointTypeID,
                "Ranking": "",
                "ServiceType": serviceTypeID,
                "Duration": 0,
                "LanguageID": languageID,
                "userType": "Customer",//userTypeID,    // might be String or int
                "InterpreterID": "",
                "Location": "",
                "Text": "",
                "AppointmentMilage": "",
                "jobType": jobType,
                "ArrivalTime": "",
                "DepartureTime": "",
                "CallServiceBit": "false",
                "CallTime": "",
                "Purpose": "",
                "Home": "",
                "Office": "",
                "Cell": "",
                "VenueID": venueID,
                "CaseNumber": "",
                "ClientName": clientName,
                "OnsiteMilage": true,
                "Distance": "",
                "PeopleOnCall": "",
                "CallerNames": "",
                "InterpreterBookedId": "",
                "DepartmentID": self.departmentID,
                "AppoinmentvenueList": [],
                "ProjectDueDate": "",
                "ScheduleNotes": "",
                "AptDetails": "",
                "FinancialNotes": "",
                "TranslationType": "",
                "BookedBy": "",
                "ConfirmedBy": "",
                "RequestedBy": userID,
                "RequestedOn": requestedON,
                "CancelledBy": "",
                "CancelledOn": "",
                "LoadedBy": userID,
                "LoadedOn": loadedON,
                "AppointmentSubType": "",
                "AddedOn": "",
                "DeleteStatus": "",
                "ChangeStatus": "",
                "QBID": "",
                "QBEditID": "",
                "PublicPrivate": "",
                "SyncBit": "",
                "CSyncBit": "",
                "MessageID": "",
                "readyToSync": "",
                "CreadyToSync": "",
                "Active": true,
                "isChanged": true,
                "CustRequestID": 0,
                "CustrequestCode": "",
                "AdditionTravelTimePay": "",
                "UpdatedOn": updatedOn ,   //"11/02/2021 10:56:42O
                "UpdatedBy": userID,
                "PreviousStatus": "NOTBOOKED",
                "SendingEndTimes": donotSend,
                "MgemilRist": false,
                "oneHremail": "2"
            ]
        ] as [String:Any]
        print("url to create Appointment \(urlString),\(parameters)")
        AF.request(urlString, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success for create request ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiCreateAppointmentResponseModel = try jsonDecoder.decode(ApiCreateAppointmentResponseModel.self, from: daata)
                        let status = self.apiCreateAppointmentResponseModel?.appointments?.first?.success ?? 0
                        if status == 1 {
                            print("Success")
                            //self.view.makeToast("Address added successfuly.",duration: 2, position: .center)
                            
                            self.navigationController?.popViewController(animated: true)
                        }else {
                            let message = self.apiCreateAppointmentResponseModel?.appointments?.first?.fastTrackOrNot ?? ""
                            self.view.makeToast(message ,duration: 2, position: .center)
                        }
                    } catch{
                        self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure ")
                    self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                    
                }
            })
    }
    func addProviderData(Active:Bool , venueID: String ,providerName : String , DeActive:Bool , departmentID: String , providerID :Int){
        SwiftLoader.show(animated: true)
        let urlString = APi.addproviderData.url
        let parameters = [
            "ProviderDetails": [
                "ProviderName":providerName,
                "ProviderID":providerID,
                "VenueID":venueID,
                "DepartmentID":departmentID,
                "Active" : Active,
                "DeActive":DeActive
            ]
        ] as [String:Any]
        print("url to create Appointment \(urlString),\(parameters)")
        AF.request(urlString, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiAddProviderDataresponse = try jsonDecoder.decode(ApiAddProviderDataresponse.self, from: daata)
                        let status = self.apiAddProviderDataresponse?.providers?.first?.success ?? 0
                        if status == 2 {
                            print("Success")
                            self.view.makeToast("Contact Name Already Exist.",duration: 2, position: .center)
                        }else {
                            //reloadScreen()
                            self.contactNameTF.text = ""
                            self.contactNameLbl.text = ""
                            self.addContactView.visibility = .gone
                            //self.selectContactBtn.setTitle("", for: .normal)
                            if self.contactAction == 0 {
                                self.view.makeToast("Contact Name Added.",duration: 2, position: .center)
                            }else if self.contactAction == 1{
                                self.view.makeToast("Contact Name Updated.",duration: 2, position: .center)
                            }else {
                                self.view.makeToast("Contact Name Deleted.",duration: 2, position: .center)
                            }
                            
                            getVenuList()
                            
                        }
                    } catch{
                        self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure ")
                    self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                    
                }
            })
    }
    
}
extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}
extension String {
    mutating func add(prefix: String) {
        self = prefix + self
    }
}
