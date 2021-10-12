//
//  InviteWithEmailVC.swift
//  TLClientApp
//
//  Created by Naiyer on 10/1/21.
//

import UIKit
import XLPagerTabStrip


class InviteWithEmailVC: UIViewController,IndicatorInfoProvider {

    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo
    {
        
        return IndicatorInfo(title:"Email")
    }
    
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var phoneCodeTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var btnMobile2FA: UIButton!
    @IBOutlet weak var btnEmail2FA: UIButton!
    
    @IBOutlet weak var btnNo2FA: UIButton!
    var inviteVmodel = InviteViewModel()
    var factorStr: String?
    var isAuthentication = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func btnInviteTapped(_ sender: Any) {
       if firstNameTF.text?.trim().count == 0 {
        firstNameTF.shake()
        return self.view.makeToast("Please enter your first name", position: .top)
        }
        else if lastNameTF.text?.trim().count == 0 {
            lastNameTF.shake()
            return self.view.makeToast("Please enter your last name", position: .top)
         }
        else if emailTF.text?.trim().count == 0 {
            emailTF.shake()
            
            return self.view.makeToast("Please enter your email", position: .top)
        
         }
        else if isAuthentication == 0 {
            return self.view.makeToast("Please select authentication factor", position: .top)
        }
        SwiftLoader.show(animated: true)
        let reqPara = inviteVmodel.inviteEmailReq(emailID: emailTF.text!, roomNo: actualRoom ?? "0", pid: inviteVmodel.random(digits: 10), mobile: mobileTF.text!, fName: firstNameTF.text!, lName: lastNameTF.text!, fromUserID: fromUserID ?? "0", authFactor: factorStr!)
        inviteVmodel.inviteWithEmail(parameter: reqPara) { success, err in
            if success! {
                SwiftLoader.hide()
                self.dismiss(animated: true, completion: nil)
            }
        }
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
    
    
}
