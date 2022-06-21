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
extension VideoCallViewController:UIDocumentPickerDelegate,MPMediaPickerControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func showPhotoGallery() {
        
        // show picker to select image from gallery
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
            
            //            let imagePicker = UIImagePickerController()
            //            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    func showVideo() {
        
        // show picker to select image form gallery
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
            
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.mediaTypes = ["public.movie"] // [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            imagePicker.videoQuality = .typeMedium
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    func showAudio() {
        
        // fetch audio from MPMedia
        let mediaPicker: MPMediaPickerController = MPMediaPickerController.self(mediaTypes:MPMediaType.music)
        mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = false
        self.present(mediaPicker, animated: true, completion: nil)
        
        
    }
    func showDocuments() {
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
        
    }
    // Document Picker delegate
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.dismiss(animated: true)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("picked url-->", urls)
    }
    
    // MARK:  MPMediaPickerController Delegate methods
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print("you picked: \(mediaItemCollection)")//This is the picked media item.
        self.dismiss(animated: true, completion: nil)
        
        //  If you allow picking multiple media, then mediaItemCollection.items will return array of picked media items(MPMediaItem)
    }
    
    // MARK: image picker delegate function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if picker.sourceType == .photoLibrary
        {
            let mszOption = TCHMessageOptions.init()
            print("picker vdo ->")
            if  let newImage = info[.originalImage] as? UIImage
                    
            {
                mszCounts = mszCounts + 1
                let fileName = (CEnumClass.share.getcurrentdateAndTimeForChat() + ".jpg").replacingOccurrences(of: " ", with: "")
                let imgData = newImage.jpegData(compressionQuality: 1)
                let imgStream : InputStream = InputStream(data: imgData!)
              
                let jsonObj = chatDetails.share.getchatString(filename: fileName, mszCount: mszCounts)
                let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj, options: [])
                let jsonString = String(data: jsonData!, encoding: .utf8)!
                
                //save url photo from picked photo
                chatDetails.share.saveImageLocally(image: newImage, fileName: fileName)
                // saveImageLocally(image: newImage, fileName: fileName)
                var imgdata = RowData.init()
                imgdata.rowType = .img
                imgdata.cellIdentifier = .imgCell
             
                imgdata.sender = 0
                imgdata.sid = ""
                imgdata.imgUrl = fileName
                imgdata.txt = ""
                imgdata.profileImg = (userDefaults.string(forKey: "ImageData") ?? "/images/noprofile.jpg")
                imgdata.name = (userDefaults.string(forKey: "firstName") ?? "")
                
                imgdata.time = CEnumClass.share.createDateAndTimeChat()
                self.chatListArr.append(imgdata)
                let jsonAtrr = TCHJsonAttributes(dictionary: jsonObj)
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
                print("jsonAtrr-->", jsonString)
                //UIImagePickerControllerMediaURL
            }
            else if  let videoURL = info[.mediaURL] as? URL {
                do {
                    mszCounts = mszCounts + 1
                    print("uploadVideoUrl----->", videoURL)
                    let vData = try Data(contentsOf: videoURL as URL)
                    let vStream : InputStream = InputStream(data: vData)
                    let fileName = (CEnumClass.share.getcurrentdateAndTimeForChat() + ".mov").replacingOccurrences(of: " ", with: "")
                    let jsonObj = chatDetails.share.getchatString(filename: fileName, mszCount: mszCounts)
                    let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj, options: [])
                    let jsonString = String(data: jsonData!, encoding: .utf8)!
                    
                    //save file to local
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                    do{
                        try FileManager.default.copyItem(at: videoURL, to: (documentsDirectory?.appendingPathComponent(fileName))!)
                        print("save video")
                    }
                    catch {
                        print("video-error:",error.localizedDescription)
                    }
                    var imgdata = RowData.init()
                    imgdata.rowType = .img
                    imgdata.cellIdentifier = .imgCell
                 
                    imgdata.sender = 0
                    imgdata.sid = ""
                    imgdata.imgUrl = fileName
                    imgdata.txt = ""
                    imgdata.profileImg = (userDefaults.string(forKey: "ImageData") ?? "/images/noprofile.jpg")
                    imgdata.name = (userDefaults.string(forKey: "firstName") ?? "")
                    
                    imgdata.time = CEnumClass.share.createDateAndTimeChat()
                    self.chatListArr.append(imgdata)
                    
                    let jsonAtrr = TCHJsonAttributes(dictionary: jsonObj)
                    mszOption.withMediaStream(vStream, contentType: "video", defaultFilename: fileName) {
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
                } catch {
                    print("Unable to load data: \(error)")
                }
                
                
            }
            
            
            
        }
       picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
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
                //            messageTV.keyboardType = .default
                //            messageTV.reloadInputViews()
                self.txtMessage.resignFirstResponder()
                self.txtMessage.text = ""
            }
            else{
                
            }
        }
        return true
    }
    
}
extension VideoCallViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = chatListArr[indexPath.row]
      
            switch rowData.rowType {
            case .txt:
                let tCell = tableView.dequeueReusableCell(withIdentifier:"TextChatCell") as! ChatTVCell
                tCell.configureText(obj: rowData)
                return tCell
              
            case .img:
                let imgCell = tableView.dequeueReusableCell(withIdentifier:"ImageChatCell") as! ImageChatCell
                //imgCell.btnCustomerPlay.tag = indexPath.row
               // imgCell.btnVendorPlay.tag = indexPath.row
                
                imgCell.configureImg(obj: rowData)
                return imgCell
             case .audioP:
                print("audioP")
                break
                
            case .vdo:
                print("vdo")
            }
      return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatListArr.count
    }
    func addKeyBoardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    @objc func DisplayVideo(sender: UIButton){
        let playData = chatListArr[sender.tag].imgUrl
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsDirectory.appendingPathComponent(playData!)
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        chatBottomConstant.constant = keyboardSize - bottomLayoutGuide.length
        
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
}
