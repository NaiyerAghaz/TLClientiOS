//
//  ChatsView.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 20/06/22.
//

import Foundation
import UIKit
import TwilioChatClient
import TwilioVideo
import SDWebImage
import MobileCoreServices
import MediaPlayer
import AVFoundation
extension VideoCallViewController:UIDocumentPickerDelegate,MPMediaPickerControllerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func showPhotoGallery() {
        
        // show picker to select image from gallery
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    func showVideo() {
        
        // show picker to select image form gallery
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
     
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.mediaTypes = ["public.movie"] // [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            imagePicker.videoQuality = .typeMedium
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    func showAudio() {
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.mp3"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    func showDocuments() {
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
        
    }
    // Document Picker delegate
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
       
        controller.dismiss(animated: true)
      
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
      
        let urlPath = urls.last
        let urlExt = urlPath?.pathExtension
       // let mszOption = TCHMessageOptions.init()
        if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 3 || chatDetails.share.getUploadedFileExtension(file: urlExt!) == 4{
            let fileName = (CEnumClass.share.getcurrentdateAndTimeForChat() + ".\(urlExt!)").replacingOccurrences(of: " ", with: "")
            uploadFilesToChatTwilio(fileName: fileName, url: urlPath!, isAudio: true, isVideo: false)
         }
        
        controller.dismiss(animated: true)
     
    }
 
    // MARK:  MPMediaPickerController Delegate methods
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
       
        mediaPicker.dismiss(animated: true)
      
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
     
