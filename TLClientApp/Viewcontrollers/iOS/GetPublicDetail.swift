//
//  GetPublicDetail.swift
//  TLClientApp
//
//  Created by Mac on 02/11/21.
//

import Foundation
import Alamofire
public class GetPublicData {
    static var sharedInstance = GetPublicData()
    public var languageArray:[String] = []
    public var userID = userDefaults.string(forKey: "userId") ?? ""
    public var userNameForTouchID = userDefaults.string(forKey: "userNameForTouchID") ?? ""
    public var userPasswordForTouchID = userDefaults.string(forKey: "userPasswordForTouchID") ?? ""
    public var usenName = userDefaults.string(forKey: "username") ?? ""
    public var companyName = userDefaults.string(forKey: "companyName") ?? ""
    public var userTypeID = userDefaults.string(forKey: "userTypeID") ?? ""
    public var companyID = userDefaults.string(forKey: "companyID") ?? ""
    var TempCustomerID = ""
    var apic = [AppointmentTypeDataModel]()
    var apiGetSpecialityDataModel:ApiGetSpecialityDataModel?
    
    public var apiGetAllLanguageResponse:ApiGetAllLanguageResponse?
    public func getAllLanguage(){
    SwiftLoader.show(animated: true)
       
       languageArray.removeAll()
        //self.apiGetAllLanguageResponse = nil
    
        let urlString = "https://lsp.totallanguage.com/Security/GetData?methodType=LanguageData"
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                       // SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success language data ")
                            guard let daataM = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiGetAllLanguageResponse = try jsonDecoder.decode(ApiGetAllLanguageResponse.self, from: daataM)
                               print("Success language ")
                                self.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
                                       let languageString = languageData.languageName ?? ""
                                         languageArray.append(languageString)
                                })
                                
                            } catch{
                                
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            
                            print("Respose Failure ")
                           
                        }
                })
     }
    
}
