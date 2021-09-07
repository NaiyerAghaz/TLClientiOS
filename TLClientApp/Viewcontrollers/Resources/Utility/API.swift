//
//  API.swift
//  TLClientApp
//
//  Created by Naiyer on 8/8/21.
//

import Foundation




let baseUrl = "https://lspservices.totallanguage.com/api"

let nBaseUrl = "https://lsp.totallanguage.com/VendorManagement/Vendor"

let twiliBaseURL = "https://sai1.smsionline.com"
let baseOPI = "https://lsp.totallanguage.com/OPI/GetOPIAccessToken"

enum APi{
    case login
    case forgetPassword
    case languagedata
    case getRoomId
    case apitoken
    case addUpdateUserDeviceToken
    case accessToken
    
    var url: URL{
        switch self {
        case .login:
            return URL(string: baseUrl + "/Security/Login")!
        case .forgetPassword:
            return URL(string: baseUrl + "/Security/ForgetPassword")!
        case .languagedata:
            return URL(string: nBaseUrl + "/GetData?methodType=LanguageData")!
        case .getRoomId:
            return URL(string: baseUrl + "/GetRoomID")!
        case .apitoken:
            return URL(string: twiliBaseURL + "/apitoken")!
        case .addUpdateUserDeviceToken:
            return URL(string: baseUrl + "/Security/AddUpdateUserDeviceToken")!
        case .accessToken :
            return URL(string: baseOPI + "/GetOPIAccessToken")!
        }
    }
}
