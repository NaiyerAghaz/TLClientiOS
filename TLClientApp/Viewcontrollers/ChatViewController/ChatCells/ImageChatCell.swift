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
    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var customerImg: UIImageView!
    @IBOutlet weak var lblCustTime: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var btnCustomerPlay: UIButton!
    @IBOutlet weak var btnVendorPlay: UIButton!
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
           print("text---------->",obj.txt,"imgurl-------->",obj.imgUrl)
            let urlStr = obj.txt!.replacingOccurrences(of: " ", with: "%20")
            let urlPath = URL(string: urlStr)
            let urlExt = urlPath?.pathExtension
            if chatDetails.share.getUploadedFileExtension(file: urlExt!) == true {
                btnCustomerPlay.isHidden = true
                customerImg.sd_setImage(with: URL(string:obj.imgUrl!), placeholderImage: UIImage(named: "person.circle"))
            }
            else {
                btnCustomerPlay.isHidden = false
                let img = chatDetails.share.getThumbnailFrom(path: URL(string: obj.imgUrl!)!)
                customerImg.image = img
//                chatDetails.share.getThumbnailImageFromVideoUrl(url: URL(string:obj.imgUrl!)!) { image in
//                    self.customerImg.image = image
//                }
                
            }
            print("filesName---->",obj.txt ?? "","extension--->", urlExt)
            
            lblCustTime.text = CEnumClass.share.getChatTime(dateString: obj.time!)
            lblCustomerName.text = obj.name
           
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

            print("imgUrl----2>",obj.imgUrl ?? "")
            vendorImg.sd_setImage(with: URL(string:obj.imgUrl!), placeholderImage: UIImage(named: "person.circle"))
                lblVendorTime.text = CEnumClass.share.getChatTime(dateString: obj.time!)
                lblVendorName.text = obj.name
                
            
        }
        
        
    }
    
}