        mediaPicker.dismiss(animated: true)
      
        
        //  If you allow picking multiple media, then mediaItemCollection.items will return array of picked media items(MPMediaItem)
    }
    
    // MARK: image picker delegate function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if picker.sourceType == .photoLibrary
        {
            let mszOption = TCHMessageOptions.init()
          if  let newImage = info[.originalImage] as? UIImage
                    
            {
              mszReplyContainerHeight.constant = 0.0
                mszCounts = mszCounts + 1
                let fileName = (CEnumClass.share.getcurrentdateAndTimeForChat() + ".jpg").replacingOccurrences(of: " ", with: "")
                let imgData = newImage.jpegData(compressionQuality: 1)
                let imgStream : InputStream = InputStream(data: imgData!)
              
                //let jsonObj = chatDetails.share.getchatString(filename: fileName, mszCount: mszCounts)
              let jsonObj2 = chatDetails.share.getchatPrivateString(filename: fileName, mszCount: mszCounts,replyID: replyId ?? "")
                var privateMSz = ""
                for pChat in privateChatArr {
                    privateMSz = privateMSz + "@\(pChat)"
                   }
                let fullMsz = "\(userDefaults.string(forKey: "firstName") ?? ""):\(privateMSz)\(jsonObj2)"
                let jsonObj3:[AnyHashable:Any] = ["attributes": fullMsz]
                let messageID = "\(userDefaults.string(forKey: "firstName") ?? "")\(userDefaults.string(forKey: "firstName") ?? "")\(mszCounts)"
                //save url photo from picked photo
                chatDetails.share.saveImageLocally(image: newImage, fileName: fileName)
                // saveImageLocally(image: newImage, fileName: fileName)
                var imgdata = RowData.init()
              if replyId != ""{
                  imgdata.rowType = .imgReply
                  imgdata.cellIdentifier = .imgReplyCell
              }
              else{
                  imgdata.rowType = .img
                  imgdata.cellIdentifier = .imgCell
              }
                
              imgdata.privatechatUser = privateMSz
              imgdata.mszID = messageID
              imgdata.replyMszID = replyId
                imgdata.sender = 0
                imgdata.sid = ""
                imgdata.imgUrl = fileName
                imgdata.txt = fileName
                let pImage = ((userDefaults.string(forKey: "ImageData") != "" ) && (userDefaults.string(forKey: "ImageData") != nil)) ? (userDefaults.string(forKey: "ImageData")) : "/images/noprofile.jpg"
                imgdata.profileImg = pImage
                imgdata.name = (userDefaults.string(forKey: "firstName") ?? "")
                imgdata.time = CEnumClass.share.createDateAndTimeChat()
                self.chatListArr.append(imgdata)
              self.replyId = ""
              lblNameReplyUser.text = ""
              lblReplyMsz.text = ""
                let jsonAtrr = TCHJsonAttributes(dictionary: jsonObj3)
                mszOption.withMediaStream(imgStream, contentType: "image/jpg", defaultFilename: fileName) {
                    print("start--upload", fileName)
                    SwiftLoader.show(title: "Uploading..", animated: true)
                } onProgress: { pro in
                    print("onprogress--upload", fileName)
                } onCompleted: { img in
                    print("complete--upload", fileName, "img:",img)
                    SwiftLoader.hide()
                    
                }.withAttributes(jsonAtrr!)
                
                myChannel?.messages?.sendMessage(with: mszOption, completion: { result, msz in
                    print("message--->", msz, result)
                })
               
                //UIImagePickerControllerMediaURL
            }
            else if  let videoURL = info[.mediaURL] as? URL {
                let fileName = (CEnumClass.share.getcurrentdateAndTimeForChat() + ".mov").replacingOccurrences(of: " ", with: "")
                uploadFilesToChatTwilio(fileName: fileName, url: videoURL,isAudio: false,isVideo: true)
                
                }}
       
       picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
       
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Upload video, audio and podf to the chat
    
    public func uploadFilesToChatTwilio(fileName:String, url:URL, isAudio:Bool, isVideo:Bool){
        let mszOption = TCHMessageOptions.init()
        do {
            mszCounts = mszCounts + 1
            print("uploadVideoUrl----->", url)
            let vData = try Data(contentsOf: url as URL)
            let vStream : InputStream = InputStream(data: vData)
          //  let jsonObj = chatDetails.share.getchatString(filename: fileName, mszCount: mszCounts)
            let jsonObj2 = chatDetails.share.getchatPrivateString(filename: fileName, mszCount: mszCounts, replyID: replyId ?? "")
              var privateMSz = ""
              for pChat in privateChatArr {
                  privateMSz = privateMSz + "@\(pChat)"
                 }
              let fullMsz = "\(userDefaults.string(forKey: "firstName") ?? ""):\(privateMSz)\(jsonObj2)"
              let jsonObj3:[AnyHashable:Any] = ["attributes": fullMsz]
            let messageID = "\(userDefaults.string(forKey: "firstName") ?? "")\(userDefaults.string(forKey: "firstName") ?? "")\(mszCounts)"
          
           //save file to local
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            do{
                try FileManager.default.copyItem(at: url, to: (documentsDirectory?.appendingPathComponent(fileName))!)
                print("save video")
            }
            catch {
                print("video-error:",error.localizedDescription)
            }
            mszReplyContainerHeight.constant = 0.0
            var imgdata = RowData.init()
            if isVideo && replyId != ""{
                imgdata.rowType = .imgReply
                imgdata.cellIdentifier = .imgReplyCell
            }
            else if isVideo && replyId == ""{
                imgdata.rowType = .img
                imgdata.cellIdentifier = .imgCell
            }
            else if isAudio && replyId != ""{
                imgdata.rowType = .audioReply
                imgdata.cellIdentifier = .audioReplyCell
            }
            else if isAudio && replyId == ""{
                imgdata.rowType = .audio
                imgdata.cellIdentifier = .audioCell
            }
            imgdata.privatechatUser = privateMSz
          imgdata.sender = 0
            imgdata.replyMszID = replyId
            imgdata.mszID = messageID
            imgdata.sid = ""
            imgdata.imgUrl = fileName
            imgdata.txt = fileName
            
            let pImage = ((userDefaults.string(forKey: "ImageData") != "" ) && (userDefaults.string(forKey: "ImageData") != nil)) ? (userDefaults.string(forKey: "ImageData")) : "/images/noprofile.jpg"
            imgdata.profileImg = pImage
            imgdata.name = (userDefaults.string(forKey: "firstName") ?? "")
            
            imgdata.time = CEnumClass.share.createDateAndTimeChat()
            self.chatListArr.append(imgdata)
            self.replyId = ""
            lblNameReplyUser.text = ""
            lblReplyMsz.text = ""
            let jsonAtrr = TCHJsonAttributes(dictionary: jsonObj3)
            mszOption.withMediaStream(vStream, contentType: "*/*", defaultFilename: fileName) {
                print("start--upload", fileName)
                SwiftLoader.show(title: "Uploading..", animated: true)
            } onProgress: { pro in
                print("onprogress--video", fileName)
            } onCompleted: { img in
                print("complete--video", fileName, "vdo:",img)
                SwiftLoader.hide()
                
            }.withAttributes(jsonAtrr!)
            
            myChannel?.messages?.sendMessage(with: mszOption, completion: { result, msz in
                print("message vdooo--->", msz, result)
            })
        }
        catch{
            print(error.localizedDescription)
        }
      }
    //MARK: UITextViewDelegates Methods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        let trimmed = txtMessage.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed == "" {
            txtMessage.text = "Type a message here.."
        }
        tblPrivateView.isHidden = true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type a message here.." {
            textView.text = ""
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        myChannel?.setFriendlyName(userDefaults.string(forKey: "firstName"))
        myChannel?.typing()
        if txtMessage.contentSize.height >= 40
        {
            txtMessageHeight.constant = 70
            txtMessage.isScrollEnabled = true
        }
        else {
            txtMessageHeight.constant = 40
        }
    }
    //end
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        scoreText.keyboardType = .default
        scoreText.reloadInputViews()
        scoreText.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldTxt = textField.text! as NSString
        let convertedTxt = textFieldTxt.replacingCharacters(in: range, with: string)
        if(textField == txtMessage){
            print("COUNT==\(convertedTxt.count)")
            if convertedTxt.count == 0 {
             self.txtMessage.resignFirstResponder()
                self.txtMessage.text = ""
            }
            
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("begin editing")
        //privateChatArr.removeAll()
        tblPrivateView.isHidden = true
        return true
    }
    
    
}
extension VideoCallViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblView {
        let rowData = chatListArr[indexPath.row]
      
