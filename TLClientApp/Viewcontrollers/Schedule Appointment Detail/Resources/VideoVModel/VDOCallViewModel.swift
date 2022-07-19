//
//  VDOCallViewModel.swift
//  TLClientApp
//
//  Created by Naiyer on 8/28/21.
//

import Foundation
import UIKit
import TwilioChatClient
class VDOCallViewModel {
    var conferrenceDetail = ConferenceInfoResultModel()
    var apiCompanyDetailsModel:APICompanyDetailsModel?
    func getTwilioToken(complitionBlock: @escaping(TwilioModel?, Error?) -> ()){
        
        WebServices.get(url: APi.apitoken.url) { (response, _) in
            print("1.....apitoken--------url:\( APi.apitoken.url)  response:\(response)")
            let twilioData = TwilioModel.getTwilioData(dicts: response as! NSDictionary)
            complitionBlock(twilioData,nil)
           
        } failureHandler: { (error, _) in
            complitionBlock(nil,nil)
            
        }
      }
    func addAppCall(apiReq: [String: Any],completionBlock:@escaping(Bool?, Error?) ->()){
        
        ApiServices.shareInstace.getDataFromApi(url: APi.vriCallStart.url, para: apiReq) { response, error in
            if response != nil {
                
                SwiftLoader.hide()
            }
            else {
                completionBlock(false, error)
            }
        }
        
    }
    func customerEndCallRequest(roomID: String) -> [String:Any] {
        let req:[String:Any] = ["strSearchString":"<Info><roomno>\(roomID)</roomno></Info>"]
       // NSDictionary *params = @{  @"strSearchString" : [NSString stringWithFormat:@"<Info><roomno>%@</roomno></Info>", self.roomID] };
        return req
    }
    func customerEndCallWithoutConnect( roomID: String,completionBlock:@escaping(Bool?, Error?) ->()){
       
        ApiServices.shareInstace.getDataFromApi(url: APi.customerVRIEndCall.url, para: customerEndCallRequest(roomID: roomID)) { response, error in
            print("End call response--------",response)
            if response != nil {
                
               
                completionBlock(true, nil)
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
    func companyReqDetails(userID: String) -> [String: Any]{
        let req:[String:Any] = ["strSearchString":"<INFO><USERID>\(userID)</USERID></INFO>"]
        return req
    }
    //Get participant details
    func getCompanydetails(req:[String:Any], completionHandler:@escaping(Bool?, Error?) -> ()){
        
            
            var request = URLRequest(url: APi.getCompanydetails.url)
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.httpMethod = "POST"
            
            do {
                
                request.httpBody = try JSONSerialization.data(withJSONObject: req, options: .prettyPrinted)
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        completionHandler(false, error)
                    }
                    guard let hostdata = data else {return}
                    do {
                        let Json = try JSONSerialization.jsonObject(with: hostdata, options: []) as? NSArray
                       
                        let newArrDict = Json![0] as! NSDictionary
                        let newdata = self.jsonToData(json: newArrDict)
                       // let result = newArrDict.object(forKey: "result") as! String
                        let jsonDecoder = JSONDecoder()
                        self.apiCompanyDetailsModel = try jsonDecoder.decode(APICompanyDetailsModel.self, from: newdata!)
                        print("getCompanydetails response:\(self.apiCompanyDetailsModel?.resultData)")
                        completionHandler(true, nil)
                       
                    }
                    catch _ {
                        print ("Oops something happened buddy")
                    }
                  }
                .resume()
            }
            catch _ {
                print ("Oops something happened buddy")
            }
        
    }
   
    func participantReqApi(roomID: String,participantSID: String,roomSID: String,userID: String) -> [String: Any]{
        let req :[String: Any] = ["strSearchString":"<Info><PID></PID><ACTION>A</ACTION><ID></ID><ACTUALROOM>\(roomID)</ACTUALROOM><PARTSID>\(participantSID)</PARTSID><ROOMSID>\(roomSID)</ROOMSID><USERID>\(userID)</USERID><MUTE>1</MUTE><VIDEO>1</VIDEO><CALL>1</CALL><TYPE>C</TYPE></Info>"]
        debugPrint("conferenceReq--------->", req)
        
        
        return req
    }
    func addParticipantReqApi(Lsid:String,roomID: String) -> [String: Any]{
        
        let req: [String: Any] = ["strSearchString":"<Info><ID>0</ID><ACTUALROOM>\(roomID)</ACTUALROOM><ROOMSID></ROOMSID><INCALL>1</INCALL><SEARCH></SEARCH><PAGEINDEX>0</PAGEINDEX><PAGESIZE>10</PAGESIZE><EXCLUDEPARTSID>\(Lsid)</EXCLUDEPARTSID></Info>"]
        
        return req
    }
    func getParticipantList2(lid: String, roomID: String,partSID: String, isfromHostcontrol:Bool, completionHandler:@escaping(Bool?, Error?) -> ()){
       
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
                guard let pdata = data else {return}
                do {
                    let Json = try JSONSerialization.jsonObject(with: pdata, options: []) as? NSArray
                   
                    let newArrDict = Json![0] as! NSDictionary
                    let result = newArrDict.object(forKey: "result") as! String
                    
                    let jsonData = result.data(using: .utf8)
                    if jsonData != nil {
                        let rJson = try JSONSerialization.jsonObject(with: jsonData!, options: []) as? NSArray
                        guard let acceptdata = data else {return}
                        if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode == 200 {
                                self.conferrenceDetail = ConferenceInfoResultModel.getDetails(dicts: rJson![0] as! NSDictionary)
                                
                              //  let items :ConferenceInfoModels = (self.conferrenceDetail.CONFERENCEInfo![0] as? ConferenceInfoModels)!
                             
                                if isfromHostcontrol {
                                    DispatchQueue.global(qos: .background).async {
                                        self.participantRuleMethod(participantsArr: self.conferrenceDetail.CONFERENCEInfo!, lid: lid, roomID: roomID, participantSID: partSID)
                                    }
                                }
                              
                             
                                completionHandler(true, nil)
                            }
                            else {
                                print("err particiapnt rule:")
                                completionHandler(false, error as? Error)
                            }
                      //  }
                     
//             let items :ConferenceInfoModels = (self.conferrenceDetail.CONFERENCEInfo![0] as? ConferenceInfoModels)!
//                        print("itmesmute-->\(items.MUTE) req: \(self.addParticipantReqApi(Lsid: lid, roomID: roomID)) response---Host: \(response)")
//                        DispatchQueue.global(qos: .background).async {
//                            self.participantRuleMethod(participantsArr: self.conferrenceDetail.CONFERENCEInfo!, lid: lid, roomID: roomID, participantSID: partSID)
//                        }
//
//
//
//                        completionHandler(true, nil)
//                    }
//                    else {
//
//
//                    }
                    
                        }}
                }
                
                catch let error {
                    SwiftLoader.hide()
                    print(error.localizedDescription)
                }
            }
            .resume()
        }
        catch _ {
            print ("Oops something happened buddy")
            SwiftLoader.hide()
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
                guard let hostdata = data else {return}
                // do {
                print("conferrenceParticiapnt Url:\(APi.ConferenceParticipant.url) para:\(para) response:\(response)")
                completionHandler(true, nil)
                print("Data---->", hostdata, response)
                
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
                guard let enddata = data else {return}
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("Data---->", enddata, response)
                        completionHandler(true, nil)
                    }
                    else {
                        completionHandler(false, nil)
                    }
                }
               
                
            }
            .resume()
        }
        catch _ {
            print ("Oops something happened buddy")
        }
    }
    
    //MARK: Disconnect individual Participant
    func endParticipantAPIReq(partSID: String) -> [String: Any]{
        let para :[String:Any] = ["strSearchString":"<Info><ACTION>E</ACTION><PARTSID>\(partSID)</PARTSID><CALL>0</CALL></Info>"]
        return para
    }
    
    func participantEndMethod1(partSID: String,completionHandler:@escaping( Bool?, Error?) ->()){
        var request = URLRequest(url: APi.ConferenceParticipant.url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Access-Control-Allow-Origin", forHTTPHeaderField: "*")
        request.httpMethod = "POST"
        
        do {
            
            request.httpBody = try JSONSerialization.data(withJSONObject: endParticipantAPIReq(partSID: partSID), options: .prettyPrinted)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completionHandler(false, error)
                }
                guard let endPdata = data else {return}
                if let httpResponse = response as? HTTPURLResponse {
                    print("participantEndMethod1-Data---->", endPdata, response, "statusCode:",httpResponse.statusCode)
                    if httpResponse.statusCode == 200 {
                        completionHandler(true, nil)
                    }
                    else {
                        completionHandler(false, nil)
                    }
                }
           
                
            }
            .resume()
        }
        catch _ {
            print ("Oops something happened buddy")
        }
    }
    func participantEndMethod2(roomSID: String, partSID: String,completionHandler:@escaping( Bool?, Error?) ->()){
       
       
        let urlStr = "\(chatURL)/ParticipantEndCall/\(roomSID)?id=\(partSID)"
        let fullURL = URL(string: urlStr)
        
        var request = URLRequest(url: fullURL!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Access-Control-Allow-Origin", forHTTPHeaderField: "*")
        request.httpMethod = "POST"
        
        do {
            let para :[String:Any] = [:]
            request.httpBody = try JSONSerialization.data(withJSONObject: para, options: .prettyPrinted)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    completionHandler(false, error)
                }
                guard let eCalldata = data else {return}
                if let httpResponse = response as? HTTPURLResponse {
                    print("participantEndMethod2-Data---->", eCalldata, response,"statusCode:",httpResponse.statusCode)
                    if httpResponse.statusCode == 200 {
                        completionHandler(true, nil)
                    }
                    else {
                        completionHandler(false, nil)
                    }
                }
            
                
            }
            .resume()
        }
        catch _ {
            print ("Oops something happened buddy")
        }
    }
    //MARK: Participant Rule Method:
    public func participantRuleMethod(participantsArr:NSMutableArray, lid:String, roomID: String, participantSID: String){
        let ruleArr = NSMutableArray()
     
        ruleArr.add(["type":"include","all":"true"])
      
        for obj in participantsArr {
            let nObj = obj as? ConferenceInfoModel
            if nObj?.MUTE == "0" {
                ruleArr.add(["type":"exclude","kind":"audio","publisher":nObj?.PARTSID])
            }
            
        }

        let para:[String: Any] = ["roomId":roomID,"id":lid,"pub":participantSID,"rule":ruleArr]
      
            var request = URLRequest(url: APi.ConferenceParticipant.url)
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.addValue("Access-Control-Allow-Origin", forHTTPHeaderField: "*")
            request.httpMethod = "POST"
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: para, options: .prettyPrinted)
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("err particiapnt rule2:",error)
                    }
                    guard let acceptdata = data else {return}
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                          print("update particiapnt rule:")
                        }
                        else {
                            print("err particiapnt rule:")
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
    
    //END-----
    func meetingClientReq(roomID: String) -> [String: Any]{
        let para :[String:Any] = ["strSearchString":"<Info><ROOMNO>\(roomID)</ROOMNO></Info>"]
        return para
    }
    func getMeetingClientStatusLobbyWithCompletion(parameter:[String:Any],completion:@escaping(Bool?, ClientStatusModel?) ->()){
        WebServices.postJson(url: APi.getMeetingClientStatus.url, jsonObject: parameter) { response, err in
          
            let res = response as! NSArray
            let nresult = (res[0] as AnyObject).value(forKey: "ResultData") as! NSArray
            let result: ClientStatusModel = ClientStatusModel.getData(dicts: nresult[0] as! NSDictionary)
            print("url->\(APi.getMeetingClientStatus.url) req:\(parameter) response:\(response)")
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
                guard let acceptdata = data else {return}
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
                guard let cPdata = data else {return}
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
    
    public func rejectRequest( pid: String, roomid: String) -> [String: Any]{
        let para :[String:Any] = ["strSearchString":"<Info><ACTION>R</ACTION><ID></ID><ACTUALROOM>\(roomid)</ACTUALROOM><PID>\(pid)</PID></Info>"]
       
        return para
    }
    public func videoTrackEnableOrDisable(isenable:Bool, img: UIImageView){
        if isenable {
            img.isHidden = true
           }
        else {
            img.isHidden = false
            
            
        }
    }
    //MARK: Switch To Audio call
    func getReqVRICallClient(roomID: String,clientID: String,sourceId: String,targetID: String) -> [String: Any]{

        let searchStr = "<VRICLIENT><ACTION>A</ACTION><ID>0</ID><CLIENTID>\(clientID)</CLIENTID><ROOMID>\(roomID)</ROOMID><CALLTYPE>OPI</CALLTYPE><CALLSTATUS>1</CALLSTATUS><SOURCE>\(sourceId)</SOURCE><TARGET>\(targetID)</TARGET></VRICLIENT>"
        let parameter = ["strSearchString":searchStr]
        
        return parameter
    }
    
    func getVRICallClients(req:[String:Any], completionHandler:@escaping([ApiCreateVRICallClientResponseModel], Error?) -> ()){
        WebServices.postJson(url: APi.createVRICallClient.url, jsonObject: req) { response, err in
            print("getCreateVRICallClient----------->",response)
            
            guard let daata = cEnum.instance.jsonToData(json: response) else { return }
            do {
                let jsonDecoder = JSONDecoder()
                let apiclientDetail = try jsonDecoder.decode([ApiCreateVRICallClientResponseModel].self, from: daata)
               completionHandler(apiclientDetail, nil)
                
            } catch{
                completionHandler([], err as? Error)
                print("error block getCommonDetail " ,error)
            }
         
        } failureHandler: { resp, err in
            print(err)
        }
    }
    
    func getReqVendorIdForAudioCall(userID: String,sourceID: String,targetID: String,ccid: String) -> [String: Any]{

        let srchString = "<Info><CUSTOMERID>\(userID)</CUSTOMERID><TYPE>O</TYPE><SOURCE>\(sourceID)</SOURCE><TARGET>\(targetID)</TARGET><CC_ID>\(ccid)</CC_ID></Info>"
        let param = ["strSearchString" :srchString]
        
        return param
    }
    
    func getVendorIdForAudioCall(req:[String:Any], completionHandler:@escaping([VendorCallStatusModel]?, Error?) -> ()){
       
        WebServices.postJson(url: APi.getCheckCallStatus.url, jsonObject: req) { response, err in
            print("vendorIDReqres----------->",response)
            do {
                let arr = response as! NSArray
                let newArrDict = arr[0] as! NSDictionary
                let result = newArrDict.object(forKey: "result") as! String
                let jsonData = result.data(using: .utf8)
                if jsonData != nil {
                    let decodeData = try JSONDecoder().decode([VendorCallStatusModel].self, from: jsonData!)
                    completionHandler(decodeData, nil)
                }
                else{
                    completionHandler(nil, err as? Error)
                }
            }
            catch{
                print(error.localizedDescription)
            }

         
        } failureHandler: { resp, err in
            print(err)
        }
        
          /*  print("Para and url vendorList", param , urlString)
            AF.request(urlString, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseData(completionHandler: { (response) in
                    SwiftLoader.hide()
                    switch(response.result){
                    
                    case .success(_):
                        guard let daata = response.data else { return }
                        do {
                            let jsonDecoder = JSONDecoder()
                            self.apiCheckCallStatusResponseModel = try jsonDecoder.decode([ApiCheckCallStatusResponseModel].self, from: daata)
                            print("Success getVendorIDs Model ",self.apiCheckCallStatusResponseModel.first?.result ?? "")
                            let str = self.apiCheckCallStatusResponseModel.first?.result ?? ""
                            
                            print("STRING DATA IS \(str)")
                            let data = str.data(using: .utf8)!
                            do {
                                //
                                print("DATAAA ISSS \(data)")
                                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                                {
                                    
                                    let newjson = jsonArray.first
                                    let userInfo = newjson?["UserInfo"] as? [[String:Any]]
                                    let statusInfo = newjson?["StatusInfo"] as? [[String:Any]] // use the json here
                                    let userIfo = userInfo?.first
                                    let vendorId = userIfo?["UserId"] as? Int
                                    let vendorName = userIfo?["CustomerDisplayName"] as? String
                                    let vendorimg = userIfo?["CustomerImage"] as? String
                                    self.vendorID = String(vendorId ?? 0)
                                    self.vendorName = vendorName ?? ""
                                    self.vendorImgUrl = vendorimg ?? ""
                                    print("vendor ID ", vendorId , userIfo ,vendorimg  )
                                } else {
                                    print("bad json")
                                }
                            } catch let error as NSError {
                                print(error)
                            }
                            self.twilioVoiceView()
                            
                            
                        } catch{
                            
                            print("error block getVendorIDs Data  " ,error)
                        }
                    case .failure(_):
                        print("Respose Failure getVendorIDs ")
                        
                    }
                })*/
        
    }
    
    //END--
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
