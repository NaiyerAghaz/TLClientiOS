//
//  CallManager.swift
//  TLClientApp
//
//  Created by Naiyer on 8/26/21.
//

import Foundation
import TwilioVideo
import TwilioVoice
class CallManagerVM {
    
    func getRoomList(complitionBlock: @escaping([RoomResultModel]?, Error?) -> ()){
        WebServices.postJson(url: APi.getRoomId.url, jsonObject: roomCreateReq()) { response, error in
            do {
                let arr = response as! NSArray
                let newArrDict = arr[0] as! NSDictionary
                let result = newArrDict.object(forKey: "result") as! String
                let jsonData = result.data(using: .utf8)
                if jsonData != nil {
                    let decodeData = try JSONDecoder().decode([RoomResultModel].self, from: jsonData!)
                    complitionBlock(decodeData, nil)
                }
                else{
                    complitionBlock(nil, error as? Error)
                }
            }
            catch{
                print(error.localizedDescription)
            }
        } failureHandler: { _, error in
            print("error")
        }
    }
    func roomCreateReq() -> [String: Any]{
        let para :[String: Any] = ["strSearchString":"<Info><STATUS>Get</STATUS></Info>"]
        return para
    }
    func getTwilioTokenWithCompletion(userID: String,Handler:@escaping(String?, Error?) ->()){
        
        
        
        let tokenURL = "\(baseOPI)?identity=\(userID)&deviceType=clientIos"
        
        do {
            let content = try String(contentsOf:URL(string: tokenURL)!)
            Handler(content, nil)
            print("content------->",content)
        }
        catch let error {
            Handler(nil, error)
            // Error handling
        }
    }
    
    func getTwilioWithCompletion(userID: String,deviceToken: Data,completionBlock: @escaping(Bool?) -> ()){
        getTwilioTokenWithCompletion(userID: userID) { accessToken, err in
            if err == nil {
                TwilioVoiceSDK.register(accessToken: accessToken!, deviceToken: deviceToken) { err in
                    if err == nil {
                        print("Twilio AccessToken Is register Succefully ======> ")
                        completionBlock(true)
                    }
                }
            }
        }
        
    }
    func getVriVendorsbyLid_KE(parameter: [String: Any], completionBlock: @escaping([MemberListM], Error?) -> ()) {
        WebServices.postNew(url: APi.getVriVendorsbyLidKE.url, jsonObject: parameter) { response, error in
            
            print(#function, "\n", response)
            guard let responseJson = response as? [String: Any] else {
                return
            }
            guard let memebersList = responseJson["GetMembers"] as? [[String: Any]], memebersList.count > 0  else {
                return
            }
            let membersList = memebersList.map {
                return MemberListM(json: $0)
            }
            completionBlock(membersList, nil)
            
        } failureHandler: { _ , error in
            
        }
    }
    func getVRIandOPICallClient(parameters: [String: Any], completionBlock: @escaping([String: Any], Error?) -> ()) {
        
        WebServices.post(url: APi.createvricallclient.url, jsonObject: parameters) { response, error in
            guard let responseArray = response as? [[String: Any]], responseArray.count > 0 else {
                return
            }
            completionBlock(responseArray[0], nil)
        } failureHandler: { _ , error in
            
        }
    }
    
    func getVarderId(parameters: [String: Any], completionBlock: @escaping([String: Any], Error?) -> ()) {
        WebServices.post(url: APi.getVRICallVendorWithCheckCallStatus.url, jsonObject: parameters) { response, error in
            guard let responseArray = response as? [[String: Any]], responseArray.count > 0 else {
                return
            }
            completionBlock(responseArray[0], nil)
        } failureHandler: { _ , error in
            
        }
    }
}

