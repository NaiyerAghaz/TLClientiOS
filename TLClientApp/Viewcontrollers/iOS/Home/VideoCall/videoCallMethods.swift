//
//  videoTrack.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 17/05/22.
//

import Foundation
import TwilioVideo
import TwilioVoice
import TwilioChatClient
import UIKit
extension VideoCallViewController {
    func configureHost(obj: ConferenceInfoModels){
    
        lblAudio.adjustsFontSizeToFitWidth = true
        lblVideo.adjustsFontSizeToFitWidth = true
        if obj.VIDEO == "0" {
            lblVideo.isHidden = false
            lblVideo.text = "You have paused \(obj.UserName!)'s video"
        }
        else {
            lblVideo.isHidden = true
        }
        if obj.MUTE == "0" {
            lblAudio.isHidden = false
            lblAudio.text = "You have muted \(obj.UserName!)'s audio"
        }
        else {
            lblAudio.isHidden = true
        }
       }
    func localPinVideoTapped(){
        pinVideoArr.removeAll()
        btnPinLocal.isSelected = !btnPinLocal.isSelected
       if  btnPinLocal.isSelected {
           btnPinLocal.setTitle("Unpin Video", for: .normal)
        }
        else {
            btnPinLocal.setTitle("Pin Video", for: .normal)
        }
       
        pinVideoArr = [pinModels(isRemotePin: false, isLocalPin: true, lp: localParticipant, rp: remoteParticipant)]
    }
}

struct pinModels{
    var isRemotePin : Bool?
    var isLocalPin: Bool?
    var lp: LocalParticipant?
    var rp: RemoteParticipant?
}
extension UIView
{
    func removeAllSubViews()
    {
       for subView :AnyObject in self.subviews
       {
            subView.removeFromSuperview()
       }
    }

}
