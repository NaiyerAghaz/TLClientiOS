//
//  ApiManager.swift
//  TLClientApp
//
//  Created by Mac on 26/10/21.
//

import Foundation
var liveBaseUrl =  "https://lsp.totallanguage.com/"
var version = ""
var apiURL = liveBaseUrl + version
enum Api{
    case login
   
    var url : URL{
        switch self {
        //MARK:- Auth
        case .login:
            return URL(string: apiURL + "login")!
     
        }
    }
}
