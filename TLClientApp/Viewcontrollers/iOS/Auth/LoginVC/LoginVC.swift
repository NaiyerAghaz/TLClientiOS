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
import Alamofire
class LoginVC: UIViewController {
    var navigator = Navigator()
    
    @IBOutlet weak var btnSeenPassword: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnFaceAndTouchID: UIButton!
    private let loginVModel = LoginVM()
    private let disposebag = DisposeBag()
    var apiCheckCallStatusResponseModel = [ApiCheckCallStatusResponseModel]()
    var context = LAContext()
    var err: NSError?
    var newErr:NSError?
    static func createWith(navigator: Navigator, storyboard: UIStoryboard) -> LoginVC {
        return storyboard.instantiateViewController(ofType: LoginVC.self).then { viewController in
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginUpdate()
    }
    
    func loginUpdate() {
        userNameTF.textColor = UIColor.white
        passwordTF.textColor = UIColor.white
        //  userNameTF.rx.text.map { $0 ?? ""}.bind(to: loginVModel.userNameTFPublishObject).disposed(by: disposebag)
        // passwordTF.rx.text.map{$0 ?? ""}.bind(to: loginVModel.emailTFPublishObject).disposed(by: disposebag)
        //        loginVModel.isValid().bind(to: btnLogin.rx.isEnabled).disposed(by: disposebag)
        //        loginVModel.isValid().map{$0 ? 1: 0.1}.bind(to: btnLogin.rx.alpha).disposed(by: disposebag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let touchID = userDefaults.value(forKey: "touchID") ?? false
        
        if  touchID as! Bool  {
            geBiometricTouchAndFace()
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
        if Reachability.isConnectedToNetwork() {
            
            SwiftLoader.show(title: "Login...", animated: true)
            
            
            loginVModel.userLogin(UserName: userNameTF.text!, Password: passwordTF.text!, Ip: "M", Latitude: "", Longitude: "") { resp, err in
                
                if resp! {
                 
                    let item = self.loginVModel.user.userDetails![0] as! DetailsModal
                    if item.userTypeID == "4" || item.userTypeID == "7" || item.userTypeID == "8" {
                        
                        let fcmToken = userDefaults.string(forKey: "fcmToken") ?? ""
                        
                        self.loginVModel.addUpdateUserDeviceToken(TokenID: fcmToken, Status: "Y", UserID: item.UserID, DeviceType: "I", voipToken: "") { status, err in
                            if status == true {
                                userDefaults.set(item.imageData, forKey: "ImageData")
                                userDefaults.set(self.userNameTF.text!, forKey:"username" )
                                userDefaults.set(item.companyID, forKey:"companyID")
                                userDefaults.set(self.passwordTF.text!, forKey: "password" )
                                userDefaults.set(item.UserID, forKey: .kUSER_ID)
                                userDefaults.set(item.companyName, forKey: "companyName")
                                userDefaults.set(item.userTypeID, forKey: "userTypeID")
                                userDefaults.set(item.customerID, forKey: "CustomerID")
                                userDefaults.set(item.timeZone, forKey: "TimeZone")
                                userDefaults.set(item.zoneShortForm, forKey: "zoneShortForm")
                                userDefaults.set(item.LoginUserTypeID, forKey:"LoginUserTypeID")
                                userDefaults.set(item.firstName, forKey:"firstName")
                                userDefaults.set(item.lastName, forKey:"lastName")
                                print("time zone on login vc ", item.timeZone)
                                
                                
                                let touchID = userDefaults.value(forKey: "touchID") ?? false
                                //  if  keychainServices.getKeychaindata(key: "touchID") != nil {
                                if touchID as! Bool {
                                    self.loginVModel.twilioRegisterWithAccessToken(userID: item.UserID) { success in
                                        if success == true {
                                            
                                            self.checkSingleSignin(userID: item.UserID, guid:userDefaults.string(forKey: "userGUID") ?? "") { res, err in
                                                if res == true {
                                                    SwiftLoader.hide()
                                                    self.view.makeToast("You have logged in", duration: 1.0, position: .top)
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ){
                                                        let storyboard = UIStoryboard(name: Storyboard_name.home, bundle: nil)
                                                        let vc = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                                                        self.navigationController?.pushViewController(vc, animated: true)
                                                    }
                                                }
                                                else {
                                                    SwiftLoader.hide()
                                                    self.showAlert()
                                                }
                                            }
                                        }
                                    }
                                }
                                else {
                                    let alert = UIAlertController(title: "Do you want to save this login to use FACE ID/TOUCH ID", message: "", preferredStyle: .alert)
                                    let cancel = UIAlertAction(title: "Cancel", style: .cancel){ cancel  in
                                        
                                        self.loginVModel.twilioRegisterWithAccessToken(userID: item.UserID) { success in
                                            if success == true {
                                                //  self.loginVModel.registerForPushNotification(fcmToken: fcmToken, userid: item.UserID)
                                                self.checkSingleSignin(userID: item.UserID, guid:userDefaults.string(forKey: "userGUID") ?? "") { res, err in
                                                    if res == true {
                                                        SwiftLoader.hide()
                                                        let storyboard = UIStoryboard(name: Storyboard_name.home, bundle: nil)
                                                        let vc = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                                                        self.navigationController?.pushViewController(vc, animated: true)
                                                    }
                                                    else {
                                                        SwiftLoader.hide()
                                                        self.showAlert()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    let yes = UIAlertAction(title: "Yes", style: .destructive) { alert in
                                        self.btnFaceAndTouchID.isHidden = false
                                        
                                        userDefaults.set(true, forKey: "touchID" )
                                        userDefaults.set(item.userName, forKey: "userNameForTouchID" )
                                        userDefaults.set(item.password, forKey: "userPasswordForTouchID")
                                        keychainServices.save(key: "touchID", data: Data("true".utf8))
                                        
                                        let localString = "Biometric Authentication!"
                                        
                                        if self.context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &self.newErr){
                                            
                                            if self.context.biometryType == .faceID {
                                                self.context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                                                    if success{
                                                        DispatchQueue.main.async {
                                                            SwiftLoader.show(title: "Login...", animated: true)
                                                            
                                                            self.loginVModel.twilioRegisterWithAccessToken(userID: item.UserID) { success in
                                                                if success == true {
                                                                    //  self.loginVModel.registerForPushNotification(fcmToken: fcmToken, userid: item.UserID)
                                                                    self.checkSingleSignin(userID: item.UserID, guid:userDefaults.string(forKey: "userGUID") ?? "") { res, err in
                                                                        if res == true {
                                                                            SwiftLoader.hide()
                                                                            let storyboard = UIStoryboard(name: Storyboard_name.home, bundle: nil)
                                                                            let vc = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                                                                            self.navigationController?.pushViewController(vc, animated: true)
                                                                        }
                                                                        else {
                                                                            SwiftLoader.hide()
                                                                            self.showAlert()
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                    }else {
                                                        SwiftLoader.hide()
                                                    }
                                                }
                                            }
                                            else if self.context.biometryType == .touchID  {
                                                self.context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                                                    if success{
                                                        DispatchQueue.main.async {
                                                            SwiftLoader.show(title: "Login..", animated: true)
                                                            
                                                            self.loginVModel.twilioRegisterWithAccessToken(userID: item.UserID) { success in
                                                                if success == true {
                                                                    //  self.loginVModel.registerForPushNotification(fcmToken: fcmToken, userid: item.UserID)
                                                                    self.checkSingleSignin(userID: item.UserID, guid:userDefaults.string(forKey: "userGUID") ?? "") { res, err in
                                                                        if res == true {
                                                                            SwiftLoader.hide()
                                                                            let storyboard = UIStoryboard(name: Storyboard_name.home, bundle: nil)
                                                                            let vc = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                                                                            self.navigationController?.pushViewController(vc, animated: true)
                                                                        }
                                                                        else {
                                                                            SwiftLoader.hide()
                                                                            self.showAlert()
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    alert.addAction(cancel)
                                    alert.addAction(yes)
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                        
                    }
                    else {
                        SwiftLoader.hide()
                        let alert = UIAlertController(title: "These credentials not belongs to Client App. If you want redirect to Vendor app please click ok", message: "", preferredStyle: .alert)
                        let cancel = UIAlertAction(title: "Cancel", style: .cancel){ cancel  in
                            
                        }
                        
                        let yes = UIAlertAction(title: "Okay", style: .destructive) { alert in
                            
                            
                        }
                        alert.addAction(cancel)
                        alert.addAction(yes)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else {
                    let userDict = self.loginVModel.user.userDetails?.firstObject  as! DetailsModal
                    self.view.makeToast(userDict.Message, duration: 1.0, position: .top)
                }
            }}
        else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
    }
    //MARK: Signle Signin
    
    func checkSingleSignin(userID:String, guid: String,complitionHandler:@escaping(Bool?, Error?) ->()){
        if Reachability.isConnectedToNetwork() {
            let urlString = APi.checkSingleUser.url
            let srchString = "<INFO><USERID>\(userID)</USERID><GUID>\(guid)</GUID></INFO>"
            let parameters = [
                "strSearchString":srchString
            ] as [String:Any]
            
            AF.request(urlString, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseData(completionHandler: { (response) in
                    
                    switch(response.result){
                        
                    case .success(_):
                        guard let daata94 = response.data else { return }
                        do {
                            let jsonDecoder = JSONDecoder()
                            self.apiCheckCallStatusResponseModel = try jsonDecoder.decode([ApiCheckCallStatusResponseModel].self, from: daata94)
                            
                            let str = self.apiCheckCallStatusResponseModel.first?.result ?? ""
                            
                            
                            let data = str.data(using: .utf8)!
                            do {
                                //
                                
                                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                                {
                                    let newjson = jsonArray.first
                                    let userInfo = newjson?["UserGuIdInfo"] as? [[String:Any]]
                                    
                                    if userInfo!.count > 0 {
                                        complitionHandler(true, nil)
                                    }
                                    else {
                                        complitionHandler(false, nil)
                                    }
                                    
                                } else {
                                    print("bad json")
                                }
                            } catch let error as NSError {
                                print(error)
                            }
                            
                        } catch{
                            
                            print("error block getVendorIDs Data  " ,error)
                        }
                    case .failure(_):
                        print("Respose Failure getVendorIDs ")
                        
                    }
                })}
        else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
    }
    func showAlert(){
        let refreshAlert = UIAlertController(title: "Someone Logged in", message: "The customer already logged-in on another device.", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    //MARK: Register Twilio AccessToken
    private func registerTwilioAccessToken(with item: DetailsModal) {
        self.loginVModel.twilioRegisterWithAccessToken(userID: item.UserID) { success in
            if success == true {
                //self.navigator.show(segue: .home(data: item), sender: self)
                let storyboard = UIStoryboard(name: Storyboard_name.home, bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(vc, animated: true)
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
        
        
        geBiometricTouchAndFace()
        
    }
    public func geBiometricTouchAndFace(){
        let localString = "Biometric Authentication!"
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){
            
            if context.biometryType == .faceID {
                
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                    if success{
                        SwiftLoader.show(title: "Login...", animated: true)
                        DispatchQueue.main.async {
                            
                            let userName = GetPublicData.sharedInstance.userNameForTouchID
                            let userPassword = GetPublicData.sharedInstance.userPasswordForTouchID
                            
                            print("user name and password ",userName, userPassword)
                            //  self.biometricAuthentication(username: CEnumClass.share.loadKeydata(keyname: "username"), pwd: CEnumClass.share.loadKeydata(keyname: "password"))
                            self.biometricAuthentication(username: userName, pwd: userPassword)
                        }
                        
                    }
                }
                
                
            }
            else if context.biometryType == .touchID  {
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                    if success{
                        DispatchQueue.main.async {
                            SwiftLoader.show(title: "Login..", animated: true)
                            let userName = GetPublicData.sharedInstance.userNameForTouchID
                            let userPassword = GetPublicData.sharedInstance.userPasswordForTouchID
                            print("user name and password ",userName, userPassword)
                            // self.biometricAuthentication(username: CEnumClass.share.loadKeydata(keyname: "username"), pwd: CEnumClass.share.loadKeydata(keyname: "password"))
                            self.biometricAuthentication(username: userName, pwd: userPassword)
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    // MARK: Func Call
    
    
    public func biometricAuthentication(username: String, pwd: String){
        
        loginVModel.userLogin(UserName: username, Password: pwd, Ip: "M", Latitude: "", Longitude: "") { resp, err in
            
            if resp! {
                
                let item = self.loginVModel.user.userDetails![0] as! DetailsModal
                if item.userTypeID == "4" || item.userTypeID == "7" || item.userTypeID == "8" {
                    
                    let fcmToken = userDefaults.string(forKey: "fcmToken") ?? ""
                    
                    self.loginVModel.addUpdateUserDeviceToken(TokenID: fcmToken, Status: "Y", UserID: item.UserID, DeviceType: "I", voipToken: "") { status, err in
                        if status == true {
                            userDefaults.set(item.imageData, forKey: "ImageData")
                            userDefaults.set(username, forKey:"username" )
                            userDefaults.set(item.companyID, forKey:"companyID")
                            userDefaults.set(pwd, forKey: "password" )
                            userDefaults.set(item.UserID, forKey: .kUSER_ID)
                            userDefaults.set(item.companyName, forKey: "companyName")
                            userDefaults.set(item.userTypeID, forKey: "userTypeID")
                            userDefaults.set(item.customerID, forKey: "CustomerID")
                            userDefaults.set(item.timeZone, forKey: "TimeZone")
                            userDefaults.set(item.zoneShortForm, forKey: "zoneShortForm")
                            userDefaults.set(item.firstName, forKey:"firstName")
                            userDefaults.set(item.lastName, forKey:"lastName")
                            self.loginVModel.twilioRegisterWithAccessToken(userID: item.UserID) { success in
                                if success == true {
                                    
                                    self.checkSingleSignin(userID: item.UserID, guid:userDefaults.string(forKey: "userGUID") ?? ""){ res, err in
                                        if res == true {
                                            SwiftLoader.hide()
                                            self.view.makeToast("You have logged in", duration: 1.0, position: .top)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                                let storyboard = UIStoryboard(name: Storyboard_name.home, bundle: nil)
                                                let vc = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }
                                            
                                        }
                                        else {
                                            SwiftLoader.hide()
                                            self.showAlert()
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            SwiftLoader.hide()
                            let userDict = self.loginVModel.user.userDetails![0] as! DetailsModal
                            self.view.makeToast(userDict.Message, duration: 1.0, position: .top)
                        }
                    }
                }else {
                    
                    SwiftLoader.hide()
                    let alert = UIAlertController(title: "These credentials not belongs to Client App. If you want redirect to Vendor app please click ok", message: "", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel){ cancel  in
                        
                    }
                    
                    let yes = UIAlertAction(title: "Okay", style: .destructive) { alert in
                    }
                    alert.addAction(cancel)
                    alert.addAction(yes)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                SwiftLoader.hide()
                let userDict = self.loginVModel.user.userDetails?.firstObject  as! DetailsModal
                self.view.makeToast(userDict.Message, duration: 1.0, position: .top)
            }
        }
        
    }
}
