//
//  CustomerDetailsViewController.swift
//  TLClientApp
//
//  Created by Mac on 18/10/21.
//

import UIKit
import Alamofire
import DropDown
class CustomerDetailsViewController: UIViewController {
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet var lastNameTF: UITextField!
    @IBOutlet var billingContactTF: UITextField!
    @IBOutlet var customerfullNameTF: UITextField!
    @IBOutlet var firstNameTF: UITextField!
    @IBOutlet var classificationNameTF: UITextField!
    @IBOutlet var classificationBtn: UIButton!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var companyNameTF: UITextField!
    @IBOutlet var userNameTF: UITextField!
    @IBOutlet var billingPhoneTF: UITextField!
    @IBOutlet var mobileNumberTF: UITextField!
    @IBOutlet var billingExtensionTF: UITextField!
    @IBOutlet var mobileExtensionTF: UITextField!
    @IBOutlet var classificationView: UIView!
    @IBOutlet var faxTF: UITextField!
    @IBOutlet var groupTF: UITextField!
    @IBOutlet var servieVerificationSwitch: UISwitch!
    @IBOutlet var websiteTF: UITextField!
    @IBOutlet var notesTF: UITextField!
    @IBOutlet var address1TF: UITextField!
    @IBOutlet var telephoneAccessCodeTF: UITextField!
    @IBOutlet var prioritySwitch: UISwitch!
    
    @IBOutlet var cityTF: UITextField!
    @IBOutlet var address3TF: UITextField!
    @IBOutlet var scheduleTransaltionServiceSwitch: UISwitch!
    @IBOutlet var willScheduleOnsiteSwitch: UISwitch!
    
    @IBOutlet var zipCodeTF: UITextField!
    @IBOutlet var stateTF: UITextField!
    @IBOutlet var sameAsBillingAddressSwitch: UISwitch!
    @IBOutlet var isLogisticVisibleSwitch: UISwitch!
    @IBOutlet var isSpeciallyVisibleSwitch: UISwitch!
    @IBOutlet var refrenceSwitch: UISwitch!
    @IBOutlet var claimSwitch: UISwitch!
    @IBOutlet var purchaseOrderSwitch: UISwitch!
    @IBOutlet var invoiceBoatchingSwitch: UISwitch!
    
