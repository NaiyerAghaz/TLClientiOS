//
//  LoginViewModel.swift
//  TLClientApp
//
//  Created by Naiyer on 8/7/21.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class LoginVM {
    let userNameTFPublishObject = PublishSubject<String>()
    let emailTFPublishObject = PublishSubject<String>()
    let userProvider = MoyaProvider<AuthServices>()
    
    var updateDeviceData = UpdatedUserDeviceToken()
    var user = UserDetail()
    
    private let disposeBag = DisposeBag()
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(userNameTFPublishObject.asObserver().startWith(""),emailTFPublishObject.asObserver().startWith("")).map{ username, email in
            return username.count > 3 && email.count > 3
            
        }.startWith(false)
    }
    public func userLogin(UserName: String,Password: String,Ip: String,Latitude: String,Longitude: String, complitionBlock: @escaping(Bool?, Error?) -> ()){
        
        ApiServices.shareInstace.getDataFromApi(url: APi.login.url, para: ApiServices.shareInstace.loginRequest(UserName: UserName, Password: Password, Ip: Ip, Latitude: Latitude, Longitude: Longitude)) {(response, error) in
            print("loginDetails are : \(APi.login.url) ,parameter ", ApiServices.shareInstace.loginRequest(UserName: UserName, Password: Password, Ip: Ip, Latitude: Latitude, Longitude: Longitude) ,response)
//            print("EditBankDetails->", response)
            if response != nil {
               
                self.user = UserDetail.getUserDetails(dicts: response!)
                SwiftLoader.hide()
                let userDict = self.user.userDetails![0] as! DetailsModal
               
                if userDict.Message != "" {
                    complitionBlock(false, error)
                }
                else {
                    complitionBlock(true, nil)
                }
                
                
            }
            else {
                complitionBlock(false, error)
            }
            
            
        }
    }
    
     func addUpdateUserDeviceToken(TokenID: String,Status: String,UserID: String,DeviceType: String,voipToken: String, complitionBlock: @escaping(Bool?, Error?) -> ()){
        
        ApiServices.shareInstace.getDataFromApi(url: APi.addUpdateUserDeviceToken.url, para: ApiServices.shareInstace.deviceTokenReq(TokenID: TokenID, Status: Status, UserID: UserID, DeviceType: DeviceType, voipToken: voipToken)) {(response, error) in
           
           
            print("UpdatedUserDeviceToken->", response)
            if response != nil {
                self.updateDeviceData = UpdatedUserDeviceToken.getUserDetails(dicts: response!)
                let data = self.updateDeviceData.table?[0] as! TableModel
                if data.success == "1" {
                    complitionBlock(true, nil)
                }
               }
            else {
                complitionBlock(false, error)
            }
            
            
            
            
        }
    }
    func twilioRegisterWithAccessToken( userID: String, CHandler:@escaping(Bool?) ->()){
        VDOCallViewModel().getTwilioToken { model, err in
            if err == nil {
                print("model------------->",model?.token)
                CallManagerVM().getTwilioWithCompletion(userID: userID, deviceToken: (model?.token?.data(using: .utf8))!) { success in
                    if success == true {
                        CHandler(true)
                        
                    }
                    else {
                        CHandler(false)
                    }
                }
                
        }
        
       
    }
    }
    
    
}
