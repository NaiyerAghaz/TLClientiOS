//
//  ReplyImgTVCell.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 06/07/22.
//

import UIKit

class ReplyImgTVCell: UITableViewCell {
    @IBOutlet weak var vendorImg: UIImageView!
    @IBOutlet weak var lblVendorTime: UILabel!
    @IBOutlet weak var lblVendorName: UILabel!
    @IBOutlet weak var vendorView: UIView!
    @IBOutlet weak var vendorImgProfile: UIImageView!
    @IBOutlet weak var lblVendorChar: UILabel!
    @IBOutlet weak var lblPChatVendorName: UILabel!
    @IBOutlet weak var btnVendorPlay: UIButton!
    @IBOutlet weak var vendorReplyImg: UIImageView!
    @IBOutlet weak var vendorReplyMessage: UILabel!
    @IBOutlet weak var vendorReplyName: UILabel!
    @IBOutlet weak var vendorReplyImgWidth: NSLayoutConstraint!
    
    @IBOutlet weak var customerReplyImgWidth: NSLayoutConstraint!
    @IBOutlet weak var customerReplyImg: UIImageView!
    @IBOutlet weak var customerReplyMessage: UILabel!
    @IBOutlet weak var customerReplyName: UILabel!
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
        print("replyImg---22222222>name:\(obj.name),txt:\(obj.txt),img:\(obj.imgUrl), sender:\(obj.sender)")
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
                let img = chatDetails.share.getImageFromName(fileName: obj.imgUrl ?? "")
       
                customerImg.image = img
                
           }
            else {
                btnCustomerPlay.isHidden = false
                let img = chatDetails.share.createVideoThumbnail(fileName: obj.imgUrl!)
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
                let img = chatDetails.share.getImageFromName(fileName: obj.imgUrl ?? "")
              vendorImg.image = img
              }
            else {
                btnVendorPlay.isHidden = false
                let img = chatDetails.share.createVideoThumbnail(fileName: obj.imgUrl!)
              vendorImg.image = img
            }
            print("privateusernameSender--------->",obj.privatechatUser)
            lblVendorTime.text = CEnumClass.share.getChatTime(dateString: obj.time!)
            lblVendorName.text = obj.name
            lblPChatVendorName.text = obj.privatechatUser
        }
    }
    public func replyUpdates(obj: RowData,send:Int){
        print("replyImg--->name:\(obj.name),txt:\(obj.txt),img:\(obj.imgUrl)")
        let urlPath = URL(string: obj.imgUrl!)
        let urlExt = urlPath?.pathExtension
        if send == 0 {
            customerReplyName.text = obj.name
            
            customerReplyMessage.text = obj.txt
            if urlExt != nil {
                if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 3 {
                   customerReplyImgWidth.constant = 32.0
                    let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
                    let largeBoldDoc = UIImage(systemName: "headphones.circle.fill", withConfiguration: largeConfig)!.withTintColor(.blue)
                    customerReplyImg.image = largeBoldDoc
                }
                else if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 4{
                    customerReplyImgWidth.constant = 32.0
                   customerReplyImg.image = chatDetails.share.getImageFromExt(file: urlExt!)
                }
                
                else if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 1 {
                    customerReplyImgWidth.constant = 32.0
                    let img = chatDetails.share.getImageFromName(fileName: obj.imgUrl ?? "")
                    customerReplyImg.image = img
                }
                else if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 2 {
                    customerReplyImgWidth.constant = 32.0
                    let img = chatDetails.share.createVideoThumbnail(fileName: obj.imgUrl ?? "")
                    customerReplyImg.image = img
                }
                else{
                    customerReplyImgWidth.constant = 0.0
                }
            }
            else {
                customerReplyImgWidth.constant = 0.0
            }}
        else {
            vendorReplyName.text = obj.name
           vendorReplyMessage.text = obj.txt

            if urlExt != nil {
                if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 3 {
                    vendorReplyImgWidth.constant = 32.0
                    let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
                    
                    let largeBoldDoc = UIImage(systemName: "headphones.circle.fill", withConfiguration: largeConfig)!.withTintColor(.blue)
                    vendorReplyImg.image = largeBoldDoc
               }
                else if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 4{
                    vendorReplyImgWidth.constant = 32.0
                   vendorReplyImg.image = chatDetails.share.getImageFromExt(file: urlExt!)
                }
               else if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 1 {
                  vendorReplyImgWidth.constant = 32.0
                    let img = chatDetails.share.getImageFromName(fileName: obj.imgUrl ?? "")
                   vendorReplyImg.image = img
                }
                else if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 2 {
                    vendorReplyImgWidth.constant = 32.0
                    let img = chatDetails.share.createVideoThumbnail(fileName: obj.imgUrl ?? "")
                    vendorReplyImg.image = img
                }
                else{
                   vendorReplyImgWidth.constant = 0.0
                }
            }
            else {
               vendorReplyImgWidth.constant = 0.0
            }}
        
    }
    
}
