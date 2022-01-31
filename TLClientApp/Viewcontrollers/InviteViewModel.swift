//
//  InviteViewModel.swift
//  TLClientApp
//
//  Created by Naiyer on 10/8/21.
//

import Foundation
class InviteViewModel{
    var conferenceModel : ConferenceInfoModels?
    var inviteModel : InviteModel?
    /*<AUTHFACT>M
     M means mobile authentication
     E means Email authentication
     N means No2FA authentication
     You can pass like this character to AUTHFACT*/
    func inviteEmailReq(emailID: String,roomNo: String, pid: String, mobile: String, fName: String,lName: String,fromUserID: String, authFactor: String, calltype: String) -> [String: Any]{
        let para :[String: Any] = ["strSearchString": "<Info><TYPE>A</TYPE><ROOMNO>\(roomNo)</ROOMNO><EMAIL>\(emailID)</EMAIL><PID>\(pid)</PID><MOBILENO>\(mobile)</MOBILENO><FNAME>\(fName)</FNAME><LNAME>\(lName)</LNAME><FROMUSERID>\(fromUserID)</FROMUSERID><AUTHFACT>\(authFactor)</AUTHFACT><CALLTYPE>\(calltype)</CALLTYPE><CNAME></CNAME><clogo></clogo></Info>" ]
       
        
      return para
    }
    func inviteDailReq(roomNo: String, pid: String, mobile: String, fName: String,lName: String,fromUserID: String) -> [String: Any] {
        
        let parameter: [String: Any] = ["strSearchString":" <Info><TYPE>A</TYPE><ROOMNO>\(roomNo)</ROOMNO><EMAIL></EMAIL><PID>\(pid)</PID><MOBILENO>\(mobile)</MOBILENO><FNAME>\(fName)</FNAME><LNAME>\(lName)</LNAME><FROMUSERID>\(fromUserID)</FROMUSERID></Info>"]
        return parameter
    }
    func inviteWithEmail(parameter:[String:Any],complitionBlock: @escaping(Bool?, Error?) -> ()){
       print("invitePara:", parameter)
        WebServices.postJson(url: APi.AddUpdateConferenceData.url, jsonObject: parameter) { response, error in
            print("url and parametere for invite through email ",APi.AddUpdateConferenceData.url , parameter)
            let arr = response as! NSArray
            let inviteDict = arr[0] as! NSDictionary
            print("newArrDictnewArrDict-->",inviteDict)
            if arr.count != 0 {
                self.inviteModel = InviteModel.getData(dicts: inviteDict)
               
                complitionBlock(true, nil)
            }
           
        } failureHandler: { _, error in
            print("error")
            
            complitionBlock(false, nil)
        }
    }
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
           number += "\(Int.random(in: 1...9))"
        }
        return number
    }
}


