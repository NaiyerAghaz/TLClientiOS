//
//  OnDemandOPIVM.swift
//  TLClientApp
//
//  Created by Mac on 01/09/21.
//

import UIKit
import Alamofire
class OnDemandOPIVM: NSObject {

}

extension OnDemandOPIVM {
    public func getTwilioAccessToken(userId: String, onSuccess: @escaping(String, Error?)->()) {
        if Network.init().isNetworkAvailable() {//
            let API_ACCESS_TOKEN = "https://lsp.totallanguage.com/OPI/GetOPIAccessToken?identity=\(userId)&deviceType=clientIos"
            
            let url = URL(string: API_ACCESS_TOKEN)!
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { return }
                print(String(data: data, encoding: .utf8)!)
                let token = String(data: data, encoding: .utf8)!
                onSuccess(token, error)
            }
            task.resume()
        }
    }
}
