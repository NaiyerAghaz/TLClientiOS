//
//  AudioTVCell.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 22/06/22.
//

import UIKit

class AudioTVCell: UITableViewCell {
    
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
            print("filesName---->",obj.txt ?? "","extension--->",urlExt)
            customerDocName.text = obj.txt
            customerTime.text = CEnumClass.share.getChatTime(dateString: obj.time!)
            customerName.text = obj.name
            customerPrivateName.text = obj.privatechatUser
            
        }
        else {
            //vendor cell
            
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
            print("filesName---->",obj.txt ?? "","extension--->",urlExt)
            vendorDocName.text = obj.txt
            vendorTime.text = CEnumClass.share.getChatTime(dateString: obj.time!)
            vendorName.text = obj.name
            vendorPrivateName.text = obj.privatechatUser

        }
    }
    
}
