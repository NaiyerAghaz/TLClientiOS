//
//  VendorTVCell.swift
//  TLClientApp
//
//  Created by Naiyer on 9/25/21.
//

import UIKit

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
