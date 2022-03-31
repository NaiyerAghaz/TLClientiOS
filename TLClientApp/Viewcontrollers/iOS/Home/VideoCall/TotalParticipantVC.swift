//
//  TotalParticipantVC.swift
//  TLClientApp
//
//  Created by Naiyer on 10/6/21.
//

import UIKit
import TwilioChatClient
import BottomPopup
import TwilioVideo


protocol AcceptAndRejectDelegate{
    func refresh(isaccept: Bool, pid: String)
    func getHostControl(obj:ConferenceInfoResultModel)
}

class TotalParticipantVC: BottomPopupViewController {
    
    @IBOutlet weak var tblView: UITableView!
    var acceptAndRejectDelegate: AcceptAndRejectDelegate?
    @IBOutlet weak var lblParticipants: UILabel!
    var callChannel : TCHChannel?
    var myChannel : TCHChannel?
    var vdoCallVM = VDOCallViewModel()
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var room: Room?
    var roomID: String?
    var roomlocalParticipantSIDrule: String?
    var conferrenceInfoArr : NSMutableArray?
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var popupDismisAlphaVal : CGFloat?
    var conferenceStatusModel: ClientStatusModel?
    var pid: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.separatorStyle = .none
        tblView.layoutSubviews()
        tblView.tableFooterView = UIView(frame: .zero)
        /// let cellNib = UINib(nibName: "VendorTVCell", bundle: nil)
        //  tblView.register(cellNib, forCellReuseIdentifier: VendorIdentityCell.vendorCell.rawValue)
        // tblView.register(cellNib, forCellReuseIdentifier: VendorIdentityCell.lobbyCell.rawValue)
        tblView.delegate = self
        tblView.dataSource = self
        DispatchQueue.main.async {
            self.lblParticipants.text = "Participants(\(self.conferrenceInfoArr?.count ?? 0))"
            self.tblView.reloadData()
        }
        
    }
    
    @IBAction func btnInviteTapped(_ sender: Any) {
        // dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.inviteParticipantCall()
        }
        
    }
    func inviteParticipantCall(){
        let callVC = UIStoryboard(name: Storyboard_name.home, bundle: nil)
        let vcontrol = callVC.instantiateViewController(identifier: "InviteParticipantVC") as! InviteParticipantVC
        vcontrol.height = 500
        vcontrol.topCornerRadius = 30
        vcontrol.presentDuration = 0.5
        vcontrol.dismissDuration = 0.5
        vcontrol.shouldDismissInteractivelty = true
        vcontrol.popupDismisAlphaVal = 0.4
        let conferrenceItem = conferrenceInfoArr![0] as? ConferenceInfoModels
        actualRoom = conferrenceItem?.ACTUALROOM
        sID = conferrenceItem?.PARTSID
        fromUserID = conferrenceItem?.FROMUSERID ?? ""
        
        present(vcontrol, animated: true, completion: nil)
    }
    @IBAction func btnCloseTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override var popupHeight: CGFloat { height ?? 500.0 }
    override var popupTopCornerRadius: CGFloat { topCornerRadius ?? 10.0 }
    override var popupPresentDuration: Double { presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { dismissDuration ?? 1.0 }
    override var popupShouldDismissInteractivelty: Bool { shouldDismissInteractivelty ?? true }
    override var popupDimmingViewAlpha: CGFloat { popupDismisAlphaVal ?? 1.0}
}
extension TotalParticipantVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if conferenceStatusModel != nil {
            return 2
        }
        else {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            guard let cellt = tblView.dequeueReusableCell(withIdentifier: VendorIdentityCell.vendorCell.rawValue, for: indexPath) as? VendorParticipantTVCell else { return UITableViewCell() }
            let obj = conferrenceInfoArr![indexPath.row] as! ConferenceInfoModels
            cellt.lblName.text = obj.UserName
            cellt.btnAudio.tag = indexPath.row
            obj.VIDEO == "1" ? (cellt.btnVideo.isSelected = false) : (cellt.btnVideo.isSelected = true)
            obj.MUTE == "1" ? (cellt.btnAudio.isSelected = false) : (cellt.btnAudio.isSelected = true)
            cellt.btnAudio.addTarget(self, action: #selector(audioPressed), for: .touchUpInside)
            cellt.btnVideo.tag = indexPath.row
            cellt.btnVideo.addTarget(self, action: #selector(videoPressed), for: .touchUpInside)
            cellt.btnDisconnect.tag = indexPath.row
            cellt.btnDisconnect.addTarget(self, action: #selector(participantCallEnded), for: .touchUpInside)
            return cellt
        }
        else {
            guard let celln = tblView.dequeueReusableCell(withIdentifier: VendorIdentityCell.lobbyCell.rawValue, for: indexPath) as? LobbyParicipantListCell else { return UITableViewCell() }
            let obj = conferenceStatusModel?.INVITEDATA![indexPath.row] as! INVITEDATAMODEL
            celln.lobbyName.text = obj.name
            celln.btnAccept.tag = indexPath.row
            celln.btnAccept.addTarget(self, action: #selector(acceptPressed), for: .touchUpInside)
            celln.btnReject.tag = indexPath.row
            celln.btnReject.addTarget(self, action: #selector(rejectPressed), for: .touchUpInside)
            return celln
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if conferenceStatusModel != nil {
            
            return conferenceStatusModel?.INVITEDATA?.count ?? 0
        }
        
        return conferrenceInfoArr?.count ?? 0
    }
    // Accept and reject from invite user:
    
    @objc func acceptPressed(_ sender: UIButton){
        if Reachability.isConnectedToNetwork() {
        DispatchQueue.main.async {
            SwiftLoader.show(animated: true)}
        let conferrenceItem = conferenceStatusModel?.INVITEDATA![sender.tag] as! INVITEDATAMODEL
        let conferrence = conferrenceInfoArr![0] as? ConferenceInfoModels
        let req = vdoCallVM.reqAccept(pid: conferrenceItem.pid!, roomid: (conferrence?.ACTUALROOM)!)
        vdoCallVM.acceptInvitation(parameter: req) { success in
            if success! {
                
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    self.acceptAndRejectDelegate?.refresh(isaccept: true, pid: conferrenceItem.pid!)
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }}else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
    }
    
    @objc func rejectPressed(_ sender: UIButton){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
        let conferrenceItem = conferenceStatusModel?.INVITEDATA![sender.tag] as! INVITEDATAMODEL
        let conferrence = conferrenceInfoArr![0] as? ConferenceInfoModels
        let req = vdoCallVM.rejectRequest(pid: conferrenceItem.pid!, roomid: (conferrence?.ACTUALROOM)!)
        vdoCallVM.rejectInvitation(parameter: req) { success in
            if success! {
                
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    self.acceptAndRejectDelegate?.refresh(isaccept: false, pid: conferrenceItem.pid!)
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }}else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
        
    }
    //End:
    
    @objc func audioPressed(_ sender: UIButton){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
        
        //let cell = tblView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! VendorParticipantTVCell
        let vdoIndex = conferrenceInfoArr![sender.tag] as! ConferenceInfoModels
        var channelBody = ""
        if vdoIndex.MUTE == "1" {
            
            vdoCallVM.audioVideoHostControl(audioVal: 0, partSID: vdoIndex.PARTSID!, isAudio: true) { success, err in
                if success == true {
                    SwiftLoader.hide()
                    DispatchQueue.global(qos: .background).async {[self] in
                        vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: vdoIndex.ACTUALROOM!) { success, err in
                            conferrenceInfoArr = vdoCallVM.conferrenceDetail.CONFERENCEInfo
                            self.acceptAndRejectDelegate?.getHostControl(obj: vdoCallVM.conferrenceDetail)
                            DispatchQueue.main.async {
                                tblView.reloadData()
                            }
                          }}
                   print("audio host OFF")
                }
                else{
                    SwiftLoader.hide()
                    print("oops something is missing OFF")
                }
                
            }
            channelBody = "PartSid-\(vdoIndex.PARTSID!)-AUDIO-OFF-\(userDefaults.string(forKey: "username")!)-\(vdoIndex.UserName!)"
        }
        else {
            
            vdoCallVM.audioVideoHostControl(audioVal: 1, partSID: vdoIndex.PARTSID!,isAudio: true) { success, err in
                if success == true {
                    SwiftLoader.hide()
                    DispatchQueue.global(qos: .background).async {[self] in
                        vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: vdoIndex.ACTUALROOM!) { success, err in
                            print("success----------Participant list")
                            conferrenceInfoArr = vdoCallVM.conferrenceDetail.CONFERENCEInfo
                            self.acceptAndRejectDelegate?.getHostControl(obj: vdoCallVM.conferrenceDetail)
                            DispatchQueue.main.async {
                                tblView.reloadData()
                            }
                        }
                    }
                    print("audio host ON")
                }
                else{
                    SwiftLoader.hide()
                    print("oops something is missing ON")
                }
            }
            channelBody = "PartSid-\(vdoIndex.PARTSID!)-AUDIO-ON-\(userDefaults.string(forKey: "username")!)-\(vdoIndex.UserName!)"
        }
        let mszOption = TCHMessageOptions.init()
        mszOption.withBody(channelBody)
        self.callChannel?.messages?.sendMessage(with: mszOption, completion: { chResult, chMessage in
            if chResult.isSuccessful() {
                
                debugPrint("Channel has updated----------------->>")
            }
        })}else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
    }
    @objc func videoPressed(_ sender: UIButton){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
        
       // let cell = tblView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! VendorParticipantTVCell
        let vdoIndex = conferrenceInfoArr![sender.tag] as! ConferenceInfoModels
        var channelBody = ""
        if vdoIndex.VIDEO == "1" {
            
            vdoCallVM.audioVideoHostControl(audioVal: 0, partSID: vdoIndex.PARTSID!, isAudio: false) { success, err in
                if success == true {
                    DispatchQueue.global(qos: .background).async {[self] in
                        vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: vdoIndex.ACTUALROOM!) { success, err in
                            
                            conferrenceInfoArr = vdoCallVM.conferrenceDetail.CONFERENCEInfo
                            self.acceptAndRejectDelegate?.getHostControl(obj: vdoCallVM.conferrenceDetail)
                            DispatchQueue.main.async {
                                
                                tblView.reloadData()
                            }
                            
                        }
                    }
                    SwiftLoader.hide()
                    print("audio host OFF")
                }
                else{
                    SwiftLoader.hide()
                    print("oops something is missing OFF")
                }}
            
            channelBody = "PartSid-\(vdoIndex.PARTSID!)-VIDEO-OFF-\(userDefaults.string(forKey: "username")!)-\(vdoIndex.UserName!)"
        }
        else {
            
            vdoCallVM.audioVideoHostControl(audioVal: 1, partSID: vdoIndex.PARTSID!,isAudio: false) { success, err in
                if success == true {
                    SwiftLoader.hide()
                    DispatchQueue.global(qos: .background).async {[self] in
                        vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: vdoIndex.ACTUALROOM!) { success, err in
                            conferrenceInfoArr = vdoCallVM.conferrenceDetail.CONFERENCEInfo
                            self.acceptAndRejectDelegate?.getHostControl(obj: vdoCallVM.conferrenceDetail)
                            
                            DispatchQueue.main.async {
                                
                                tblView.reloadData()
                            }
                        }}
                    
                }
                else{
                    SwiftLoader.hide()
                    print("oops something is missing ON")
                }
            }
            channelBody = "PartSid-\(vdoIndex.PARTSID!)-VIDEO-ON-\(userDefaults.string(forKey: "username")!)-\(vdoIndex.UserName!)"
        }
        let mszOption = TCHMessageOptions.init()
        mszOption.withBody(channelBody)
        self.callChannel?.messages?.sendMessage(with: mszOption, completion: { chResult, chMessage in
            if chResult.isSuccessful() {
                
                debugPrint("Channel has updated----------------->>")
            }
        })}else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
    }
    @objc func participantCallEnded(_ sender: UIButton){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
        
        let vdoIndex = conferrenceInfoArr![sender.tag] as! ConferenceInfoModels
        if conferrenceInfoArr!.count == 1 {
            
            vdoCallVM.participantEndCall(roomID: vdoIndex.ACTUALROOM!) { success, err in
                if success == true {
                    
                    DispatchQueue.main.async {[self] in
                        SwiftLoader.hide()
                        if (room != nil){
                            room?.disconnect()
                            if (self.camera != nil){
                                camera?.stopCapture()
                                camera = nil
                            }
                            if (localVideoTrack != nil){
                                localVideoTrack = nil
                            }
                            self.presentingViewController?.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: nil)
                        }
                    }}
                
                else{
                    SwiftLoader.hide()
                    print("oops something is missing OFF")
                }}
            
        }
        else {
            vdoCallVM.participantEndMethod1(partSID: vdoIndex.PARTSID!) { success, err in
                if success == true {
                    self.vdoCallVM.participantEndMethod2(roomSID: vdoIndex.ROOMSID!, partSID: vdoIndex.PARTSID!) { success, err in
                        if success == true {
                            
                            DispatchQueue.main.async {[self] in
                                SwiftLoader.hide()
                                dismiss(animated: true, completion: nil)
                                //tblView.reloadData()
                            }}
                        else {
                            DispatchQueue.main.async {
                                SwiftLoader.hide()
                            }
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        SwiftLoader.hide()
                    }
                }
            }
            
        }}else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
        }
}

