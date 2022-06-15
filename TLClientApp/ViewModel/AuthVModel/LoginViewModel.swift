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
import Alamofire
import UIKit

class LoginVM {
    let userNameTFPublishObject = PublishSubject<String>()
    let emailTFPublishObject = PublishSubject<String>()
    let userProvider = MoyaProvider<AuthServices>()
    var apiCheckCallStatusResponseModel = [ApiCheckCallStatusResponseModel]()
    var updateDeviceData = UpdatedUserDeviceToken()
    var user = UserDetail()
    
    private let disposeBag = DisposeBag()
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(userNameTFPublishObject.asObserver().startWith(""),emailTFPublishObject.asObserver().startWith("")).map{ username, email in
            return username.count > 3 && email.count > 3
            
        }.startWith(false)
    }
    public func userLogin(UserName: String,Password: String,Ip: String,Latitude: String,Longitude: String, complitionBlock: @escaping(Bool?, Error?) -> ()){
        
        getDataFromApiLogin(url: APi.login.url, para: ApiServices.shareInstace.loginRequest(UserName: UserName, Password: Password, Ip: Ip, Latitude: Latitude, Longitude: Longitude)) {(response, error) in
          //  print("loginDetails are : \(APi.login.url) ,parameter ", ApiServices.shareInstace.loginRequest(UserName: UserName, Password: Password, Ip: Ip, Latitude: Latitude, Longitude: Longitude) ,response)
//            print("EditBankDetails->", response)
            if response != nil {
               
                self.user = UserDetail.getUserDetails(dicts: response!)
               
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
    func getDataFromApiLogin(url: URL, para: [String:Any], completionHandler:@escaping(NSDictionary?, Error?) -> ()){
        WebServices.postJson(url: url, jsonObject: para,completionHandler: {(response, _) in
            completionHandler(response as? NSDictionary, nil)
            SwiftLoader.hide()
        }){ (error, _) in
            print(error)
            completionHandler(nil, error as? Error)
            SwiftLoader.hide()
        }
    }
     func addUpdateUserDeviceToken(TokenID: String,Status: String,UserID: String,DeviceType: String,voipToken: String, complitionBlock: @escaping(Bool?, Error?) -> ()){
         print("addUpdateUserDeviceToken->", TokenID)
        ApiServices.shareInstace.getDataFromApi(url: APi.addUpdateUserDeviceToken.url, para: ApiServices.shareInstace.deviceTokenReq(TokenID: TokenID, Status: Status, UserID: UserID, DeviceType: DeviceType, voipToken: voipToken)) {(response, error) in
           
           
            print("UpdatedUserDeviceToken->", response)
            if response != nil {
                self.updateDeviceData = UpdatedUserDeviceToken.getUserDetails(dicts: response!)
                let data = self.updateDeviceData.table?[0] as! TableModel
                if data.success == "1" {
                    userDefaults.set(data.CurrentUserGuid, forKey: "userGUID")
                    print("userGUID is \(data.CurrentUserGuid)")
                    if self.updateDeviceData.table!.count > 0 {
                        self.logoutWebFromAll(userid: UserID, guuid: data.CurrentUserGuid) { success, err in
                            print("success:logoutWebFromAll",success)
                        }
                        complitionBlock(true, nil)
                    }
                    else {
                        complitionBlock(true, nil)
                    }
                   }
               }
            else {
                complitionBlock(false, error)
            }
            
            }
         
    }
    
    
    func logoutWebFromAll(userid:String,guuid: String, complitionBlock: @escaping(Bool?, Error?) -> ()){
       
       ApiServices.shareInstace.getDataFromApi(url: APi.logoutfromwebforall.url, para:logoutRequest(userID: userid, guuid: guuid)) {(response, error) in
          print("responselogoutWebFromAll->", response)
           if response != nil {
               
                   complitionBlock(true, nil)
               
              }
           else {
               complitionBlock(false, error)
           }
           
       }
        
   }
    func logoutRequest(userID: String, guuid: String ) -> [String:Any]{
        let para:[String: Any] = ["UserID":userID, "UserGuID":guuid]
        return para
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
                    } }}}
    }
    func checkSingleSigninToUser(completionHandler:@escaping(Bool?, Error?) ->()){
        
        let urlString = APi.checkSingleUser.url
        let userID = GetPublicData.sharedInstance.userID
        let currentGUID = userDefaults.string(forKey: "userGUID") ?? ""
      //  "<INFO><USERID>" + SessionSave.getsession(AppConstants.USER_ID, getApplicationContext()) + "</USERID><GUID>" + SessionSave.getsession(AppConstants.UserGuID, getApplicationContext()) + "</GUID><LOGOUTSIGNALR>Y</LOGOUTSIGNALR></INFO>";
        
        let srchString = "<INFO><USERID>\(userID)</USERID><GUID>\(currentGUID)</GUID><LOGOUTSIGNALR>Y</LOGOUTSIGNALR></INFO>"
        let parameters = [
            "strSearchString":srchString
             ] as [String:Any]
        print("url to get  checkSingleSignin \(urlString),\(parameters)")
                AF.request(urlString, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                    
                        case .success(_):
                            guard let daata94 = response.data else { return }
                            do {
                                print("check singel user response ",daata94)
                                let jsonDecoder = JSONDecoder()
                                self.apiCheckCallStatusResponseModel = try jsonDecoder.decode([ApiCheckCallStatusResponseModel].self, from: daata94)
                                print("Success getVendorIDs Model ",self.apiCheckCallStatusResponseModel.first?.result ?? "")
                                let str = self.apiCheckCallStatusResponseModel.first?.result ?? ""
                        
                                print("STRING DATA IS \(str)")
                                let data = str.data(using: .utf8)!
                                do {
    //
                                    print("DATAAA ISSS \(data)")
                                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                                    {

                                        let newjson = jsonArray.first
                                        let userInfo = newjson?["UserGuIdInfo"] as? [[String:Any]]
                                        if userInfo!.count > 0 {
                                            completionHandler(true, nil)
                                        }
                                        else {
                                            completionHandler(false, nil)
                                        }
//
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
    
    func registerForPushNotification(fcmToken: String,userid: String){
        let pushNotificationStr = nBaseUrl + "/registerForPushNotification?userid=\(userid)&fcm_device_token=\(fcmToken)&notifytype=fcm&user_type=clientio"
        print("pushNotificationStrurl------>",pushNotificationStr)
        let requserURL = URL(string: pushNotificationStr)
        WebServices.get(url: requserURL!) { (response, _) in
            
           print("registerPushNotification:",response)
           
        } failureHandler: { (error, _) in
            print("registerPushNotificationerr----",error.localizations)
           
        }
      }
  
    
}
