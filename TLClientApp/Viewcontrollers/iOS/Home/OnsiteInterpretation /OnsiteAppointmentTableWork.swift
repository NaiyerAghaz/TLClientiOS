//
//  OnsiteAppointmentTableWork.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 02/02/22.
//

import Foundation
import UIKit
import iOSDropDown
import Alamofire
protocol SaveBookedAppointmentData : AnyObject{
    func didSave(_ class: BlockedAppointmentTVCell, flag: Bool , AppointmentDate : String , index : Int, startTime : String ,EndTime : String,languageID: Int, GenderID : String, ClientName : String , clientIntials : String , clientRefrence : String , venueID : String , departmentID : Int , contactID : Int ,location: String , Notes: String  , isAppointmentDateSelect : Bool , isStartTimeSelect : Bool, isEndtimeSelect : Bool , languageName : String,venueName: String, DepartmentName: String, genderType: String, conatctName: String, isVenueSelect: Bool , venueTitleName : String , addressname : String , cityName : String , stateName : String , zipcode: String ,startTimeForPicker : Date ,endTimeForPicker : Date)
}
protocol ReloadBlockedTable : AnyObject {
    func didReloadTable(performTableReload : Bool )
    func didopenMoreoption(action : Bool , type : String )
  
    func showAlertWithMessageInTable(message: String)
}
class BlockedAppointmentTVCell : UITableViewCell , UITextFieldDelegate {
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
    @IBOutlet weak var languageTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    
    @IBOutlet weak var travelMileStackView: UIStackView!
    @IBOutlet weak var startTimebtn: UIButton!
    
    @IBOutlet weak var endTimeBtn: UIButton!
    @IBOutlet weak var endTimeTF: UITextField!
    @IBOutlet weak var startTimeTf: UITextField!
    
    var apiGetCustomerDetailResponseModel = [ApiGetCustomerDetailResponseModel]()
    
