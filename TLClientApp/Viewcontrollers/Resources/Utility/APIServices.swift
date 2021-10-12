//
//  APIServices.swift
//  TLClientApp
//
//  Created by Naiyer on 8/10/21.
//

import Foundation
import Alamofire
class ApiServices: NSObject {
    static let shareInstace = ApiServices()
    func getDataFromApi(url: URL, para: [String:Any], completionHandler:@escaping(NSDictionary?, Error?) -> ()){
        print("para->",para)
        WebServices.postJson(url: url, jsonObject: para,completionHandler: {(response, _) in
            completionHandler(response as? NSDictionary, nil)
            SwiftLoader.hide()
        }){ (error, _) in
            print(error)
            completionHandler(nil, error as? Error)
            SwiftLoader.hide()
        }
    }
   
    
    func loginRequest(UserName:String,Password:String,Ip:String,Latitude:String,Longitude:String) -> [String: Any]{
        let para:[String: Any] = ["UserName":UserName,"Password":Password,"Ip":Ip,"Latitude":Latitude,"Longitude":Longitude]
        return para
    }
    func forgotReq(email:String,userName: String) ->[String:Any] {
        let req:[String: Any] = [
            "Email":email,
            "UserName":userName
        ]
        return req
       }
    func deviceTokenReq(TokenID: String,Status: String,UserID: String,DeviceType: String,voipToken: String) -> [String: Any]{
    let para:[String: Any] = ["TokenID":TokenID, "Status":Status, "UserID":UserID,"DeviceType":DeviceType,"voipToken":voipToken]
        return para
    }
    
    
}