            switch rowData.rowType {
            case .txt:
                let tCell = tableView.dequeueReusableCell(withIdentifier:chatDetailIndentifier.txtCell.rawValue) as! ChatTVCell
                tCell.configureText(obj: rowData)
                return tCell
            case .txtReply:
                let tCell = tableView.dequeueReusableCell(withIdentifier:chatDetailIndentifier.txtReplyCell.rawValue) as! ReplyMessageTVCell
                if let indexs = chatListArr.firstIndex(where: {$0.mszID == rowData.replyMszID}) {
                    tCell.replyUpdates(obj: chatListArr[indexs],send: rowData.sender!)

                }
                tCell.configureText(obj: rowData)
                return tCell
            
            case .img:
                let imgCell = tableView.dequeueReusableCell(withIdentifier:chatDetailIndentifier.imgCell.rawValue) as! ImageChatCell
               imgCell.btnCustomerPlay.tag = indexPath.row
               imgCell.btnVendorPlay.tag = indexPath.row
                imgCell.btnCustomerPlay.addTarget(self, action: #selector(displayVideo(sender:)), for: .touchUpInside)
                imgCell.btnVendorPlay.addTarget(self, action: #selector(displayVideo(sender:)), for: .touchUpInside)
                imgCell.customerImg.tag = indexPath.row
                imgCell.vendorImg.tag = indexPath.row
                let tap = UITapGestureRecognizer(target: self, action: #selector(displayImageFullImage(gesture:)))
                imgCell.customerImg.isUserInteractionEnabled = true
                imgCell.customerImg.addGestureRecognizer(tap)
                let tap2 = UITapGestureRecognizer(target: self, action: #selector(displayImageFullImage2(gesture:)))
                imgCell.vendorImg.isUserInteractionEnabled = true
                imgCell.vendorImg.addGestureRecognizer(tap2)
                //imgCell.vendorImg.addGestureRecognizer(tap)
                imgCell.configureImg(obj: rowData)
                return imgCell
            case .imgReply:
                let imgCell = tableView.dequeueReusableCell(withIdentifier:chatDetailIndentifier.imgReplyCell.rawValue) as! ReplyImgTVCell
                if let indexs = chatListArr.firstIndex(where: {$0.mszID == rowData.replyMszID}) {
                    imgCell.replyUpdates(obj: chatListArr[indexs],send:rowData.sender!)
                 }
               imgCell.btnCustomerPlay.tag = indexPath.row
               imgCell.btnVendorPlay.tag = indexPath.row
                imgCell.btnCustomerPlay.addTarget(self, action: #selector(displayVideo(sender:)), for: .touchUpInside)
                imgCell.btnVendorPlay.addTarget(self, action: #selector(displayVideo(sender:)), for: .touchUpInside)
                imgCell.customerImg.tag = indexPath.row
                imgCell.vendorImg.tag = indexPath.row
                let tap = UITapGestureRecognizer(target: self, action: #selector(replyDisplayImageFullImage(gesture:)))
                imgCell.customerImg.isUserInteractionEnabled = true
                imgCell.customerImg.addGestureRecognizer(tap)
                let tap2 = UITapGestureRecognizer(target: self, action: #selector(replyDisplayImageFullImage2(gesture:)))
                imgCell.vendorImg.isUserInteractionEnabled = true
                imgCell.vendorImg.addGestureRecognizer(tap2)
                imgCell.vendorImg.addGestureRecognizer(tap)
                imgCell.configureImg(obj: rowData)
                return imgCell
             case .audio:
                let audioCell = tableView.dequeueReusableCell(withIdentifier:chatDetailIndentifier.audioCell.rawValue) as! AudioTVCell
                audioCell.customerBtnPlay.tag = indexPath.row
                audioCell.vendorBtnPlay.tag = indexPath.row
                audioCell.customerBtnPlay.addTarget(self, action: #selector(displayAudio(sender:)), for: .touchUpInside)
                audioCell.vendorBtnPlay.addTarget(self, action: #selector(displayAudio(sender:)), for: .touchUpInside)
                audioCell.vendorDocImg.tag = indexPath.row
                audioCell.customerDocImg.tag = indexPath.row
                let vdocTap2 = UITapGestureRecognizer(target: self, action: #selector(displayDocs(gesture:)))
                audioCell.vendorDocImg.isUserInteractionEnabled = true
                audioCell.vendorDocImg.addGestureRecognizer(vdocTap2)
                let docTap = UITapGestureRecognizer(target: self, action: #selector(displayDocs2(gesture:)))
                audioCell.customerDocImg.isUserInteractionEnabled = true
                audioCell.customerDocImg.addGestureRecognizer(docTap)
                audioCell.configureAudio(obj: rowData)
                return audioCell
            case .audioReply:
                let audioCell = tableView.dequeueReusableCell(withIdentifier:chatDetailIndentifier.audioReplyCell.rawValue) as! ReplyAudioTVCell
                if let indexs = chatListArr.firstIndex(where: {$0.mszID == rowData.replyMszID}) {
                    audioCell.replyUpdates(obj: chatListArr[indexs],send:rowData.sender!)
                 }
                audioCell.customerBtnPlay.tag = indexPath.row
                audioCell.vendorBtnPlay.tag = indexPath.row
                audioCell.customerBtnPlay.addTarget(self, action: #selector(displayAudio(sender:)), for: .touchUpInside)
                audioCell.vendorBtnPlay.addTarget(self, action: #selector(displayAudio(sender:)), for: .touchUpInside)
                audioCell.vendorDocImg.tag = indexPath.row
                audioCell.customerDocImg.tag = indexPath.row
                let vdocTap2 = UITapGestureRecognizer(target: self, action: #selector(displayDocs(gesture:)))
                audioCell.vendorDocImg.isUserInteractionEnabled = true
                audioCell.vendorDocImg.addGestureRecognizer(vdocTap2)
                let docTap = UITapGestureRecognizer(target: self, action: #selector(displayDocs2(gesture:)))
                audioCell.customerDocImg.isUserInteractionEnabled = true
                audioCell.customerDocImg.addGestureRecognizer(docTap)
                audioCell.configureAudio(obj: rowData)
                return audioCell
           }
        }
        else if tableView == tblPrivateView {
            
            let pCell = tblPrivateView.dequeueReusableCell(withIdentifier: chatDetailIndentifier.pMessageCell.rawValue) as! PrivateMessageTVCell
            let dataNames = vdoCallVM.conferrenceDetail.CONFERENCEInfo![indexPath.row] as! ConferenceInfoModels
            pCell.lblName.text = dataNames.UserName
            pCell.btnCheck.tag = indexPath.row
            pCell.btnCheck.addTarget(self, action: #selector(getCheckUpdate(sender:)), for: .touchUpInside)
           
            if privateChatArr.contains(dataNames.UserName!){
                pCell.btnCheck.isSelected = true
            }
            else {
                pCell.btnCheck.isSelected = false
            }
           
            
            return pCell
        }
      return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblPrivateView {
           
            return vdoCallVM.conferrenceDetail.CONFERENCEInfo?.count ?? 0
        }
        else {
            return chatListArr.count
        }
    
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var configure = UISwipeActionsConfiguration()
       //configure.performsFirstActionWithFullSwipe = false
        let rowData = chatListArr[indexPath.row]
        if rowData.sender == 1 {
            let replyAction = UIContextualAction(style: .normal, title: nil) { [self] _, _, complete in
               
                switch rowData.rowType {
                case .txt:
                    print("mszzzid--1>",rowData.mszID!)
                    replyId = rowData.mszID!
                    mszReplyContainerHeight.constant = 45
                    lblNameReplyUser.text = rowData.name
                    lblReplyMsz.text = rowData.txt
                    imgReplyWidth.constant = 0.0
                   // 46
                  
                case .img:
                    print("mszzzid--2>",rowData.mszID!)
                    replyId =  rowData.mszID!
                    imgReplyWidth.constant = 46.0
                    let urlPath = URL(string: rowData.imgUrl!)
                    let urlExt = urlPath?.pathExtension
                    mszReplyContainerHeight.constant = 45
                    lblNameReplyUser.text = rowData.name
                    lblReplyMsz.text = rowData.txt
                    if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 1 {
                      let img = chatDetails.share.getImageFromName(fileName: rowData.imgUrl ?? "")
                      imgReplymsz.image = img
                      }
                    else {
                        let img = chatDetails.share.createVideoThumbnail(fileName: rowData.imgUrl!)
                      imgReplymsz.image = img
                  }
                   
                 case .audio:
                    replyId =  rowData.mszID!
                    imgReplyWidth.constant = 46.0
                    let urlPath = URL(string: rowData.imgUrl!)
                    let urlExt = urlPath?.pathExtension
                    
                    mszReplyContainerHeight.constant = 45
                    lblNameReplyUser.text = rowData.name
                    lblReplyMsz.text = rowData.txt
                   if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 3 {
                       let largeConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .bold, scale: .large)
                        let largeBoldDoc = UIImage(systemName: "headphones.circle.fill", withConfiguration: largeConfig)!.withTintColor(.blue)
                        imgReplymsz.image = largeBoldDoc
                    }
                    else {
                      imgReplymsz.image = chatDetails.share.getImageFromExt(file: urlExt!)
                    }
                   
                case .txtReply:
                    print("reply")
                case .imgReply:
                    print("imgReply")
                case .audioReply:
                print("audioreply")
                }
                complete(true)
                    }
                    
                    // here set your image and background color
            replyAction.image = UIImage(named: "reply")
            replyAction.backgroundColor = UIColor.clear
          
            configure = UISwipeActionsConfiguration(actions: [replyAction])
            configure.performsFirstActionWithFullSwipe = true
                    return configure
        }
        else {
            return configure
        }
 }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblView {
            let rowData = chatListArr[indexPath.row]
            switch rowData.rowType {
            case .img:
                let urlPath = URL(string: rowData.imgUrl!)
                let urlExt = urlPath?.pathExtension
                if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 1 {
                    let img = chatDetails.share.getImageFromName(fileName: rowData.imgUrl ?? "")
                    let imgCrop = img?.getImgRatio()
                    return (tableView.frame.width - 90)/imgCrop!
                }
                else {
                    let img = chatDetails.share.createVideoThumbnail(fileName: rowData.imgUrl!)
                    let imgCrop = img?.getImgRatio()
                    return (tableView.frame.width - 90)/imgCrop!
                }
            case .imgReply:
                let urlPath = URL(string: rowData.imgUrl!)
                let urlExt = urlPath?.pathExtension
                if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 1 {
                    let img = chatDetails.share.getImageFromName(fileName: rowData.imgUrl ?? "")
                    let imgCrop = img?.getImgRatio()
                    return (tableView.frame.width - 90)/imgCrop!
                }
                else {
                    let img = chatDetails.share.createVideoThumbnail(fileName: rowData.imgUrl!)
                    let imgCrop = img?.getImgRatio()
                    return (tableView.frame.width - 90)/imgCrop!
                }
            default:
                return tableView.estimatedRowHeight
            }
        }
       return tableView.estimatedRowHeight
     
    }
    
    func addKeyBoardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    @objc func displayVideo(sender: UIButton){
        let playData = chatListArr[sender.tag].imgUrl
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let vurl = documentsDirectory.appendingPathComponent(playData!)
       //let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        
        let player = AVPlayer(url: vurl)
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            self.playerViewController.player!.play()
        }
    }
    @objc func displayAudio(sender: UIButton){
        let playData = chatListArr[sender.tag].imgUrl
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let vurl = documentsDirectory.appendingPathComponent(playData!)
     
        let player = AVPlayer(url: vurl)
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            self.playerViewController.player!.play()
        }
    }
    @objc func displayImageFullImage(gesture: UITapGestureRecognizer){
        let imgData = chatListArr[gesture.view!.tag]
        let sB = UIStoryboard(name: Storyboard_name.chat, bundle: nil)
        let vc = sB.instantiateViewController(withIdentifier: Control_Name.imgPopup) as! ImagePopupViewController
        let imgFullurl = (imgData.imgUrl)!.replacingOccurrences(of: " ", with: "%20")
        let urlPath = URL(string: imgFullurl)
        let urlExt = urlPath?.pathExtension
        if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 1 {
            vc.fileName = imgData.imgUrl
            vc.isImage = true
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
        @objc func displayImageFullImage2(gesture: UITapGestureRecognizer){
            let imgData = chatListArr[gesture.view!.tag]
            let sB = UIStoryboard(name: Storyboard_name.chat, bundle: nil)
            let vc = sB.instantiateViewController(withIdentifier: Control_Name.imgPopup) as! ImagePopupViewController
            let imgFullurl = (imgData.imgUrl)!.replacingOccurrences(of: " ", with: "%20")
            let urlPath = URL(string: imgFullurl)
            let urlExt = urlPath?.pathExtension
            if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 1 {
                vc.fileName = imgData.imgUrl
                vc.isImage = true
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
}
    @objc func replyDisplayImageFullImage(gesture: UITapGestureRecognizer){
        let imgData = chatListArr[gesture.view!.tag]
        let sB = UIStoryboard(name: Storyboard_name.chat, bundle: nil)
        let vc = sB.instantiateViewController(withIdentifier: Control_Name.imgPopup) as! ImagePopupViewController
        let imgFullurl = (imgData.imgUrl)!.replacingOccurrences(of: " ", with: "%20")
        let urlPath = URL(string: imgFullurl)
        let urlExt = urlPath?.pathExtension
        if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 1 {
            vc.fileName = imgData.imgUrl
            vc.isImage = true
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
        @objc func replyDisplayImageFullImage2(gesture: UITapGestureRecognizer){
            let imgData = chatListArr[gesture.view!.tag]
            let sB = UIStoryboard(name: Storyboard_name.chat, bundle: nil)
            let vc = sB.instantiateViewController(withIdentifier: Control_Name.imgPopup) as! ImagePopupViewController
            let imgFullurl = (imgData.imgUrl)!.replacingOccurrences(of: " ", with: "%20")
            let urlPath = URL(string: imgFullurl)
            let urlExt = urlPath?.pathExtension
            if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 1 {
                vc.fileName = imgData.imgUrl
                vc.isImage = true
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
}
    @objc func displayDocs(gesture: UITapGestureRecognizer){
        let imgData = chatListArr[gesture.view!.tag]
        let sB = UIStoryboard(name: Storyboard_name.chat, bundle: nil)
        let vc = sB.instantiateViewController(withIdentifier: Control_Name.imgPopup) as! ImagePopupViewController
        let imgFullurl = (imgData.txt)!.replacingOccurrences(of: " ", with: "%20")
        let urlPath = URL(string: imgFullurl)
        let urlExt = urlPath?.pathExtension
       
        if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 4 {
            vc.fileName = imgData.imgUrl
            vc.isImage = false
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
}
    @objc func displayDocs2(gesture: UITapGestureRecognizer){
        let imgData = chatListArr[gesture.view!.tag]
        let sB = UIStoryboard(name: Storyboard_name.chat, bundle: nil)
        let vc = sB.instantiateViewController(withIdentifier: Control_Name.imgPopup) as! ImagePopupViewController
        let imgFullurl = (imgData.txt)!.replacingOccurrences(of: " ", with: "%20")
        let urlPath = URL(string: imgFullurl)
        let urlExt = urlPath?.pathExtension
       
        if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 4 {
            vc.fileName = imgData.imgUrl
            vc.isImage = false
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
}
    @objc func replyDisplayDocs(gesture: UITapGestureRecognizer){
        let imgData = chatListArr[gesture.view!.tag]
        let sB = UIStoryboard(name: Storyboard_name.chat, bundle: nil)
        let vc = sB.instantiateViewController(withIdentifier: Control_Name.imgPopup) as! ImagePopupViewController
        let imgFullurl = (imgData.txt)!.replacingOccurrences(of: " ", with: "%20")
        let urlPath = URL(string: imgFullurl)
        let urlExt = urlPath?.pathExtension
       
        if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 4 {
            vc.fileName = imgData.imgUrl
            vc.isImage = false
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
}
    @objc func replyDisplayDocs2(gesture: UITapGestureRecognizer){
        let imgData = chatListArr[gesture.view!.tag]
        let sB = UIStoryboard(name: Storyboard_name.chat, bundle: nil)
        let vc = sB.instantiateViewController(withIdentifier: Control_Name.imgPopup) as! ImagePopupViewController
        let imgFullurl = (imgData.txt)!.replacingOccurrences(of: " ", with: "%20")
        let urlPath = URL(string: imgFullurl)
        let urlExt = urlPath?.pathExtension
       
        if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 4 {
            vc.fileName = imgData.imgUrl
            vc.isImage = false
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
}
    @objc func getCheckUpdate(sender: UIButton){
        sender.isSelected = !sender.isSelected
      
           let dataNames = vdoCallVM.conferrenceDetail.CONFERENCEInfo![sender.tag] as! ConferenceInfoModels
           if let index = privateChatArr.firstIndex(of: dataNames.UserName!) {
               self.privateChatArr.remove(at: index)
           }
           else {
               self.privateChatArr.append(dataNames.UserName!)
           }
        self.lblPrivateChatCounts.text = "\(privateChatArr.count)"
        
}
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        chatBottomConstant.constant = keyboardSize - bottomLayoutGuide.length
      //  chatBottomConstant.constant = keyboardSize - view.safeAreaLayoutGuide.bottomAnchor
        let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
        
        //tableView.contentInset.bottom = keyboardSize
         self.view.layoutIfNeeded()
          self.tblView.scrollToBottomRow()
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let info = notification.userInfo!
        let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        chatBottomConstant.constant = 0
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded()
        }
        tblView.contentInset.bottom = 0
        print("keyboard hide")
    }
    @IBAction func btnCloseTapped(_ sender: Any) {
        self.txtMessage.resignFirstResponder()
        self.isOpenChat = false
        self.chatView.isHidden = true
    }
    func chatClosed(){
        self.txtMessage.resignFirstResponder()
        self.chatView.isHidden = true
        
    
    }
    
    
    @IBAction func btnOpenPrivateChatUsers(_ sender: UIButton) {
        txtMessage.resignFirstResponder()
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            tblPrivateView.isHidden = false
            DispatchQueue.main.async {
                self.tblPrivateView.reloadData()
            }
           
        }
        else {
            tblPrivateView.isHidden = true
        }
         }
    @IBAction func btnDonePrivatemszTapped(_ sender: Any) {
        tblPrivateView.isHidden = true
        btnSelectUser.isSelected = false
    }
    
    @IBAction func btnCancelledPrivateMszTapped(_ sender: Any) {
        self.privateChatArr.removeAll()
        tblPrivateView.isHidden = true
        btnSelectUser.isSelected = false
        self.lblPrivateChatCounts.text = "\(privateChatArr.count)"
    }
    
}


