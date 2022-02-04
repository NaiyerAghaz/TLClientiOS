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
            self.tblView.reloadData()
        }
        
        
       
       /* SwiftLoader.show(animated: true)
        vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: roomID!) { success, err in
            if success == true {
                SwiftLoader.hide()
                self.conferrenceInfoArr = self.vdoCallVM.conferrenceDetail.CONFERENCEInfo
                DispatchQueue.main.async {[self] in
                    lblParticipants.text = "Participants (\(conferrenceInfoArr?.count ?? 0))"
                    self.tblView.reloadData()
                }
            }
            else {
                SwiftLoader.hide()
            }
        }*/
      
       
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
        vcontrol.topCornerRadius = 20
        vcontrol.presentDuration = 0.5
        vcontrol.dismissDuration = 0.5
        vcontrol.shouldDismissInteractivelty = true
        vcontrol.popupDismisAlphaVal = 0.4
        let conferrenceItem = conferrenceInfoArr![0] as? ConferenceInfoModels
        print("conferrenceItem-------->", conferrenceItem?.ACTUALROOM , conferrenceItem?.FROMUSERID)
        actualRoom = conferrenceItem?.ACTUALROOM
        sID = conferrenceItem?.PARTSID
        fromUserID = conferrenceItem?.FROMUSERID ?? ""
        
       // InviteViewModel().conferenceModel = conferrenceItem
       // print("Invite--->",InviteViewModel().conferenceModel?.ACTUALROOM)
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
        print("conferrenceInfoArr==============:",conferrenceInfoArr?.count)
        if indexPath.section == 0
        {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: VendorIdentityCell.vendorCell.rawValue, for: indexPath) as? VendorParticipantTVCell else { return UITableViewCell() }
        

            let obj = conferrenceInfoArr![indexPath.row] as! ConferenceInfoModels
            cell.lblName.text = obj.UserName
            cell.btnAudio.tag = indexPath.row
            cell.btnAudio.addTarget(self, action: #selector(audioPressed), for: .touchUpInside)
            cell.btnVideo.tag = indexPath.row
            cell.btnVideo.addTarget(self, action: #selector(videoPressed), for: .touchUpInside)
            cell.btnDisconnect.addTarget(self, action: #selector(participantCallEnded), for: .touchUpInside)
            return cell
        }
        else {
            guard let cell = tblView.dequeueReusableCell(withIdentifier: VendorIdentityCell.lobbyCell.rawValue, for: indexPath) as? LobbyParicipantListCell else { return UITableViewCell() }
            let obj = conferenceStatusModel?.INVITEDATA![indexPath.row] as! INVITEDATAMODEL
                cell.lobbyName.text = obj.name
               cell.btnAccept.tag = indexPath.row
                cell.btnAccept.addTarget(self, action: #selector(acceptPressed), for: .touchUpInside)
                cell.btnReject.tag = indexPath.row
                cell.btnReject.addTarget(self, action: #selector(rejectPressed), for: .touchUpInside)
//                cell.btnDisconnect.addTarget(self, action: #selector(participantCallEnded), for: .touchUpInside)
            return cell
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
                let bodyMsz = "acceptfromclient:\(conferrenceItem.pid!)"
                print("acceptmessagebody-------------------------->:",bodyMsz)
                self.dismiss(animated: true, completion: nil)
                }
              
            }
        }
    }

    @objc func rejectPressed(_ sender: UIButton){
        SwiftLoader.show(animated: true)
        let conferrenceItem = conferenceStatusModel?.INVITEDATA![sender.tag] as! INVITEDATAMODEL
        let conferrence = conferrenceInfoArr![0] as? ConferenceInfoModels
        let req = vdoCallVM.rejectRequest(pid: conferrenceItem.pid!, roomid: (conferrence?.ACTUALROOM)!)
        vdoCallVM.rejectInvitation(parameter: req) { success in
            if success! {
               
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                self.acceptAndRejectDelegate?.refresh(isaccept: false, pid: conferrenceItem.pid!)
                let bodyMsz = "acceptfromclient:\(conferrenceItem.pid!)"
                print("rejectmessagebody-------------------------->:",bodyMsz)
                self.dismiss(animated: true, completion: nil)
                }
              
            }
        }
        
    }
    //End:
    
    @objc func audioPressed(_ sender: UIButton){
        SwiftLoader.show(animated: true)
        //  let indx = vendorTbl
        // sender.isSelected = !sender.isSelected
        let cell = tblView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! VendorParticipantTVCell
        let vdoIndex = conferrenceInfoArr![sender.tag] as! ConferenceInfoModels
        var channelBody = ""
        if vdoIndex.MUTE == "1" {
            cell.btnAudio.isSelected = true
            vdoCallVM.audioVideoHostControl(audioVal: 0, partSID: vdoIndex.PARTSID!, isAudio: true) { success, err in
                if success == true {
                    DispatchQueue.global(qos: .background).async {[self] in
                        vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: vdoIndex.ACTUALROOM!) { success, err in
                            conferrenceInfoArr = vdoCallVM.conferrenceDetail.CONFERENCEInfo
                            
                            DispatchQueue.main.async {
                                tblView.reloadData()
                            }
                            print("success----------Participant list")
                        }
                    }
                    SwiftLoader.hide()
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
            cell.btnAudio.isSelected = false
            vdoCallVM.audioVideoHostControl(audioVal: 1, partSID: vdoIndex.PARTSID!,isAudio: true) { success, err in
                if success == true {
                    SwiftLoader.hide()
                    DispatchQueue.global(qos: .background).async {[self] in
                        vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: vdoIndex.ACTUALROOM!) { success, err in
                            print("success----------Participant list")
                            conferrenceInfoArr = vdoCallVM.conferrenceDetail.CONFERENCEInfo
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
        })
    }
    @objc func videoPressed(_ sender: UIButton){
        SwiftLoader.show(animated: true)
        //  let indx = vendorTbl
        // sender.isSelected = !sender.isSelected
        let cell = tblView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! VendorParticipantTVCell
        let vdoIndex = conferrenceInfoArr![sender.tag] as! ConferenceInfoModels
        var channelBody = ""
        if vdoIndex.VIDEO == "1" {
            cell.btnVideo.isSelected = true
            vdoCallVM.audioVideoHostControl(audioVal: 0, partSID: vdoIndex.PARTSID!, isAudio: false) { success, err in
                if success == true {
                    DispatchQueue.global(qos: .background).async {[self] in
                        vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: vdoIndex.ACTUALROOM!) { success, err in
                            print("success----------Participant list")
                            conferrenceInfoArr = vdoCallVM.conferrenceDetail.CONFERENCEInfo
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
                }
                
            }
            
            channelBody = "PartSid-\(vdoIndex.PARTSID!)-VIDEO-OFF-\(userDefaults.string(forKey: "username")!)-\(vdoIndex.UserName!)"
        }
        else {
            cell.btnVideo.isSelected = false
            vdoCallVM.audioVideoHostControl(audioVal: 1, partSID: vdoIndex.PARTSID!,isAudio: false) { success, err in
                if success == true {
                    SwiftLoader.hide()
                    DispatchQueue.global(qos: .background).async {[self] in
                        vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: vdoIndex.ACTUALROOM!) { success, err in
                            conferrenceInfoArr = vdoCallVM.conferrenceDetail.CONFERENCEInfo
                            print("success----------Participant list")
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
            channelBody = "PartSid-\(vdoIndex.PARTSID!)-VIDEO-ON-\(userDefaults.string(forKey: "username")!)-\(vdoIndex.UserName!)"
        }
        let mszOption = TCHMessageOptions.init()
        mszOption.withBody(channelBody)
        self.callChannel?.messages?.sendMessage(with: mszOption, completion: { chResult, chMessage in
            if chResult.isSuccessful() {
                
                debugPrint("Channel has updated----------------->>")
            }
        })
    }
    @objc func participantCallEnded(_ sender: UIButton){
        SwiftLoader.show(animated: true)
        //  let indx = vendorTbl
        // sender.isSelected = !sender.isSelected
      //  let cell = tblView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! VendorTVCell
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
                                   // let obj  = self.conferrenceInfoArr![sender.tag] as! ConferenceInfoModels
                                   // conferrenceInfoArr?.remove(obj)
                                    dismiss(animated: true, completion: nil)
                                    //tblView.reloadData()
                                    
                                }
                               
                            }
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
                
            }
    }
}

