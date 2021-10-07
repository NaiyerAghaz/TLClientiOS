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

class TotalParticipantVC: BottomPopupViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblParticipants: UILabel!
    var callChannel : TCHChannel?
    var vdoCallVM = VDOCallViewModel()
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var room: Room?
    var roomlocalParticipantSIDrule: String?
    var conferrenceInfoArr : NSMutableArray?
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var popupDismisAlphaVal : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.separatorStyle = .none
        tblView.layoutSubviews()
        tblView.tableFooterView = UIView(frame: .zero)
        let cellNib = UINib(nibName: "VendorTVCell", bundle: nil)
        tblView.register(cellNib, forCellReuseIdentifier: tableCellIndentifier.vendorTVCell.rawValue)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.reloadData()
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
        // vcontrol.popupDelegate = self
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
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: tableCellIndentifier.vendorTVCell.rawValue, for: indexPath) as? VendorTVCell else { return UITableViewCell() }
        let obj = conferrenceInfoArr![indexPath.row] as! ConferenceInfoModels
        cell.lblName.text = obj.UserName
        cell.btnAudio.tag = indexPath.row
        cell.btnAudio.addTarget(self, action: #selector(audioPressed), for: .touchUpInside)
        cell.btnVideo.tag = indexPath.row
        cell.btnVideo.addTarget(self, action: #selector(videoPressed), for: .touchUpInside)
        cell.btnDisconnect.addTarget(self, action: #selector(participantCallEnded), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conferrenceInfoArr?.count ?? 0
    }
    /* func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tblView.frame.width, height: 80))
     headerView.backgroundColor = UIColor(displayP3Red: 36/255, green: 36/255, blue: 36/255, alpha: 1)
     let lbLobby = UILabel()
     lbLobby.frame = CGRect.init(x: 15, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10)
     lbLobby.text = "View Lobby"
     lbLobby.font = .systemFont(ofSize: 16)
     lbLobby.textColor = .white
     let lblPart = UILabel()
     lblPart.frame = CGRect.init(x: 15, y: 30, width: headerView.frame.width-10, height: headerView.frame.height-10)
     lblPart.text = "Participants List"
     lblPart.font = .systemFont(ofSize: 16)
     lblPart.textColor = .white
     
     headerView.addSubview(lbLobby)
     headerView.addSubview(lblPart)
     
     return headerView
     }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 80
     }*/
    @objc func audioPressed(_ sender: UIButton){
        SwiftLoader.show(animated: true)
        //  let indx = vendorTbl
        // sender.isSelected = !sender.isSelected
        let cell = tblView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! VendorTVCell
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
        let cell = tblView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! VendorTVCell
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
        vdoCallVM.participantEndCall(roomID: vdoIndex.ACTUALROOM!) { success, err in
            if success == true {
                
                SwiftLoader.hide()
                print("End call")
                DispatchQueue.main.async {[self] in
                    if conferrenceInfoArr!.count == 1 {
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
                    }
                    else {
                        
                    }
                }
                
            }
            else{
                SwiftLoader.hide()
                print("oops something is missing OFF")
            }
            
        }
    }
}
