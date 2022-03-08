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
        // At the moment, this example only supports rendering one Participant at a time.
        // self.view.makeToast("Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")
        
        for remoteParticipant in room.remoteParticipants {
            
            remoteParticipant.delegate = self
        }
        
        localParticipant = room.localParticipant
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
        self.callKitCompletionHandler = nil
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
        updateYourFeedback()
       // self.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    func roomDidFailToConnect(room: Room, error: Error) {
        //logMessage(messageText: "Failed to connect to room with error: \(error.localizedDescription)")
        self.view.makeToast("Failed to connect to room with error: \(error.localizedDescription)")
        self.callKitCompletionHandler!(false)
        self.room = nil
        // self.showRoomUI(inRoom: false)
    }
    
    func roomIsReconnecting(room: Room, error: Error) {
        self.view.makeToast( "Reconnecting to room internet is too slow..")
        //  logMessage(messageText: "Reconnecting to room \(room.name), error = \(String(describing: error))")
    }
    
    func roomDidReconnect(room: Room) {
        // self.view.makeToast( "Reconnected to room \(room.name)")
        //  logMessage(messageText: "Reconnected to room \(room.name)")
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        print("participant added times---------------:",participant.remoteAudioTracks.count)
        recordTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(recordTimer), userInfo: nil, repeats: true)
        /*  participant.delegate = self
         // Listen for events from all Participants to decide which RemoteVideoTrack to render.
         
         // self.view.makeToast( "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
         var saveParticipant = true
         var index = 0
         for i in 0...self.remoteParticipantArr.count
         {
         //(self.localParicipantDictionary?.value(forKey: "0") as? NSObject)?.value(forKey: "participant") as?
         let newParticipant = (remoteParicipantDictionary?.value(forKey: "\(i)") as? NSObject)?.value(forKey: "participant") as? RemoteParticipant
         
         if newParticipant == participant {
         saveParticipant = false
         }
         index = i + 1
         }
         if saveParticipant{
         self.remoteParticipantArr.append(participant)
         participant.delegate = self
         self.remoteParicipantDictionary?["\(index)"] = ["participant":participant]
         
         }*/
        participant.delegate = self
        self.remoteParticipantArr.append(participant)
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        recordTime.invalidate()
        timer.invalidate()
        if myAudio != nil{
            myAudio.stop()
        }
    }
    
}
