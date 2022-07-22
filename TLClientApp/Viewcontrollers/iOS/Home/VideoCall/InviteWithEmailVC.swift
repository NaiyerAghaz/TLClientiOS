//
//  InviteWithEmailVC.swift
//  TLClientApp
//
//  Created by Naiyer on 10/1/21.
//

import UIKit
import XLPagerTabStrip


class InviteWithEmailVC: UIViewController,IndicatorInfoProvider, UITextFieldDelegate,MICountryPickerDelegate{
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        print("name-->",name, "code:",code, "dialcode:", dialCode)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo
    {
        return IndicatorInfo(title:"Email")
    }
    @IBOutlet weak var mobile2faView: UIView!
    
    @IBOutlet weak var no2faView: UIView!
    @IBOutlet weak var email2faView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var txtPhoneCode: UITextField!
    @IBOutlet weak var imgCountry: UIImageView!
    let picker = MICountryPicker()
    @IBOutlet weak var mobileTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    var vdoCallVM = VDOCallViewModel()
    @IBOutlet weak var btnMobile2FA: UIButton!
    @IBOutlet weak var btnEmail2FA: UIButton!
    var vdoModel = VDOCallViewModel()
    @IBOutlet weak var btnNo2FA: UIButton!
    var inviteVmodel = InviteViewModel()
    var factorStr: String?
    var isAuthentication = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        picker.delegate = self
        uiConfigure()
        companyDetailPermission()
    }
    public func uiConfigure(){
        let bundle = "assets.bundle/"
        
        let image = UIImage( named: bundle + "us.png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
        // self.countryCode = dialCode
        self.imgCountry.image = image
        txtfieldLayout(txt: lastNameTF, isView: false)
        txtfieldLayout(txt: firstNameTF, isView: false)
        txtfieldLayout(txt: emailTF, isView: false)
        txtfieldLayout(txt: txtPhoneCode, isView: true)
        let placeholder1 = txtPhoneCode.placeholder ?? ""
        txtPhoneCode.withImage(direction: .Right, image: UIImage(named: "ic_ddwon")!, colorSeparator: UIColor.black, colorBorder: UIColor.black)
        txtPhoneCode.attributedPlaceholder = NSAttributedString(string: placeholder1, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        let placeholder2 = mobileTF.placeholder ?? ""
        mobileTF.attributedPlaceholder = NSAttributedString(string: placeholder2, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
    }
    func companyDetailPermission(){
        SwiftLoader.show(animated: true)
        
        let req = vdoModel.companyReqDetails(userID: userDefaults.string(forKey: .kUSER_ID)!)
        vdoModel.getCompanydetails(req: req) { success, err in
            DispatchQueue.main.async {
                SwiftLoader.hide()
                print("getCompanydetails:",success)
                if self.vdoModel.apiCompanyDetailsModel?.resultData![0].eMAILFA == false
                {
                    self.email2faView.isHidden = true
                }
                if self.vdoModel.apiCompanyDetailsModel?.resultData![0].mOBILEFA == false
                {
                    self.mobile2faView.isHidden = true
                }
                if self.vdoModel.apiCompanyDetailsModel?.resultData![0].nOFA == false
                {
                    self.no2faView.isHidden = true
                }
            }
        }
    }
    
    @IBAction func btnInviteTapped(_ sender: Any) {
        if ((vdoModel.apiCompanyDetailsModel?.resultData![0].pARTCOUNT)!) <= vdoModel.conferrenceDetail.CONFERENCEInfo!.count {
            return self.view.makeToast("You have reached maximum participants limit", position: .top)
        }
        else if firstNameTF.text?.trim().count == 0 {
            firstNameTF.shake()
            return self.view.makeToast("Please enter your first name", position: .top)
        }
        else if lastNameTF.text?.trim().count == 0 {
            lastNameTF.shake()
            return self.view.makeToast("Please enter your last name", position: .top)
        }
        else if !emailTF.text!.isValidEmail() {
            emailTF.shake()
            
            return self.view.makeToast("Please enter your email", position: .top)
            
        }
        else if isAuthentication == 0 {
            return self.view.makeToast("Please select authentication factor", position: .top)
        }
        else if isAuthentication == 1 {
            if mobileTF.text!.isEmpty{
                return self.view.makeToast("Please enter your mobile", position: .top)
            }
        }
        
        if Reachability.isConnectedToNetwork() {
            SwiftLoader.show(animated: true)
            //fromUserID ?? "0"
            let mob:String = txtPhoneCode.text! + mobileTF.text!
            let reqPara = inviteVmodel.inviteEmailReq(emailID: emailTF.text!, roomNo: actualRoom ?? "0", pid: inviteVmodel.random(digits: 10), mobile: mob, fName: firstNameTF.text!, lName: lastNameTF.text!, fromUserID: GetPublicData.sharedInstance.userID, authFactor: factorStr!, calltype: "vri")
            inviteVmodel.inviteWithEmail(parameter: reqPara) { success, err in
                SwiftLoader.hide()
                // checkmark
                
                if success! {
                    
                    self.view.makeToast("Email has been sent", position: .center)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.presentingViewController!.presentingViewController!.dismiss(animated: true, completion: nil)
                    }
                    
                    
                }
            }}else {self.view.makeToast(ConstantStr.noItnernet.val)}
    }
    @IBAction func btn2FATapped(_ sender: UIButton) {
        if sender.tag == 1 {
            sender.isSelected = !sender.isSelected
            btnEmail2FA.isSelected = false
            btnNo2FA.isSelected = false
            isAuthentication = 1
            factorStr = "M"
            
        }
        else if sender.tag == 2 {
            sender.isSelected = !sender.isSelected
            btnMobile2FA.isSelected = false
            btnNo2FA.isSelected = false
            isAuthentication = 2
            factorStr = "E"
        }
        else if sender.tag == 3 {
            sender.isSelected = !sender.isSelected
            btnMobile2FA.isSelected = false
            btnEmail2FA.isSelected = false
            isAuthentication = 3
            factorStr = "N"
            
        }
    }
    
    
    @IBAction func selectPhoneCodeTapped(_ sender: Any) {
        picker.showCallingCodes = true
        picker.didSelectCountryClosure = { [self] name, code in
            picker.navigationController?.isNavigationBarHidden=true
            //picker.navigationController?.popViewController(animated: true)
            picker.dismiss(animated: true, completion: nil)
            
            
        }
        picker.didSelectCountryWithCallingCodeClosure = { name , code , dialCode in
            
            self.picker.navigationController?.isNavigationBarHidden=true
            //picker.navigationController?.popViewController(animated: true)
            print("code is ",code)
            let bundle = "assets.bundle/"
            
            let image = UIImage( named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
            
            self.txtPhoneCode.text = dialCode
            // self.countryCode = dialCode
            self.imgCountry.image = image
            self.picker.dismiss(animated: true, completion: nil)
            
        }
        self.present(picker, animated: true, completion: nil)
    }
    func txtfieldLayout(txt:UITextField,isView:Bool){
        if isView{
            
            phoneView.layer.borderWidth = 1
            phoneView.layer.borderColor = UIColor.white.cgColor
            
            phoneView.layer.cornerRadius = 1
            phoneView.layer.masksToBounds = true
        }
        else {
            txt.layer.borderWidth = 1
            txt.layer.borderColor = UIColor.white.cgColor
            let placeholder = txt.placeholder ?? ""
            txt.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            txt.layer.cornerRadius = 1
            txt.layer.masksToBounds = true
        }
        
        
        
    }
    
}
