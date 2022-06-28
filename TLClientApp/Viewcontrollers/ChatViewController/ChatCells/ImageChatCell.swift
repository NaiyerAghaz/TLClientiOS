//
//  ImageChatCell.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 13/06/22.
//

import UIKit

class ImageChatCell: UITableViewCell {
    
    @IBOutlet weak var vendorImg: UIImageView!
    @IBOutlet weak var lblVendorTime: UILabel!
    @IBOutlet weak var lblVendorName: UILabel!
    @IBOutlet weak var vendorView: UIView!
    @IBOutlet weak var vendorImgProfile: UIImageView!
    @IBOutlet weak var lblVendorChar: UILabel!
    @IBOutlet weak var lblPChatVendorName: UILabel!
    @IBOutlet weak var btnVendorPlay: UIButton!
    
    @IBOutlet weak var lblPChatCustomerName: UILabel!
    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var customerImg: UIImageView!
    @IBOutlet weak var lblCustTime: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var btnCustomerPlay: UIButton!
    @IBOutlet weak var customerImgProfile: UIImageView!
    @IBOutlet weak var lblCustomerChar: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    public func configureImg(obj: RowData){
        if obj.sender == 0 {
            //customer cell
            var pImg = nBaseUrl + obj.profileImg!
            pImg = pImg.replacingOccurrences(of: " ", with: "%20")
            vendorView.isHidden = true
            customerView.isHidden = false
            if obj.profileImg != "" && obj.profileImg != nil {
                customerImgProfile.sd_setImage(with: URL(string: pImg), placeholderImage: UIImage(named: "person.circle"))
                lblCustomerChar.isHidden = true
            }
            else {
                lblCustomerChar.isHidden = false
                customerImgProfile.isHidden = true
                lblCustomerChar.text = obj.name?.first?.uppercased()
            }
            let urlPath = URL(string: obj.imgUrl!)
            let urlExt = urlPath?.pathExtension
            if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 1 {
                btnCustomerPlay.isHidden = true
                customerImg.image = chatDetails.share.getImageFromName(fileName: obj.imgUrl ?? "")
            }
            else {
                btnCustomerPlay.isHidden = false
                let img = chatDetails.share.createVideoThumbnail(fileName: obj.imgUrl!)//chatDetails.share.getThumbnailFrom(path: URL(string: obj.imgUrl!)!)
                customerImg.image = img
            }
            lblCustTime.text = CEnumClass.share.getChatTime(dateString: obj.time!)
            lblCustomerName.text = obj.name
            lblPChatCustomerName.text = obj.privatechatUser
            
        }
        else {
            //vendor cell
            var pImg = nBaseUrl + obj.profileImg!
            pImg = pImg.replacingOccurrences(of: " ", with: "%20")
            
            vendorView.isHidden = false
            customerView.isHidden = true
            if obj.profileImg != "" && obj.profileImg != nil {
                vendorImgProfile.sd_setImage(with: URL(string: pImg), placeholderImage: UIImage(named: "person.circle"))
                lblVendorChar.isHidden = true
            }
            else {
                lblVendorChar.isHidden = false
                vendorImgProfile.isHidden = true
                lblVendorChar.text = obj.name?.first?.uppercased()
            }
            
            let urlPath = URL(string: obj.imgUrl!)
            let urlExt = urlPath?.pathExtension
            if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 1 {
                btnVendorPlay.isHidden = true
                vendorImg.image = chatDetails.share.getImageFromName(fileName: obj.imgUrl ?? "")
                
            }
            else {
                btnVendorPlay.isHidden = false
                let img = chatDetails.share.createVideoThumbnail(fileName: obj.imgUrl!)
                vendorImg.image = img
            }
            lblVendorTime.text = CEnumClass.share.getChatTime(dateString: obj.time!)
            lblVendorName.text = obj.name
            lblPChatVendorName.text = obj.privatechatUser
        }
    }
    
}
class PrivateMessageTVCell: UITableViewCell {
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblName: UILabel!
}
