//
//  FeedbackVModel.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 09/03/22.
//

import Foundation
class FeedbackVModel {
    
   // func submitfeedbackMethod(parameter:[String:Any],completion:@escaping(Bool?, ClientStatusModel?) ->()){
    func submitfeedbackMethod(parameter:[String:Any], completionHnadler:@escaping(Bool, Error?) ->()){
        WebServices.postJson(url: APi.addCallFeedback.url, jsonObject: parameter) { response, err in
           
            print("feedbackResponse------>",response)
            completionHnadler(true,nil)
          
        } failureHandler: { resp, err in
            completionHnadler(false,err as? Error)
        }
        
    }
    func requestFeedback(callquality: String,VendID: String,roomno: String,CustID: String,LID: String,rating: Int) -> [String: Any]{
        let parameter = [
            "callquality":callquality,
            "VendID":VendID,
            "roomno":roomno,
            "CustID":CustID,
            "LID":LID,
            "rating":rating,
            "calltype":"V",
            "uType":"C"] as [String : Any]
        return parameter
    }
    func getFeedbackDetails(parameter:[String:Any], completionHandler:@escaping(APIGetfeedbackDetail?, Error?) ->()){
        WebServices.postJson(url: APi.getFeedbackDetails.url, jsonObject: parameter) { response, err in
            print("getFeedbackDetails----------->",response)
            
            guard let daata = cEnum.instance.jsonToData(json: response) else { return }
            do {
                let jsonDecoder = JSONDecoder()
                let apiGetfeedbackDetail = try jsonDecoder.decode(APIGetfeedbackDetail.self, from: daata)
               completionHandler(apiGetfeedbackDetail, nil)
                
            } catch{
                completionHandler(nil, err as? Error)
                print("error block getCommonDetail " ,error)
            }
         
        } failureHandler: { resp, err in
            print(err)
        }
    }
    func feedbackReq(roomId: String) -> [String:Any]{
        let parameter = [
            "RoomId":roomId,
            "calltype":"V"
        ]
        return parameter
    }

    
}
