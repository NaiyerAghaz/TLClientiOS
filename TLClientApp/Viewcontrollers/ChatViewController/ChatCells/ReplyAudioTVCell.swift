//
//  ReplyAudioTVCell.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 07/07/22.
//

import UIKit

class ReplyAudioTVCell: UITableViewCell {
    @IBOutlet weak var vendorView: UIView!
    @IBOutlet weak var vendorTime: UILabel!
    @IBOutlet weak var vendorName: UILabel!
    @IBOutlet weak var vendorBtnPlayWidth: NSLayoutConstraint!
    @IBOutlet weak var vendorBtnPlay: UIButton!
    @IBOutlet weak var vendorDocName: UILabel!
    @IBOutlet weak var vendorDocImg: UIImageView!
    @IBOutlet weak var vendorProfileImg: UIImageView!
    @IBOutlet weak var vendorNameChar: UILabel!
    @IBOutlet weak var vendorPrivateName: UILabel!
    @IBOutlet weak var vendorReplyImg: UIImageView!
    @IBOutlet weak var vendorReplyMessage: UILabel!
    @IBOutlet weak var vendorReplyName: UILabel!
    @IBOutlet weak var vendorReplyImgWidth: NSLayoutConstraint!
    
    @IBOutlet weak var customerReplyImgWidth: NSLayoutConstraint!
    @IBOutlet weak var customerReplyImg: UIImageView!
    @IBOutlet weak var customerReplyMessage: UILabel!
    @IBOutlet weak var customerReplyName: UILabel!
    @IBOutlet weak var customerPrivateName: UILabel!
    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var customerNameChar: UILabel!
    @IBOutlet weak var customerProfileImg: UIImageView!
    @IBOutlet weak var customerDocImg: UIImageView!
    @IBOutlet weak var customerDocName: UILabel!
    @IBOutlet weak var customerBtnPlay: UIButton!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerTime: UILabel!
    @IBOutlet weak var customerBtnPlayWidth: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public func configureAudio(obj: RowData){
        if obj.sender == 0 {
            //customer cell
            var pImg = nBaseUrl + obj.profileImg!
            pImg = pImg.replacingOccurrences(of: " ", with: "%20")
            vendorView.isHidden = true
            customerView.isHidden = false
            if obj.profileImg != "" && obj.profileImg != nil {
                customerProfileImg.sd_setImage(with: URL(string: pImg), placeholderImage: UIImage(named: "person.circle"))
                customerNameChar.isHidden = true
            }
            else {
                customerNameChar.isHidden = false
                customerProfileImg.isHidden = true
                customerNameChar.text = obj.name?.first?.uppercased()
            }
            let urlPath = URL(string: obj.imgUrl!)
            let urlExt = urlPath?.pathExtension
            if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 3 {
                customerBtnPlay.isHidden = false
                customerBtnPlayWidth.constant = 40.0
                let largeConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .bold, scale: .large)
                
                let largeBoldDoc = UIImage(systemName: "headphones.circle.fill", withConfiguration: largeConfig)!.withTintColor(.blue)
                customerDocImg.image = largeBoldDoc
            }
            else {
                customerBtnPlay.isHidden = true
                customerBtnPlayWidth.constant = 0.0
                
                customerDocImg.image = chatDetails.share.getImageFromExt(file: urlExt!)
            }
            
            customerDocName.text = obj.txt
            customerTime.text = CEnumClass.share.getChatTime(dateString: obj.time!)
            customerName.text = obj.name
            customerPrivateName.text = obj.privatechatUser
            
        }
        else {
          var pImg = nBaseUrl + obj.profileImg!
            pImg = pImg.replacingOccurrences(of: " ", with: "%20")
            
            vendorView.isHidden = false
            customerView.isHidden = true
            if obj.profileImg != "" && obj.profileImg != nil {
                vendorProfileImg.sd_setImage(with: URL(string: pImg), placeholderImage: UIImage(named: "person.circle"))
                vendorNameChar.isHidden = true
            }
            else {
                vendorNameChar.isHidden = false
                vendorProfileImg.isHidden = true
                vendorNameChar.text = obj.name?.first?.uppercased()
            }
            
            let urlPath = URL(string: obj.imgUrl!)
            let urlExt = urlPath?.pathExtension
            if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 3 {
                vendorBtnPlay.isHidden = false
                vendorBtnPlayWidth.constant = 40.0
                let largeConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .bold, scale: .large)
                
                let largeBoldDoc = UIImage(systemName: "headphones.circle.fill", withConfiguration: largeConfig)!.withTintColor(.blue)
                vendorDocImg.image = largeBoldDoc
              }
            else {
                vendorBtnPlay.isHidden = true
                vendorBtnPlayWidth.constant = 0.0
                
                vendorDocImg.image = chatDetails.share.getImageFromExt(file: urlExt!)
            }

            vendorDocName.text = obj.txt
            vendorTime.text = CEnumClass.share.getChatTime(dateString: obj.time!)
            vendorName.text = obj.name
            vendorPrivateName.text = obj.privatechatUser

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
