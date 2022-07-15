//
//  ScheduledOPIViewController.swift
//  TLClientApp
//
//  Created by Naiyer on 8/20/21.
//

import UIKit
import XLPagerTabStrip
import iOSDropDown
import Alamofire
class ScheduledOPIViewController: UIViewController, IndicatorInfoProvider, UITextFieldDelegate, MICountryPickerDelegate {
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
      print(code)
    }
    

    static func createWith(navigator: Navigator, storyboard: UIStoryboard) -> ScheduledOPIViewController {
        return storyboard.instantiateViewController(ofType: ScheduledOPIViewController.self).then { viewController in
            
        }
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo
        {
            
            return IndicatorInfo(title:"Scheduled OPI")
        }
    @IBOutlet weak var selectDateTimeTF: UITextField!
    @IBOutlet weak var selectVRIView: UIView!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var confirmationEmailTF: ACFloatingTextfield!
    @IBOutlet weak var lastNameTF: ACFloatingTextfield!
    
    @IBOutlet weak var firstNameTF: ACFloatingTextfield!
    @IBOutlet weak var trgtLngTF: iOSDropDown!
    
    @IBOutlet weak var trgtLngView: UIView!
    @IBOutlet weak var thirsParicipantsView: UIView!
    @IBOutlet weak var secoundParticipantsView: UIView!
    @IBOutlet weak var firstParticipantsView: UIView!
    @IBOutlet weak var srcLngTF: iOSDropDown!
    @IBOutlet weak var srcLngView: UIView!
    @IBOutlet weak var roomNoLbl: UILabel!
    
    @IBOutlet weak var thirdParticipantsTF: UITextField!
    @IBOutlet weak var secoundParticipantsTF: UITextField!
    @IBOutlet weak var firstParticipantsTF: UITextField!
    @IBOutlet weak var notesTF: GrowingTextView!
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var specialityTF: ACFloatingTextfield!
    @IBOutlet weak var patientClientNumberTF: ACFloatingTextfield!
    @IBOutlet weak var cPinitialsTF: ACFloatingTextfield!
    @IBOutlet weak var clientPatientName: ACFloatingTextfield!
    @IBOutlet weak var HrTxt: iOSDropDown!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var minTxt: iOSDropDown!
    var isFromAppointment = false
    var apmtID = ""
    var apiScheduleVRIMeetResponseModel:ApiScheduleVRIMeetResponseModel?
    var callManagerVM = CallManagerVM()
    var languageViewModel = LanguageVM()
    var picker = MICountryPicker()
    var bundle = "assets.bundle/"
    var roomId = "0"
    var DialCode = ""
    var showFisrtParticipants = true
    var showSecoundparticipants = false
    var showThirdParticipants = false
    var participantsList = [String]()
    var scheduleViewModel = ScheduleViewModel()
    var srcLngID = "0"
    var trgtLngID = "0"
    let hourArr = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    let minArr = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        // Do any additional setup after loading the view.
        clientPatientName.delegate = self
        HrTxt.optionArray = hourArr
       
        HrTxt.setLeftPaddingPoints(20)
        HrTxt.selectedRowColor = UIColor.clear
        HrTxt.didSelect{(selectedText , index , id) in
        self.HrTxt.text = "\(selectedText)"
        
        }
        minTxt.optionArray = minArr
        minTxt.setLeftPaddingPoints(20)
        minTxt.selectedRowColor = UIColor.clear
        minTxt.didSelect{(selectedText , index , id) in
        self.minTxt.text = "\(selectedText)"
        
        }
       self.selectDateTimeTF.text = CEnumClass.share.getcurrentdateAndTimeVRI()
        
        srcLngTF.optionArray = GetPublicData.sharedInstance.languageArray
        srcLngTF.selectedRowColor = UIColor.clear
        srcLngTF.didSelect{(selectedText , index , id) in
        self.srcLngTF.text = "\(selectedText)"
        GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
             print("language data \(languageData.languageName ?? "")")
              if selectedText == languageData.languageName ?? "" {
                 self.srcLngID = "\(languageData.languageID ?? 0)"
                print("languageId \(self.srcLngID)")
               }
            })
        }
        trgtLngTF.optionArray = GetPublicData.sharedInstance.languageArray
