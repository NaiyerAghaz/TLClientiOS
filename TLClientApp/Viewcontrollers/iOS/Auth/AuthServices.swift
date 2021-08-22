//
//  AuthServices.swift
//  TLClientApp
//
//  Created by Naiyer on 8/8/21.
//

import Foundation
import Moya
import UIKit

enum AuthServices {
    case login(UserName: String,Password: String,Ip: String,Latitude: String,Longitude: String)
}
extension AuthServices: TargetType {
    
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var path: String {
        switch self {
        case .login(_, _, _, _, _):
            return "Security/Login"
        
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        
        }
    }
    
    var sampleData: Data {
        switch self {
        case .login:
            return "start loding".data(using: .utf8)!
        
        }
    }
    
    var task: Task {
        switch self {
        case let .login(UserName, Password, Ip, Latitude, Longitude):
            return .requestParameters(parameters: ["UserName": UserName, "Password": Password,"Ip": Ip, "Latitude": Latitude,"Longitude": Longitude], encoding: JSONEncoding.default)
       
        }
    }
    
    var headers: [String : String]? {
        let headersR : [String: String] = ["Content-type": "application/json"]
        return headersR
    }
    
    
}
