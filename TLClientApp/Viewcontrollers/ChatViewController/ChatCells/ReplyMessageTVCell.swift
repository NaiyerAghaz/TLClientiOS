//
//  ReplyMessageTVCell.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 01/07/22.
//

import UIKit

class ReplyMessageTVCell: UITableViewCell {
    
    //ReplyMessage Cell
    
    @IBOutlet weak var customerReplyMessage: UILabel!
    
    @IBOutlet weak var customerReplyImgWidth: NSLayoutConstraint!
    @IBOutlet weak var customerReplyImg: UIImageView!
    @IBOutlet weak var customerReplyName: UILabel!
    @IBOutlet weak var rightCustomerView: UIView!
    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var lblCustomerChar: UILabel!
    @IBOutlet weak var imgCustomer: UIImageView!
    @IBOutlet weak var lblCustomerChat: ActiveLabel!
    @IBOutlet weak var lblCustomerTime: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var vendorReplyMessage: UILabel!
    
    @IBOutlet weak var vendorReplyImgWidth: NSLayoutConstraint!
    @IBOutlet weak var vendorReplyImg: UIImageView!
    @IBOutlet weak var vendorReplyName: UILabel!
    @IBOutlet weak var leftVendorView: UIView!
    @IBOutlet weak var vendorView: UIView!
    @IBOutlet weak var lblVendorChar: UILabel!
    @IBOutlet weak var ImgVendor: UIImageView!
    @IBOutlet weak var lblVendorChat: ActiveLabel!
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
            let text = NSMutableAttributedString()
            text.append(NSAttributedString(string: obj.privatechatUser ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 25/255, green: 157/255, blue: 217/255, alpha: 1)]));
            text.append(NSAttributedString(string: obj.txt ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
            //lblPrivateCustomerName.text = obj.privatechatUser
            lblCustomerChat.attributedText = text
            lblCustomerChat.handleURLTap { url in
                
                CEnumClass.share.activeLinkCall(activeURL: url)
            }
            lblCustomerChat.handleEmailTap { txt in
                let appURL = URL(string: "mailto:\(txt)")!
                CEnumClass.share.activeLinkCall(activeURL: appURL)
            }
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
            let text = NSMutableAttributedString()
            text.append(NSAttributedString(string: obj.privatechatUser ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 25/255, green: 157/255, blue: 217/255, alpha: 1)]));
            text.append(NSAttributedString(string: obj.txt ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
            //lblPrivateVendorName.text = obj.privatechatUser
            lblVendorChat.attributedText = text
           
            lblVendorChat.handleURLTap { url in
                
                CEnumClass.share.activeLinkCall(activeURL: url)
            }
            lblVendorChat.handleEmailTap { txt in
                let appURL = URL(string: "mailto:\(txt)")!
                CEnumClass.share.activeLinkCall(activeURL: appURL)
            }
           
            lblVendorTime.text = CEnumClass.share.getChatTime(dateString: obj.time!)
            lblVendorName.text = obj.name
         }}
    public func replyUpdates(obj: RowData,send:Int){
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
