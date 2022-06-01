//
//  CallManager.swift
//  TLClientApp
//
//  Created by Naiyer on 8/26/21.
//

import Foundation
import TwilioVideo
import TwilioVoice
import Malert
import UIKit
class CallManagerVM {
    
    func getRoomList(complitionBlock: @escaping([RoomResultModel]?, Error?) -> ()){
        WebServices.postJson(url: APi.getRoomId.url, jsonObject: roomCreateReq()) { response, error in
            do {
                print("roomidurl:\(APi.getRoomId.url), req:\(self.roomCreateReq()) response:\(response)")
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
                print("twilio register--",userID)
                TwilioVoiceSDK.register(accessToken: accessToken!, deviceToken: deviceToken) { err in
                    if err == nil {
                        print("twilio accesstoken--",accessToken)
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
       
        parameter  = ["sourceLid":sourceID ,"lid":targetID,"Roomno":roomId ,"senderid":userDefaults.string(forKey: .kUSER_ID)! ,"touserid":"","statustype":1,"TLname":targetName,"sLName":sourceName ,"devicetype":"I","calltype":"V","patientname":"","patientno":"","Slid":sourceID,"companyID":userDefaults.string(forKey: "companyID") ?? "","callfrom":"app","ondemandvendorid":"","CallGetInType":"vri"]
        print("addAppcall parameter:",parameter)
        
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
            guard let responseArray1 = response as? [[String: Any]], responseArray1.count > 0 else {
                return
            }
            completionBlock(responseArray1[0], nil)
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
    //MARK OPI call request:
    func normalCallClientReq(ccid:String, clientID: String, roomID: String,sourceId: String,targetID: String) -> [String: Any] {
        
            let para:[String:Any] = ["strSearchString":"<VRICLIENT><ACTION>A</ACTION><ID>\(ccid)</ID><CLIENTID>\(clientID)</CLIENTID><ROOMID>\(roomID)</ROOMID><CALLTYPE>OPI</CALLTYPE><CALLSTATUS>1</CALLSTATUS><SOURCE>\(sourceId)</SOURCE><TARGET>\(targetID)</TARGET></VRICLIENT>"]
            return para
        
       }
    func switchCallClientReq(ccid:String, clientID: String, roomID: String,sourceId: String,targetID: String) -> [String: Any] {
       
            
            let para:[String:Any] = ["strSearchString":"<VRICLIENT><ACTION>C</ACTION><ID>\(ccid)</ID><CLIENTID>\(clientID)</CLIENTID><ROOMID>\(roomID)</ROOMID><CALLTYPE>OPI</CALLTYPE><SOURCE>\(sourceId)</SOURCE><TARGET>\(targetID)</TARGET></VRICLIENT>"]
            return para
       
       }
}

// MARK:- RemoteParticipantDelegate

extension VideoCallViewController : RemoteParticipantDelegate {
    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
        debugPrint("Participant \(participant.identity) published video track")
        
    }
    
    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.
        debugPrint("Participant \(participant.identity) unpublished video track")
        
    }
    
    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.
        debugPrint("Participant \(participant.identity) published audio track")
        
    }
    
    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // self.view.makeToast("Participant \(participant.identity) unpublished audio track")
        debugPrint("mute participant :", participant.audioTracks)
        
    }
    
    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        
        if (self.remoteParticipant == nil) {
           
            _ = renderRemoteParticipant(participant: participant)
        }
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {[self] in
            self.vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: roomID!,partSID: participant.sid!, isfromHostcontrol: false) { [self] success, err in
                if self.remoteParticipantArr.count > 1 {
                DispatchQueue.main.async {
                    print("totalparticipants-1--->",self.vdoCallVM.conferrenceDetail.CONFERENCEInfo?.count)
                    self.lblTotalParticipant.text = "\(self.vdoCallVM.conferrenceDetail.CONFERENCEInfo?.count ?? 2)"
                    self.isChangeView = true
                    self.parentSpeakerView.isHidden = true
                    self.vdoCollectionView.isHidden = false
                    self.vdoCollectionView.reloadData()
                }
                }
                else {
                    DispatchQueue.main.async {
                        self.lblTotalParticipant.text = "\(self.vdoCallVM.conferrenceDetail.CONFERENCEInfo?.count ?? 1)"
                      
                    }
                    
                if vdoCallVM.conferrenceDetail.CONFERENCEInfo?.count ?? 0 > 0 {
                                let pSID = remoteParticipant?.sid
                               
                                for pObj in  self.vdoCallVM.conferrenceDetail.CONFERENCEInfo! {
                                    let participantSID = pObj as! ConferenceInfoModels
                                    if participantSID.PARTSID == pSID {
                                        DispatchQueue.main.async {
                                            self.configureHost(obj: participantSID)
                                            self.remoteParticiapntName = participantSID.UserName!
                                            self.lblParticipantName.adjustsFontSizeToFitWidth = true
                                            self.lblParticipantName.text = participantSID.UserName
                                        }
                                        
                                       } }}}
            }
            isParticipanthasAdded = true
        }
        
    }
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        print("cleanup remote participant----------------------:","remove->",participant, "existing:",self.remoteParticipant)
        // self.view.makeToast("Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
       /* if self.remoteParticipant == participant {
           // cleanupRemoteParticipant()
            
            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
               let index = remainingParticipants.firstIndex(of: participant) {
                remainingParticipants.remove(at: index)
                renderRemoteParticipants(participants: remainingParticipants)
            }
            
        }*/
        if remoteParticipantArr.count > 1 {
            for vdo in remoteParticipantArr {
                if vdo == participant {
                    if let index = remoteParticipantArr.firstIndex(of: vdo) {
                        remoteParticipantArr.remove(at: index)
                    }
                }
            }
            if remoteParticipant == participant {
                print("exchange participants-----", remoteParticipant, "::", participant)
                remoteParticipant = remoteParticipantArr[0]
            }
           lblTotalParticipant.text = "\(remoteParticipantArr.count)"
            print("totalparticipants-3--->",remoteParticipantArr.count)
            DispatchQueue.global(qos: .background).async { [self] in
                vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: roomID!,partSID: participant.sid!, isfromHostcontrol: false) { success, err in
                    if success == true && self.vdoCallVM.conferrenceDetail.TOTALRECORDS != "0"{
                        if self.remoteParticipantArr.count == 1 {
                            DispatchQueue.main.async {
                                self.lblTotalParticipant.text = "\(self.vdoCallVM.conferrenceDetail.CONFERENCEInfo?.count ?? 1)"
                                self.remoteParticipant = self.remoteParticipantArr[0]
                                if self.isChangeView == true {
                                   self.isChangeView = false
                                    self.vdoCollectionView.isHidden = true
                                    self.parentSpeakerView.isHidden = false
                                    self.mainPreview.isHidden = false
                                    self.fullFlashViewChangesMethod(isFlip: false)
                                }
                                else {
                                    
                                    self.isChangeView = false
                                    self.mainPreview.isHidden = false
                                    self.parentSpeakerView.isHidden = false
                                    self.vdoCollectionView.isHidden = true
                                }
                                print("totalparticipants-4--->",remoteParticipantArr.count)
                                
                           
                            }
                           // self.vdoCollectionView.reloadData()
                        }
                        else {
                            DispatchQueue.main.async {
                                self.lblTotalParticipant.text = "\(self.vdoCallVM.conferrenceDetail.CONFERENCEInfo?.count ?? 2)"
                                print("totalparticipants-5--->",self.vdoCallVM.conferrenceDetail.CONFERENCEInfo?.count)
                                if self.room != nil && self.localVideoTrack != nil {
                                    if self.isChangeView == true {
                                        self.vdoCollectionView.reloadData()
                                    }
                                    else {
                                        if self.remoteParticipant == participant {
                                            self.remoteParticipant = self.remoteParticipantArr[0]
                                            self.fullFlashViewChangesMethod(isFlip: false)
                                        }
                                        else {
                                            
                                        }
                                    }
                                }
                               
                               
                            }
                        }
                       }
                    else {
                        isFeedback = true
                        self.backToMainController()
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
        updateYourFeedback()
    }
    @objc func participantNotAvailable(noti:Notification){
        if remoteParticipantArr.count == 0 {
            timer.invalidate()
            ringToneTimer.invalidate()
            if myAudio != nil{
                myAudio!.stop()
            }
            if (localVideoTrack != nil){
                localVideoTrack = nil
            }
            if localAudioTrack != nil {
                localAudioTrack = nil
            }
           camera?.stopCapture()
            DispatchQueue.main.async {
                self.switchToAudioMethod()
            }
          
        }
        
    }
    //MARK: Switch To AudioCall
    public func switchToAudioMethod() {
        let switchToAudioView = SwitchToAudioView.instantiateFromNib()
        let sT = sourceLangName! + ">>>>>" + targetLangName!
        switchToAudioView.stLang = sT
        let alert = Malert(customView: switchToAudioView, tapToDismiss: false)
        alert.buttonsSpace = 10
        alert.buttonsAxis = .horizontal
        alert.textAlign = .center
        alert.margin = 24
        alert.buttonsSideMargin = 24
        alert.buttonsBottomMargin = 16
        alert.cornerRadius = 12
        alert.backgroundColor = UIColor(red:25/255, green:157/255, blue:217/255, alpha:1.0)
        alert.titleFont = UIFont.systemFont(ofSize: 20)
        
        let laterAction = MalertAction(title: "Switch to OPI")
        { [self] in SwiftLoader.show(animated: true)
            if myAudio != nil{
                myAudio!.stop()
            }
            if (room != nil){
                room?.disconnect()
                if (self.camera != nil){
                    camera?.stopCapture()
                    camera = nil
                }
                if (localVideoTrack != nil){
                    localVideoTrack = nil
                }
                if  self.localAudioTrack != nil {
                    self.localAudioTrack = nil
                }
           }
            DispatchQueue.main.async { [self] in
                dismiss(animated: false, completion: nil)
                videocallDelegate?.switchToAudioMethods(roomId: roomID ?? "", sourceLangID: sourceLangID ?? "", targetLangID: targetLangID ?? "", ccid: callid ?? "0", sourceLangName: sourceLangName ?? "", targetLangName: targetLangName ?? "", patientno: patientno ?? "", patientname: patientname ?? "")
             }
           }
        laterAction.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        laterAction.tintColor = UIColor(red:25/255, green:157/255, blue:217/255, alpha:1.0)
        laterAction.cornerRadius = 5
        alert.addAction(laterAction)
        
        let nothanks = MalertAction(title: "No, Thanks"){
            self.dismissViewControllers()
            
        }
        nothanks.backgroundColor = UIColor(red:25/255, green:157/255, blue:217/255, alpha:1.0)
        nothanks.tintColor = .white
        nothanks.cornerRadius = 5
        nothanks.borderColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha:1.0)
        nothanks.borderWidth = 1
        alert.addAction(nothanks)
        // for no thanks rgb 25,157,217
        
        present(alert, animated: true, completion: nil)
        // examples.append(Example(title: "Example 4", malert: alert))
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

        if isParticipanthasAdded {
        if remoteParticipantArr.count > 1 {
            for vdo in remoteParticipantArr {
                if vdo == participant {
                    if let index = remoteParticipantArr.firstIndex(of: vdo) {
                        //  remoteParticipantArr.remove(at: index)
                        let indexPath = IndexPath(item: index + 1, section: 0)
                        DispatchQueue.main.async {
                            self.vdoCollectionView.reloadItems(at: [indexPath])
                        }
                       
                    }
                }
            }
          
        }
        else {
            if isChangeView {
                for vdo in remoteParticipantArr {
                    if vdo == participant {
                        if let index = remoteParticipantArr.firstIndex(of: vdo) {
                            //  remoteParticipantArr.remove(at: index)
                            let indexPath = IndexPath(item: index + 1, section: 0)
                            DispatchQueue.main.async {
                                self.vdoCollectionView.reloadItems(at: [indexPath])
                            }
                            
                        }
                    }
                }
            }
            else {
                if participant == remoteParticipant {
                    if isSwitchToRemote {
                    preview.backgroundColor = UIColor.clear
                        imgLocalPrivacy.isHidden = true
                    }
                    else {
                        speakerImgPrivacy.isHidden = true
                    }
                   }
            } }
        }
    }
    
    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        print("DisableVideoTrack:Particiapnt", participant.sid, remoteParticipantArr.count)
     if isParticipanthasAdded {
        if remoteParticipantArr.count > 1 {
            for vdo in remoteParticipantArr {
                if vdo == participant {
                    if let index = remoteParticipantArr.firstIndex(of: vdo) {
                        //  remoteParticipantArr.remove(at: index)
                        let indexPath = IndexPath(item: index + 1, section: 0)
                        DispatchQueue.main.async {
                            self.vdoCollectionView.reloadItems(at: [indexPath])
                        }
                    }
                }
            }
           
        }
        else {
            if isChangeView {
                for vdo in remoteParticipantArr {
                    if vdo == participant {
                        if let index = remoteParticipantArr.firstIndex(of: vdo) {
                            //  remoteParticipantArr.remove(at: index)
                            let indexPath = IndexPath(item: index + 1, section: 0)
                            DispatchQueue.main.async {
                                self.vdoCollectionView.reloadItems(at: [indexPath])
                            }
                        }
                    }
                }
            }
            else {
                if participant == remoteParticipant {
                    if isSwitchToRemote {
                        preview.backgroundColor = UIColor.black
                        imgLocalPrivacy.isHidden = false
                    }
                    else {
                        speakerImgPrivacy.isHidden = false
                    }
                   
                }
            }
            
        }}
        
    }
    
    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
       

        if isParticipanthasAdded {
        if remoteParticipantArr.count > 1 {
            for audio in remoteParticipantArr {
                if audio == participant {
                    if let index = remoteParticipantArr.firstIndex(of: audio) {
                        //  remoteParticipantArr.remove(at: index)
                        let indexPath = IndexPath(item: index + 1, section: 0)
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            self.vdoCollectionView.reloadItems(at: [indexPath])
                        }
                    }
                }
            }
            
        }
            else {
                if isChangeView {
            for audio in remoteParticipantArr {
                if audio == participant {
                    if let index = remoteParticipantArr.firstIndex(of: audio) {
                        //  remoteParticipantArr.remove(at: index)
                        let indexPath = IndexPath(item: index + 1, section: 0)
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            self.vdoCollectionView.reloadItems(at: [indexPath])
                        }
                       
                    }
                }
            }}
                else {
                    if participant == remoteParticipant {
                        if isSwitchToRemote {
                            btnMic.isSelected = false
                            btnMic.isHidden = false
                            btnSpeakerMic.isHidden = true
                            
                           
                        }
                        else {
                            btnSpeakerMic.isSelected = false
                            btnSpeakerMic.isHidden = false
                            btnMic.isSelected = false
                            btnMic.isHidden = true
                        }
                       
                    }
                }
        }}}
    
    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
       

        if isParticipanthasAdded {
        if remoteParticipantArr.count > 1 {
            for audio in remoteParticipantArr {
                if audio == participant {
                    if let index = remoteParticipantArr.firstIndex(of: audio) {
                        //  remoteParticipantArr.remove(at: index)
                        let indexPath = IndexPath(item: index + 1, section: 0)
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            self.vdoCollectionView.reloadItems(at: [indexPath])
                        }
                       
                    }
                }
            }
           
        }
        else {
            if isChangeView {
            for audio in remoteParticipantArr {
                if audio == participant {
                    if let index = remoteParticipantArr.firstIndex(of: audio) {
                        //  remoteParticipantArr.remove(at: index)
                        let indexPath = IndexPath(item: index + 1, section: 0)
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            self.vdoCollectionView.reloadItems(at: [indexPath])
                        }
                    }
                }
            }}
            else {
                if participant == remoteParticipant {
                    if isSwitchToRemote {
                        btnMic.isSelected = true
                        btnMic.isHidden = false
                        btnSpeakerMic.isHidden = true
                       
                    }
                    else {
                        btnSpeakerMic.isHidden = false
                        btnSpeakerMic.isSelected = true
                        btnMic.isSelected = false
                        btnMic.isHidden = true
                    }
                   
                }
            }
        }}
    }
    
    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        self.view.makeToast("FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
        
    }
    
    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        self.view.makeToast("FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}


