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
    func addAppCall( apiReq: [String: Any],completionBlock:@escaping(Bool?, Error?) ->()){
      
        ApiServices.shareInstace.getDataFromApi(url: APi.vriCallStart.url, para: apiReq) { response, error in
            if response != nil {
            
print("AddCallResponse-->", response)
            
            
                            }
                            else {
                                completionBlock(false, error)
                            }
        }
        
    }
    func startCallRequest(lid: String,Roomno: String,senderid: String, touserid: String, statustype: String, TLname: String, sLName: String,devicetype: String,calltype: String,patientname: String,patientno: String, Slid: String,companyID: String,checkListFilters: String, callfrom:String, ondemandvendorid: String,CallGetInType: String) -> [String: Any]{
        let para:[String: Any] = ["lid":lid,"Roomno":Roomno,"senderid":senderid,"touserid":touserid,"statustype":statustype,"TLname":TLname,"TLname":TLname,"sLName":sLName,"devicetype":devicetype,"calltype":calltype,"patientname":patientname,"patientno":patientno,"Slid":Slid,"companyID":companyID,"checkListFilters":checkListFilters]
        return para
    }
    func participantUserActionDetails(req:[String:Any], completionHandler:@escaping(Bool?, Error?) -> ()){
        
        ApiServices.shareInstace.getDataFromApi(url: APi.ConferenceParticipant.url, para: req) { response, err in
            print("reponse---------->",response)
            if response != nil {
                completionHandler(true, nil)
            }
            else {
                completionHandler(false, err)
            }
        }
    }
    func participantReqApi(roomID: String,participantSID: String,roomSID: String,userID: String) -> [String: Any]{
        let req :[String: Any] = ["strSearchString":"<Info><PID></PID><ACTION>A</ACTION><ID></ID><ACTUALROOM>\(roomID)</ACTUALROOM><PARTSID>\(participantSID)</PARTSID><ROOMSID>\(roomSID)</ROOMSID><USERID>\(userID)</USERID><MUTE>1</MUTE><VIDEO>1</VIDEO><CALL>1</CALL><TYPE>C</TYPE></Info>"]
        debugPrint("conferenceReq--------->", req)
        
        
        return req
    }
    
    
   
    
   
}
