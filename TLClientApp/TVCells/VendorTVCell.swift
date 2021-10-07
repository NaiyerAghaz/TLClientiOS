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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
