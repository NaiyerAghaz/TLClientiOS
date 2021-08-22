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
    
    var user = UserDetail()
    
    private let disposeBag = DisposeBag()
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(userNameTFPublishObject.asObserver().startWith(""),emailTFPublishObject.asObserver().startWith("")).map{ username, email in
            return username.count > 3 && email.count > 3
            
        }.startWith(false)
    }
    public func userLogin(UserName: String,Password: String,Ip: String,Latitude: String,Longitude: String, complitionBlock: @escaping(Bool?, Error?) -> ()){
        
        ApiServices.shareInstace.getDataFromApi(url: APi.login.url, para: ApiServices.shareInstace.loginRequest(UserName: UserName, Password: Password, Ip: Ip, Latitude: Latitude, Longitude: Longitude)) {(response, error) in
           
            print("EditBankDetails->", response)
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
    
}
        
        //        userProvider.request(.login(UserName: UserName, Password: Password,Ip: Ip,Latitude: Latitude,Longitude: Longitude)) { (result) in
        //            switch result{
        //            case .success(let response):
        //                print("response---->", response)
        //                do {
        //
        //                    // make sure this JSON is in the format we expect
        //                    if let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] {
        //                        // try to read out a string array
        //
        //                        let userD = json["UserDetails"] as? NSArray
        //                        print("uuu->",userD)
        ////                        if   (((userD![0] as AnyObject).value("Message") as? String) != nil)) != nil {
        ////                            print("mszzz----",msz)
        ////                        }
        ////                        else {
        ////                            self.user = try! JSONDecoder().decode(User.self, from: response.data)
        ////                            complitionBlock(true, nil)
        ////                        }
        //                    }
        //                } catch let error as NSError {
        //                    print("Failed to load: \(error.localizedDescription)")
        //                }
        ////                let json = CEnumClass.share.convertToJSONFromData(resulTDict: response.data as NSData)
        ////
        ////                print("json--->", json)
        ////                if ((json.object(forKey:"Message") as? String) != nil) {
        ////                    self.errorUser = try! JSONDecoder().decode(ErrorUser.self, from: response.data)
        ////                    complitionBlock(false,  nil)
        ////                }
        ////                else {
        ////
        ////                }
        //
        //
        //            case .failure(let err):
        //                complitionBlock(false, err)
        //                print(err.localizedDescription)
        //            }
        //        }
        
        //        self.userProvider.rx
        //            .request(.login(UserName: UserName, Password: Password,Ip: Ip,Latitude: Latitude,Longitude: Longitude))
        //            .mapJSON()
        //            .subscribe {event in
        //                switch event {
        //                case let .success(response):
        //
        //                    guard let response = response as? [String: AnyObject] else {
        //                        break
        //                    }
        //
        //                    if let error = response["error"] as? String {
        //                        self.response.value = error
        //                        return
        //                    }
        //
        //                    if let user = response["UserDetails"] {
        //                        let json = CEnumClass.share.convertToJSON(resulTDict: user as! NSDictionary)
        //
        //                        print("userData->", user)
        //                    }
        //
        //                    break
        //                case .error(_):
        //                    self.response.value = "Something went wrong. Please try again!"
        //                    break
        //                }
        //            }.disposed(by: self.disposeBag)
    
