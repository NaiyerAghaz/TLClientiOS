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
        
        // self.cleanupRemoteParticipant()
        
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
            updateYourFeedback()
        }
        
    }
    //THis method will call who is speaking
    func dominantSpeakerDidChange(room: Room, participant: RemoteParticipant?) {
       print("participantisSpeakerSId:", participant?.sid)
       /* currentSpeakerParticipant = participant
        if remoteParticipantArr.count > 1 {
        if previousSpeakerParticipant == nil && participant != nil{
           print("pp----------------01")
            for newP in remoteParticipantArr {
                if newP == currentSpeakerParticipant {
                    if let index = remoteParticipantArr.firstIndex(of: newP) {
                        //  remoteParticipantArr.remove(at: index)
                        let indexPath = IndexPath(item: index + 1, section: 0)
                        previousSpeakerParticipant = participant
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.vdoCollectionView.reloadItems(at: [indexPath])
                        }
                    }
                }
            }
        }
        else if previousSpeakerParticipant != nil && participant != nil{
            
            if currentSpeakerParticipant != previousSpeakerParticipant {
                for newP in remoteParticipantArr {
                    if newP == currentSpeakerParticipant {
                        if let index = remoteParticipantArr.firstIndex(of: newP) {
                          previousSpeakerParticipant = participant
                            let indexPath = IndexPath(item: index + 1, section: 0)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                self.vdoCollectionView.reloadItems(at: [indexPath])
                            }
                        }
                    }
                }
                for newP in remoteParticipantArr {
                    if newP == previousSpeakerParticipant {
                        if let index = remoteParticipantArr.firstIndex(of: newP) {
                            //  remoteParticipantArr.remove(at: index)
                            
                            let indexPath = IndexPath(item: index + 1, section: 0)
                           
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                self.vdoCollectionView.reloadItems(at: [indexPath])
                            }
                        }
                    }
                }
               
            }
            else {
                for newP in remoteParticipantArr {
                    if newP == currentSpeakerParticipant {
                        if let index = remoteParticipantArr.firstIndex(of: newP) {
                            //  remoteParticipantArr.remove(at: index)
                            let indexPath = IndexPath(item: index + 1, section: 0)
                            self.previousSpeakerParticipant = participant
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.vdoCollectionView.reloadItems(at: [indexPath])
                            }
                        }
                    }
                }
               
            }
        }
        else {
            for newP in remoteParticipantArr {
                if newP == previousSpeakerParticipant {
                    if let index = remoteParticipantArr.firstIndex(of: newP) {
                        //  remoteParticipantArr.remove(at: index)
                        let indexPath = IndexPath(item: index, section: 0)
                        previousSpeakerParticipant = participant
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.vdoCollectionView.reloadItems(at: [indexPath])
                        }
                    }
                }
            }
           
        }
        }
        else {
            if participant != nil {
                
                for newP in remoteParticipantArr {
                    if newP == currentSpeakerParticipant {
                        if let index = remoteParticipantArr.firstIndex(of: newP) {
                            //  remoteParticipantArr.remove(at: index)
                            let indexPath = IndexPath(item: index, section: 0)
                            self.previousSpeakerParticipant = participant
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.vdoCollectionView.reloadItems(at: [indexPath])
                            }
                        }
                    }
                }
            }
            else {
                for newP in remoteParticipantArr {
                    if newP == previousSpeakerParticipant {
                        if let index = remoteParticipantArr.firstIndex(of: newP) {
                            //  remoteParticipantArr.remove(at: index)
                            let indexPath = IndexPath(item: index, section: 0)
                            currentSpeakerParticipant = participant
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.vdoCollectionView.reloadItems(at: [indexPath])
                            }
                        }
                    }
                }
            }
         }*/
        
    }

    
    func roomDidFailToConnect(room: Room, error: Error) {
        //logMessage(messageText: "Failed to connect to room with error: \(error.localizedDescription)")
        self.view.makeToast("Failed to connect to room with error: \(error.localizedDescription)")
        // self.callKitCompletionHandler!(false)
        self.room = nil
        // self.showRoomUI(inRoom: false)
    }
    
    func roomIsReconnecting(room: Room, error: Error) {
        self.view.makeToast( "Reconnecting to room internet is too slow..")
        
    }
    
    func roomDidReconnect(room: Room) {
        // self.view.makeToast( "Reconnected to room \(room.name)")
        //  logMessage(messageText: "Reconnected to room \(room.name)")
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        if !recordTime.isValid {
            callStartTime = cEnum.instance.getCurrentDateAndTime()
            recordTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(recordTimer), userInfo: nil, repeats: true)
        }
     
       
//        let vdoModel = VDOCallViewModel()
//        let req = vdoModel.companyReqDetails(userID: userDefaults.string(forKey: .kUSER_ID)!)
//        print("participantDidConnectCount----->",self.remoteParticipantArr.count)
//        vdoModel.getCompanydetails(req: req) { success, err in
//            print("getCompanydetails:",success,(vdoModel.apiCompanyDetailsModel?.resultData![0].pARTCOUNT)!)
//            if (vdoModel.apiCompanyDetailsModel?.resultData![0].pARTCOUNT)! > self.remoteParticipantArr.count {
//                print("getCompanydetails 11111:")
//                DispatchQueue.main.async {
//
//                    self.remoteParticipantArr.append(participant)
//                }
//
//            }
//            else {
//                self.view.makeToast("You have reached maximum participants limit", position: .center)
//            }
//        }
      //  SecondaryRemoteParticipant = participant
        participant.delegate = self
        self.remoteParticipantArr.append(participant)
        print("participantDidConnect----->",participant)
       
//        participant.delegate = self
//        self.remoteParticipantArr.append(participant)
        
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        recordTime.invalidate()
        timer.invalidate()
        if myAudio != nil{
            myAudio!.stop()
        }
    }
    
}
