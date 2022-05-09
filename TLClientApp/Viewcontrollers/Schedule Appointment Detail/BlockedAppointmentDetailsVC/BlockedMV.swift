//
//  BlockedMV.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 25/04/22.
//

import Foundation
import Alamofire
class BlockedVModel {
    var apiEncryptedDataResponse:ApiEncryptedDataResponse?
    func hitApiDecryptValue(value : String , encryptedValue : @escaping(Bool? , String?) -> ()){
       let urlString = APi.encryptdecryptvalue.url
      let parameter = [
            "value": value, "key": "Dcrpt"
        ] as [String : Any]
        
        AF.request(urlString, method: .post , parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiEncryptedDataResponse = try jsonDecoder.decode(ApiEncryptedDataResponse.self, from: daata)
                        
                        let encrypValue = self.apiEncryptedDataResponse?.value ?? ""
                        encryptedValue(true , encrypValue)
                        
                    } catch{
                        encryptedValue(false , "N/A")
                        
                    }
                case .failure(_):
                    encryptedValue(false , "N/A")
                  }
            })}
 
}
