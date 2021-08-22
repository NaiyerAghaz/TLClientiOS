//
//  ForgotPasswordVC.swift
//  TLClientApp
//
//  Created by Naiyer on 8/7/21.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    var forgotVM = ForgotViewModel()
    static func createWith(navigator: Navigator, storyboard: UIStoryboard) -> ForgotPasswordVC {
        return storyboard.instantiateViewController(ofType: ForgotPasswordVC.self).then { viewController in
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

       
    }
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.topItem?.title = ""
        CEnumClass.share.transParentNav(nav: self.navigationController)
    }
    @IBAction func btnSendTabbed(_ sender: Any) {
        if !emailTF.text!.isValidEmail(){
            return self.view.makeToast("Please enter valid email", duration: 1.0, position: .center)
        }
       else if emailTF.text!.isEmpty {
            return self.view.makeToast("Please enter your Email", duration: 1.0, position: .center)
        }
        else if userNameTF.text!.isEmpty {
            return self.view.makeToast("Please enter your UserName", duration: 1.0, position: .center)
        }
       
        SwiftLoader.show(title: "Sending...", animated: true)
        
        forgotVM.userForgotPWD(Email: emailTF.text!, UserName: userNameTF.text!) { resp, err in
            let errMsz = self.forgotVM.user.SuccessErrorDetails![0] as! ErrorModel
            if !resp! {
                UIAlertController.showAlertWithOkButton(controller: nil, message: errMsz.Message, completion: nil)
                self.view.makeToast(errMsz.Message, duration: 1.0, position: .bottom)
            }
            else {
                UIAlertController.showAlertWithOkButton(controller: nil, message: errMsz.Message) { status, message in
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
        }

    }
    

}
