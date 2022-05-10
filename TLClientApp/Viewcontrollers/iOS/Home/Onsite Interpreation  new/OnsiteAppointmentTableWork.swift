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
import DropDown
protocol SaveBookedAppointmentData : AnyObject{
    func didSave(_ class: BlockedAppointmentTVCell, flag: Bool , AppointmentDate : String , index : Int, startTime : String ,EndTime : String,languageID: Int, GenderID : String, ClientName : String , clientIntials : String , clientRefrence : String , venueID : String , departmentID : Int , contactID : Int ,location: String , Notes: String  , isAppointmentDateSelect : Bool , isStartTimeSelect : Bool, isEndtimeSelect : Bool , languageName : String,venueName: String, DepartmentName: String, genderType: String, conatctName: String, isVenueSelect: Bool , venueTitleName : String , addressname : String , cityName : String , stateName : String , zipcode: String ,startTimeForPicker : Date ,endTimeForPicker : Date,              isproviderSelect :Bool, isDepartmentSlecet : Bool, isLanguageSelect : Bool,isgenderSelect : Bool,isCleintNameEnterd : Bool ,isClientRefrenceEnyterd : Bool, IsNotesEntered : Bool , isLocationEneterd : Bool, isvenueFlag : Bool)
}
protocol TelephonicSaveBookedAppointmentData : AnyObject {
    func didSave(_ class: TelephonicAppointmentTVCell, flag: Bool , AppointmentDate : String , index : Int, startTime : String ,EndTime : String,languageID: Int, GenderID : String, ClientName : String , clientIntials : String , clientRefrence : String , venueID : String , departmentID : Int , contactID : Int ,location: String , Notes: String  , isAppointmentDateSelect : Bool , isStartTimeSelect : Bool, isEndtimeSelect : Bool , languageName : String,venueName: String, DepartmentName: String, genderType: String, conatctName: String, isVenueSelect: Bool , venueTitleName : String , addressname : String , cityName : String , stateName : String , zipcode: String ,startTimeForPicker : Date ,endTimeForPicker : Date,              isproviderSelect :Bool, isDepartmentSlecet : Bool, isLanguageSelect : Bool,isgenderSelect : Bool,isCleintNameEnterd : Bool ,isClientRefrenceEnyterd : Bool, IsNotesEntered : Bool , isLocationEneterd : Bool, isvenueFlag : Bool)
}
protocol ReloadBlockedTable : AnyObject {
    func didReloadTable(performTableReload : Bool ,elemntID: Int, isConatctUpdate : Bool)
    func didopenMoreoption(action : Bool , type : String )
    func updateOneTimeDepartment(departmentData : DepartmentData , isDelete : Bool)
    func updateOneTimeConatct(ConatctData : ProviderData, isDelete : Bool)
    func showAlertWithMessageInTable(message: String)
    func bookedAppointment()
}
class BlockedAppointmentTVCell : UITableViewCell , UITextFieldDelegate {
    
    
    @IBOutlet weak var addContactStackView: UIStackView!
    @IBOutlet weak var addDepartmentStackView: UIStackView!
    @IBOutlet weak var cancelImg: UIImageView!
    let dropDown = DropDown()
    @IBOutlet weak var AppointmentTitleLbl: UILabel!
    @IBOutlet weak var contactUpdateView: UIView!
    @IBOutlet weak var venueDetailView: UIView!
    @IBOutlet weak var departmentDetailUpdate: UIView!
    
    @IBOutlet weak var actionContactDropdown: UIButton!
    @IBOutlet weak var actionDepartmentDropDown: UIButton!
    @IBOutlet weak var actionVenueDropDown: UIButton!
    @IBOutlet weak var clientRefrenceTF: UITextField!
    @IBOutlet weak var appointmentDateTF: UITextField!
    @IBOutlet weak var appointmentDateBtn: UIButton!
    @IBOutlet weak var addOneTimeVenueBtn: UIButton!
    
    @IBOutlet weak var specialNoteTf: UITextField!
    @IBOutlet weak var selectContactTF: iOSDropDown!
    @IBOutlet weak var contactNameTF: UITextField!
    @IBOutlet weak var departmentNameTF: UITextField!
    @IBOutlet weak var activateDeactivateView: UIView!
    
    
    @IBOutlet weak var appointmentCancelBtn: UIButton!
    
    
    @IBOutlet weak var showContactMoreOptionbtn: UIButton!
   