    var delegate : SaveBookedAppointmentData?
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
        self.languageTF.isUserInteractionEnabled = false
        self.contactUpdateView.visibility = .gone
        self.venueDetailView.visibility = .gone
        self.departmentDetailUpdate.visibility = .gone
        self.appointmentCancelBtn.isHidden = true
        self.activateDeactivateView.visibility = .gone
        self.travelMileStackView.visibility = .gone
        showLanguageDropDown()
        self.cancelImg.isHidden = true
        self.clientNameTF.delegate = self
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
            self.departmentNameTF.text = ""
        }else if actionType == "Deactivate"{
            self.depatmrntActionType = 3
        }
    }
    //MARK: - Text Field Delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
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
                    self.specialNotes = txt
               }else if textField == self.locationTF {
                    self.locationText = txt
               }else if textField == self.clientRefrenceTF {
                    self.Clientrefrence = txt
               }else if textField == self.clientIntiaalTF {
                      self.clientIntials = txt
               }else if textField == self.clientNameTF{
                      self.clientName = txt
                      self.clientIntials = self.clientIntiaalTF.text ?? ""
               }else if textField == self.locationTF{
                   self.locationText = txt
               }else if textField == self.specialNoteTf{
                   self.specialNotes = txt
              }
        
               print("----text is ", txt)
            //print("all value are ",self.firstName,self.lastName , self.emailID,self.mobileNum,self.countryCode)
       
            self.AppointmentDate = self.appointmentDateTF.text ?? ""
            self.startTime = self.startTimeTf.text ?? ""
            self.endTime = self.endTimeTF.text ?? ""
            self.venueName = self.selectVenueTF.text ?? ""
            self.departmentName = self.selectDepartmentTF.text ?? ""
            self.ConatctName = self.selectContactTF.text ?? ""
            self.genderName = self.genderTF.text ?? ""
            self.languageName = self.languageTF.text ?? ""
        
        
        delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: self.languageName,venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName,startTimeForPicker : Date() ,endTimeForPicker : Date())
    
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
                    self.isGenderSelect = true
                    self.delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: self.rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: self.languageName,venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName,startTimeForPicker : Date() ,endTimeForPicker : Date())
                }
            })
        }
        genderTF.selectedRowColor = UIColor.clear
        genderTF.didSelect{ [self](selectedText , index , id) in
            self.genderTF.text = "\(selectedText)"
            self.genderDetail.forEach({ languageData in
                print("language data \(languageData.Value )")
                if selectedText == languageData.Value {
                    self.genderID = languageData.Code 
                    //print("languageId \(self.genderID)")
                    self.genderName = languageData.Value
                    self.isGenderSelect = true
                    delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: self.languageName, venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName,startTimeForPicker : Date() ,endTimeForPicker : Date())
                }
            })
        }
        
        
        
        
        
    }
    func showLanguageDropDown(){
       /* self.languageTF.optionArray = GetPublicData.sharedInstance.languageArray
        print("OPTIONS ARRYA \(GetPublicData.sharedInstance.languageArray)")
        print("OPTIONS NEW ARRAY \(languageTF.optionArray)")
        languageTF.checkMarkEnabled = true
        languageTF.isSearchEnable = true
        languageTF.selectedRowColor = UIColor.clear
        languageTF.didSelect{(selectedText , index , id) in
            self.languageTF.text = "\(selectedText)"
            GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
              //  print("language data \(languageData.languageName ?? "")")
                if selectedText == languageData.languageName ?? "" {
                    self.languageName = selectedText
                    self.languageID = languageData.languageID ?? 0
                    print("languageId \(self.languageID)")
                    self.delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: self.rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: selectedText , venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName)
                }
            })
        }
        languageTF.listDidDisappear {
            GetPublicData.sharedInstance.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
              //  print("language data \(languageData.languageName ?? "")")
                if self.languageTF.text ?? "" == languageData.languageName ?? "" {
                    self.languageName = languageData.languageName ?? ""
                    self.languageID = languageData.languageID ?? 0
                    print("languageId \(self.languageID)")
                    self.delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: self.rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: self.languageTF.text ?? "",venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName)
                }
            })
        }*/
      
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
        
        selectVenueTF.optionArray = self.venueArray
        print("OPTIONS NEW ARRAY \(selectVenueTF.optionArray)")
        selectVenueTF.checkMarkEnabled = true
        selectVenueTF.isSearchEnable = true
        selectVenueTF.selectedRowColor = UIColor.clear
        selectVenueTF.didSelect{(selectedText , index , id) in
           self.venueDetailView.visibility = .visible
           
            self.selectVenueTF.text = "\(selectedText)"
            self.selectedVenue = "\(selectedText)"
            self.venueDetail.forEach({ languageData in
                self.tableDelegate?.didReloadTable(performTableReload: true)
                print("selected Venue name  \(languageData.VenueName ?? "")")
                print("department name  \(self.departmentName)")
                print("conatact name  \(self.ConatctName)")
                print("venue name  \(self.venueName)")
                if selectedText == languageData.VenueName ?? "N/A" {
                    self.venueID = "\(languageData.VenueID ?? 0)"
                    self.venueTitleName = languageData.VenueName ?? "N/A"
                    self.addressName = languageData.Address ?? "N/A"
                    self.stateName = languageData.State ?? "N/A"
                    self.cityName = languageData.City ?? "N/A"
                    self.zipcodeName = "\(languageData.ZipCode ?? "N/A")"
                    self.venueNameLbl.text = languageData.VenueName ?? "N/A"
                    self.venueName = languageData.VenueName ?? "N/A"
                   
                    self.isVenueSelect = true
                    
                    print("selected venue ",languageData)
                    
                    self.delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: self.rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: self.languageName,venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName,startTimeForPicker : Date() ,endTimeForPicker : Date())
                }
            })
        }
        
        
        
        oneTimeDepartmentArr.forEach { oneTimeDepart in
            self.departmentDetail.append(oneTimeDepart)
            self.departmentArray.append(oneTimeDepart.DepartmentName ?? "")
        }
        selectDepartmentTF.optionArray = self.departmentArray
        print("OPTIONS NEW ARRAY \(selectDepartmentTF.optionArray)")
        selectDepartmentTF.checkMarkEnabled = true
        selectDepartmentTF.isSearchEnable = true
        selectDepartmentTF.selectedRowColor = UIColor.clear
        selectDepartmentTF.didSelect{(selectedText , index , id) in
            //self.departmentNameTF.text = "\(selectedText)"
           // self.editDepartmentNameTF.text = "\(selectedText)"
            self.selectedDepartment = "\(selectedText)"
            self.departmentDetailUpdate.visibility = .gone
            self.tableDelegate?.didReloadTable(performTableReload: true)
            self.departmentDetail.forEach({ languageData in
                print("language data \(languageData.DepartmentName ?? "")")
                if selectedText == languageData.DepartmentName ?? "" {
                    self.departmentID = languageData.DepartmentID ?? 0
                    print("department name  \(self.departmentName)")
                    print("conatact name  \(self.ConatctName)")
                    print("venue name  \(self.venueName)")
                    //self.isDepartmentSelect = true
                    self.departmentName = selectedText
                    self.delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: self.rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: self.languageName,venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName,startTimeForPicker : Date() ,endTimeForPicker : Date())
                }
            })
        }
        
        
        oneTimeContactArr.forEach { oneTimeDepart in
            self.providerDetail.append(oneTimeDepart)
            self.providerArray.append(oneTimeDepart.ProviderName ?? "")
        }
        
        selectContactTF.optionArray = self.providerArray
        print("OPTIONS NEW ARRAY \(selectContactTF.optionArray)")
        selectContactTF.checkMarkEnabled = true
        selectContactTF.isSearchEnable = true
        selectContactTF.selectedRowColor = UIColor.clear
        selectContactTF.didSelect{(selectedText , index , id) in
            self.selectedContact = "\(selectedText)"
           // self.contactNameTF.text = "\(selectedText)"
            //self.editContactNameTF.text = "\(selectedText)"
            self.contactUpdateView.visibility = .gone
            self.tableDelegate?.didReloadTable(performTableReload: true)
            self.providerDetail.forEach({ languageData in
                print("language data \(languageData.ProviderName ?? "")")
                print("department name  \(self.departmentName)")
                print("conatact name  \(self.ConatctName)")
                print("venue name  \(self.venueName)")
                if selectedText == languageData.ProviderName ?? "" {
                    self.providerID = languageData.ProviderID ?? 0
                    print("languageId \(self.providerID)")
                    //self.isProviderSelect = true
                    self.ConatctName = selectedText
                    self.delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: self.rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: self.languageName,venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName,startTimeForPicker : Date() ,endTimeForPicker : Date())
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
                                    delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: self.languageName,venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName,startTimeForPicker : Date() ,endTimeForPicker : Date())
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
        tableDelegate?.didopenMoreoption(action: true, type: "Contact")
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
        tableDelegate?.didopenMoreoption(action: true, type: "Department")
        
    }
}
    
