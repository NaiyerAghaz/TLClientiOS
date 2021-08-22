//
//  LoginVC.swift
//  TLClientApp
//
//  Created by Naiyer on 8/7/21.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import LocalAuthentication
import AVKit

class LoginVC: UIViewController {
    var navigator = Navigator()
    
    @IBOutlet weak var btnSeenPassword: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnFaceAndTouchID: UIButton!
    private let loginVModel = LoginVM()
    private let disposebag = DisposeBag()
    
    var context = LAContext()
    var err: NSError?
    
    static func createWith(navigator: Navigator, storyboard: UIStoryboard) -> LoginVC {
        return storyboard.instantiateViewController(ofType: LoginVC.self).then { viewController in
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginUpdate()
        
        // Do any additional setup after loading the view.
    }
    func loginUpdate() {
        userNameTF.rx.text.map { $0 ?? ""}.bind(to: loginVModel.userNameTFPublishObject).disposed(by: disposebag)
        passwordTF.rx.text.map{$0 ?? ""}.bind(to: loginVModel.emailTFPublishObject).disposed(by: disposebag)
        //        loginVModel.isValid().bind(to: btnLogin.rx.isEnabled).disposed(by: disposebag)
        //        loginVModel.isValid().map{$0 ? 1: 0.1}.bind(to: btnLogin.rx.alpha).disposed(by: disposebag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if keychainServices.getKeychaindata(key: "touchID") != nil {
            self.btnFaceAndTouchID.isHidden = false
        }
        else{
            self.btnFaceAndTouchID.isHidden = true
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func btnForgotTabbed(_ sender: Any) {
        navigator.show(segue: .forgetPassword, sender: self)
    }
    
    @IBAction func btnLoginTabbed(_ sender: Any) {
        
        if userNameTF.text!.isEmpty {
            return self.view.makeToast("Please enter your UserName", duration: 1.0, position: .top)
        }
        else if passwordTF.text!.isEmpty {
            return self.view.makeToast("Please enter your Password", duration: 1.0, position: .top)
        }
        
        SwiftLoader.show(title: "Login...", animated: true)
        loginVModel.userLogin(UserName: userNameTF.text!, Password: passwordTF.text!, Ip: "M", Latitude: "", Longitude: "") { resp, err in
            SwiftLoader.hide()
            if resp! {
                let item = self.loginVModel.user.userDetails![0] as! DetailsModal
                keychainServices.save(key: "username", data: Data(self.userNameTF.text!.utf8))
                keychainServices.save(key: "password", data: Data(self.passwordTF.text!.utf8))
                self.view.makeToast("You have logged in", duration: 1.0, position: .top)
                if  keychainServices.getKeychaindata(key: "touchID") != nil {
                    self.navigator.show(segue: .home(data: item), sender: self)
                }
                else {
                    let alert = UIAlertController(title: "Do you want to save this login to use FACE ID/TOUCH ID", message: "", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel){ cancel  in
                        self.navigator.show(segue: .home(data: item), sender: self)
                    }
                    
                    let yes = UIAlertAction(title: "Yes", style: .destructive) { alert in
                        self.btnFaceAndTouchID.isHidden = false
                        keychainServices.save(key: "touchID", data: Data("true".utf8))
                        self.navigator.show(segue: .home(data: item), sender: self)
                    }
                    alert.addAction(cancel)
                    alert.addAction(yes)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                let userDict = self.loginVModel.user.userDetails![0] as! DetailsModal
                self.view.makeToast(userDict.Message, duration: 1.0, position: .top)
            }
        }
        
    }
    @IBAction func btnSeenPasswordTabbed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected == true {
            passwordTF.isSecureTextEntry = false
            btnSeenPassword.setImage(UIImage(named: "ic_seenpassword"), for: .normal)
            
        }
        else {
            passwordTF.isSecureTextEntry = true
            btnSeenPassword.setImage(UIImage(named: "ic_unseenpassword"), for: .normal)
        }
        
        
    }
    @IBAction func btnFaceIDTouchID(_ sender: UIButton) {
        let localString = "Biometric Authentication!"
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){
            
            if context.biometryType == .faceID {
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                    if success{
                        DispatchQueue.main.async {
                            SwiftLoader.show(title: "Login...", animated: true)
                            self.biometricAuthentication(username: CEnumClass.share.loadKeydata(keyname: "username"), pwd: CEnumClass.share.loadKeydata(keyname: "password"))
                        }
                        
                    }
                }
                
                
            }
            else if context.biometryType == .touchID  {
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                    if success{
                        DispatchQueue.main.async {
                            SwiftLoader.show(title: "Login..", animated: true)
                            self.biometricAuthentication(username: CEnumClass.share.loadKeydata(keyname: "username"), pwd: CEnumClass.share.loadKeydata(keyname: "password"))
                        }
                        
                    }
                }
            }
        }
        
    }
    
    // MARK: Func Call
    
    
    public func biometricAuthentication(username: String, pwd: String){
        
        loginVModel.userLogin(UserName: username, Password: pwd, Ip: "M", Latitude: "", Longitude: "") { resp, err in
            SwiftLoader.hide()
            if resp! {
                if !(self.navigationController?.topViewController is HomeViewController) {
                    print("MainSegue LoginViewController")
                    self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                }
                
                
            }
            else {
                let userDict = self.loginVModel.user.userDetails![0] as! DetailsModal
                self.view.makeToast(userDict.Message, duration: 1.0, position: .top)
            }
            
            
            
        }
    }
    
}
