//
//  WebServicesAlamoFire.swift
//  MTR
//
//  Created by Naiyer on 28/06/2021.
//  Copyright © 2018 Shubham. All rights reserved.
//

import Foundation
import Alamofire
typealias CompletionBlock = (AnyObject, AnyObject) -> Void
typealias FailureBlock = (AnyObject, AnyObject) -> Void

// ((Swift.Int) -> Swift.Void)? = nil )
/// https://www.raywenderlich.com/121540/alamofire-tutorial-getting-started
let configuration = URLSessionConfiguration.default
class WebServices {
    static let sessionManager = Alamofire.Session(configuration: configuration)
    class func get(url: URL, completionHandler: CompletionBlock? = nil, failureHandler: FailureBlock? = nil) {
        
        sessionManager.request(url,
                               method: .get
            )
            .responseJSON { response in
                
                if let json = response.value {
                    
                    completionHandler!(json as AnyObject, response.result as AnyObject)
                    
                } else {
                    
                    failureHandler?("" as AnyObject, "" as AnyObject)
                    
                }
                
            }
            .responseString { some in
                
            }
         .responseData { _ in
        }
        
    }
    
    class func postEncoded(url : URL , jsonObject : Parameters , completionHandler: CompletionBlock? = nil,failureHandler: FailureBlock? = nil){
        
         sessionManager.request(url, method: .post, parameters: jsonObject, encoding: URLEncoding.httpBody, headers: ["content-type": "application/x-www-form-urlencoded"]).responseJSON { response in
            if let json = response.value {
                completionHandler!(json as AnyObject, response.result as AnyObject)
            } else {
                failureHandler?(response.value as AnyObject, "" as AnyObject)
            }
     }.responseString { _ in
            
         }.responseString { _ in 
             }
        }
    
    class func post( url: URL, jsonObject: Parameters,
                     completionHandler: CompletionBlock? = nil,
                     failureHandler: FailureBlock? = nil) {
        sessionManager.request(url,
                               method: .post,
                               parameters: jsonObject,
                               encoding: JSONEncoding.default,
                               headers: ["content-type": "application/json"])
            .responseJSON { response in
                
           
                if let json = response.value {
                    completionHandler!(json as AnyObject, response.result as AnyObject)
                } else {
                    failureHandler?(response.value as AnyObject, "" as AnyObject)
                }
            }
            .responseString { _ in
                
            }
            .responseData { _ in
        }
    }
    class func postNew( url: URL, jsonObject: Parameters,
                     completionHandler: CompletionBlock? = nil,
                     failureHandler: FailureBlock? = nil) {
        sessionManager.request(url,
                               method: .post,
                               parameters: jsonObject,
                               encoding: JSONEncoding.default,
                               headers: ["content-type": "application/json"])
            .responseJSON { response in
                
           
                if let json = response.value {
                    completionHandler!(json as AnyObject, response.result as AnyObject)
                } else {
                    failureHandler?(response.value as AnyObject, "" as AnyObject)
                }
            }
            .responseString { _ in
                
            }
            .responseData { _ in
        }
    }
    class func postJson( url: URL, jsonObject: Parameters,
                     completionHandler: CompletionBlock? = nil,
                     failureHandler: FailureBlock? = nil) {
        
    sessionManager.request(url,
                               method: .post,
                               parameters: jsonObject,
                               encoding: JSONEncoding.default,
                               headers: ["content-type": "application/json"])
            .responseJSON { response in
                
               
                if let json = response.value {
                    completionHandler!(json as AnyObject, response.result as AnyObject)
                } else {
                    failureHandler?(response.value as AnyObject, "" as AnyObject)
                }
            }
            .responseString { _ in
                
            }
            .responseData { _ in
        }
    }
    
    /*
    class func uploadSingleImage(url: URL, jsonObject: [String : Any],
                                 image: UIImage? = nil,
                                 fileName: String? = NSUUID().uuidString,
                                 completionHandler: CompletionBlock? = nil,
                                 failureHandler: FailureBlock? = nil) {
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        
        //Dotzu.sharedManager.addLogger(session: configuration)
        sessionManager.upload(multipartFormData: { multipartFormData in
            
            if let image1 = image {
                
                if let data = image1.jpegData(compressionQuality: 1)
                {
                    
                    multipartFormData.append(data,
                                             
                                             withName: "image",
                                             
                                             fileName: "\(fileName!)_\(NSUUID().uuidString).jpeg",
                        mimeType: "image/jpeg")
                }
            }
            
            for (key1, value1) in jsonObject {
                
                let recieveValue = "\(value1)"
                
                let someData = recieveValue.data(using: .utf8)
                
                multipartFormData.append(someData! , withName: key1)
                
            }
            
        }, to: url ,  headers: headers ) { encodingResult in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { _ in
                    
                    // Print progress
                })
                
                upload.responseJSON { response in
                    
                  
                    
                    if let json = response.result.value {
                        
                    
                        completionHandler!(json as AnyObject, response.result as AnyObject)
                        
                    } else{
                        failureHandler?("" as AnyObject, "" as AnyObject)
                        
                    }
                }
                upload.responseString(completionHandler: { (string) in
                 
                    
                })
                
            case .failure(let encodingError):
                
                failureHandler?("" as AnyObject, "" as AnyObject)
                
                print(encodingError)
            }
        }
    }*/
}

