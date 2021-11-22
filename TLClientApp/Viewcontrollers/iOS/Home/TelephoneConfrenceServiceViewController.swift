//
//  TelephoneConfrenceServiceViewController.swift
//  TLClientApp
//
//  Created by Mac on 29/10/21.
//

import UIKit
import DropDown
import  Alamofire
import iOSDropDown
class TelephoneConfrenceServiceViewController: UIViewController, UITextFieldDelegate {
    
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
    @IBOutlet var contactNameLbl: UILabel!
    @IBOutlet var addContactView: UIView!
    @IBOutlet var venueNameLbl: UILabel!
    @IBOutlet var addressNameLbl: UILabel!
   
    var apiGetAuthCoderesponseModel:ApiGetAuthCoderesponseModel?
    var apiGetSpecialityDataModel :ApiGetSpecialityDataModel?
    var apiGetAllVenueDataResponseModel:ApiGetAllVenueDataResponseModel?
    @IBOutlet var languageTF: iOSDropDown!
    var apiCreateAppointmentResponseModel:ApiCreateAppointmentResponseModel?
    var apiAddProviderDataresponse:ApiAddProviderDataresponse?
     
    var venueID = "0"
    var languageID = "0"
    var dropDown = DropDown()
    var contactArray:[String] = []
    var venueArray:[String] = []
    var genderArray:[String] = []
    var specialityArray:[String] = []
    var jobType = ""
    var providerID = "0"
    var appointTypeId = 1
     var appointStatusID = 0
    var authCode = ""
    var genderId = ""
    var serviceId = ""
    var contactAction = 0
    var selectedContact = ""
    var departmentID = "0"
    var venueIDForContact = "0"
    var sendEndTimevar = false
    override func viewDidLoad() {
        super.viewDidLoad()
        getAuthCode()
       getServiceType()
   self.sendEndTimeSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.70)
   //self.btnDeactivate.layer.borderColor = UIColor(hexString: "33A5FF").cgColor
   //self.btnDeactivate.layer.borderWidth = 0.6
   self.sendEndTimeSwitch.isOn = false
   self.sendEndTimeSwitch.addTarget(self, action: #selector(sendEndTime), for: .valueChanged)
   //self.languageTF.delegate = self
   self.clientNameTf.delegate = self
   //self.addDepartMentView.visibility = .gone
   self.addContactView.visibility = .gone
   //self.venueAddressMainView.visibility = .gone
   getVenuList()
   self.erviceTypebtn.setTitle("Select Service Type", for: .normal)
   GetPublicData.sharedInstance.getAllLanguage()
   self.userNameLbl.text = GetPublicData.sharedInstance.usenName
   self.companyNameLbl.text = GetPublicData.sharedInstance.companyName
   
   let dateFormatter = DateFormatter()
   dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
   let startDate =  dateFormatter.string(from: Date())
  self.requestONTF.text = startDate
   self.loadedONTF.text = startDate
   languageTF.optionArray = GetPublicData.sharedInstance.languageArray
   languageTF.checkMarkEnabled = true
        
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
   // Do any additional setup after loading the view.
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
            let selectedText = languageTF.text ?? ""
            GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
              print("language data \(languageData.languageName ?? "")")
               if selectedText == languageData.languageName ?? "" {
                       self.languageID = "\(languageData.languageID ?? 0)"
                      print("languageId \(self.languageID)")
                }
            })
        }
        
    }
    
    
    @IBAction func selectContact(_ sender: UIButton) {
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
    @IBAction func addActualConatct(_ sender: UIButton) {
        if contactAction == 0 {
            // add department
            if  contactNameTF.text == ""{
                self.view.makeToast("Please add Contact Name. ")
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
        self.contactNameTF.text = self.selectedContact
        if  contactNameTF.text == ""{
            self.view.makeToast("Please add Contact Name. ")
        }else {
            let departmentName = contactNameTF.text ?? ""
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
    @IBAction func actionEndDate(_ sender: UIButton) {
        let minDate = Date().adding(minutes: 120)
         RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .dateAndTime, minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
                         // TODO: Your implementation for date
                         self?.endDateTF.text = selectedDate.dateString("MM/dd/YYYY hh:mm a")
                     })
    }
    @IBAction func actionStartDate(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .dateAndTime, minDate: Date(), maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
                        // TODO: Your implementation for date
                        self?.startDateTF.text = selectedDate.dateString("MM/dd/YYYY hh:mm a")
                    })
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
                            self?.genderId = "\(typeData.id ?? 0)"
                        }
                    })
           }
    }
    
    @IBAction func actionProcessingDetailCalender(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .dateAndTime, minDate: Date(), maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
                        // TODO: Your implementation for date
            let selectedDate  = selectedDate.dateString("MM/dd/YYYY hh:mm a")
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
        let startDate = self.startDateTF.text ?? ""
        let endDate = self.endDateTF.text ?? ""
        let cpIntial = self.clientInitialTF.text ?? ""
        let requestedOn = self.requestONTF.text ?? ""
        let loadedOn = self.loadedONTF.text ?? ""
        let updatedOn = self.requestONTF.text ?? ""
        self.jobType = "Telephone Conference"
        if self.startDateTF.text!.isEmpty {
                    self.view.makeToast("Please fill Start Date.",duration: 1, position: .center)
                    
        }else if self.endDateTF.text!.isEmpty {
            self.view.makeToast("Please fill End Date.",duration: 1, position: .center)
            
        }else if self.languageID == "0" {
            self.view.makeToast("Please Select Language",duration: 1, position: .center)
            
        }else {
            self.createRequestForAppointment(userID: userId, companyID: companyID, AuthCode: authCode, AppointStatusID: appointStatusID, startDate: startDate, EndDate: endDate, AppointTypeID: appointTypeId, languageID: languageID, userTypeID: userTypeID, jobType: jobType, clientName: clientName, venueID: self.venueID, updatedOn: updatedOn, requestedON: requestedOn, loadedON: loadedOn, cpInitials: cpIntial, serviceTypeID: serviceId, genderID: genderId, userName: userName)
        }
    }
    
    func getAuthCode(){
        SwiftLoader.show(animated: true)
        genderArray.removeAll()
        //   https://lsp.totallanguage.com/Appointment/GetData?methodType=AuthenticationCode&UserID=219490&UserType=Customer&CompanyID=55
             let userId = userDefaults.string(forKey: "userId") ?? ""
              let companyId = userDefaults.string(forKey: "companyID") ?? ""
            let userTypeID = userDefaults.string(forKey: "userTypeID") ?? ""
            let urlPostFix = "UserID=\(userId)&UserType=\(userTypeID)&CompanyID=\(companyId)"
        
            let urlString = "\(APi.getAuthCode.url)" + urlPostFix
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
                                    if type == "TELEPHONE" {
                                        self.appointTypeId = typeData.id ?? 0
                                    }
                                })
                                
                                self.authCodeLbl.text = apiGetAuthCoderesponseModel?.authenticationCode?.first?.authCode ?? ""
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
                                self.erviceTypebtn.setTitle(btnTitle, for: .normal)
                                self.apiGetSpecialityDataModel?.speciality?.forEach({ genderData in
                                    let title = genderData.displayValue ?? ""
                                    self.specialityArray.append(title)
                                })
                                
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
        //self.departmentArray.removeAll()
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
                                     // self.departmentArray.append(venueString)
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
    func createRequestForAppointment(userID:String,companyID:String,AuthCode:String , AppointStatusID:Int , startDate:String, EndDate:String , AppointTypeID:Int , languageID :String , userTypeID:String ,jobType : String , clientName:String , venueID: String , updatedOn:String , requestedON:String, loadedON:String , cpInitials:String ,serviceTypeID : String , genderID : String, userName : String ){
        SwiftLoader.show(animated: true)
        let urlString = APi.addAppointment.url
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
               "ProviderID": "0",
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
               "userType": userTypeID,    // might be String or int
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
               "DepartmentID": "0",
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
               "SendingEndTimes": "false",
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
                            print("Respose Success  create appointment ")
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
                                     self.view.makeToast("Provider Name Already Exist.",duration: 2, position: .center)
                                }else {
                                    //reloadScreen()
                                    self.contactNameTF.text = ""
                                    self.contactNameLbl.text = ""
                                    self.addContactView.visibility = .gone
                                    //self.selectContactBtn.setTitle("", for: .normal)
                                    self.view.makeToast("Provider Name Saved",duration: 2, position: .center)
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
