//
//  InviteWithDialVC.swift
//  TLClientApp
//
//  Created by Naiyer on 10/2/21.
//

import UIKit
import XLPagerTabStrip

class InviteWithDialVC: UIViewController,IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo
    {
        
        return IndicatorInfo(title:"Dial")
    }
    var inviteVmodel = InviteViewModel()
    @IBOutlet weak var mobileTF: ACFloatingTextfield!
    @IBOutlet weak var lastNameTF: ACFloatingTextfield!
    @IBOutlet weak var firstNameTF: ACFloatingTextfield!
    
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
         else if mobileTF.text?.trim().count == 0 {
            mobileTF.shake()
             
             return self.view.makeToast("Please enter your mobile", position: .top)
         }
        SwiftLoader.show(animated: true)
        let para = inviteVmodel.inviteDailReq(roomNo: actualRoom ?? "0", pid:inviteVmodel.random(digits: 10), mobile: mobileTF.text!, fName: firstNameTF.text!, lName: lastNameTF.text!, fromUserID: fromUserID!)
            inviteVmodel.inviteWithEmail(parameter: para) { success, err in
                if success! {
                    SwiftLoader.hide()
                    self.dismiss(animated: true, completion: nil)
                }
          }
        
    }
}
