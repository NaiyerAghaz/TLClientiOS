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
    func addAppCall(req:[String:Any], completionHandler:@escaping(Bool?, Error?) -> ()){
        
        ApiServices.shareInstace.getDataFromApi(url: APi.vricallstart.url, para: req) { response, err in
            print("reponse---------->",response)
            if response != nil {
                print("VRI CALL REQUEST AND URL IS \(APi.vricallstart.url) and parameter is \(req)")
                completionHandler(true, nil)
            }
            else {
                completionHandler(false, err)
            }
        }
    }
    
func addAppCallReqAPI(sourceID: String,targetID: String,roomId: String,targetName: String,sourceName: String, patientName: String, patientNo:String) -> [String: Any]{
        var parameter:[String:Any] = [:]
       
        parameter  = ["sourceLid":sourceID ,"lid":targetID,"Roomno":roomId ,"senderid":GetPublicData.sharedInstance.userID ,"touserid":0,"statustype":1,"TLname":targetName,"sLName":sourceName ,"devicetype":"I","calltype":"V","patientname":"","patientno":"","Slid":sourceID,"companyID":userDefaults.string(forKey: "companyID") ?? "","callfrom":"app","ondemandvendorid":"","CallGetInType":"vri"]
        
        
        return parameter
    }
    func priorityReqAPI(LtargetId: String,Calltype:String,Slid: String) -> [String: Any] {
        let parameter:[String:Any] = ["LId":LtargetId ,"UserId":userDefaults.string(forKey: "userid") ?? "","Calltype":Calltype ,"MembersType":"app" ,"Slid":Slid]
        
        return parameter
    }
    func priorityVideoCall(req:[String:Any], completionHandler:@escaping(Bool?, Error?) -> ()){
        
        ApiServices.shareInstace.getDataFromApi(url: APi.getVriVendorsbyLid.url, para: req) { response, err in
            
            if response != nil {
                completionHandler(true, nil)
            }
            else {
                completionHandler(false, err)
            }
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

// MARK:- RemoteParticipantDelegate

extension VideoCallViewController : RemoteParticipantDelegate {
    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
        //self.view.makeToast("Participant \(participant.identity) published video track")
        
    }
    
    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.
       // self.view.makeToast("Participant \(participant.identity) unpublished video track")
        
    }
    
    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.
       // self.view.makeToast("Participant \(participant.identity) published audio track")
        
    }
    
    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
       // self.view.makeToast("Participant \(participant.identity) unpublished audio track")
        print("mute participant :", participant.audioTracks)
        
    }
    
    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // The LocalParticipant is subscribed to the RemoteParticipant's video Track. Frames will begin to arrive now.
       // self.view.makeToast("Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
        if (self.remoteParticipant == nil) {
            _ = renderRemoteParticipant(participant: participant)
        }
        if remoteParicipantDictionary?.count == 1 {
            
            let localParticipant = (self.localParicipantDictionary?.value(forKey: "0") as? NSObject)?.value(forKey: "participant") as? LocalParticipant
            self.localParicipantDictionary?["0"] = ["participant":localParticipant, "videoTrak":videoTrack]
            
        }
        var saveParticipant = false
        var index = 0
        for i in 0...remoteParticipantArr.count{
            let nParticipant = (self.localParicipantDictionary?.value(forKey: "\(i)") as? NSObject)?.value(forKey: "participant") as? RemoteParticipant
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[self] in
            self.vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: roomID!) { success, err in
                
            }
            
        }}
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        print("cleanup remote participant----------------------:")
        // self.view.makeToast("Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
        if self.remoteParticipant == participant {
            cleanupRemoteParticipant()
            
            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
               let index = remainingParticipants.firstIndex(of: participant) {
                remainingParticipants.remove(at: index)
                renderRemoteParticipants(participants: remainingParticipants)
            }
            
        }
        if remoteParticipantArr.count > 1 {
            for vdo in remoteParticipantArr {
                if vdo == participant {
                    if let index = remoteParticipantArr.firstIndex(of: vdo) {
                        remoteParticipantArr.remove(at: index)
                    }
                }
            }
            
            lblTotalParticipant.text = "\(remoteParticipantArr.count)"
            DispatchQueue.global(qos: .background).async { [self] in
                vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: roomID!) { success, err in
                    if success == true && vdoCallVM.conferrenceDetail.TOTALRECORDS != "0"{
                        DispatchQueue.main.async {
                            self.vdoCollectionView.reloadData()
                        }
                    }
                    else {
                        backToMainController()
                    }
                }
            } }
        else {
            backToMainController()
       }
        
    }
    func backToMainController(){
        remoteParticipantArr.removeAll()
        
        self.room = nil
        if (self.camera != nil){
            camera?.stopCapture()
            camera = nil
        }
        if (localVideoTrack != nil){
            localVideoTrack = nil
        }
        if localAudioTrack != nil {
            localAudioTrack = nil
        }
        
        self.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: nil)
        
    }
    
    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        print("Subscribe audio track!")
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
      //  self.view.makeToast("Subscribed to audio track for Participant \(participant.identity)")
        
        
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
       // self.view.makeToast("Unsubscribed from audio track for Participant \(participant.identity)")
        
    }
    
    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        print("enableVideoTrack:Particiapnt", participant.sid, remoteParticipantArr.count)
        for obj in vdoCallVM.conferrenceDetail.CONFERENCEInfo! {
            let objects = obj as! ConferenceInfoModels
            if objects.PARTSID == participant.sid {
                self.view.makeToast("TURN ON \(objects.UserName!)'s video", duration: 2, position: .center)
            }
        }

        self.vdoCollectionView.reloadData()
     }
    
    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        print("DisableVideoTrack:Particiapnt", participant.sid, remoteParticipantArr.count)

        for obj in vdoCallVM.conferrenceDetail.CONFERENCEInfo! {
            let objects = obj as! ConferenceInfoModels
            if objects.PARTSID == participant.sid {
                self.view.makeToast("TURN OFF \(objects.UserName!)'s video", duration: 2, position: .center)
            }
        }
     
       
        self.vdoCollectionView.reloadData()
        
    }
    
    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        for obj in vdoCallVM.conferrenceDetail.CONFERENCEInfo! {
            let objects = obj as! ConferenceInfoModels
            if objects.PARTSID == participant.sid {
                self.view.makeToast("Unmute \(objects.UserName!)'s Audio", duration: 2, position: .center)
            }
        }
        if remoteParticipantArr.count > 1 {
//            for audio in remoteParticipantArr {
//                if audio == participant {
//                    if let index = remoteParticipantArr.firstIndex(of: audio) {
//                      //  remoteParticipantArr.remove(at: index)
//                        let indexPath = IndexPath(item: index, section: 0)
//                        vdoCollectionView.reloadItems(at: [indexPath])
//                    }
//                }
//            }
            vdoCollectionView.reloadData()
        }
        else {
            for audio in remoteParticipantArr {
                if audio == participant {
                    if let index = remoteParticipantArr.firstIndex(of: audio) {
                      //  remoteParticipantArr.remove(at: index)
                        let indexPath = IndexPath(item: index, section: 0)
                        vdoCollectionView.reloadItems(at: [indexPath])
                    }
                }
            }
        }
        
        
    }
    
    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        for obj in vdoCallVM.conferrenceDetail.CONFERENCEInfo! {
            let objects = obj as! ConferenceInfoModels
            if objects.PARTSID == participant.sid {
                self.view.makeToast("Mute \(objects.UserName!)'s Audio", duration: 2, position: .center)
            }
        }
        if remoteParticipantArr.count > 1 {
//            for audio in remoteParticipantArr {
//                if audio == participant {
//                    if let index = remoteParticipantArr.firstIndex(of: audio) {
//                      //  remoteParticipantArr.remove(at: index)
//                        let indexPath = IndexPath(item: index, section: 0)
//                        vdoCollectionView.reloadItems(at: [indexPath])
//                    }
//                }
//            }
            vdoCollectionView.reloadData()
        }
        else {
            for audio in remoteParticipantArr {
                if audio == participant {
                    if let index = remoteParticipantArr.firstIndex(of: audio) {
                      //  remoteParticipantArr.remove(at: index)
                        let indexPath = IndexPath(item: index, section: 0)
                        vdoCollectionView.reloadItems(at: [indexPath])
                    }
                }
            }
        }
       // self.view.makeToast("Participant \(participant.identity) disabled audio track")
        
    }
    
    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        self.view.makeToast("FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
        
    }
    
    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        self.view.makeToast("FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
     }
    }


