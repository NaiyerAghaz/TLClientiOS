//
//  ChatTVCell.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 06/06/22.
//

import UIKit

class ChatTVCell: UITableViewCell {

    //Text Chat Cell
    
    @IBOutlet weak var rightCustomerView: UIView!
    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var lblCustomerChar: UILabel!
    @IBOutlet weak var imgCustomer: UIImageView!
    @IBOutlet weak var lblCustomerChat: UILabel!
    @IBOutlet weak var lblCustomerTime: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    
    @IBOutlet weak var leftVendorView: UIView!
    @IBOutlet weak var vendorView: UIView!
    @IBOutlet weak var lblVendorChar: UILabel!
    @IBOutlet weak var ImgVendor: UIImageView!
    @IBOutlet weak var lblVendorChat: UILabel!
    @IBOutlet weak var lblVendorTime: UILabel!
    @IBOutlet weak var lblVendorName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
