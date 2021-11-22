//
//  VDOCallViewModel.swift
//  TLClientApp
//
//  Created by Naiyer on 8/28/21.
//

import Foundation
class VDOCallViewModel {
    
func getTwilioToken(complitionBlock: @escaping(TwilioModel?, Error?) -> ()){
        
        WebServices.get(url: APi.apitoken.url) { (response, _) in
           
            let twilioData = TwilioModel.getTwilioData(dicts: response as! NSDictionary)
            complitionBlock(twilioData,nil)
            SwiftLoader.hide()
        } failureHandler: { (error, _) in
            complitionBlock(nil,nil)
            SwiftLoader.hide()
        }
        
    }
    
   
}