    @IBOutlet weak var addContactBtn: UIButton!
    
    @IBOutlet weak var clearContactBtn: UIButton!
    @IBOutlet weak var addActualContactBtn: UIButton!
   
    @IBOutlet weak var addActualDepartmentbtn: UIButton!
    @IBOutlet weak var clearDepartmentBtn: UIButton!
   
    @IBOutlet weak var actionShowmoreDepartmentOption: UIButton!
    @IBOutlet weak var actionAddDepartMent: UIButton!
    
    
    @IBOutlet weak var addvenueBtn: UIButton!
    
    
    
    
    
    @IBOutlet weak var selectDepartmentTF: iOSDropDown!
    @IBOutlet weak var zipcodeLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var citynameLbl: UILabel!
    @IBOutlet weak var addressnameLbl: UILabel!
    @IBOutlet weak var venueNameLbl: UILabel!
   
    @IBOutlet weak var selectVenueTF: iOSDropDown!
    @IBOutlet weak var clientIntiaalTF: UITextField!
    @IBOutlet weak var clientNameTF: UITextField!
    @IBOutlet weak var genderTF: iOSDropDown!
    @IBOutlet weak var languageTF: iOSDropDown!
    @IBOutlet weak var locationTF: UITextField!
    
    @IBOutlet weak var travelMileStackView: UIStackView!
    @IBOutlet weak var startTimebtn: UIButton!
    @IBOutlet weak var genderDropDownBtn: UIButton!
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
       // self.languageTF.isUserInteractionEnabled = false
        self.contactUpdateView.visibility = .gone
        self.venueDetailView.visibility = .gone
        self.departmentDetailUpdate.visibility = .gone
        self.appointmentCancelBtn.isHidden = true
        self.activateDeactivateView.visibility = .gone
        self.travelMileStackView.visibility = .gone
        showLanguageDropDown()
        self.cancelImg.isHidden = true
        self.clientNameTF.delegate = self
        self.clientRefrenceTF.delegate = self
        self.locationTF.delegate = self
        self.clientIntiaalTF.delegate = self
        self.specialNoteTf.delegate = self
        
