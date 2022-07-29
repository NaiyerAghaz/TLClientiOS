//
//  RoomDelegates.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 08/03/22.
//

import Foundation
import UIKit
import TwilioVideo
import CallKit
//MARK: RoomDelegate
extension VideoCallViewController:RoomDelegate{
    func roomDidConnect(room: Room) {
       let vModel = VDOCallViewModel()
        // TwilioVideoSDK.audioDevice = audioDevice
        // At the moment, this example only supports rendering one Participant at a time.
        // self.view.makeToast("Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")
        print("participantDidConnect11111----->",room.remoteParticipants)
        for remoteParticipant in room.remoteParticipants {
            
            remoteParticipant.delegate = self
        }
        
        localParticipant = room.localParticipant
        primarylocalParticiapnt = localParticipant
        
        roomlocalParticipantSIDrule = room.localParticipant?.sid
        localParticipant?.delegate = self
        
        self.localParicipantDictionary?["0"] = ["participant":localParticipant]
        for i in 0 ..< room.remoteParticipants.count {
            let nParticipant = room.remoteParticipants[i]
            remoteParticipantArr.append(nParticipant)
            // if let participant = room.remoteParticipants[i] {
            nParticipant.delegate = self
            self.remoteParicipantDictionary?["\(i)"] = ["participant":nParticipant]
            
            //  }
        }
        let req = vModel.participantReqApi(roomID: self.roomID ?? "", participantSID: (room.localParticipant?.sid)!, roomSID: room.sid, userID: userDefaults.string(forKey: .kUSER_ID)!)
        vModel.participantUserActionDetails(req: req) { success, err in
            print("reposen : \(success) url: \( APi.ConferenceParticipant.url) request:\(req)")
        }
        
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
        // logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")
        recordTime.invalidate()
        if !self.userInitiatedDisconnect, let uuid = room.uuid, let error = error as? TwilioVideoSDK.Error {
            var reason = CXCallEndedReason.remoteEnded
            
            if error.code != .roomRoomCompletedError {
                reason = .failed
            }
            
            // self.callKitProvider.reportCall(with: uuid, endedAt: nil, reason: reason)
        }
        
        self.cleanRemoteParticipants()
        
        //  self.showRoomUI(inRoom: false)
        //  self.callKitCompletionHandler = nil
        self.userInitiatedDisconnect = false
        room.disconnect()
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
       
        if remoteParticipantArr.count > 0{
            chatClosed()
            if customerEndCall == false {
           
            updateYourFeedback()
            }
        }
        
    }
   
    //THis method will call who is speaking
    func dominantSpeakerDidChange(room: Room, participant: RemoteParticipant?) {
//        if room.localParticipant != nil {
//            self.localParticipant = room.localParticipant
//        }
        if participant?.sid != nil {
            if remoteParticipantArr.count != vdoCallVM.conferrenceDetail.CONFERENCEInfo?.count {
                self.vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: roomID!, partSID: (participant?.sid!)!, isfromHostcontrol: false) { success, err in

                    DispatchQueue.main.async {
                        self.lblTotalParticipant.text = "\(self.vdoCallVM.conferrenceDetail.CONFERENCEInfo?.count ?? 0)"
                    }

                    }
            }
        }
//       
        if participant != nil {
            if isChangeView {
                if currentSpeakerParticipant != nil && participant != currentSpeakerParticipant{
                    let temp = currentSpeakerParticipant
                    currentSpeakerParticipant = participant
                    if let index = remoteParticipantArr.firstIndex(of: participant!) {
                        //  remoteParticipantArr.remove(at: index)
                        let indexPath = IndexPath(item: index + 1, section: 0)
                       // previousSpeakerParticipant = participant
                        DispatchQueue.main.async {
                            self.vdoCollectionView.reloadItems(at: [indexPath])
                        }
                    }
                    if let index = remoteParticipantArr.firstIndex(of: temp!) {
                        //  remoteParticipantArr.remove(at: index)
                        let indexPath = IndexPath(item: index + 1, section: 0)
                       // previousSpeakerParticipant = participant
                        DispatchQueue.main.async {
                            self.vdoCollectionView.reloadItems(at: [indexPath])
                        }
                    }

                    
                }
                else {
                    currentSpeakerParticipant = participant
                    if let index = remoteParticipantArr.firstIndex(of: participant!) {
                        //  remoteParticipantArr.remove(at: index)
                        let indexPath = IndexPath(item: index + 1, section: 0)
                       // previousSpeakerParticipant = participant
                        DispatchQueue.main.async {
                            self.vdoCollectionView.reloadItems(at: [indexPath])
                        }
                    }
                   
                    
                   // self.vdoCollectionView.reloadData()
                }
            }
        }
        else {
            if isChangeView {
                if currentSpeakerParticipant != nil && participant == nil{
                    let temp = currentSpeakerParticipant
                    currentSpeakerParticipant = participant
                   
                    if let index = remoteParticipantArr.firstIndex(of: temp!) {
                        //  remoteParticipantArr.remove(at: index)
                        let indexPath = IndexPath(item: index + 1, section: 0)
                       // previousSpeakerParticipant = participant
                        DispatchQueue.main.async {
                            self.vdoCollectionView.reloadItems(at: [indexPath])
                        }
                    }
}
                else {
                    if participant != nil {
                        currentSpeakerParticipant = participant
                        if let index = remoteParticipantArr.firstIndex(of: participant!) {
                            //  remoteParticipantArr.remove(at: index)
                            let indexPath = IndexPath(item: index + 1, section: 0)
                           // previousSpeakerParticipant = participant
                            DispatchQueue.main.async {
                                self.vdoCollectionView.reloadItems(at: [indexPath])
                            }
                        }
                    }
                  }
            }
        }
   }

    
    func roomDidFailToConnect(room: Room, error: Error) {
        //logMessage(messageText: "Failed to connect to room with error: \(error.localizedDescription)")
        self.view.makeToast("Failed to connect to room with error: \(error.localizedDescription)")
        // self.callKitCompletionHandler!(false)
        self.room = nil
        // self.showRoomUI(inRoom: false)
    }
    
    func roomIsReconnecting(room: Room, error: Error) {
        self.lblReconecting.isHidden = false
        self.lblReconecting.startBlink()
        
        self.view.makeToast( "Reconnecting to room internet is too slow..")
        
    }
    
    func roomDidReconnect(room: Room) {
        self.lblReconecting.stopBlink()
        self.lblReconecting.isHidden = true
        self.localParticipant = room.localParticipant
        // self.view.makeToast( "Reconnected to room \(room.name)")
        //  logMessage(messageText: "Reconnected to room \(room.name)")
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        print("particiapnt did connect-->")
        participant.delegate = self
        self.remoteParticipantArr.append(participant)
//        self.vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: roomID!, partSID: participant.sid!, isfromHostcontrol: false) { success, err in
//            print("getParticipantList2 --->6:")
//            print(success)
//        }
        
        if !recordTime.isValid {
            callStartTime = cEnum.instance.getCurrentDateAndTime()
            recordTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(recordTimer), userInfo: nil, repeats: true)
        }
  
        
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {

        if remoteParticipantArr.count > 1{
                    self.vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: roomID!, partSID: participant.sid!, isfromHostcontrol: false) { success, err in
                      
                    }
            if remoteParticipant != nil {
                recordTime.invalidate()
                
                timer.invalidate()
                if myAudio != nil{
                    myAudio!.stop()
                }
            }
            
        }
      
    }
    
}
