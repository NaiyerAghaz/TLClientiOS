//
//  ForgotViewModel.swift
//  TLClientApp
//
//  Created by Naiyer on 8/13/21.
//

import Foundation

class ForgotViewModel {
    
    public var user = ForgotUser()
    
    public func userForgotPWD(Email: String,UserName: String, complitionBlock: @escaping(Bool?, Error?) -> ()){
        
        ApiServices.shareInstace.getDataFromApi(url: APi.forgetPassword.url, para: ApiServices.shareInstace.forgotReq(email: Email, userName: UserName)) {(response, error) in
            SwiftLoader.hide()
            print("forgotUser->", response)
            if response != nil {
                
                self.user = ForgotUser.getForgotData(dicts: response!)
                
                let userDict = self.user.SuccessErrorDetails![0] as! ErrorModel
                if userDict.Status == "2" {
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