//MARK: - Onsite Table Work

extension OnsiteInterpretationNewViewController : UITableViewDelegate , UITableViewDataSource , SaveBookedAppointmentData  , ReloadBlockedTable{
    

    func showAlertWithMessageInTable(message: String) {
        self.showAlertwithmessage(message: message)
    }
    
    
     
    func didopenMoreoption(action : Bool , type : String) {
        self.isFromTableCell = true 
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
    
    
    func didSave(_ class: BlockedAppointmentTVCell, flag: Bool, AppointmentDate: String, index: Int, startTime: String, EndTime: String, languageID: Int, GenderID: String, ClientName: String, clientIntials: String, clientRefrence: String, venueID: String, departmentID: Int, contactID: Int, location: String, Notes: String, isAppointmentDateSelect: Bool, isStartTimeSelect: Bool, isEndtimeSelect: Bool , languageName: String ,venueName: String, DepartmentName: String, genderType: String, conatctName: String, isVenueSelect: Bool,venueTitleName: String, addressname: String, cityName: String, stateName: String, zipcode: String,startTimeForPicker: Date , endTimeForPicker: Date) {
    
        print("Delegate  working \(languageID)")
//        if AppointmentDate != "" && startTime != "" && EndTime != "" && languageID != 0  && venueID != ""  {
//        }else {
//
//           print("ENTERED ANSWER IS \(AppointmentDate)" , startTime,EndTime,languageID , GenderID , ClientName , clientIntials , clientRefrence , venueID, departmentID , contactID , location , Notes , isAppointmentDateSelect , isStartTimeSelect)
//
//           print("fill complete detail.")
//       }
            
            print("DATA IS THERE \(languageID)")
            
          
        let BookedAppoinmentData = BlockedAppointmentData(AppointmentDate: AppointmentDate, startTime: startTime, endTime: EndTime, languageID: languageID, genderID: GenderID, clientName: ClientName, ClientIntials: clientIntials, ClientRefrence: clientRefrence, venueID: venueID, DepartmentID: departmentID, contactID: contactID, location: location, SpecialNotes: Notes, rowIndex: index, languageName: languageName,venueName: venueName, DepartmentName: DepartmentName, genderType: genderType, conatctName: conatctName, isVenueSelect: isVenueSelect,venueTitleName: venueTitleName, addressname: addressname, cityName: cityName, stateName: stateName, zipcode: zipcode,startTimeForPicker: Date() , endTimeForPicker: Date())
            
                print("booked languageID Data \(BookedAppoinmentData.languageID ?? 0)")
                print("booked Appointment Data \(BookedAppoinmentData.AppointmentDate ?? "")")
                print("booked startTime Data \(BookedAppoinmentData.startTime ?? "")")
                print("booked ClientIntials Data \(BookedAppoinmentData.ClientIntials ?? "")")
                print("booked venueID Data \(BookedAppoinmentData.venueName ?? "")")
                print("booked DepartmentName Data \(BookedAppoinmentData.DepartmentName ?? "")")
                print("booked conatctName Data \(BookedAppoinmentData.conatctName ?? "")")
            
            if self.blockedAppointmentArr.count == 0 {
                self.blockedAppointmentArr.append(BookedAppoinmentData)
            }else {
                
                if  self.blockedAppointmentArr.contains(where: {$0.rowIndex == BookedAppoinmentData.rowIndex}) {
                    //found
                    print("found")
                    for itemm in self.blockedAppointmentArr {
                        if itemm.rowIndex == BookedAppoinmentData.rowIndex {
                            itemm.startTime = BookedAppoinmentData.startTime
                            itemm.endTime = BookedAppoinmentData.endTime
                            itemm.AppointmentDate = BookedAppoinmentData.AppointmentDate
                            itemm.languageID = BookedAppoinmentData.languageID
                            itemm.languageName = BookedAppoinmentData.languageName
                            itemm.genderID = BookedAppoinmentData.genderID
                            itemm.clientName = BookedAppoinmentData.clientName
                            itemm.ClientIntials = BookedAppoinmentData.ClientIntials
                            itemm.ClientRefrence = BookedAppoinmentData.ClientRefrence
                            itemm.venueID = BookedAppoinmentData.venueID
                            itemm.DepartmentID = BookedAppoinmentData.DepartmentID
                            itemm.contactID = BookedAppoinmentData.contactID
                            itemm.location = BookedAppoinmentData.location
                            itemm.SpecialNotes = BookedAppoinmentData.SpecialNotes
                            itemm.venueName = BookedAppoinmentData.venueName
                            itemm.DepartmentName = BookedAppoinmentData.DepartmentName
                            itemm.conatctName = BookedAppoinmentData.conatctName
                            itemm.genderType = BookedAppoinmentData.genderType
                            itemm.isVenueSelect = BookedAppoinmentData.isVenueSelect
                            itemm.venueTitleName = BookedAppoinmentData.venueTitleName
                            itemm.addressname = BookedAppoinmentData.addressname
                            itemm.cityName = BookedAppoinmentData.cityName
                            itemm.stateName = BookedAppoinmentData.stateName
                            itemm.zipcode = BookedAppoinmentData.zipcode
                        }
                    }

                    
                    
                }else {
                    // not found
                    self.blockedAppointmentArr.append(BookedAppoinmentData)
                }

            }
                  
            blockedAppointmentArr.forEach { BlockedAppointmentData in
                hitApiEncryptValue(value: BlockedAppointmentData.clientName ?? "") { completionc, encrptValue in
                    if completionc ?? false {
                        BlockedAppointmentData.clientName = encrptValue
                        print("encryptedValue ",BlockedAppointmentData.ClientRefrence  )
                    }
                }
                hitApiEncryptValue(value: BlockedAppointmentData.ClientIntials ?? "") { completionc, encrptValue in
                    if completionc ?? false {
                        BlockedAppointmentData.ClientIntials = encrptValue
                        print("encryptedValue ",BlockedAppointmentData.ClientRefrence  )
                    }
                }
                hitApiEncryptValue(value: BlockedAppointmentData.ClientRefrence ?? "") { completionc, encrptValue in
                    if completionc ?? false {
                        BlockedAppointmentData.ClientRefrence = encrptValue
                        print("encryptedValue ",BlockedAppointmentData.ClientRefrence  )
                    }
                }
            }
              
                
                
        
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
        cell.appointmentCancelBtn.tag = indexPath.row
        cell.appointmentCancelBtn.addTarget(self, action: #selector(CancelApt), for: .touchUpInside)
        if indexPath.row == 0 {
            cell.cancelImg.isHidden = true
            cell.appointmentCancelBtn.isHidden = true
        }else {
            cell.cancelImg.isHidden = false
            cell.appointmentCancelBtn.isHidden = false
        }
        cell.appointmentDateBtn.tag = indexPath.row
        cell.appointmentDateBtn.addTarget(self, action: #selector(showAppointmentDate), for: .touchUpInside)
        
        cell.startTimebtn.tag = indexPath.row
        cell.startTimebtn.addTarget(self, action: #selector(showStartTime), for: .touchUpInside)
        
        cell.endTimeBtn.tag = indexPath.row
        cell.endTimeBtn.addTarget(self, action: #selector(showEndTime), for: .touchUpInside)
        
        
        cell.rowIndex = indexPath.row
        cell.delegate = self
        cell.tableDelegate = self
        cell.addvenueBtn.tag = indexPath.row
        cell.addvenueBtn.addTarget(self, action: #selector(actionAddVenueBtn), for: .touchUpInside)
        
        let aptNumber = indexPath.row + 1
        cell.AppointmentTitleLbl.text = "Appointment \(aptNumber)"
        
        let BlockedData = self.blockedAppointmentArr[indexPath.row]
        
        cell.appointmentDateTF.text = BlockedData.AppointmentDate
        cell.startTimeTf.text = BlockedData.startTime
        cell.endTimeTF.text = BlockedData.endTime
        cell.languageTF.text = self.BlockedLanguage//BlockedData.languageName
        cell.genderTF.text = BlockedData.genderType
        cell.clientNameTF.text = BlockedData.clientName
        cell.clientIntiaalTF.text = BlockedData.ClientIntials
        cell.clientRefrenceTF.text = BlockedData.ClientRefrence
        print("venue name \(BlockedData.venueName)")
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
        
        
        if BlockedData.venueName != "" {
            cell.venueDetailView.visibility = .visible
        }else {
            cell.venueDetailView.visibility = .gone
        }
        
        
        
        
        return cell
        
    }
    @objc func actionAddVenueBtn(sender : UIButton){
        let vc = storyboard?.instantiateViewController(identifier: "AddNewVenueViewController") as! AddNewVenueViewController
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        
    }
    @objc func showAppointmentDate(sender : UIButton){
        //textfield.endEditing(true)
        let cell = blockedAppointmentTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BlockedAppointmentTVCell
        
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
        let cell = blockedAppointmentTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BlockedAppointmentTVCell
        let minDate = Date().dateByAddingYears(-5)
        RPicker.selectDate(title: "Select Start Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectedDateforPicker, minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.selectedStartTimeForPicker = selectedDate
            self?.selectedEndTimeForPicker = selectedDate.adding(minutes: 120)
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            let endTimee = roundoff.adding(minutes: 120)
            self?.blockedAppointmentArr[sender.tag].startTimeForPicker = selectedDate
            
            
            
            let startBookedTime = self?.blockedAptStartTimeTF.text ?? ""
            let startcellBookedTime = roundoff.dateString("hh:mm a")
            print("selected time \(startcellBookedTime), but blocked time \(startBookedTime)")
            
            let startmainTime = self?.timeConversion24(time12: startBookedTime)
            let startCellTime = self?.timeConversion24(time12: startcellBookedTime)
            
            
            //if startcellBookedTime < startBookedTime {
            if (startCellTime ?? "") < (startmainTime ?? "") {
                print("time should not exceed")
               self?.view.makeToast("Your appointment start time cannot be lesser the overall appointment's start time. Please adjust the overall appointment start time accordingly.",duration : 3.0 , position : .center)
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
       
        let cell = blockedAppointmentTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BlockedAppointmentTVCell
        let selectedDateforPicker = self.blockedAppointmentArr[sender.tag].endTimeForPicker ?? Date()
        let minDate = Date().dateByAddingYears(-5)
        RPicker.selectDate(title: "Select End Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectedDateforPicker,minDate: minDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.selectedEndTimeForPicker = selectedDate
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
           
            
            
            let startBookedTime = self?.blockedEndTimeTF.text ?? ""
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
                self?.view.makeToast("Your last appointment end time cannot exceed the overall appointment end time. Please adjust the overall appointment end time accordingly." , duration : 2.0 , position : .center)
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


class BlockedAppointmentData {
    
    var AppointmentDate : String?
    var  startTime : String?
    var endTime : String?
    var languageID : Int?
    var genderID : String?
    var clientName : String?
    var ClientIntials : String?
    var ClientRefrence : String?
    var venueID : String?
    var DepartmentID :Int?
    var contactID : Int?
    var location : String?
    var SpecialNotes : String?
    var rowIndex : Int?
    var languageName : String?
    var venueName : String?
    var DepartmentName : String?
    var genderType: String?
    var conatctName: String?
    var isVenueSelect : Bool?
    var venueTitleName: String?
    var addressname: String?
    var cityName: String?
    var stateName: String?
    var zipcode: String?
    var startTimeForPicker : Date?
    var endTimeForPicker : Date?
    
    
    
    
    init (AppointmentDate : String ,startTime : String, endTime : String, languageID : Int, genderID : String , clientName : String , ClientIntials : String , ClientRefrence : String , venueID : String , DepartmentID :Int, contactID : Int, location : String , SpecialNotes : String, rowIndex : Int , languageName : String,venueName : String,DepartmentName : String,genderType: String,conatctName: String, isVenueSelect: Bool,venueTitleName: String, addressname: String, cityName: String, stateName: String, zipcode: String,startTimeForPicker :Date,endTimeForPicker : Date) {
        self.AppointmentDate = AppointmentDate
        self.startTime = startTime
        self.endTime = endTime
        self.languageID = languageID
        self.genderID = genderID
        self.clientName = clientName
        self.ClientIntials = ClientIntials
        self.ClientRefrence = ClientRefrence
        self.venueID = venueID
        self.DepartmentID = DepartmentID
        self.contactID = contactID
        self.location = location
        self.SpecialNotes = SpecialNotes
        self.rowIndex = rowIndex
        self.languageName = languageName
        self.venueName = venueName
        self.DepartmentName = DepartmentName
        self.conatctName = conatctName
        self.genderType = genderType
        self.isVenueSelect = isVenueSelect
        self.venueTitleName = venueName
        self.addressname = addressname
        self.cityName = cityName
        self.stateName = stateName
        self.zipcode = zipcode
        self.startTimeForPicker = startTimeForPicker
        self.endTimeForPicker = endTimeForPicker
    }
}
