//
//  ChatModels.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 06/06/22.
//

import Foundation
import UIKit
import TwilioChatClient
import MobileCoreServices
import MediaPlayer
import TwilioChatClient
import TwilioVideo
import Photos
import Moya
struct RowData {
    var rowType: RowType = .txt
    var sender : Int? = 0
    var cellIdentifier: chatDetailIndentifier = .txtCell
    var cellTypeIdx :CellType_Idx = .txtCell
    var sid: String? = ""
    var profileImg: String? = ""
    var txt :String? = ""
    var imgUrl : String? = ""
    var vdoUrl : String? = ""
    var audioUrl : String? = ""
    var name : String? = ""
    var time: String? = ""
}
enum RowType:Int {
    case txt = 0
    case img
    case audioP
    case vdo
    
}
enum chatDetailIndentifier : String {
    case txtCell =  "TextChatCell"
    case imgCell = "ImageChatCell"
}
enum CellType_Idx : Int {
    case txtCell = 0
    case imgCell
}

//Nib Name
struct NibNames {
    static let chat = "ChatTVCell"
    static let chatImg = "ImageChatCell"
}
class chatViewModels {
    public func getChatMessage(message:TCHMessage, istypeImg: Bool,url:String, completionHandler:@escaping(RowData?, Error?) -> ()) {
        if istypeImg {
            let ndict = message.attributes()?.dictionary
            
            let mszStr = ndict![AnyHashable("attributes")] as! String
            print("mszStr---->",mszStr)
            if mszStr.contains(":") && mszStr.contains("##") {
                let nMsz = mszStr.replacingOccurrences(of: "\n", with: "")
                let arr = nMsz.split(separator: ":")
                let senderName = arr.first
                let lastObj = arr.last?.dropFirst()
                let mszArr = lastObj?.split(separator: "#")
                let sName2 = mszArr?.first
                let msz = mszArr?[1] ?? ""
                let sImage = mszArr?[2]
                let sIdentity = mszArr?[3] ?? ""
                var data = RowData.init()
                let urlPath = URL(string: String(msz))
                let urlExt = urlPath?.pathExtension
                if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 1 {
                    let fileName = (CEnumClass.share.getcurrentdateAndTimeForChat() + ".\(urlExt!)").replacingOccurrences(of: " ", with: "")
                    chatDetails.share.downloadImage(from: URL(string: url)!) { img in
                        chatDetails.share.saveImageLocally(image: img!, fileName: fileName)
                        data.rowType = .img
                        data.cellIdentifier = .imgCell
                        data.sender = 1
                        data.sid = message.sid
                        data.imgUrl = fileName
                        data.txt = String(msz)
                        data.profileImg = "\(sImage ?? "")"
                        data.name = "\(senderName ?? "")"
                        data.time = message.dateCreated
                       
                        completionHandler(data, nil)
                    }
                }
                else if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 2 {
                    let fileName = (CEnumClass.share.getcurrentdateAndTimeForChat() + ".\(urlExt!)").replacingOccurrences(of: " ", with: "")
                    let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                    let destinationURL = docsUrl?.appendingPathComponent(fileName)
                    
                    if let vdoUrl = URL(string: url) {
                        URLSession.shared.downloadTask(with: vdoUrl) {(tempUrl,response,error) in
                            if let fullUrl = tempUrl {
                                DispatchQueue.main.async {
                                    do
                                    {
                                      let vData = try Data(contentsOf: fullUrl)
                                        print("download video temp url--------->", fullUrl)

                                        // 2
                                        try vData.write(to: destinationURL!,options: .atomic)
                                        data.rowType = .img
                                        data.cellIdentifier = .imgCell
                                        
                                        data.sender = 1
                                        data.vdoUrl = url
                                        data.sid = message.sid
                                        data.imgUrl = fileName
                                        data.txt = String(msz)
                                        data.profileImg = "\(sImage ?? "")"
                                        data.name = "\(senderName ?? "")"
                                        data.time = message.dateCreated
                                       
                                        completionHandler(data, nil)
                                    
                                   
                                  }
                                catch{
                                    print("dowload error video")
                                }}
                            }
                        }.resume()
                    }
                    
                }
                print("senderName:\(senderName),sName2:\(sName2), sImage:\(sImage),sIdentity:\(sIdentity), imgurl = \( data.imgUrl),msz::\(msz)")
            }
            
        }
        else {
            let mszStr = message.body ?? ""
            if mszStr.contains(":") && mszStr.contains("##") {
                let nMsz = message.body!.replacingOccurrences(of: "\n", with: "")
                let arr = nMsz.split(separator: ":")
                let senderName = arr.first
                let lastObj = arr.last?.dropFirst()
                let mszArr = lastObj?.split(separator: "#")
                let sName2 = mszArr?.first
                let msz = mszArr?[1]
                let sImage = mszArr?[2]
                let sIdentity = mszArr?[3] ?? ""
                var data = RowData.init()
                
                data.rowType = .txt
                data.cellIdentifier = .txtCell
                sIdentity == (userDefaults.string(forKey: "twilioIdentity") ?? "") ? (data.sender = 0) : (data.sender = 1)
                data.sid = message.sid
                data.txt = "\(msz ?? "")"
                data.profileImg = "\(sImage ?? "")"
                data.name = "\(senderName ?? "")"
                data.time = message.dateCreated
                //  self.arrChatSection.append(data)
                print("senderName1:\(senderName),sName21:\(sName2), sImage1:\(sImage),sIdentity1:\(sIdentity), msz::\(msz)")
                completionHandler(data, nil)
            }
        }
        
        
    }
    func downloadVideo(){
        
    }
}

