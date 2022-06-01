//
//  VendorTVCell.swift
//  TLClientApp
//
//  Created by SMIT 005 on 24/11/21.
//


import UIKit
import TwilioVideo
class VendorTVCell: UITableViewCell {
   
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnAudio: UIButton!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnDisconnect: UIButton!
    //LobbyCell

    @IBOutlet weak var lobbyName: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
}
    
    
}
enum VendorIdentityCell:String {
    case lobbyCell  = "LobbyParicipantListCell"
    case vendorCell = "VendorParticipantTVCell"
}

class VendorParticipantTVCell: UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnAudio: UIButton!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnDisconnect: UIButton!
    
}
class LobbyParicipantListCell: UITableViewCell {
    @IBOutlet weak var lobbyName: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
}

class VDOCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var btnMic: UIButton!
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var imgRemotePrivacy: UIImageView!
    @IBOutlet weak var lblVideo: PaddingLabel!
    @IBOutlet weak var audioLbl: PaddingLabel!
    @IBOutlet weak var participantName: PaddingLabel!
    @IBOutlet weak var btnPinVideo: UIButton!
    @IBOutlet weak var isSpeakingLbl: PaddingLabel!
    func configure(obj: ConferenceInfoModels){
    print("obj.VIDEO---->",obj.VIDEO, ":obj.MUTE ==",obj.MUTE)
        audioLbl.adjustsFontSizeToFitWidth = true
        lblVideo.adjustsFontSizeToFitWidth = true
        if obj.VIDEO == "0" {
            lblVideo.isHidden = false
            lblVideo.text = "You have paused \(obj.UserName!)'s video"
        }
        else {
            lblVideo.isHidden = true
        }
        if obj.MUTE == "0" {
            audioLbl.isHidden = false
            audioLbl.text = "You have muted \(obj.UserName!)'s audio"
        }
        else {
            audioLbl.isHidden = true
        }
       }
}
//

