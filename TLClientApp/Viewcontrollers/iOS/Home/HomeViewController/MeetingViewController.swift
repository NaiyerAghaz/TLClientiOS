//
//  MeetingViewController.swift
//  TLClientApp
//
//  Created by SMIT 005 on 29/11/21.
//

import UIKit
import XLPagerTabStrip
import Alamofire

protocol SaveAnswersInObject : AnyObject{
    func didSave(_ class: AddparticipentstableViewCell, flag: Bool , firstName : String , index : Int ,lastName : String ,emailID : String, phoneNumber : String, countryCode : String)
}
protocol SaveCountryCode : AnyObject {
    func saveCountryCode(countryCode: String, flagImage:UIImage,rowndex :Int)
}
class AddparticipentstableViewCell:UITableViewCell ,UITextFieldDelegate {
    
    @IBOutlet weak var openCountryCode: UIButton!
    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var addParticipantsOuterView: UIView!
    @IBOutlet weak var mobileNumberView: UIView!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var emailIDView: UIView!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var cancelImage: UIImageView!
    var rowIndex:Int? = nil
    var firstName = ""
    var lastName = ""
    var emailID = ""
    var countryCode = ""
    var mobileNum = ""
    var delegate : SaveAnswersInObject?
    @IBOutlet weak var cancelParticipantBtn: UIButton!
    override func awakeFromNib() {
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        emailTF.delegate = self
        mobileTF.delegate = self
        self.firstNameView.layer.cornerRadius = self.firstNameView.bounds.height / 2
        self.firstNameView.layer.borderWidth = 0.8
        self.firstNameView.layer.borderColor = UIColor.lightGray.cgColor
        self.addParticipantsOuterView.addShadowGrey()
        self.emailIDView.layer.cornerRadius = self.emailIDView.bounds.height / 2
        self.emailIDView.layer.borderWidth = 0.8
        self.emailIDView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.lastNameView.layer.cornerRadius = self.lastNameView.bounds.height / 2
        self.lastNameView.layer.borderWidth = 0.8
        self.lastNameView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.mobileNumberView.layer.cornerRadius = self.mobileNumberView.bounds.height / 2
        self.mobileNumberView.layer.borderWidth = 0.8
        self.mobileNumberView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.countryCodeTF.setLeftPaddingPoints(60)
        self.countryCodeTF.attributedPlaceholder = NSAttributedString(string: "(US)+1", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        setFlagAndPhoneNumberCodeLeftViewIcon(icon: UIImage(named: "down button arrow")!)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.mobileTF {
            if self.countryCodeTF.text == "" {
                self.contentView.makeToast("Please add country code.")
            }else {
                
            }
        }
    }
    func textFieldDidEndEditing(_ textView: UITextField) {
            print("Function textViewDidEndEditing ")
                   print("Row index is ",rowIndex)
                   guard let txt = textView.text else { return }
                   guard rowIndex != nil else { return }
                   var firstname = ""
                   var lastName = ""
                   var emailId = ""
                   var phNum = ""
                   if textView == self.firstNameTF {
                        self.firstName = txt
                   }else if textView == self.lastNameTF {
                        self.lastName = txt
                   }else if textView == self.mobileTF {
                        self.mobileNum = txt
                   }else if textView == self.emailTF {
                          self.emailID = txt
                   }else if textView == self.countryCodeTF{
                          //self.countryCode = txt
                   }
                   print("----text is ", txt)
                print("all value are ",self.firstName,self.lastName , self.emailID,self.mobileNum,self.countryCode)
               delegate?.didSave(self, flag: true, firstName: self.firstName, index: rowIndex ?? 0, lastName: self.lastName, emailID: self.emailID, phoneNumber: self.mobileNum , countryCode: self.countryCode  )
  
        }
    
       func setFlagAndPhoneNumberCodeLeftViewIcon(icon: UIImage) {
           let btnView = UIButton(frame: CGRect(x: 0, y: 0, width: 6.32, height: 3.08))
           btnView.setImage(icon, for: .normal)
           btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right:  10)
           self.countryCodeTF.rightViewMode = .always
           self.countryCodeTF.rightView = btnView
      }

}
class MeetingViewController: UIViewController , IndicatorInfoProvider, SaveAnswersInObject, MICountryPickerDelegate {
    func didSave(_ class: AddparticipentstableViewCell, flag: Bool, firstName: String, index: Int, lastName: String, emailID: String, phoneNumber: String , countryCode: String) {
        print("index value in did save \(index)")
               
               print("ENTERED ANSWER IS \(firstName)")
               let password = String(random(digits: 6))
               let meetID = String(random(digits: 10))
              // let pDouble = Double(firstName) ?? 0.0
               if firstName != "" && lastName != "" && phoneNumber != "" && emailID != "" {
                     let meetApiModel = ScheduleMeetingInvitation(Active: true, password: password, MeetingId: meetID, ScheduleMeetingId: 0, PhoneNumber: phoneNumber, Email: emailID, LastName: lastName, FirstName: firstName, ScheduleMeetingInvitationId: 0,countryCode: countryCode)
                print("anything ")
                       self.scheduleMeetingInvitation.append(meetApiModel)
                       self.fillParticipantDetail = true
               }else {
                      self.fillParticipantDetail = false
                  print("ENTERED ANSWER IS \(firstName)" , lastName,phoneNumber,emailID)
                  print("fill complete detail.")
              }
             
    }
    @IBOutlet weak var lastNameTF: ACFloatingTextfield!
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var startDateTF: UITextField!
    @IBOutlet weak var firstNameTF: ACFloatingTextfield!
    @IBOutlet weak var roomNoLbl: UILabel!
    var callManagerVM = CallManagerVM()
    var participantsCount = 1
    var roomId = ""
    var selectedIndex = 0
    var delegate : SaveAnswersInObject?
    var fillParticipantDetail = false
    var scheduleMeetingInvitation = [ScheduleMeetingInvitation]()
    var apiScheduleVRIMeetResponseModel:ApiScheduleVRIMeetResponseModel?
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Meeting")
    }
    static func createWith(navigator: Navigator, storyboard: UIStoryboard) -> MeetingViewController {
        return storyboard.instantiateViewController(ofType: MeetingViewController.self).then { viewController in
            
        }
    }

    
    
    @IBOutlet weak var inviteParticipantTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startDateView.layer.cornerRadius = 10
        self.startDateView.layer.borderWidth = 0.8
        self.startDateView.layer.borderColor = UIColor.lightGray.cgColor
        self.inviteParticipantTV.delegate = self
        self.inviteParticipantTV.dataSource = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        let startDate =  dateFormatter.string(from: Date().nearestHour() ?? Date())
        
        
        self.startDateTF.text = startDate
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
        callManagerVM.getRoomList { roolist, error in
            if error == nil {
                self.roomId = roolist?[0].RoomNo ?? "0"
                self.roomNoLbl.text = "Room No: \(self.roomId)"
                SwiftLoader.hide()
                
            }
            
        }}else{
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
        
        // Do any additional setup after loading the view.
    }
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
           number += "\(Int.random(in: 1...9))"
        }
        return number
    }
    @IBAction func actionScheduleMeeting(_ sender: UIButton) {
        print("random number is ",random(digits: 6))
        if self.startDateTF.text!.isEmpty {
                    self.view.makeToast("Please fill Start Date.",duration: 1, position: .center)
            return
                    
        }else if self.firstNameTF.text!.isEmpty {
            self.view.makeToast("Please fill First Name.",duration: 1, position: .center)
            return
            
        }else if self.lastNameTF.text!.isEmpty {
            self.view.makeToast("Please fill Last Name.",duration: 1, position: .center)
            return
            
        }else if self.fillParticipantDetail == false  {
            self.view.makeToast("Please fill Complete Participants Detail.",duration: 1, position: .center)
            return
            
        }else {
            let firstName = self.firstNameTF.text ?? ""
            let lastName = self.lastNameTF.text ?? ""
            let date = self.startDateTF.text ?? ""
            let userID = GetPublicData.sharedInstance.userID
            let companyID = GetPublicData.sharedInstance.companyID
            hitApiScheduleMeeting(firstName: firstName, lastName: lastName, date: date, time: date, userID: userID, companyID: companyID, active: true)
        }
        
    }
    @IBAction func actionSelectDate(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .dateAndTime, minDate: Date(), maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
                        // TODO: Your implementation for date
                        let roundOff = selectedDate.nearestHour() ?? selectedDate
                        self?.startDateTF.text = roundOff.dateString("MM/dd/YYYY hh:mm a")
                         
                    })
        
    }
    @IBAction func addParticipents(_ sender: UIButton) {
        self.selectedIndex = self.participantsCount + 1
        if participantsCount == 1 {
            
            self.participantsCount = 2
            self.inviteParticipantTV.reloadData()
        } else if participantsCount == 2{
            self.participantsCount = 3
            self.inviteParticipantTV.reloadData()
        } else if participantsCount == 3{
            self.view.makeToast("You can add only three Participants.")
        }
    }
    func hitApiScheduleMeeting(firstName : String,lastName : String,date : String,time : String,userID : String,companyID : String,active : Bool){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
        var newArr = [ScheduleMeetingInvitation]()
        scheduleMeetingInvitation.forEach { (meetdata) in
            let cc = meetdata.countryCode ?? ""
            let pn = meetdata.PhoneNumber ?? ""
            let phWithCC = cc + pn
            print("ph with cc ", phWithCC)
            let item = ScheduleMeetingInvitation(Active: meetdata.Active, password: meetdata.password, MeetingId: meetdata.MeetingId, ScheduleMeetingId: meetdata.ScheduleMeetingId, PhoneNumber: phWithCC, Email: meetdata.Email, LastName: meetdata.LastName, FirstName: meetdata.FirstName, ScheduleMeetingInvitationId: meetdata.ScheduleMeetingInvitationId, countryCode: meetdata.countryCode, flagImage: meetdata.flagImage)
             newArr.append(item)
        }
        let meetArr = newArr.map { data in
                            [
                                "Active" : data.Active,
                                "password" : data.password ?? "",
                                "MeetingId" : data.MeetingId ?? "",
                                "ScheduleMeetingId" : data.ScheduleMeetingId ,
                                "PhoneNumber" : data.PhoneNumber ?? "",
                                "Email" : data.Email ?? "",
                                "LastName" : data.LastName ?? "",
                                "FirstName" : data.FirstName ?? "",
                                "ScheduleMeetingInvitationId" : data.ScheduleMeetingInvitationId
                            ]
                        }
            print("meet arr ",meetArr)
        let urlString = APi.AddScheduleMeeting.url
        let parameters = [
            "ScheduleMeeting": [
                 "ScheduleMeetingId": 0,
                 "FirstName": firstName,
                 "LastName":lastName,
                 "Date":date, //"12/02/2021 10:34 AM",
                 "Time":time,//"12/02/2021 10:34 AM",
                 "CreatedUser":userID,
                 "CompanyId":companyID,
                "RoomNo":self.roomId,
                 "Active":active,
                 "ScheduleMeetingInvitation" : meetArr
            ]
        ] as [String:Any]
             print("url to create Meet Appointment \(urlString),\(parameters)")
                AF.request(urlString, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success  create Meet appointment ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiScheduleVRIMeetResponseModel = try jsonDecoder.decode(ApiScheduleVRIMeetResponseModel.self, from: daata)
                                let status = self.apiScheduleVRIMeetResponseModel?.scheduleVRI?.first?.success ?? 0
                                if status == 1 {
                                    print("Success Meet Requset ")
                                     //self.view.makeToast("Address added successfuly.",duration: 2, position: .center)
                                    
                                    self.navigationController?.popViewController(animated: true)
                                }else {
                                    let message = self.apiScheduleVRIMeetResponseModel?.scheduleVRI?.first?.fastTrackOrNot ?? ""
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
                    })}
        else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
     }
    

}
//MARK: - Table Work
extension MeetingViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participantsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddparticipentstableViewCell", for: indexPath) as! AddparticipentstableViewCell
        if participantsCount == 1 {
            cell.cancelParticipantBtn.isHidden = true
            cell.cancelImage.isHidden = true
        }else {
            cell.cancelParticipantBtn.isHidden = false
            cell.cancelImage.isHidden = false
        }
        let arrCount = self.scheduleMeetingInvitation.count
        if arrCount > indexPath.row {
            cell.firstNameTF.text = self.scheduleMeetingInvitation[indexPath.row].FirstName
            cell.lastNameTF.text = self.scheduleMeetingInvitation[indexPath.row].LastName
            cell.mobileTF.text = self.scheduleMeetingInvitation[indexPath.row].PhoneNumber
            cell.emailTF.text = self.scheduleMeetingInvitation[indexPath.row].Email
            cell.countryCodeTF.text = self.scheduleMeetingInvitation[indexPath.row].countryCode
        }else {
            cell.firstNameTF.text = ""
            cell.lastNameTF.text = ""
            cell.mobileTF.text = ""
            cell.emailTF.text = ""
            cell.countryCodeTF.text = ""
        }
        cell.openCountryCode.tag = indexPath.row
        cell.openCountryCode.addTarget(self, action: #selector(openCountryCodeAction), for: .touchUpInside)
        cell.rowIndex = indexPath.row
        cell.delegate = self
        cell.cancelParticipantBtn.tag = indexPath.row
        cell.cancelParticipantBtn.addTarget(self, action: #selector(cancelParticipants), for: .touchUpInside)
        return cell
    }
    @objc func cancelParticipants(_ sender: UIButton){
        let index = sender.tag
        self.selectedIndex = index
        if self.scheduleMeetingInvitation.count > index {
            self.scheduleMeetingInvitation.remove(at: index)
        }
        
        print("array detail is \(self.scheduleMeetingInvitation)")
        if participantsCount == 3{
            self.participantsCount = 2
            self.inviteParticipantTV.reloadData()
        }else if participantsCount == 2{
            self.participantsCount = 1
            self.inviteParticipantTV.reloadData()
        }else if participantsCount == 1{
            self.view.makeToast("Can't remove last Cell.")
        }
    }
   @objc func openCountryCodeAction(_ sender: UIButton) {
            self.navigationItem.setHidesBackButton(false, animated: true)
       let cell = inviteParticipantTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! AddparticipentstableViewCell
            let picker = MICountryPicker { (name, code ) -> () in
                
                print("picked code : ",code)
                print("PICKED COUNTRY IS \(name)")
                let bundle = "assets.bundle/"
                print("IMAGE IS \(UIImage( named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil))")
            }
            picker.delegate = self
            // Display calling codes
            picker.showCallingCodes = true
            // or closure
            picker.didSelectCountryClosure = { name, code in
                picker.navigationController?.isNavigationBarHidden=true
                picker.navigationController?.popViewController(animated: true)
                print("code is ",code)
                let bundle = "assets.bundle/"
                
                let image = UIImage( named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
                print("IMAGE IS \(image)")
                
            }
            picker.didSelectCountryWithCallingCodeClosure = { name , code , dialCode in
                picker.navigationController?.isNavigationBarHidden=true
                //picker.navigationController?.popViewController(animated: true)
                print("code is ",code)
                let bundle = "assets.bundle/"
                
                let image = UIImage( named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
                print("IMAGE IS \(image)")
                cell.countryCodeTF.text = dialCode
                cell.countryCode = dialCode
                cell.flagImg.image = image
               // self.scheduleMeetingInvitation[sender.tag].countryCode = code
               // self.scheduleMeetingInvitation[sender.tag].flagImage = image
               // self.inviteParticipantTV.reloadData()
            }
            navigationController?.pushViewController(picker, animated: true)
        }
        
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String ) {
                 picker.navigationController?.isNavigationBarHidden=true//?.popViewController(animated: true)
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.navigationItem.setHidesBackButton(true, animated: true)
                print("CODE IS \(code)")
                
                print("Dial Code ",dialCode)
                let bundle = "assets.bundle/"
                print("IMAGE IS \(UIImage( named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil))")
        
                
                //DialCode = "\(dialCode)"
               // countryCodeTF.text = "\(dialCode)"//"Selected Country: \(name) , \(code)"
                //tempImageView.image = UIImage( named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
            
        }
    
}

//MARK: - Participants Model
struct ScheduleMeetingInvitation {
    var Active :Bool = true
    var password : String?
    var MeetingId :String?
    var ScheduleMeetingId :Int = 0
    var PhoneNumber: String?
    var Email:String?
    var LastName :String?
    var FirstName:String?
    var ScheduleMeetingInvitationId : Int = 0
    var countryCode = "0"
    var flagImage :UIImage?
}