    @IBOutlet var address2TF: UITextField!
    @IBOutlet var billingZipCodeTF: UITextField!
    @IBOutlet var billingStateTF: UITextField!
    @IBOutlet var billingCityTF: UITextField!
    @IBOutlet var billingAddressTF: UITextField!
    let dropDown = DropDown()
    var classificationArr:[String] = []
    var apiGetClassificationDetails:ApiGetClassificationDetails?
    var apiCustomerDetailResponseModel : ApiCustomerDetailResponseModel?
    var selectedClassification = ""
    var classificationAction = 0
    override func viewDidLoad() {
        super.viewDidLoad()
          updateUI()
        classificationView.visibility = .gone
         getCustomerDetail()
        
    }
    @IBAction func deleteClassifications(_ sender: UIButton) {
        //classificationView.visibility = .visible
        self.classificationAction = 2
        self.classificationNameTF.text = self.selectedClassification
        if classificationNameTF.text != ""{
            let name = classificationNameTF.text
            self.apiGetClassificationDetails?.cLASSIFICATION?.forEach({ dataC in
                if dataC.classification == name {
                    self.addUpdateClassifiation(classificationName: name ?? "" , classificationID: dataC.id ?? 0)
                }
            })
            
        }else {
            self.view.makeToast("Please add Classification.")
        }
    }
    @IBAction func editClassifications(_ sender: UIButton) {
        classificationView.visibility = .visible
        self.classificationAction = 1
        self.classificationNameTF.text = self.selectedClassification
    }
    @IBAction func addClassifications(_ sender: UIButton) {
        classificationView.visibility = .visible
        self.classificationAction = 0
        self.classificationNameTF.text = ""
        
        
        
    }
    @IBAction func actionBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnClassificationTapped(_ sender: UIButton) {
        dropDown.anchorView = sender //5
                dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
                //dropDown.textFont = UIFont(name: "ProximaNova-Regular", size: 14.0)!
                dropDown.backgroundColor = UIColor.white
                dropDown.layer.cornerRadius = 20
                dropDown.clipsToBounds = true
                dropDown.show() //7
                dropDown.dataSource = classificationArr
                //["Finance","Human Resource", "Scheduling", "Translation"]
              dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
                  sender.setTitle(item, for: .normal)
                sender.setTitleColor(UIColor.black, for: .normal)
                self?.selectedClassification = item
                self?.classificationNameTF.text = item
              }
    }
    @IBAction func actionClassificationperform(_ sender: UIButton) {
        if classificationAction == 0 {
            if classificationNameTF.text != ""{
                self.addUpdateClassifiation(classificationName: classificationNameTF.text ?? "" , classificationID: 0)
            }else {
                self.view.makeToast("Please add Classification.")
            }
        }else if classificationAction == 1 {
            if classificationNameTF.text != ""{
                let name = classificationNameTF.text
                
                self.apiGetClassificationDetails?.cLASSIFICATION?.forEach({ dataC in
                    print("self.selectedClassification \(self.selectedClassification) , \(dataC.classification)")
                    if dataC.classification == self.selectedClassification {
                        self.addUpdateClassifiation(classificationName: name ?? "" , classificationID: dataC.id ?? 0)
                    }
                })
                
            }else {
                self.view.makeToast("Please add Classification.")
            }
        }else {
            if classificationNameTF.text != ""{
                let name = classificationNameTF.text
                self.apiGetClassificationDetails?.cLASSIFICATION?.forEach({ dataC in
                    if dataC.classification == name {
                        self.addUpdateClassifiation(classificationName: name ?? "" , classificationID: dataC.id ?? 0)
                    }
                })
                
            }else {
                self.view.makeToast("Please add Classification.")
            }
            
        }
    }
    func addUpdateClassifiation(classificationName : String , classificationID:Int) {
        self.apiGetClassificationDetails = nil
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
             
        let customerId = userDefaults.string(forKey: "CustomerID") ?? ""
        let companyId = userDefaults.string(forKey: "companyID") ?? ""
        var urlString = ""
         if classificationAction == 2 {
            urlString = "https://lsp.totallanguage.com/CustomerManagement/CustomerDetail/GetData?methodType=ADDUPDATECLASSIFICATION&classification=&id=\(classificationID)&active=0"
        }else {
            urlString = "https://lsp.totallanguage.com/CustomerManagement/CustomerDetail/GetData?methodType=ADDUPDATECLASSIFICATION&classification=\(classificationName)&id=\(classificationID)&active=1&Companyid=\(companyId)"
        }
        let urlNew:String = urlString.replacingOccurrences(of: " ", with: "%20")
        print("url for classification \(urlString)")
        
                AF.request(urlNew, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        print("respose is \(response)")
                        self.classificationNameTF.text = ""
                        self.classificationBtn.setTitle("", for: .normal)
                        self.classificationView.visibility = .gone
                        if classificationAction == 0 {
                            self.view.makeToast("Classification added successfully.")
                        }else if classificationAction == 1{
                            self.view.makeToast("Classification updated successfully.")
                        }else if classificationAction == 2{
                            self.view.makeToast("Classification deleted successfully.")
                        }else {
                            
                        }
                       
                            getCustomerDetail()
                        
                        
                    })}
        else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
     }
    func getClassificationDetails(){
        if Reachability.isConnectedToNetwork() {
        self.apiGetClassificationDetails = nil
        self.classificationArr.removeAll()
        SwiftLoader.show(animated: true)
              /*  let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(UserDefaults.standard.value(forKey:"token") ?? "")",
                           "cache-control": "no-cache"
                       ]
               // print("😗---hitApiSignUpUser -" , Api.profile.url) 10/01/2021 */
        let customerId = userDefaults.string(forKey: "CustomerID") ?? ""
        let companyId = userDefaults.string(forKey: "companyID") ?? ""
        let urlString = "https://lsp.totallanguage.com/CustomerManagement/CustomerDetail/GetData?methodType=CLASSIFICATION&UserID=\(customerId)&UserType=Customer&CompanyId=\(companyId)"
        print("url for classification \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success ")
                            guard let daata76 = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiGetClassificationDetails = try jsonDecoder.decode(ApiGetClassificationDetails.self, from: daata76)
                               print("Success")
                                                                
                                self.apiGetClassificationDetails?.cLASSIFICATION?.forEach({ classificationData in
                                    let titleName = classificationData.classification ?? ""
                                    self.classificationArr.append(titleName)
                                })
                                
                               
                            } catch{
                                
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                           
                        }
                    })}
        else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
     }
    
    func getCustomerDetail(){
        if Reachability.isConnectedToNetwork() {
        self.apiCustomerDetailResponseModel = nil
        SwiftLoader.show(animated: true)
              /*  let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(UserDefaults.standard.value(forKey:"token") ?? "")",
                           "cache-control": "no-cache"
                       ]
               // print("😗---hitApiSignUpUser -" , Api.profile.url) 10/01/2021 */
        let customerId = userDefaults.string(forKey: "CustomerID") ?? ""
        
        let urlString = "https://lsp.totallanguage.com/CustomerManagement/CustomerDetail/GetCustomerDetails?methodType=CustomerDetails&CustomerID=\(customerId)"
        print("url to get schedule \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success ")
                            guard let daata77 = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiCustomerDetailResponseModel = try jsonDecoder.decode(ApiCustomerDetailResponseModel.self, from: daata77)
                               print("Success")
                                let content = self.apiCustomerDetailResponseModel?.customerDetails
                                updateSwitchState(switchh: prioritySwitch, previousState: content?.priority ?? false)
                                updateSwitchState(switchh: claimSwitch, previousState: content?.claim ?? false)
                             
                                updateSwitchState(switchh: servieVerificationSwitch, previousState: content?.isServiceVerificication ?? false)
                                updateSwitchState(switchh: willScheduleOnsiteSwitch, previousState: content?.willProvideOnsite ?? false)
                                updateSwitchState(switchh: scheduleTransaltionServiceSwitch, previousState: content?.willProvideTranslation ?? false)
                                updateSwitchState(switchh: invoiceBoatchingSwitch, previousState: content?.invoiceBatch ?? false)
                                updateSwitchState(switchh: purchaseOrderSwitch, previousState: content?.purchaseOrder ?? false)
                                updateSwitchState(switchh: refrenceSwitch, previousState: content?.reference ?? false)
                                updateSwitchState(switchh: isLogisticVisibleSwitch, previousState: content?.isLogisticsVisible ?? false)
                                updateSwitchState(switchh: isSpeciallyVisibleSwitch , previousState: content?.isSpecialtyVisible
                                                    ?? false)
                                //updateSwitchState(switchh: sameAsBillingAddressSwitch, previousState: content?.bi ?? false)
                                
                                
                                self.userNameTF.text =  content?.userName ?? ""
                                self.emailTF.text = content?.email ?? ""
                                self.firstNameTF.text = content?.firstName ?? ""
                                self.lastNameTF.text = content?.lastName ?? ""
                                self.billingContactTF.text = content?.billingContactName ?? ""
                                self.companyNameTF.text = content?.officialCompany ?? ""
                                self.customerfullNameTF.text = content?.customerFullName ?? ""
                                self.passwordTF.text = content?.password ?? ""
                                self.faxTF.text = content?.fAX ?? ""
                                self.mobileNumberTF.text = content?.mobilePhone ?? ""
                                self.billingPhoneTF.text = content?.billingPhone ?? ""
                                self.billingExtensionTF.text = content?.billingExtension ?? ""
                                self.websiteTF.text = content?.website ?? ""
                                self.notesTF.text = content?.notes ?? ""
                                self.groupTF.text = content?.groupID ?? ""
                                self.address1TF.text = content?.address?.address1 ?? ""
                                self.address3TF.text = content?.address?.address3 ?? ""
                                self.cityTF.text = content?.address?.city ?? ""
                                self.stateTF.text = content?.address?.stateName ?? ""
                                self.zipCodeTF.text = content?.address?.zipCode ?? ""
                                self.billingCityTF.text = content?.address?.billingCity ?? ""
                                self.billingStateTF.text = content?.address?.billingStateName ?? ""
                                self.billingAddressTF.text = content?.address?.billingAddress ?? ""
                                self.billingZipCodeTF.text = content?.address?.billingZipCode ?? ""
                                self.address2TF.text = content?.address?.address2 ?? ""
                                getClassificationDetails()
                            } catch{
                                
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                           
                        }
                    })}
            else {
                self.view.makeToast(ConstantStr.noItnernet.val)
            }
     }
    func updateUI(){
        self.userNameTF.setLeftPaddingPoints(20)
        self.passwordTF.setLeftPaddingPoints(20)
        self.firstNameTF.setLeftPaddingPoints(20)
        self.address1TF.setLeftPaddingPoints(20)
        self.address2TF.setLeftPaddingPoints(20)
        self.address3TF.setLeftPaddingPoints(20)
        self.cityTF.setLeftPaddingPoints(20)
        self.groupTF.setLeftPaddingPoints(20)
        self.lastNameTF.setLeftPaddingPoints(20)
        self.companyNameTF.setLeftPaddingPoints(20)
        self.customerfullNameTF.setLeftPaddingPoints(20)
        self.billingCityTF.setLeftPaddingPoints(20)
        self.emailTF.setLeftPaddingPoints(20)
        self.billingContactTF.setLeftPaddingPoints(20)
        self.billingPhoneTF.setLeftPaddingPoints(20)
        self.billingStateTF.setLeftPaddingPoints(20)
        self.websiteTF.setLeftPaddingPoints(20)
        self.faxTF.setLeftPaddingPoints(20)
        self.billingZipCodeTF.setLeftPaddingPoints(20)
        self.mobileNumberTF.setLeftPaddingPoints(20)
        self.mobileExtensionTF.setLeftPaddingPoints(20)
        self.notesTF.setLeftPaddingPoints(20)
        self.billingAddressTF.setLeftPaddingPoints(20)
        self.zipCodeTF.setLeftPaddingPoints(20)
        self.stateTF.setLeftPaddingPoints(20)
        self.classificationNameTF.setLeftPaddingPoints(20)
        self.telephoneAccessCodeTF.setLeftPaddingPoints(20)
        setRightViewIcon(icon: UIImage(named: "remove_red_eye")!, txtField: passwordTF)
        self.prioritySwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.70)
        self.claimSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.70)
        self.servieVerificationSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.70)
        //self.claimSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.70)
        self.willScheduleOnsiteSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.70)
        self.scheduleTransaltionServiceSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.70)
        self.invoiceBoatchingSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.70)
        self.purchaseOrderSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.70)
        self.claimSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.70)
        self.refrenceSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.70)
        self.isSpeciallyVisibleSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.70)
        self.isLogisticVisibleSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.70)
        self.sameAsBillingAddressSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.70)
    }
    func setRightViewIcon(icon: UIImage , txtField : UITextField) {

            let btnView = UIButton(frame: CGRect(x: 0, y: 0, width:50, height: 50))
            btnView.setImage(icon, for: .normal)
            btnView.imageEdgeInsets = UIEdgeInsets(top: -10, left: -36, bottom: -10, right:  10)
            btnView.imageView?.contentMode = .scaleAspectFit
            if txtField == passwordTF{
                btnView.tag = 1
                btnView.addTarget(self, action: #selector(self.showButtonTapped), for: .touchUpInside)
            }
            txtField.rightViewMode = .always
            txtField.rightView = btnView
        }
        @objc func showButtonTapped(_ sender: UIButton) {
                    sender.isSelected = !sender.isSelected
                    if sender.isSelected{
                        
                        sender.setImage(UIImage(named: "eye close"), for: .normal)
                        if sender.tag == 1 {
                            passwordTF.isSecureTextEntry=false
                        }
                        
                    }
                    else {
                        sender.setImage(UIImage(named: "remove_red_eye"), for: .normal)
                        if sender.tag == 1 {
                            passwordTF.isSecureTextEntry=true
                        }
                    }
            }
    func updateSwitchState(switchh :UISwitch , previousState: Bool){
        
        if previousState {
            switchh.isOn = true
        }else {
            switchh.isOn = false
        }
        switchh.addTarget(self, action: #selector(priorityswitchStateChange), for: .valueChanged)
    }
    @objc func priorityswitchStateChange(){
        print("Priority switch ")
    }
}
