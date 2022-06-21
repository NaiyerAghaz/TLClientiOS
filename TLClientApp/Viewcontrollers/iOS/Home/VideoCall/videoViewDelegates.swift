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
        let messString = message.body!
        //chat message adding:
        
        if message.hasMedia() {
           
                isOpenChat == true ? (chatIndicatorView.isHidden = true) : (chatIndicatorView.isHidden = false)
                
//                message.getMediaContentTemporaryUrl { result, imgurl in
//                    self.chatVModel.getChatMessage(message: message, istypeImg: true, url: imgurl ?? "") { data, err in
//                        self.chatListArr.append(data!)
//
//                    } }
            let ndict = message.attributes()?.dictionary
            let mszStr = ndict![AnyHashable("attributes")] as! String
            print("mszSTR---->", mszStr)
            let cusIndetity = userDefaults.string(forKey: "twilioIdentity")
            if !mszStr.contains(cusIndetity!){
                message.getMediaContentTemporaryUrl { result, imgurl in
                    self.chatVModel.getChatMessage(message: message, istypeImg: true, url: imgurl ?? "") { data, err in
                        self.chatListArr.append(data!)
                        if self.isOpenChat {
                           
                            DispatchQueue.main.async {
                                self.chatIndicatorView.isHidden = true
                                self.tblView.reloadData()
                                self.view.layoutIfNeeded()
                                self.tblView.scrollToBottomRow()
                                
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.chatIndicatorView.isHidden = false
                            }
                           
                        }
                        } }
                
            }else {
                if self.isOpenChat {
                   
                    DispatchQueue.main.async {
                        self.chatIndicatorView.isHidden = true
                        if self.chatListArr.count > 0 {
                            self.tblView.reloadData()
                            self.view.layoutIfNeeded()
                            self.tblView.scrollToBottomRow()
                        }
                    }
                }
                else{
                    self.chatIndicatorView.isHidden = false
                }}}
        else if messString.contains(":") && messString.contains("##"){
           self.chatVModel.getChatMessage(message: message, istypeImg: false, url: "") { data, err in
                    self.chatListArr.append(data!)
                    if self.isOpenChat {
                        self.chatIndicatorView.isHidden = true
                        DispatchQueue.main.async {
                            self.tblView.reloadData()
                            self.view.layoutIfNeeded()
                            self.tblView.scrollToBottomRow()
                        }
                       }
                    else {
                        self.chatIndicatorView.isHidden = false
                    }
                   }}
        
        //        if remoteParticipantArr.count >= 10 {
        //            return self.view.makeToast("You have reached maximum participants limit", position: .center)
        //        }
        else {
            if messString.contains("meetingfrominvitenotification") {
                DispatchQueue.main.async {
                    self.showLobbyAlert()
                }
                
            }
        }
    }
    func jsonToString(json: AnyObject) -> String{
        do {
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            return jsonString
            
        } catch let myJSONError {
            print(myJSONError)
            return myJSONError.localizedDescription
        }
        
    }
    
    
    
    public func getChatMessage(msz: String, message:TCHMessage,isOpenChats:Bool) {
        let nMsz = msz.replacingOccurrences(of: "\n", with: "")
        let arr = nMsz.split(separator: ":")
        let senderName = arr.first
        let lastObj = arr.last?.dropFirst()
        let mszArr = lastObj?.split(separator: "#")
        let sName2 = mszArr?.first
        let msz = mszArr?[1]
        let sImage = mszArr?[2]
        let sIdentity = mszArr?[3] ?? ""
        
        var data = RowData.init()
        data.rowType = .txt
        sIdentity == (userDefaults.string(forKey: "twilioIdentity") ?? "") ? (data.sender = 0) : (data.sender = 1)
        data.cellIdentifier = .txtCell
        data.sid = message.sid
        data.txt = "\(msz ?? "")"
        data.profileImg = "\(sImage ?? "")"
        data.name = "\(senderName ?? "")"
        data.time = message.dateCreated
        chatArr.append(data)
        if isOpenChats {
            NotificationCenter.default.post(name: Notification.Name("chatUpdateWithNotify"), object: nil,userInfo: nil)
        }
        
        print("messString:\(msz),senderName:\(senderName), lastObj:\(lastObj),mszArr:\(mszArr),sName2:\(sName2),msz:\(msz),sImage:\(sImage),sIdentity:\(sIdentity)")
    }
    
    
    //MARK: Collectionview Delegate and Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if remoteParticipantArr.count > 1 {
            
            return remoteParticipantArr.count + 1
        }
        
        else {
            if isChangeView {
                return remoteParticipantArr.count + 1
            }
            else {
                return remoteParticipantArr.count
            }
            
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = vdoCollectionView.dequeueReusableCell(withReuseIdentifier: cellIndentifier.VDOCollectionViewCell.rawValue, for: indexPath) as!  VDOCollectionViewCell
        
        let cRemoteView = VideoView(frame: CGRect(x: 0, y: 0, width: cell.remoteView.frame.size.width-1, height: cell.remoteView.frame.size.height-1))
        cRemoteView.contentMode = .scaleAspectFill
        cRemoteView.layer.cornerRadius = 0
        cRemoteView.clipsToBounds = false
        cell.remoteView.addSubview(cRemoteView)
        cell.btnPinVideo.tag = indexPath.row
        cell.btnPinVideo.addTarget(self, action: #selector(pinVideoMethods(sender:)), for: .touchUpInside)
        cell.btnPinVideo.layer.cornerRadius = 5
        cell.btnPinVideo.clipsToBounds = true
        
        
        if remoteParticipantArr.count > 1{
            if indexPath.row == 0 {
                
                cell.btnMic.isHidden = true
                mainPreview.isHidden = true
                // isAttendMultiPart = true
                //  self.lView = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                //  self.lView.contentMode = .scaleAspectFill
                // self.lView.clipsToBounds = false
                localVideoTrack!.addRenderer(cRemoteView)
                vdoCallVM.videoTrackEnableOrDisable(isenable: localVideoTrack!.isEnabled, img: cell.imgRemotePrivacy)
                cell.audioLbl.isHidden = true
                cell.lblVideo.isHidden = true
                //cell.isSpeakingLbl.isHidden = true
                cell.participantName.isHidden = true
                //  cell.remoteView.addSubview(lView)
                
                if pinVideoArr.count > 0 {
                    if pinVideoArr[0].isLocalPin  == true {
                        cell.btnPinVideo.isSelected = true
                    }
                    else {
                        cell.btnPinVideo.isSelected = false
                    }
                }
                else {
                    cell.btnPinVideo.isSelected = false
                }
                cell.remoteView.layer.borderColor = UIColor.clear.cgColor
                cell.remoteView.layer.borderWidth = 0
                
                return cell
            }
            else {
                if  indexPath.row > 0 {
                    cell.btnMic.isHidden = false
                    
                    let videoPublications = remoteParticipantArr[indexPath.row - 1].remoteVideoTracks
                    let objSID = remoteParticipantArr[indexPath.row - 1].sid
                    for publication in videoPublications {
                        print("vdoTrackSid:", publication.trackSid, publication.trackName)
                        if let subscribedVideoTrack = publication.remoteTrack,
                           publication.isTrackSubscribed {
                            print("vdosubscribedVideoTrack2-------------->:", subscribedVideoTrack.sid)
                            if subscribedVideoTrack.isEnabled {
                                cell.imgRemotePrivacy.isHidden = true
                                // let remote = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                                //  remote.contentMode = .scaleAspectFill
                                // remote.clipsToBounds = false
                                
                                subscribedVideoTrack.addRenderer(cRemoteView)
                                // cell.remoteView.addSubview(remote)
                            }
                            else {
                                cell.imgRemotePrivacy.isHidden = false
                                //vdoCallVM.videoTrackEnableOrDisable(isenable: false, img: cell.imgRemotePrivacy)
                                // let remote = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                                //remote.backgroundColor = UIColor.black
                                // remote.contentMode = .scaleAspectFill
                                // remote.clipsToBounds = false
                                cell.remoteView.addSubview(cRemoteView)
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
                                
                                cell.participantName.adjustsFontSizeToFitWidth = true
                                cell.participantName.text = participantSID.UserName
                                cell.configure(obj: participantSID)
                                cell.participantName.isHidden = false
                                if currentSpeakerParticipant?.sid == pSID {
                                    cell.remoteView.layer.borderColor = UIColor.green.cgColor
                                    cell.remoteView.layer.borderWidth = 2
                                }
                                else {
                                    cell.remoteView.layer.borderColor = UIColor.clear.cgColor
                                    cell.remoteView.layer.borderWidth = 0
                                }
                                
                            }
                        }
                    }
                    
                    if pinVideoArr.count > 0 {
                        if pinVideoArr[0].isRemotePin == true {
                            if remoteParticipantArr[indexPath.row - 1] == pinVideoArr[0].rp {
                                cell.btnPinVideo.isSelected = true
                            }
                            else {
                                cell.btnPinVideo.isSelected = false
                            }
                            
                        }
                        else {
                            cell.btnPinVideo.isSelected = false
                        }
                    }
                    else {
                        cell.btnPinVideo.isSelected = false
                    }
                    
                    return cell
                }}
        }
        
        else {
            
            if isChangeView {
                if indexPath.row == 0 {
                    cell.btnMic.isHidden = true
                    
                    mainPreview.isHidden = true
                    // isAttendMultiPart = true
                    // self.lView = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                    // self.lView.contentMode = .scaleAspectFill
                    // self.lView.clipsToBounds = false
                    localVideoTrack!.addRenderer(cRemoteView)
                    vdoCallVM.videoTrackEnableOrDisable(isenable: localVideoTrack!.isEnabled, img: cell.imgRemotePrivacy)
                    cell.audioLbl.isHidden = true
                    cell.lblVideo.isHidden = true
                    
                    //cell.isSpeakingLbl.isHidden = true
                    cell.participantName.isHidden = true
                    cell.remoteView.layer.borderColor = UIColor.clear.cgColor
                    cell.remoteView.layer.borderWidth = 0
                    //  cell.remoteView.addSubview(lView)
                    if pinVideoArr.count > 0 {
                        if pinVideoArr[0].isLocalPin  == true {
                            cell.btnPinVideo.isSelected = true
                        }
                        else {
                            cell.btnPinVideo.isSelected = false
                        }
                    }
                    else {
                        cell.btnPinVideo.isSelected = false
                    }
                    return cell
                }
                else {
                    if  indexPath.row > 0 {
                        cell.btnMic.isHidden = false
                        let videoPublications = remoteParticipantArr[indexPath.row - 1].remoteVideoTracks
                        //  let obj = self.vdoCallVM.conferrenceDetail.CONFERENCEInfo![indexPath.row - 1] as! ConferenceInfoModels
                        // let objSID = remoteParticipantArr[indexPath.row - 1].sid
                        for publication in videoPublications {
                            print("vdoTrackSid:", publication.trackSid, publication.trackName)
                            if let subscribedVideoTrack = publication.remoteTrack,
                               publication.isTrackSubscribed {
                                print("vdosubscribedVideoTrack2-------------->222:", subscribedVideoTrack.sid)
                                if subscribedVideoTrack.isEnabled {
                                    cell.imgRemotePrivacy.isHidden = true
                                    // let remote = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                                    // remote.contentMode = .scaleAspectFill
                                    // remote.clipsToBounds = false
                                    subscribedVideoTrack.addRenderer(cRemoteView)
                                    // cell.remoteView.addSubview(remote)
                                }
                                else {
                                    cell.imgRemotePrivacy.isHidden = false
                                    // vdoCallVM.videoTrackEnableOrDisable(isenable: false, img: cell.imgRemotePrivacy)
                                    // let remote = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                                    cRemoteView.backgroundColor = UIColor.black
                                    // remote.contentMode = .scaleAspectFill
                                    //  remote.clipsToBounds = false
                                    //cell.remoteView.addSubview(remote)
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
                                    print("audioTrackSid:",pSID, participantSID.UserName)
                                    cell.participantName.adjustsFontSizeToFitWidth = true
                                    
                                    cell.participantName.text = participantSID.UserName
                                    cell.configure(obj: participantSID)
                                    cell.participantName.isHidden = false
                                    if currentSpeakerParticipant?.sid == pSID {
                                        cell.remoteView.layer.borderColor = UIColor.green.cgColor
                                        cell.remoteView.layer.borderWidth = 2
                                    }
                                    else {
                                        cell.remoteView.layer.borderColor = UIColor.clear.cgColor
                                        cell.remoteView.layer.borderWidth = 0
                                    }
                                    
                                }
                            }
                        }
                        
                        if pinVideoArr.count > 0 {
                            if pinVideoArr[0].isRemotePin == true {
                                if remoteParticipantArr[indexPath.row - 1] == pinVideoArr[0].rp {
                                    cell.btnPinVideo.isSelected = true
                                }
                                else {
                                    cell.btnPinVideo.isSelected = false
                                }}
                            else {
                                cell.btnPinVideo.isSelected = false
                            }
                        }
                        else {
                            cell.btnPinVideo.isSelected = false
                        }
                        
                        
                        return cell
                    }
                }
            }
            
            else {
                let videoPublications = remoteParticipantArr[indexPath.row].remoteVideoTracks
                let pSID = remoteParticipantArr[indexPath.row].sid
                
                //                if isAttendMultiPart {
                //                    if (localAudioTrack == nil) {
                //                        localAudioTrack = LocalAudioTrack()
                //                        if (localAudioTrack == nil) {
                //                            self.view.makeToast("Failed to create audio track")
                //                        }
                //                    }
                //
                //                    self.mainPreview.isHidden = false
                //                    cell.btnMic.isHidden = false
                //                }
                for publication in videoPublications {
                    print("vdoTrackSid2:", publication.trackSid, publication.trackName)
                    if let subscribedVideoTrack = publication.remoteTrack,
                       publication.isTrackSubscribed {
                        print("vdosubscribedVideoTrack1-------------->33:", subscribedVideoTrack.sid)
                        if subscribedVideoTrack.isEnabled {
                            vdoCallVM.videoTrackEnableOrDisable(isenable: subscribedVideoTrack.isEnabled, img: cell.imgRemotePrivacy)
                            //  let remote = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                            // remote.contentMode = .scaleAspectFill
                            //  remote.clipsToBounds = false
                            subscribedVideoTrack.addRenderer(cRemoteView)
                            
                            // cell.remoteView.addSubview(remote)
                        }
                        else {
                            vdoCallVM.videoTrackEnableOrDisable(isenable: false, img: cell.imgRemotePrivacy)
                            // let remote = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                            cRemoteView.backgroundColor = UIColor.black
                            //remote.contentMode = .scaleAspectFill
                            //remote.clipsToBounds = false
                            // cell.audioLbl.isHidden = true
                            //cell.lblVideo.isHidden = true
                            // cell.participantName.isHidden = true
                            // cell.remoteView.addSubview(remote)
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
                        
                        cell.participantName.adjustsFontSizeToFitWidth = true
                        cell.participantName.isHidden = false
                        cell.participantName.text = "\(obj.UserName!)"
                        cell.configure(obj: obj)
                    }
                    
                }
                
                if pinVideoArr.count > 0 {
                    if pinVideoArr[0].isRemotePin == true {
                        if remoteParticipantArr[indexPath.row - 1] == pinVideoArr[0].rp {
                            cell.btnPinVideo.isSelected = true
                        }
                        else {
                            cell.btnPinVideo.isSelected = false
                        }
                    }
                    else {
                        cell.btnPinVideo.isSelected = false
                    }
                }
                else {
                    cell.btnPinVideo.isSelected = false
                }
                cell.remoteView.layer.borderColor = UIColor.clear.cgColor
                cell.remoteView.layer.borderWidth = 0
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    @objc func pinVideoMethods(sender : UIButton) {
        pinVideoArr.removeAll()
        sender.isSelected = !sender.isSelected
        let cell = vdoCollectionView.dequeueReusableCell(withReuseIdentifier: cellIndentifier.VDOCollectionViewCell.rawValue, for: IndexPath(index: sender.tag)) as!  VDOCollectionViewCell
        print("localVideoTrack1-------->", localVideoTrack)
        if sender.isSelected {
            isChangeView = false
            
            if sender.tag == 0 {
                print("first index local")
                moreArr[2] = "Unpin video"
                moreDropDown.dataSource = moreArr
                self.localAudioTrack = LocalAudioTrack()
                self.localVideoTrack = LocalVideoTrack(source: camera!, enabled: true, name: "Camera")
                self.isSwitchToRemote = true
                self.pinVideoArr = [pinModels(isRemotePin: false, isLocalPin: true, lp: localParticipant, rp: remoteParticipant)]
                self.vdoCollectionView.isHidden = true
                self.parentSpeakerView.isHidden = false
                self.mainPreview.isHidden = false
                self.fullFlashViewChangesMethod(isFlip: false)
            }
            else {
                moreArr[2] = "Unpin video"
                moreDropDown.dataSource = moreArr
                // self.remoteParticiapntName = cell.participantName.text ?? ""
                btnPinLocal.isSelected = false
                self.isSwitchToRemote = false
                print("other index remote")
                self.remoteParticipant = remoteParticipantArr[sender.tag - 1]
                self.pinVideoArr = [pinModels(isRemotePin: true, isLocalPin: false, lp: localParticipant, rp: remoteParticipantArr[sender.tag - 1])]
                self.vdoCollectionView.isHidden = true
                self.parentSpeakerView.isHidden = false
                self.mainPreview.isHidden = false
                self.fullFlashViewChangesMethod(isFlip: false)
            }
        }
        else {
            moreArr[2] = "Pin video"
            moreDropDown.dataSource = moreArr
            cell.btnPinVideo.isSelected = false
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == vdoCollectionView {
            if self.remoteParticipantArr.count == 1 && isChangeView == false {//&& isChangeView == false{
                return CGSize(width: vdoCollectionView.frame.size.width, height: vdoCollectionView.frame.size.height)
            }
            else if self.remoteParticipantArr.count == 1 && isChangeView == true {
                
                return CGSize(width: (self.vdoCollectionView.frame.size.width) - 6, height: (self.vdoCollectionView.frame.size.height/2) - 6)
            }
            else if self.remoteParticipantArr.count == 2 {
                if indexPath.row == 0 {
                    return CGSize(width: vdoCollectionView.frame.size.width, height: (vdoCollectionView.frame.size.height/2) - 6)
                    
                }
                else {
                    
                    return CGSize(width: (self.vdoCollectionView.frame.size.width/2) - 6, height: (self.vdoCollectionView.frame.size.height/2) - 6)
                }
            }
            else if self.remoteParticipantArr.count == 3 {
                
                return CGSize(width: vdoCollectionView.frame.size.width/2-6, height: vdoCollectionView.frame.size.height/2-6)
            }
            else if self.remoteParticipantArr.count == 4 {
                if indexPath.row == 3 {
                    return CGSize(width: vdoCollectionView.frame.size.width, height: vdoCollectionView.frame.size.height/3-6)
                }
                else {
                    
                    return CGSize(width: vdoCollectionView.frame.size.width/2-6, height: vdoCollectionView.frame.size.height/3-6)
                }
            }
            else if self.remoteParticipantArr.count == 5 {
                return CGSize(width: vdoCollectionView.frame.size.width/2-6, height: vdoCollectionView.frame.size.height/3-6)
            }
            else if self.remoteParticipantArr.count == 6 {
                
                if indexPath.row == 5 {
                    return CGSize(width: vdoCollectionView.frame.size.width/3-6, height: vdoCollectionView.frame.size.height/3-6)
                }
                return CGSize(width: vdoCollectionView.frame.size.width/2-6, height: vdoCollectionView.frame.size.height/3-6)
                
            }
            else if self.remoteParticipantArr.count == 7 {
                if indexPath.row == 6 {
                    return CGSize(width: vdoCollectionView.frame.size.width/3-6, height: vdoCollectionView.frame.size.height/3-6)
                }
                
                return CGSize(width: vdoCollectionView.frame.size.width/2-6, height: vdoCollectionView.frame.size.height/3-6)
            }
            else if self.remoteParticipantArr.count == 8 {
                return CGSize(width: vdoCollectionView.frame.size.width/3-6, height: vdoCollectionView.frame.size.height/3-6)
            }
            return CGSize(width: vdoCollectionView.frame.size.width/2 - 6, height: vdoCollectionView.frame.size.height/2-6)
            
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

extension VideoCallViewController: chatDelegateMethods {
    func chatRefreshed(chats: [RowData]?) {
        chatListArr = chats!
        isOpenChat = false
    }
    
    
}