extension ChatViewController : TCHChannelDelegate {
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, messageAdded message: TCHMessage) {
        if isOpenChat {
            if message.hasMedia(){
                let ndict = message.attributes()?.dictionary
                let mszStr = ndict![AnyHashable("attributes")] as! String
                let cusIndetity = userDefaults.string(forKey: "twilioIdentity")
                if !mszStr.contains(cusIndetity!){
                    message.getMediaContentTemporaryUrl { result, imgurl in
                        self.chatVModel.getChatMessage(message: message, istypeImg: true, url: imgurl ?? "") { data, err in
                            self.arrChatSection.append(data!)
                            DispatchQueue.main.async {
                                
                                self.tblView.reloadData()
                                self.view.layoutIfNeeded()
                                self.tblView.scrollToBottomRow()
                                
                            } } }
                    
                }else {
                    DispatchQueue.main.async {
                        if self.arrChatSection.count > 0 {
                            self.tblView.reloadData()
                            self.view.layoutIfNeeded()
                            self.tblView.scrollToBottomRow()
                        }
                    }
                }
                
                
            }
            else {
                
                chatVModel.getChatMessage(message: message, istypeImg: false, url: "") { data, err in
                    self.arrChatSection.append(data!)
                    DispatchQueue.main.async {
                        if self.arrChatSection.count > 0 {
                            self.tblView.reloadData()
                            self.view.layoutIfNeeded()
                            self.tblView.scrollToBottomRow()
                        }
                    }
                }
            }
            
        }
        
    }
    
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, memberJoined member: TCHMember) {
        print("channel member-->", member)
        // addMessages(newMessages: [StatusMessage(statusMember:member, status:.Joined)])
    }
    
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, memberLeft member: TCHMember) {
        print("channel member left-->", member)
        //addMessages(newMessages: [StatusMessage(statusMember:member, status:.Left)])
    }
    
    func chatClient(_ client: TwilioChatClient, channelDeleted channel: TCHChannel) {
        print("channel  deleted-->", channel)
        
    }
    
    /* func chatClient(_ client: TwilioChatClient,
     channel: TCHChannel,
     synchronizationStatusUpdated status: TCHChannelSynchronizationStatus) {
     if isOpenChat {
     self.chatVModel.chatArrList.removeAll()
     if status == .all {
     channel.messages?.getLastWithCount(100) { (result, items) in
     for obj in items! {
     if obj.hasMedia() {
     self.chatVModel.getChatMessage(message: obj, istypeImg: true)
     }
     else {
     self.chatVModel.getChatMessage(message: obj, istypeImg: false)
     }
     }
     if self.chatVModel.chatArrList.count > 0 {
     print("channel message --->", result, "--item:", items)
     self.chatVModel.chatArrList =  self.chatVModel.chatArrList.sorted(by: {($0.time ?? "") < ($1.time ?? "")})
     self.tblView.reloadData()
     self.view.layoutIfNeeded()
     self.tblView.scrollToBottomRow()
     }
     
     // self.addMessages(newMessages: Set(items!))
     }
     //            loadMessages()
     //            DispatchQueue.main.async {
     //                self.tableView?.reloadData()
     //                self.setViewOnHold(onHold: false)
     //            }
     }}
     }*/
    
}
extension ChatViewController:UIDocumentPickerDelegate,MPMediaPickerControllerDelegate {
    func showPhotoGallery() {
        
        // show picker to select image form gallery
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
                print("imgdata--->",imgData)
                //                let msz = "\(userDefaults.string(forKey: "firstName") ?? ""):#\(userDefaults.string(forKey: "firstName") ?? "")\(mszCounts)##\(fileName)#\((userDefaults.string(forKey: "ImageData") ?? "/images/noprofile.jpg"))#\(userDefaults.string(forKey: "twilioIdentity") ?? "")"
                //                let jsonObj:[AnyHashable:Any] = ["attributes": msz]
                let jsonObj = chatDetails.share.getchatString(filename: fileName, mszCount: mszCounts)
                let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj, options: [])
                let jsonString = String(data: jsonData!, encoding: .utf8)!
                
