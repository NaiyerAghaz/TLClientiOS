//
//  CallManager.swift
//  TLClientApp
//
//  Created by Naiyer on 8/26/21.
//

import Foundation
import TwilioVideo
import TwilioVoice
import TwilioChatClient

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
                        completionBlock(true)
                    }
                }
            }
        }
        
    }
    
    func addAppCall(req:[String:Any], completionHandler:@escaping(Bool?, Error?) -> ()){
        
        ApiServices.shareInstace.getDataFromApi(url: APi.vricallstart.url, para: req) { response, err in
            print("reponse---------->",response)
            if response != nil {
                completionHandler(true, nil)
            }
            else {
                completionHandler(false, err)
            }
        }
    }
    
    func addAppCallReqAPI(sourceID: String,targetID: String,roomId: String,targetName: String,sourceName: String, patientName: String, patientNo:String) -> [String: Any]{
        var parameter:[String:Any] = [:]
        
        parameter  = ["sourceLid":sourceID ,"lid":targetID,"Roomno":roomId ,"senderid":userDefaults.string(forKey: "userid") ?? "" ,"touserid":0,"statustype":1,"TLname":targetName,"sLName":sourceName ,"devicetype":"I","calltype":"V","patientname":"","patientno":"","Slid":sourceID,"companyID":userDefaults.string(forKey: "companyID") ?? "","callfrom":"app","ondemandvendorid":"","CallGetInType":"vri"]
        
        
        return parameter
    }
    func priorityReqAPI(LtargetId: String,Calltype:String,Slid: String) -> [String: Any] {
        let parameter:[String:Any] = ["LId":LtargetId ,"UserId":userDefaults.string(forKey: "userid") ?? "","Calltype":Calltype ,"MembersType":"app" ,"Slid":Slid]
        
        return parameter
    }
    func priorityVideoCall(req:[String:Any], completionHandler:@escaping(Bool?, Error?) -> ()){
        debugPrint("priorityPara--->", req)
        ApiServices.shareInstace.getDataFromApi(url: APi.getVriVendorsbyLid.url, para: req) { response, err in
            print("reponsegetVriVendorsbyLid:---------->",response)
            if response != nil {
                completionHandler(true, nil)
            }
            else {
                completionHandler(false, err)
            }
        }
    }
}
// MARK:- RemoteParticipantDelegate
extension VideoCallViewController : RemoteParticipantDelegate {
    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
        self.view.makeToast("Participant \(participant.identity) published video track")
        
    }
    
    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.
        self.view.makeToast("Participant \(participant.identity) unpublished video track")
        
    }
    
    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.
        self.view.makeToast("Participant \(participant.identity) published audio track")
        
    }
    
    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        self.view.makeToast("Participant \(participant.identity) unpublished audio track")
        
    }
    
    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // The LocalParticipant is subscribed to the RemoteParticipant's video Track. Frames will begin to arrive now.
        self.view.makeToast("Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
        if (self.remoteParticipant == nil) {
            _ = renderRemoteParticipant(participant: participant)
        }
        if remoteParicipantDictionary?.count == 1 {
           /* {
                
                if(self.isChatConnected){
                    [self.chatBtn setHidden:NO];
                    self.chatBGView.hidden = NO;
                }
                
                TVILocalParticipant * participantLocal;
                
                participantLocal = [[self.localParticipantsDictionary valueForKey:@"0"] valueForKey:@"participant"];
                
                [self.localParticipantsDictionary setObject:@{
                    @"participant" : participantLocal,
                    @"videoTrak" : self.localVideoTrack
                } forKey:@"0"];
            }*/
            let localParticipant = (self.localParicipantDictionary?.value(forKey: "0") as? NSObject)?.value(forKey: "participant") as? LocalParticipant
            self.localParicipantDictionary?["0"] = ["participant":localParticipant, "videoTrak":videoTrack]
            
        }
        /*
         bool saveParticipant = false;
         int index = 0;
         for (int i= 0; i< self.remoteParticipantsList.count; i++) {
             TVIRemoteParticipant * participant1 = [[self.remoteParticipantsDictionary valueForKey:[NSString stringWithFormat:@"%d",i]] valueForKey:@"participant"];
             
             if(participant1 == participant){
                 saveParticipant = true;
                 index = i;
                 break;
             }
         }
         if(saveParticipant){
             [self.remoteParticipantsDictionary setObject:@{
                 @"participant" : participant,
                 @"videoTrak" : videoTrack
             } forKey:[NSString stringWithFormat:@"%d",index]];
         }
         
         dispatch_async(dispatch_get_main_queue(), ^(void){
             [self.videoCollectionView reloadData];
             [self.speakerVideoCollectionView reloadData];
         });
         */
        var saveParticipant = false
        var index = 0
        for i in 0...remoteParticipantArr.count{
            let nParticipant = (self.remoteParicipantDictionary?.value(forKey: "\(i)") as? NSObject)?.value(forKey: "participant") as? RemoteParticipant
            if nParticipant == participant {
                saveParticipant = true
                index = i
            }
            
        }
        if saveParticipant{
            //remoteParicipantDictionary?["\(index)"] =
            self.remoteParicipantDictionary?["\(index)"] = ["participant":participant, "videoTrak": videoTrack]
        }
        DispatchQueue.main.async {
            self.vdoCollectionView.reloadData()
        }
        
        
    }
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        print("cleanup remote participant----------------------:")
        self.view.makeToast("Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
        if self.remoteParticipant == participant {
            cleanupRemoteParticipant()
            
            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
               let index = remainingParticipants.firstIndex(of: participant) {
                remainingParticipants.remove(at: index)
                renderRemoteParticipants(participants: remainingParticipants)
            }
        }
    }
    
    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
        self.view.makeToast("Subscribed to audio track for Participant \(participant.identity)")
        
        
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
        self.view.makeToast("Unsubscribed from audio track for Participant \(participant.identity)")
        
    }
    
    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        self.view.makeToast("Participant \(participant.identity) enabled video track")
        
        
    }
    
    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        self.view.makeToast("Participant \(participant.identity) enabled video track")
    }
    
    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        self.view.makeToast("Participant \(participant.identity) enabled audio track")
        
    }
    
    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        
        self.view.makeToast("Participant \(participant.identity) disabled audio track")
        
    }
    
    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        self.view.makeToast("FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
        
    }
    
    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        self.view.makeToast("FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
        
        
    }
    
}

