//
//  videoViewDelegates.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 08/03/22.
//

import Foundation
import TwilioVideo
import TwilioChatClient
import UIKit
extension VideoCallViewController:VideoViewDelegate {
    func videoViewDidReceiveData(view: VideoView) {
        print("vv:",view)
    }
    func remoteParticipantSwitchedOnVideoTrack(participant: RemoteParticipant, track: RemoteVideoTrack) {
        print("track:",participant)
    }
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        print("vv2:",view)
    }
    func chatClient(_ client: TwilioChatClient, channelAdded channel: TCHChannel) {
        print("channel has added")
    }
    //When new client added in call this method will call
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, messageAdded message: TCHMessage) {
        // print("call-----------------------------101")
        //print("message body:", message.body)
        let messString = message.body!
        if messString.contains("meetingfrominvitenotification") {
            DispatchQueue.main.async {
                self.showLobbyAlert()
            }
            
        }}}

