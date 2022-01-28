//
//  VDOCallViewModel.swift
//  TLClientApp
//
//  Created by Naiyer on 8/28/21.
//

import Foundation


class VDOCallViewModel {
    var conferrenceDetail = ConferenceInfoResultModel()
    
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
    func addParticipantReqApi(Lsid:String,roomID: String) -> [String: Any]{
        
        let req: [String: Any] = ["strSearchString":"<Info><ID>0</ID><ACTUALROOM>\(roomID)</ACTUALROOM><ROOMSID></ROOMSID><PARTSID></PARTSID><INCALL>1</INCALL><SEARCH></SEARCH><PAGEINDEX>0</PAGEINDEX><PAGESIZE>10</PAGESIZE><EXCLUDEPARTSID>\(Lsid)</EXCLUDEPARTSID></Info>"]
        debugPrint("conferenceReq-222-------->", req)
        return req
    }
    func getParticipantList2(lid: String, roomID: String, completionHandler:@escaping(Bool?, Error?) -> ()){
        conferrenceDetail.CONFERENCEInfo?.removeAllObjects()
        var request = URLRequest(url: APi.getParticipantByRoom.url)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "POST"
        
        do {
            
            request.httpBody = try JSONSerialization.data(withJSONObject: addParticipantReqApi(Lsid: lid, roomID: roomID), options: .prettyPrinted)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completionHandler(false, error)
                }
                guard let data = data else {return}
                do {
                    let Json = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray
                    print("participant added json:------------------>",Json)
                    let newArrDict = Json![0] as! NSDictionary
                    let result = newArrDict.object(forKey: "result") as! String
                    print("resultresultresult->",result,newArrDict)
                    let jsonData = result.data(using: .utf8)
                    if jsonData != nil {
                        let rJson = try JSONSerialization.jsonObject(with: jsonData!, options: []) as? NSArray
                        self.conferrenceDetail = ConferenceInfoResultModel.getDetails(dicts: rJson![0] as! NSDictionary)
                        let items :ConferenceInfoModels = (self.conferrenceDetail.CONFERENCEInfo![0] as? ConferenceInfoModels)!
                        
                        print("ObjectConference!--->", self.conferrenceDetail.CONFERENCEInfo?.count, items.UserName)
                        completionHandler(true, nil)
                    }
                    else {
                        completionHandler(false, error as? Error)
                    }
                    
                }
                
                catch let error {
                    print(error.localizedDescription)
                }
            }
            .resume()
        }
        catch _ {
            print ("Oops something happened buddy")
        }
    }
    func audioReqAPI(val: Int, partSID: String, isAudio: Bool) -> [String: Any] {
        var parameter :[String:Any] = [:]
        if isAudio {
            parameter = ["strSearchString":"<Info><ACTION>M</ACTION><PARTSID>\(partSID)</PARTSID><MUTE>\(val)</MUTE></Info>"]
        }
        else {
            parameter = ["strSearchString":"<Info><ACTION>O</ACTION><PARTSID>\(partSID)</PARTSID><VIDEO>\(val)</VIDEO></Info>"]
        }
        
        
        return parameter
    }
    func audioVideoHostControl(audioVal: Int, partSID: String,isAudio: Bool, completionHandler:@escaping( Bool?, Error?) ->()){
        var para :[String:Any] = [:]
        if isAudio {
            para = audioReqAPI(val: audioVal, partSID: partSID,isAudio: isAudio)
        }
        else {
            para = audioReqAPI(val: audioVal, partSID: partSID,isAudio: isAudio)
        }
        
        var request = URLRequest(url: APi.ConferenceParticipant.url)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "POST"
        
        do {
            
            request.httpBody = try JSONSerialization.data(withJSONObject: para, options: .prettyPrinted)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completionHandler(false, error)
                }
                guard let data = data else {return}
                // do {
                completionHandler(true, nil)
                print("Data---->", data, response)
                
            }
            .resume()
        }
        catch _ {
            print ("Oops something happened buddy")
        }
    }
    func endAPIReq(roomID: String) -> [String: Any]{
        let para :[String:Any] = ["strSearchString":"<Info><ACTION>D</ACTION><ACTUALROOM>%@</ACTUALROOM><CALL>0</CALL></Info>"]
        return para
    }
    
    func participantEndCall(roomID: String,completionHandler:@escaping( Bool?, Error?) ->()){
        var request = URLRequest(url: APi.ConferenceParticipant.url)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Access-Control-Allow-Origin", forHTTPHeaderField: "*")
        request.httpMethod = "POST"
        
        do {
            
            request.httpBody = try JSONSerialization.data(withJSONObject: endAPIReq(roomID: roomID), options: .prettyPrinted)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completionHandler(false, error)
                }
                guard let data = data else {return}
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completionHandler(true, nil)
                    }
                    else {
                        completionHandler(false, nil)
                    }
                }
                print("Data---->", data, response)
                
            }
            .resume()
        }
        catch _ {
            print ("Oops something happened buddy")
        }
    }
    func meetingClientReq(roomID: String) -> [String: Any]{
        let para :[String:Any] = ["strSearchString":"<Info><ROOMNO>\(roomID)</ROOMNO></Info>"]
        return para
    }
    func getMeetingClientStatusLobbyWithCompletion(parameter:[String:Any],completion:@escaping(Bool?, ClientStatusModel?) ->()){
        WebServices.postJson(url: APi.getMeetingClientStatus.url, jsonObject: parameter) { response, err in
            print("clientStatus----------->",response)
            let res = response as! NSArray
            let nresult = (res[0] as AnyObject).value(forKey: "ResultData") as! NSArray
            let result: ClientStatusModel = ClientStatusModel.getData(dicts: nresult[0] as! NSDictionary)
            completion(true, result)
        } failureHandler: { resp, err in
            print(err)
        }
        
    }
    func reqAccept( pid: String, roomid: String) -> [String: Any]{
        let para :[String:Any] = ["strSearchString":"<Info><ACTION>P</ACTION><ID></ID><ACTUALROOM>\(roomid)</ACTUALROOM><PID>\(pid)</PID></Info>"]
        return para
    }
    //Accept Invite call
    func acceptInvitation(parameter:[String: Any],completionBlock:@escaping(Bool?) ->()) {
        var request = URLRequest(url: APi.ConferenceParticipant.url)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Access-Control-Allow-Origin", forHTTPHeaderField: "*")
        request.httpMethod = "POST"
        
        do {
            
            request.httpBody = try JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completionBlock(false)
                }
                guard let data = data else {return}
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completionBlock(true)
                    }
                    else {
                        completionBlock(false)
                    }
                }
                print("DataAccept---->", response)
                
            }
            .resume()
        }
        catch _ {
            print ("Oops something happened buddy")
        }
    }
    func rejectInvitation(parameter:[String: Any],completionBlock:@escaping(Bool?) ->()) {
        
    }
    //Reject Invite call
    
   // Convert from JSON to nsdata
    public func jsonToData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
    
    
}