//              languageTF.checkMarkEnabled = true
        trgtLngTF.selectedRowColor = UIColor.clear
        trgtLngTF.didSelect{(selectedText , index , id) in
        self.trgtLngTF.text = "\(selectedText)"
        GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
             print("language data \(languageData.languageName ?? "")")
              if selectedText == languageData.languageName ?? "" {
                 self.trgtLngID = "\(languageData.languageID ?? 0)"
                print("languageId \(self.trgtLngID)")
               }
            })
        }
        SwiftLoader.show(animated: true)
        callManagerVM.getRoomList { roolist, error in
            if error == nil {
                self.roomId = roolist?[0].RoomNo ?? "0"
                let mainRoom = "Room No: \(self.roomId)"
                let range = (mainRoom as NSString).range(of: self.roomId)
                let mutableStr = NSMutableAttributedString.init(string: mainRoom)
                mutableStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
                self.roomNoLbl.attributedText = mutableStr
              
                SwiftLoader.hide()
                
            }
            
        }
       
      
        languageViewModel.languageData { list, err in
            if err == nil {
                SwiftLoader.hide()
               //
                self.srcLngTF.text = "English"
                //self.languageViewModel.titleToTxtField(row: 0, txtField: self.txtSourceLanguage)
                //
                
            }}
      
        
        
         updateUI()
        if isFromAppointment {
            getDataRedirectReload()
        }
        else {
            let image = UIImage( named: bundle + "us.png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
            tempImageView.image = image
            getDataReload()
        }
    }
    @IBAction func openCountryCodeAction(_ sender: Any) {
        picker.showCallingCodes = true
        picker.didSelectCountryClosure = { [self] name, code in
            picker.navigationController?.isNavigationBarHidden=true
            //picker.navigationController?.popViewController(animated: true)
            picker.dismiss(animated: true, completion: nil)
      }
        picker.didSelectCountryWithCallingCodeClosure = { [self] name , code , dialCode in
            self.picker.navigationController?.isNavigationBarHidden=true
            //picker.navigationController?.popViewController(animated: true)
            print("code is ",code)
          
            
            let image = UIImage( named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
          self.DialCode = "\(dialCode)"
            self.countryCodeTF.text = "\(dialCode)"//"Selected Country: \(name) , \(code)"
            self.tempImageView.image = image
            
        }
        self.present(picker, animated: true, completion: nil)
        }
        

    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == clientPatientName {

            let stringInput = textField.text?.trimmingCharacters(in: .whitespaces)
            let abc = stringInput ?? ""
            let stringInputArr = abc.components(separatedBy:" ")
            var stringNeed = ""
            let abcc:Character="C"
            for string in stringInputArr {
                stringNeed += String(string.first ?? abcc)
            }

            print(stringNeed)
            self.cPinitialsTF.text = stringNeed.uppercased()
        }
    }
    @IBAction func cancelThirsParticipants(_ sender: UIButton) {
        self.showThirdParticipants = false
        self.thirsParicipantsView.visibility = .gone
        self.thirdParticipantsTF.text = ""
        
    }
    @IBAction func cancelSecoundParticipants(_ sender: UIButton) {
        self.showSecoundparticipants = false
        self.secoundParticipantsView.visibility = .gone
        self.secoundParticipantsTF.text = ""
    }
    @IBAction func cancelFirstParticipants(_ sender: UIButton) {
        self.showFisrtParticipants = true
        self.firstParticipantsTF.text = ""
    }
    @IBAction func actionAddParticipants(_ sender: UIButton) {
        
        if (showFisrtParticipants == true) && (showSecoundparticipants == false) && (showThirdParticipants == false ){
            print("1 first participants \(showFisrtParticipants), \n scound participants \(showSecoundparticipants), \n third participants \(showThirdParticipants)")
            if  firstParticipantsTF.text == ""{
                self.thirsParicipantsView.visibility = .gone
                self.secoundParticipantsView.visibility = .gone
                self.firstParticipantsView.visibility = .visible
                self.view.makeToast("Please fill First Participants Name.",duration: 1, position: .center)
                return
                
            }else {
               
                    self.thirsParicipantsView.visibility = .gone
                    self.secoundParticipantsView.visibility = .visible
                    self.firstParticipantsView.visibility = .visible
                    showSecoundparticipants = true
                
                
            }
           
        }else if (showFisrtParticipants == true) && (showSecoundparticipants == true) && (showThirdParticipants == false ){
            print("2 first participants \(showFisrtParticipants), \n scound participants \(showSecoundparticipants), \n third participants \(showThirdParticipants)")
            if secoundParticipantsTF.text == "" {
                self.thirsParicipantsView.visibility = .gone
                self.secoundParticipantsView.visibility = .visible
                self.firstParticipantsView.visibility = .visible
                self.view.makeToast("Please fill Secound Participants Name.",duration: 1, position: .center)
                return
            }else {
                self.thirsParicipantsView.visibility = .visible
                self.secoundParticipantsView.visibility = .visible
                self.firstParticipantsView.visibility = .visible
                showThirdParticipants = true
            }
            
        }else if (showFisrtParticipants == true) && (showSecoundparticipants == false) && (showThirdParticipants == true ){
            print("3 first participants \(showFisrtParticipants), \n scound participants \(showSecoundparticipants), \n third participants \(showThirdParticipants)")
            if thirdParticipantsTF.text == "" {
                self.thirsParicipantsView.visibility = .visible
                self.secoundParticipantsView.visibility = .gone
                self.firstParticipantsView.visibility = .visible
                self.view.makeToast("Please fill Secound Participants Name.",duration: 1, position: .center)
                return
            }else {
                self.thirsParicipantsView.visibility = .visible
                self.secoundParticipantsView.visibility = .visible
                self.firstParticipantsView.visibility = .visible
                showSecoundparticipants = true
            }
        }
        
        
        
        
        
    }
    @IBAction func actionScheduleTapped(_ sender: UIButton) {
        if let firstParticipants = self.firstParticipantsTF.text , !firstParticipants.isEmpty {
            print("add first participants ")
            self.participantsList.append(firstParticipants)
        }
        if let secoundParticipants = self.secoundParticipantsTF.text , !secoundParticipants.isEmpty {
            print("add secound participants ")
            self.participantsList.append(secoundParticipants)
        }
        if let thirdParticipants = self.thirdParticipantsTF.text , !thirdParticipants.isEmpty {
            print("add third participants ")
            self.participantsList.append(thirdParticipants)
        }
        print("participants list ",participantsList)
        let selectedText = srcLngTF.text ?? ""
        let selectedText1 = trgtLngTF.text ?? ""
        GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
             print("language data \(languageData.languageName ?? "")")
              if selectedText1 == languageData.languageName ?? "" {
                 self.trgtLngID = "\(languageData.languageID ?? 0)"
                print("languageId \(self.trgtLngID)")
               }
        })
        GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
            print("language data \(languageData.languageName ?? "")")
            if selectedText == languageData.languageName ?? "" {
                self.srcLngID = "\(languageData.languageID ?? 0)"
                     print("languageId \(self.srcLngID)")
                 }
            })
        if self.selectDateTimeTF.text!.isEmpty {
            self.view.makeToast("Please fill Start Date.",duration: 1, position: .center)
            return
                    
        }else if self.firstNameTF.text!.isEmpty {
            
            self.view.makeToast("Please fill First Name.",duration: 1, position: .center)
            
            return
           
            
        }else if self.lastNameTF.text!.isEmpty {
           
            self.view.makeToast("Please fill Last Name.",duration: 1, position: .center)
            return
            
        }else if self.firstParticipantsTF.text!.isEmpty  {
            self.view.makeToast("Please fill Complete Participants Detail.",duration: 1, position: .center)
            return
            
        }else if self.confirmationEmailTF.text!.isEmpty  {
            self.view.makeToast("Please fill Email Address.",duration: 1, position: .center)
            return
            
        }else if self.clientPatientName.text!.isEmpty  {
            self.view.makeToast("Please fill Client/Patient Name.",duration: 1, position: .center)
            return
            
        }else {
            let firstName = self.firstNameTF.text ?? ""
            let lastName = self.lastNameTF.text ?? ""
            let date = self.selectDateTimeTF.text ?? ""
            let userID = GetPublicData.sharedInstance.userID
            let companyID = GetPublicData.sharedInstance.companyID
            let emailId = self.confirmationEmailTF.text ?? ""
            let countryCode = self.countryCodeTF.text ?? ""
            let mobileNo =  self.phoneNumberTF.text ?? ""
            let mobileWithCode = countryCode + mobileNo
            let cPIntial = self.cPinitialsTF.text ?? ""
            let hrTxt = self.HrTxt.text ?? ""
            let minTxt = self.minTxt.text ?? ""
            let anticipatedHr = "\(hrTxt):\(minTxt)"
            let clientNumber = self.patientClientNumberTF.text ?? ""
            let notes = self.notesTF.text ?? ""
            let caseName = self.clientPatientName.text ?? ""
            let speciality = self.specialityTF.text ?? ""
            hitApiScheduleVRIAppointment(firstName: firstName, lastName: lastName, date: date, time: date, userID: userID, companyID: companyID, active: true, LanguageID: self.trgtLngID, caseNumber: clientNumber, anticipatedHR: anticipatedHr, cPintials: cPIntial, srcLngID: self.srcLngID, mobileNo: mobileWithCode, emailID: emailId, participantsList: participantsList,notes: notes,caseName: caseName,speciality: speciality)
        }
    }
    @IBAction func selectDateAndTime(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .dateAndTime, minDate: Date(), maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
                        // TODO: Your implementation for date
                        self?.selectDateTimeTF.text = selectedDate.dateString("MM/dd/YYYY hh:mm a")
                         
                    })
    }
    func hitApiScheduleVRIAppointment(firstName : String,lastName : String,date : String,time : String,userID : String,companyID : String,active : Bool, LanguageID: String,caseNumber:String,anticipatedHR:String,cPintials : String, srcLngID : String,mobileNo:String,emailID:String,participantsList:[String],notes:String,caseName:String,speciality:String){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
        
        let urlString = APi.AddScheduleVRI.url
        let parameters = [
            "RequestType":"2",
            "UserType":"Customer",
            "LanguageID":LanguageID,//"1205",
            "DateTime":date,//"11/26/2021 03:59 pm",
            "id":"0",
            "createdby":userID,//"217888",
            "requestedby":userID,//"217888",
            "casename":caseName,//"test",
            "caseno":caseNumber,//"test",
            "anticipatedduration":anticipatedHR,//"6:5",
            "caseinitial":cPintials,//"t",
            "notes":notes,
            "status":2,
            "random":self.roomId,//"21112692",
            "sourcelanguageid":srcLngID,//"3",
            "firstname":firstName,//"leo",
            "lastname":lastName,//"m",
            "phno":mobileNo,//"",
            "confmail":emailID,//"marikanti2289@gmail.com",
            "speciality":speciality,
            "reasoncall":"",
            "vendorlist":0,
            "inviteparticipant":participantsList,//"marikanti2289",
            "ThirdPartyCompanyId":""
                                
                
            
        ] as [String:Any]
             print("url to create Meet Appointment \(urlString),\(parameters)")
                AF.request(urlString, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success  create Meet appointment ")
                            guard let daata84 = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiScheduleVRIMeetResponseModel = try jsonDecoder.decode(ApiScheduleVRIMeetResponseModel.self, from: daata84)
                                let status = self.apiScheduleVRIMeetResponseModel?.scheduleVRI?.first?.success ?? 0
                                if status == 3 {
                                    print("Success Meet Requset ")
                                     //self.view.makeToast("Address added successfuly.",duration: 2, position: .center)
                                    
                                    self.navigationController?.popViewController(animated: true)
                                }else {
                                    
                                    if let message = self.apiScheduleVRIMeetResponseModel?.scheduleVRI?.first?.fastTrackOrNot  {
                                        
                                         self.view.makeToast(message ,duration: 2, position: .center)
                                    }else {
                                        self.view.makeToast("Please try after sometime." ,duration: 2, position: .center)
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
                    })}
        else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
     }
    public func getDataRedirectReload(){
        SwiftLoader.show(animated: true)
        ///https://lsp.totallanguage.com/CustomerManagement/CustomerDetail/GetData?methodType=SCHEDULVRIDETAILSBYID&id=1340&userid=218905&Type=1
        let uID = GetPublicData.sharedInstance.userID
        let urlStr = scheduleURL + "\(apmtID)&userid=\(uID)&Type=2"
        scheduleViewModel.scheduleData(urlStr: urlStr) { [self] scheduleData, err in
            SwiftLoader.hide()
            let obj = scheduleData?.SCHEDULVRIDETAILSBYID?[0] as! ScheduleDataModel
            self.roomId = obj.Random
            let mainRoom = "Room No: \(self.roomId)"
            let range = (mainRoom as NSString).range(of: self.roomId)
            let mutableStr = NSMutableAttributedString.init(string: mainRoom)
            mutableStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
            self.roomNoLbl.attributedText = mutableStr
//            if let index = GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.firstIndex(where: {$0.languageID == Int(obj.SourceLanguageID)}) {
//                self.srcLngTF.text = GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData![index].languageName
//
//            }
            self.srcLngTF.text = obj.SLanguageName
            self.trgtLngTF.text = obj.TLanguageName
           
            firstNameTF.text = obj.FirstName
            lastNameTF.text = obj.LastName
            confirmationEmailTF.text = obj.ConfMail
            let sepratDuration = obj.AnticipatedDuration.split(separator: ":")
            HrTxt.text = "\(sepratDuration[0])"
            minTxt.text = "\(sepratDuration[1])"
            clientPatientName.text = obj.CaseName
            cPinitialsTF.text = obj.CaseInitial
            patientClientNumberTF.text = obj.CaseNo
            specialityTF.text = obj.Speciality
            notesTF.text = obj.Notes
            let phoneSeprate = obj.PhNo.split(separator: " ")
            if phoneSeprate.count > 1 {
                countryCodeTF.text = "\(phoneSeprate[0])"
                phoneNumberTF.text = "\(phoneSeprate[1])"
            }
            else {
                if phoneSeprate.count != 0 {
                    phoneNumberTF.text = "\(phoneSeprate[0])"
                }
            }
            
            
            //firstParticipantsTF.text = ""
          //  secoundParticipantsTF.text = ""
           // thirdParticipantsTF.text = ""
            self.firstParticipantsView.visibility = .visible
            self.secoundParticipantsView.visibility = .gone
            self.thirsParicipantsView.visibility = .gone
        }
        
        
    }
    public func getDataReload(){
        self.selectDateTimeTF.text = CEnumClass.share.getcurrentdateAndTimeVRI()
        SwiftLoader.show(animated: true)
        callManagerVM.getRoomList { roolist, error in
            if error == nil {
                
                self.roomId = roolist?[0].RoomNo ?? "0"
                let mainRoom = "Room No: \(self.roomId)"
                let range = (mainRoom as NSString).range(of: self.roomId)
                let mutableStr = NSMutableAttributedString.init(string: mainRoom)
                mutableStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
                self.roomNoLbl.attributedText = mutableStr
                
                SwiftLoader.hide()
                
            }}
        self.notesTF.placeholder = "Notes"
        self.secoundParticipantsView.visibility = .gone
        self.thirsParicipantsView.visibility = .gone
    }
    func updateUI(){
        self.srcLngView.layer.borderWidth = 0.6
        self.srcLngView.layer.cornerRadius = 10
        self.srcLngView.layer.borderColor = UIColor.lightGray.cgColor
        self.trgtLngView.layer.borderWidth = 0.6
        self.trgtLngView.layer.cornerRadius = 10
        self.trgtLngView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.phoneNumberView.layer.borderWidth = 0.6
        self.phoneNumberView.layer.cornerRadius = 10
        self.phoneNumberView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.selectVRIView.layer.borderWidth = 0.6
        self.selectVRIView.layer.cornerRadius = 10
        self.selectVRIView.layer.borderColor = UIColor.lightGray.cgColor
        self.HrTxt.layer.borderWidth = 0.6
        self.HrTxt.layer.cornerRadius = 10
        self.HrTxt.layer.borderColor = UIColor.lightGray.cgColor
        self.minTxt.layer.borderWidth = 0.6
        self.minTxt.layer.cornerRadius = 10
        self.minTxt.layer.borderColor = UIColor.lightGray.cgColor
        
        self.notesView.layer.borderWidth = 0.6
        self.notesView.layer.cornerRadius = 10
        self.notesView.layer.borderColor = UIColor.lightGray.cgColor
        
       // self.secoundParticipantsView.visibility = .gone
       // self.thirsParicipantsView.visibility = .gone
      //  self.notesTF.placeholder = "Notes"
        
        self.countryCodeTF.setLeftPaddingPoints(60)
        self.countryCodeTF.attributedPlaceholder = NSAttributedString(string: "+1", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        setFlagAndPhoneNumberCodeLeftViewIcon(icon: UIImage(named: "down button arrow")!)
    }
    func setFlagAndPhoneNumberCodeLeftViewIcon(icon: UIImage) {
        let btnView = UIButton(frame: CGRect(x: 0, y: 0, width: 6.32, height: 3.08))
        btnView.setImage(icon, for: .normal)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right:  10)
        self.countryCodeTF.rightViewMode = .always
        self.countryCodeTF.rightView = btnView
    }
}