      //  NotificationCenter.default.addObserver(self, selector: #selector(self.selectActionToPerform(notification:)), name: Notification.Name("selectActionType"), object: nil)


    }
  
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
            self.venueName = self.selectVenueTF.text ?? ""
            self.departmentName = self.selectDepartmentTF.text ?? ""
            self.ConatctName = self.selectContactTF.text ?? ""
            self.genderName = self.genderTF.text ?? ""
            self.languageName = self.languageTF.text ?? ""
            self.addressName = self.addressnameLbl.text ?? ""
            self.cityName = self.citynameLbl.text ?? ""
            self.stateName = self.stateLbl.text ?? ""
            self.zipcodeName = self.zipcodeLbl.text ?? ""
            self.clientName = self.clientNameTF.text ?? ""
            self.Clientrefrence = self.clientRefrenceTF.text ?? ""
            self.clientIntials = self.clientIntiaalTF.text ?? ""
            self.specialNotes = self.specialNoteTf.text ?? ""
            self.locationText = self.locationTF.text ?? ""
        
        
        
        
       
      
        
        delegate?.didSave(self, flag: true, AppointmentDate: self.AppointmentDate, index: rowIndex, startTime: self.startTime, EndTime: self.endTime, languageID: self.languageID, GenderID: self.genderID, ClientName: self.clientName, clientIntials: self.clientIntials, clientRefrence: self.Clientrefrence, venueID: self.venueID, departmentID: self.departmentID, contactID: self.providerID, location: self.locationText, Notes: self.specialNotes, isAppointmentDateSelect: self.isAppointmentDateSelect, isStartTimeSelect: self.isStartTimeSelect, isEndtimeSelect: self.isEndtimeSelect, languageName: self.languageName,venueName: self.venueName, DepartmentName: self.departmentName, genderType: self.genderName, conatctName: self.ConatctName, isVenueSelect: self.isVenueSelect,venueTitleName: self.venueTitleName, addressname: self.addressName, cityName: self.cityName, stateName:  self.stateName, zipcode: self.zipcodeName,startTimeForPicker : Date() ,endTimeForPicker : Date(),   isproviderSelect :false, isDepartmentSlecet : false, isLanguageSelect : false,isgenderSelect : false,isCleintNameEnterd : isClientName ,isClientRefrenceEnyterd : isclientRef, IsNotesEntered : isNote , isLocationEneterd : islocatin,isvenueFlag : false)
    
    }
   
   
    func showLanguageDropDown(){
        self.languageTF.optionArray = GetPublicData.sharedInstance.languageArray
        languageTF.listDidAppear {
                    self.dropDown.direction = .top
                }
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
                    self.venueName = self.selectVenueTF.text ?? ""
                    self.departmentName = self.selectDepartmentTF.text ?? ""
                    self.ConatctName = self.selectContactTF.text ?? ""
                    self.genderName = self.genderTF.text ?? ""
                  
                    self.addressName = self.addressnameLbl.text ?? ""
                    self.cityName = self.citynameLbl.text ?? ""
                    self.stateName = self.stateLbl.text ?? ""
                    self.zipcodeName = self.zipcodeLbl.text ?? ""
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
                    self.venueName = self.selectVenueTF.text ?? ""
                    self.departmentName = self.selectDepartmentTF.text ?? ""
                    self.ConatctName = self.selectContactTF.text ?? ""
                    self.genderName = self.genderTF.text ?? ""
                  
                    self.addressName = self.addressnameLbl.text ?? ""
                    self.cityName = self.citynameLbl.text ?? ""
                    self.stateName = self.stateLbl.text ?? ""
                    self.zipcodeName = self.zipcodeLbl.text ?? ""
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
            searchString = "<INFO><COMPANYID>\(companyID)</COMPANYID><ID>\(id)</ID><Name>\(departmentName)</Name><VenueID></VenueID><Flag>\(flag)</Flag><Type>\(type)</Type><CustomerID>\(GetPublicData.sharedInstance.TempCustomerID)</CustomerID><OneTime>\(isOneTime)</OneTime><Deptid>\(deptID)</Deptid><LOGINUSERID>\(userID)</LOGINUSERID></INFO>"
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
                                        //tableDelegate?.didReloadTable(performTableReload: true)
                                        self.contactNameTF.text = ""
                                        self.selectDepartmentTF.text = ""
                                        self.departmentNameTF.text = ""
                                        if contactActiontype == 5 {
                                            let itemA = ProviderData(ProviderID: status, ProviderName: departmentName)
                                            oneTimeContactArr.append(itemA)
                                            
                                            self.tableDelegate?.updateOneTimeConatct(ConatctData: itemA, isDelete: false )
                                        }else if contactActiontype == 2 {
                                            let itemA = ProviderData(ProviderID: status, ProviderName: departmentName)
                                            
                                            self.tableDelegate?.updateOneTimeConatct(ConatctData: itemA, isDelete: true)
                                        }else {
                                            
                                        }
                                    }else if self.depatmrntActionType != nil  {
                                        self.departmentName = ""
                                        self.selectDepartmentTF.text = ""
                                        self.departmentNameTF.text = ""
                                        self.departmentDetailUpdate.visibility = .gone
                                        //tableDelegate?.didReloadTable(performTableReload: true)
                                        if depatmrntActionType == 5 {
                                            let itemA = DepartmentData(DeActive: 0, DepartmentID: status, DepartmentName: departmentName)
                                            oneTimeDepartmentArr.append(itemA)
                                            self.tableDelegate?.updateOneTimeDepartment(departmentData: itemA, isDelete: false)
                                        }else if depatmrntActionType == 2 {
                                            let itemA = DepartmentData(DeActive: 0, DepartmentID: status, DepartmentName: departmentName)
                                            self.tableDelegate?.updateOneTimeDepartment(departmentData: itemA, isDelete: true)
                                        }else {
                                            
                                        }
                                    }else {
                                        
                                    }
                                    self.AppointmentDate = self.appointmentDateTF.text ?? ""
                                    self.startTime = self.startTimeTf.text ?? ""
                                    self.endTime = self.endTimeTF.text ?? ""
                                    self.venueName = self.selectVenueTF.text ?? ""
                                    self.departmentName = self.selectDepartmentTF.text ?? ""
                                    self.ConatctName = self.selectContactTF.text ?? ""
                                    self.genderName = self.genderTF.text ?? ""
                                    self.languageName = self.languageTF.text ?? ""
                                    self.addressName = self.addressnameLbl.text ?? ""
                                    self.cityName = self.citynameLbl.text ?? ""
                                    self.stateName = self.stateLbl.text ?? ""
                                    self.zipcodeName = self.zipcodeLbl.text ?? ""
                                    self.clientName = self.clientNameTF.text ?? ""
                                    self.Clientrefrence = self.clientRefrenceTF.text ?? ""
                                    self.clientIntials = self.clientIntiaalTF.text ?? ""
                                    self.specialNotes = self.specialNoteTf.text ?? ""
                                    self.locationText = self.locationTF.text ?? ""
                                   
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

}
    
