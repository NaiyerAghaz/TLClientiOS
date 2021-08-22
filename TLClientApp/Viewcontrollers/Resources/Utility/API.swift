//
//  API.swift
//  TLClientApp
//
//  Created by Naiyer on 8/8/21.
//

import Foundation




let baseUrl = "https://lspservices.totallanguage.com/api"
let nBaseUrl = "https://lsp.totallanguage.com/VendorManagement/Vendor/"

enum APi{
    case login
    case forgetPassword
    case languagedata
    
    var url: URL{
        switch self {
        case .login:
            return URL(string: baseUrl + "/Security/Login")!
        case .forgetPassword:
            return URL(string: baseUrl + "/Security/ForgetPassword")!
        case .languagedata:
            return URL(string: nBaseUrl + "GetData?methodType=LanguageData")!
        }
    }
}