                //                let nObj = ChatObj()
                //                nObj.attributes = msz
                //save url photo from picked photo
                chatDetails.share.saveImageLocally(image: newImage, fileName: fileName)
                // saveImageLocally(image: newImage, fileName: fileName)
                var imgdata = RowData.init()
                imgdata.rowType = .img
                imgdata.cellIdentifier = .imgCell
                // print("imgrowdata----->", data.imgUrl)
                imgdata.sender = 0
                imgdata.sid = ""
                imgdata.imgUrl = fileName
                imgdata.txt = ""
                imgdata.profileImg = (userDefaults.string(forKey: "ImageData") ?? "/images/noprofile.jpg")
                imgdata.name = (userDefaults.string(forKey: "firstName") ?? "")
                
                imgdata.time = CEnumClass.share.createDateAndTimeChat()
                self.arrChatSection.append(imgdata)
                
                /*  if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
                 let imgName = imgUrl.lastPathComponent
                 let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                 let localPath = documentDirectory?.appending(imgName)
                 
                 let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                 let data = image.jpegData(compressionQuality: 1)! as NSData
                 data.write(toFile: localPath!, atomically: true)
                 //let imageData = NSData(contentsOfFile: localPath!)!
                 let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
                 print("photoURL---->",photoURL)
                 var imgdata = RowData.init()
                 imgdata.rowType = .img
                 imgdata.cellIdentifier = .imgCell
                 // print("imgrowdata----->", data.imgUrl)
                 imgdata.sender = 0
                 imgdata.sid = ""
                 imgdata.imgUrl = fileName
                 imgdata.txt = userDefaults.string(forKey: "firstName") ?? ""
                 imgdata.profileImg = (userDefaults.string(forKey: "ImageData") ?? "/images/noprofile.jpg")
                 imgdata.name = (userDefaults.string(forKey: "firstName") ?? "")
                 
                 imgdata.time = CEnumClass.share.createDateAndTimeChat()
                 self.arrChatSection.append(imgdata)
                 
                 }*/
                //end-
                
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
                
                chatChannel?.messages?.sendMessage(with: mszOption, completion: { result, msz in
                    print("message--->", msz, result)
                })
                print("jsonAtrr-->", jsonString)
                //UIImagePickerControllerMediaURL
            }
            else if  let videoURL = info[.mediaURL] as? NSURL {
                do {
                    mszCounts = mszCounts + 1
                    print("uploadVideoUrl----->", videoURL)
                    let vData = try Data(contentsOf: videoURL as URL)
                    let vStream : InputStream = InputStream(data: vData)
                    let fileName = CEnumClass.share.getcurrentdateAndTimeForChat() + ".mp4"
                    let jsonObj = chatDetails.share.getchatString(filename: fileName, mszCount: mszCounts)
                    let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj, options: [])
                    let jsonString = String(data: jsonData!, encoding: .utf8)!
                    // let imageData = try Data(contentsOf: theProfileImageUrl as URL)
                    //  profileImageView.image = UIImage(data: imageData)
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
                    
                    chatChannel?.messages?.sendMessage(with: mszOption, completion: { result, msz in
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
    
}