//MARK: - Onsite Table Work

extension OnsiteBlockedAppointmentVC : UITableViewDelegate , UITableViewDataSource , SaveBookedAppointmentData  , ReloadBlockedTable , UpdateOneTimeVenue{
    
    
    
    func bookedAppointment() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func updateOneTimeVenue(VenueName: String, cityName: String, Address: String, State: String, zipCode: String, venueID: Int, stateID: Int, address2: String) {
        print("Delegate Working ")
        let itemA = VenueData(Address: Address, Address2: address2, City: cityName, CompanyID: Int(GetPublicData.sharedInstance.companyID), CustomerCompany: GetPublicData.sharedInstance.companyName, CustomerName: GetPublicData.sharedInstance.usenName, Notes: "", State: State, StateID: stateID, VenueID: venueID, VenueName: VenueName, ZipCode: zipCode, isOneTime: true)
        self.venueDetail.append(itemA)
        self.venueArray.append(VenueName)
    }
    
    func updateOneTimeDepartment(departmentData: DepartmentData , isDelete: Bool) {
        
       // if isDelete {
            /*start shanges*/
            if oneTimeDepartmentArr.count != 0{
            
            if isDelete {
          
                if let obj = oneTimeDepartmentArr.firstIndex(where: {$0.DepartmentID == departmentData.DepartmentID}){
                    oneTimeDepartmentArr.remove(at: obj)
                }
                for  itemm in blockedAppointmentArr {
                     itemm.DepartmentName = ""
                     itemm.DepartmentID = 0
                            
                 
                }
                getVenueDetail(customerId: self.customerID)
               
            }
            
            else {
                
                if let obj = oneTimeDepartmentArr.firstIndex(where: {$0.DepartmentID == departmentData.DepartmentID}){
                    oneTimeDepartmentArr.remove(at: obj)
                }
                for  itemm in blockedAppointmentArr {
                     itemm.DepartmentName = ""
                     itemm.DepartmentID = 0
                            
                 
                }
                   self.oneTimeDepartmentArr.append(departmentData)
                    getVenueDetail(customerId: self.customerID)
               
            }
                let index = IndexPath(item: selectedIndex, section: 0)
                self.blockedAppointmentTV.reloadRows(at: [index], with: .automatic)
                //self.blockedAppointmentTV.reloadData()
            }
            else {
            if isDelete {
                
                for  itemm in blockedAppointmentArr {
                     itemm.DepartmentName = ""
                     itemm.DepartmentID = 0
                            
                 
                }
                getVenueDetail(customerId: self.customerID)
            }
            else {
               self.oneTimeDepartmentArr.append(departmentData)
                getVenueDetail(customerId: self.customerID)
            }
                let index = IndexPath(item: selectedIndex, section: 0)
                self.blockedAppointmentTV.reloadRows(at: [index], with: .automatic)
               // self.blockedAppointmentTV.reloadData()
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
    print("selectedIndex----->", selectedIndex)
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
            let index = IndexPath(item: selectedIndex, section: 0)
            
            self.blockedAppointmentTV.reloadRows(at: [index], with: .automatic)
          //  self.blockedAppointmentTV.reloadData()
        }
        else {
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
           self.oneTimeContactArr.append(ConatctData)
            getVenueDetail(customerId: self.customerID)
        }
            let index = IndexPath(item: selectedIndex, section: 0)
            self.blockedAppointmentTV.reloadRows(at: [index], with: .automatic)
            //self.blockedAppointmentTV.reloadData()
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
            self.activateOptionView.visibility = .gone
            self.DeactivateOptionView.visibility = .gone
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockedAppointmentTVCell", for: indexPath) as! BlockedAppointmentTVCell
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
        cell.addvenueBtn.tag = indexPath.row
        cell.addvenueBtn.addTarget(self, action: #selector(actionAddVenueBtn), for: .touchUpInside)
        
        let aptNumber = indexPath.row + 1
        cell.AppointmentTitleLbl.text = "Appointment \(aptNumber)"
        
        let BlockedData = self.blockedAppointmentArr[indexPath.row]
        cell.rowIndex = indexPath.row //BlockedData.rowIndex ?? 0
        cell.appointmentDateTF.text = BlockedData.AppointmentDate
        cell.startTimeTf.text = BlockedData.startTime
        cell.endTimeTF.text = BlockedData.endTime
        cell.languageTF.text = self.BlockedLanguage//BlockedData.languageName
        cell.genderTF.text = BlockedData.genderType
        cell.clientNameTF.text = BlockedData.showClientName
        cell.clientIntiaalTF.text = BlockedData.showClientIntials
        cell.clientRefrenceTF.text = BlockedData.showClientRefrence
        print("venue name  in  cell is \(BlockedData.venueName)")
        print("department in cell  name \(BlockedData.DepartmentName)")
        cell.selectDepartmentTF.text = BlockedData.DepartmentName
        cell.selectVenueTF.text = BlockedData.venueName
        cell.actionVenueDropDown.tag = indexPath.row
        cell.actionVenueDropDown.addTarget(self, action: #selector(actionSelectVenue), for: .touchUpInside)
        cell.selectContactTF.text = BlockedData.conatctName
        cell.locationTF.text = BlockedData.location
        cell.specialNoteTf.text = BlockedData.SpecialNotes
        cell.venueNameLbl.text = BlockedData.venueName
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
        selectedIndex = sender.tag
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
        selectedIndex = sender.tag
        self.vanueID = blockedAppointmentArr[sender.tag].venueID ?? "0"

        
        self.DepartmentIDForOperation = blockedAppointmentArr[sender.tag].DepartmentID ?? 0
    }
    @objc func actionAddContact(sender : UIButton){
        let storyboard = UIStoryboard(name: "SchedulingAppointments", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDepartmentAndContactVC") as! UpdateDepartmentAndContactVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.isdepartSelect = false
        vc.tableDelegate = self
        vc.actionType = "Add"
        vc.venueID = vanueID
        selectedIndex = sender.tag
        vc.contactActiontype = 0
        self.present(vc, animated: true, completion: nil)
    }
    @objc func actionAddDepartment(sender : UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "UpdateDepartmentAndContactVC") as! UpdateDepartmentAndContactVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.isdepartSelect = true
        vc.actionType = "Add"
        vc.venueID = vanueID
        selectedIndex = sender.tag
        vc.tableDelegate = self
        vc.depatmrntActionType = 0
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
           self?.blockedAppointmentTV.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
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
           self?.blockedAppointmentTV.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
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
            self?.blockedAppointmentTV.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
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
           self?.blockedAppointmentTV.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
      }
    }
    @objc func actionAddVenueBtn(sender : UIButton){
        let vc = storyboard?.instantiateViewController(identifier: "AddUpdateVenueVC") as! AddUpdateVenueVC
        self.navigationController?.pushViewController(vc, animated: true)
        
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
       
        //changes start
        let sTime = appointmentDateTF.text! + " \(starttimeTF.text!)"
        let minDate = CEnumClass.share.getCompleteDateAndTime(dateAndTime: sTime)
        let endTime = appointmentDateTF.text! + " \(endTimeTF.text!)"
        let maxTimes = CEnumClass.share.getCompleteDateAndTime(dateAndTime: endTime)
        
        let selectedDateAntime = appointmentDateTF.text! + " \(blockedAppointmentArr[sender.tag].startTime!)"
        let selectDate = CEnumClass.share.getCompleteDateAndTime(dateAndTime: selectedDateAntime)
        //changes end
        
        let timeDDate =   CEnumClass.share.getCurrentTimeToDate(time: blockedAppointmentArr[sender.tag].startTime!)
        let cell = blockedAppointmentTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BlockedAppointmentTVCell
       // let minDate = Date().dateByAddingYears(-5)
        RPicker.selectDate(title: "Select Start Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectDate, minDate: minDate, maxDate: maxTimes, didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.blockedAppointmentArr[sender.tag].startTimeForPicker = selectedDate
            self?.blockedAppointmentArr[sender.tag].endTimeForPicker = selectedDate.adding(minutes: 120)
            let  roundoff = selectedDate//.nearestHour() ?? selectedDate
            let endTimee = roundoff.adding(minutes: 120)
            self?.blockedAppointmentArr[sender.tag].startTimeForPicker = selectedDate
            
            
            
            let startBookedTime = self?.starttimeTF.text ?? ""
            let startcellBookedTime = roundoff.dateString("hh:mm a")
            print("selected time \(startcellBookedTime), but blocked time \(startBookedTime)")
            
            let startmainTime = self?.timeConversion24(time12: startBookedTime)
            let startCellTime = self?.timeConversion24(time12: startcellBookedTime)
            
            
            //if startcellBookedTime < startBookedTime {
            if (startCellTime ?? "") <= (startmainTime ?? "") {
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
       
        let cell = blockedAppointmentTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BlockedAppointmentTVCell
      
        //changes start
        let sTime = appointmentDateTF.text! + " \(starttimeTF.text!)"
        let minDate = CEnumClass.share.getCompleteDateAndTime(dateAndTime: sTime)
        let endTime = appointmentDateTF.text! + " \(endTimeTF.text!)"
        let maxTimes = CEnumClass.share.getCompleteDateAndTime(dateAndTime: endTime)
        
        let selectedDateAntime = appointmentDateTF.text! + " \(blockedAppointmentArr[sender.tag].endTime!)"
        let selectDate = CEnumClass.share.getCompleteDateAndTime(dateAndTime: selectedDateAntime)
        //changes end
       
        RPicker.selectDate(title: "Select End Time", cancelText: "Cancel", datePickerMode: .time, selectedDate: selectDate, minDate: minDate, maxDate: maxTimes, didSelectDate: {[weak self] (selectedDate) in
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
                if (endCellTime ?? "") < (endMaintime ?? "") {
                    
                     
                cell.endTimeTF.text = roundoff.dateString("hh:mm a")
                self?.blockedAppointmentArr.forEach({ BlockedAppointmentData in
                    if BlockedAppointmentData.rowIndex == sender.tag {
                        BlockedAppointmentData.endTime = roundoff.dateString("hh:mm a")
                        cell.endTime = roundoff.dateString("hh:mm a")
                    }
                })
            }else {
                self?.view.makeToast("Your last appointment end time cannot exceed the overall appointment end time. Please adjust the overall appointment end time accordingly." , duration : 3.0 , position : .center)
            
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
    var startTime : String?
    var endTime : String?
    var languageID : Int?
    var genderID : String?
    var showClientName : String?
    var showClientIntials : String?
    var showClientRefrence : String?
    
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
    var isDepartmentSelect : Bool?
    var isConatctSelect : Bool?
    var venueTitleName: String?
    var addressname: String?
    var cityName: String?
    var stateName: String?
    var zipcode: String?
    var startTimeForPicker : Date?
    var endTimeForPicker : Date?
    var authCode : String?
    
    
    
    init (AppointmentDate : String ,startTime : String, endTime : String, languageID : Int, genderID : String , clientName : String , ClientIntials : String , ClientRefrence : String , venueID : String , DepartmentID :Int, contactID : Int, location : String , SpecialNotes : String, rowIndex : Int , languageName : String,venueName : String,DepartmentName : String,genderType: String,conatctName: String, isVenueSelect: Bool,venueTitleName: String, addressname: String, cityName: String, stateName: String, zipcode: String,startTimeForPicker :Date,endTimeForPicker : Date, authCode:String , showClientName: String , showClientIntials:String , showClientRefrence: String, isDepartmentSelect: Bool,isConatctSelect : Bool) {
        self.showClientName = showClientName
        self.showClientIntials = showClientIntials
        self.showClientRefrence = showClientRefrence
        self.authCode = authCode
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
        self.isConatctSelect = isConatctSelect
        self.isDepartmentSelect = isDepartmentSelect
    }
}
