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
extension VideoCallViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if remoteParticipantArr.count > 1 {
            
            return remoteParticipantArr.count + 1
        }
        else {
            return remoteParticipantArr.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = vdoCollectionView.dequeueReusableCell(withReuseIdentifier: cellIndentifier.VDOCollectionViewCell.rawValue, for: indexPath) as!  VDOCollectionViewCell
        cell.remoteView?.contentMode = .scaleAspectFill
        cell.remoteView.layer.cornerRadius = 0
        cell.remoteView.clipsToBounds = false
        cell.remoteView.frame.size.width = vdoCollectionView.bounds.width
        cell.remoteView.frame.size.height = vdoCollectionView.bounds.height
        
        if remoteParticipantArr.count > 1 {
            if indexPath.row == 0 {
                cell.btnMic.isHidden = true
                preview.isHidden = true
                isAttendMultiPart = true
                self.lView = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                self.lView.contentMode = .scaleAspectFill
                self.lView.clipsToBounds = false
                localVideoTrack!.addRenderer(lView)
                vdoCallVM.videoTrackEnableOrDisable(isenable: localVideoTrack!.isEnabled, img: cell.imgRemotePrivacy)
                cell.audioLbl.isHidden = true
                cell.lblVideo.isHidden = true
                cell.participantName.isHidden = true
                cell.remoteView.addSubview(lView)
                
                return cell
            }
            else {
                if  indexPath.row > 0 {
                    cell.btnMic.isHidden = false
                    
                    let videoPublications = remoteParticipantArr[indexPath.row - 1].remoteVideoTracks
                    let obj = self.vdoCallVM.conferrenceDetail.CONFERENCEInfo![indexPath.row - 1] as! ConferenceInfoModels
                    
                    for publication in videoPublications {
                        print("vdoTrackSid:", publication.trackSid, publication.trackName)
                        if let subscribedVideoTrack = publication.remoteTrack,
                           publication.isTrackSubscribed {
                            print("vdosubscribedVideoTrack2-------------->:", subscribedVideoTrack.sid)
                            if subscribedVideoTrack.isEnabled {
                                cell.imgRemotePrivacy.isHidden = true
                                let remote = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                                remote.contentMode = .scaleAspectFill
                                remote.clipsToBounds = false
                                
                                subscribedVideoTrack.addRenderer(remote)
                                cell.remoteView.addSubview(remote)
                            }
                            else {
                                vdoCallVM.videoTrackEnableOrDisable(isenable: false, img: cell.imgRemotePrivacy)
                                let remote = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                                remote.backgroundColor = UIColor.black
                                remote.contentMode = .scaleAspectFill
                                remote.clipsToBounds = false
                                cell.remoteView.addSubview(remote)
                            }
                            
                        }}
                    let audioPublications = remoteParticipantArr[indexPath.row - 1].audioTracks
                    for audioPub in audioPublications {
                        print("audioTrackSid:", audioPub.trackSid, audioPub.trackName)
                        if let audio = audioPub.audioTrack {
                            audio.isEnabled == true ? (cell.btnMic.isSelected = false) : (cell.btnMic.isSelected = true)
                        }
                    }
                    if vdoCallVM.conferrenceDetail.CONFERENCEInfo?.count ?? 0 > 0 {
                        let pSID = remoteParticipantArr[indexPath.row - 1].sid
                     
                        for pObj in  self.vdoCallVM.conferrenceDetail.CONFERENCEInfo! {
                            let participantSID = pObj as! ConferenceInfoModels
                            if participantSID.PARTSID == pSID {
                                if pSID == isSpeakerSId && isSpeaking{
                                    cell.lblNameSpeaker.isHidden = false
                                    cell.lblNameSpeaker.text = "\(obj.UserName!) is  speaking"
                                }
                                else {
                                    cell.lblNameSpeaker.isHidden = true
                                }
                                cell.participantName.isHidden = false
                                cell.participantName.text = participantSID.UserName
                              
                                cell.configure(obj: participantSID)
                            }
                    
                        }
                        

                    }
                   
                    
                    return cell
                }
            }}
        else {
            let videoPublications = remoteParticipantArr[indexPath.row].remoteVideoTracks
            let pSID = remoteParticipantArr[indexPath.row].sid
            print("vdosubscribedVideoTrack01-------------->:", pSID)
            if isAttendMultiPart {
                if (localAudioTrack == nil) {
                    localAudioTrack = LocalAudioTrack()
                    if (localAudioTrack == nil) {
                        self.view.makeToast("Failed to create audio track")
                    }
                }
                self.preview.isHidden = false
                cell.btnMic.isHidden = false
            }
            for publication in videoPublications {
                print("vdoTrackSid2:", publication.trackSid, publication.trackName)
                if let subscribedVideoTrack = publication.remoteTrack,
                   publication.isTrackSubscribed {
                    print("vdosubscribedVideoTrack1-------------->:", subscribedVideoTrack.sid)
                    if subscribedVideoTrack.isEnabled {
                        vdoCallVM.videoTrackEnableOrDisable(isenable: subscribedVideoTrack.isEnabled, img: cell.imgRemotePrivacy)
                        let remote = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                        remote.contentMode = .scaleAspectFill
                        remote.clipsToBounds = false
                        subscribedVideoTrack.addRenderer(remote)
                        
                        cell.remoteView.addSubview(remote)
                    }
                    else {
                        vdoCallVM.videoTrackEnableOrDisable(isenable: false, img: cell.imgRemotePrivacy)
                        let remote = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                        remote.backgroundColor = UIColor.black
                        remote.contentMode = .scaleAspectFill
                        remote.clipsToBounds = false
                        // cell.audioLbl.isHidden = true
                        //cell.lblVideo.isHidden = true
                        // cell.participantName.isHidden = true
                        cell.remoteView.addSubview(remote)
                    }
                }}
            
            let audioPublications = remoteParticipantArr[indexPath.row].audioTracks
            for audioPub in audioPublications {
                print("audioTrackSid2:", audioPub.trackSid, audioPub.trackName)
                if let audio = audioPub.audioTrack {
                    audio.isEnabled == true ? (cell.btnMic.isSelected = false) : (cell.btnMic.isSelected = true)
                }
            }
            if vdoCallVM.conferrenceDetail.CONFERENCEInfo?.count ?? 0 > 0 {
                let obj = self.vdoCallVM.conferrenceDetail.CONFERENCEInfo![indexPath.row] as! ConferenceInfoModels
                if pSID == obj.PARTSID {
                    
                    cell.participantName.text = obj.UserName
                    cell.configure(obj: obj)
                }
                if (obj.PARTSID == isSpeakerSId) && isSpeaking == true{
                    cell.lblNameSpeaker.isHidden = false
                    cell.lblNameSpeaker.text = "\(obj.UserName!) is  speaking.."
                }
                else {
                    cell.lblNameSpeaker.isHidden = true
                }
            }
            
            return cell
            
        }
        
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == vdoCollectionView {
            if self.remoteParticipantArr.count == 1 {
                return CGSize(width: vdoCollectionView.frame.size.width, height: vdoCollectionView.frame.size.height)
            }
            else if self.remoteParticipantArr.count == 2 {
                if indexPath.row == 0 {
                    return CGSize(width: vdoCollectionView.frame.size.width, height: vdoCollectionView.frame.size.height/2-5)
                    
                }
                else {
                    return CGSize(width: vdoCollectionView.frame.size.width/2-5, height: vdoCollectionView.frame.size.height/2-5)
                }
            }
            else if self.remoteParticipantArr.count == 3 {
                
                return CGSize(width: vdoCollectionView.frame.size.width/2-5, height: vdoCollectionView.frame.size.height/2-5)
            }
            else if self.remoteParticipantArr.count == 4 {
                if indexPath.row == 3 {
                    return CGSize(width: vdoCollectionView.frame.size.width, height: vdoCollectionView.frame.size.height/3-5)
                }
                else {
                    
                    return CGSize(width: vdoCollectionView.frame.size.width/2-5, height: vdoCollectionView.frame.size.height/3-5)
                }
            }
            else if self.remoteParticipantArr.count == 5 {
                return CGSize(width: vdoCollectionView.frame.size.width/2-5, height: vdoCollectionView.frame.size.height/3-5)
            }
            else if self.remoteParticipantArr.count == 6 {
                
                if indexPath.row == 5 {
                    return CGSize(width: vdoCollectionView.frame.size.width/3-5, height: vdoCollectionView.frame.size.height/3-5)
                }
                return CGSize(width: vdoCollectionView.frame.size.width/2-5, height: vdoCollectionView.frame.size.height/3-5)
                
            }
            else if self.remoteParticipantArr.count == 7 {
                if indexPath.row == 6 {
                    return CGSize(width: vdoCollectionView.frame.size.width/3-5, height: vdoCollectionView.frame.size.height/3-5)
                }
                
                return CGSize(width: vdoCollectionView.frame.size.width/2-5, height: vdoCollectionView.frame.size.height/3-5)
            }
            else if self.remoteParticipantArr.count == 8 {
                return CGSize(width: vdoCollectionView.frame.size.width/3-5, height: vdoCollectionView.frame.size.height/3-5)
            }
            return CGSize(width: vdoCollectionView.frame.size.width/2 - 5, height: vdoCollectionView.frame.size.height/2-5)
            
        }
        else {
            return CGSize(width: 370, height: 490)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if bottomView.isHidden != true && topView.isHidden != true {
            bottomView.isHidden = true
            topView.isHidden = true
        }
        else {
            bottomView.isHidden = false
            topView.isHidden = false
        }
    }
}
