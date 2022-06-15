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
    public func configureText(obj: RowData){
        if obj.sender == 0 {
            //customer cell
            var pImg = nBaseUrl + obj.profileImg!
            pImg = pImg.replacingOccurrences(of: " ", with: "%20")
            
            vendorView.isHidden = true
            customerView.isHidden = false
            if obj.profileImg != "" && obj.profileImg != nil {
                imgCustomer.sd_setImage(with: URL(string: pImg), placeholderImage: UIImage(named: "person.circle"))
                lblCustomerChar.isHidden = true
            }
            else {
                lblCustomerChar.isHidden = false
                imgCustomer.isHidden = true
                lblCustomerChar.text = obj.name?.first?.uppercased()
            }
            lblCustomerChat.text = obj.txt
            lblCustomerTime.text = CEnumClass.share.getChatTime(dateString: obj.time!)
            lblCustomerName.text = obj.name
           
        }
        else {
            //vendor cell
          
                var pImg = nBaseUrl + obj.profileImg!
                pImg = pImg.replacingOccurrences(of: " ", with: "%20")
              
                vendorView.isHidden = false
                customerView.isHidden = true
                if obj.profileImg != "" && obj.profileImg != nil {
                    ImgVendor.sd_setImage(with: URL(string: pImg), placeholderImage: UIImage(named: "person.circle"))
                    lblVendorChar.isHidden = true
                }
                else {
                    lblVendorChar.isHidden = false
                    ImgVendor.isHidden = true
                    lblVendorChar.text = obj.name?.first?.uppercased()
                }
                lblVendorChat.text = obj.txt
                lblVendorTime.text = CEnumClass.share.getChatTime(dateString: obj.time!)
                lblVendorName.text = obj.name
                
            
        }
        
        
    }
    
}
