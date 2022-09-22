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
    var privatechatUser: String? = ""
    var mszID :String? = ""
    var replyMszID : String? = ""
}
enum RowType:Int {
    case txt
    case txtReply
    case img
    case imgReply
    case audio
    
    case audioReply
    
}
enum chatDetailIndentifier : String {
    case txtCell =  "TextChatCell"
    case imgCell = "ImageChatCell"
    case audioCell = "AudioTVCell"
    case pMessageCell = "PrivateMessageTVCell"
    case txtReplyCell = "ReplyMessageTVCell"
    case imgReplyCell = "ReplyImgTVCell"
    case audioReplyCell = "ReplyAudioTVCell"
}
enum CellType_Idx : Int {
    case txtCell = 0
    case imgCell
    case audioCell
    case txtReplyCell
    
}

//Nib Name
struct NibChatNames {
    static let chat = "ChatTVCell"
    static let chatImg = "ImageChatCell"
    static let audio = "AudioTVCell"
    static let replyChatTxt = "ReplyMessageTVCell"
    static let replyImg = "ReplyImgTVCell"
    static let replyAudio = "ReplyAudioTVCell"
}
class chatViewModels {
    public func getChatMessage(message:TCHMessage, istypeImg: Bool,url:String, completionHandler:@escaping(RowData?, Bool?) -> ()) {
        if istypeImg {
            let ndict = message.attributes()?.dictionary
            
            let mszStr = ndict![AnyHashable("attributes")] as! String
           // print("mszStr--------------->",mszStr)
            if mszStr.contains(":") && mszStr.contains("#") {
                let nMsz = mszStr.replacingOccurrences(of: "\n", with: "")
                let arr = nMsz.split(separator: ":")
                let senderName = arr.first
                let tags = "\(arr.last!)"
              //  print("tags--------->",tags)
                if tags.contains("@") {
                    let privateMSZ = "@" + "\(userDefaults.string(forKey: "firstName") ?? "")"
                  //  print("privateMSZ:",privateMSZ)
                    if tags.contains(privateMSZ){
                        let tagsArr = tags.split(separator: "#",omittingEmptySubsequences: false)
                        let privateUser = tagsArr.first
                        let messageId = senderName! + "\(tagsArr[1])"
                        let replyMszId = tagsArr[2]
                        let msz = tagsArr[3]
                        let sImage = tagsArr[4]
                        let imgName = msz.replacingOccurrences(of: " ", with: "%20")
                        let urlPath = URL(string: String(imgName))
                        let urlExt = urlPath?.pathExtension
                       // print("private---->\(tagsArr.first!), msz:\(msz),sImage:\(sImage)")
                        if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 1 {
                            let fileName = (CEnumClass.share.getcurrentdateAndTimeForChat() + ".\(urlExt!)").replacingOccurrences(of: " ", with: "")
                            chatDetails.share.downloadImage(from: URL(string: url)!) { img, err in
                                var data = RowData.init()
                                if err == false {
                                    if replyMszId != "" {
                                        data.rowType = .imgReply
                                        data.cellIdentifier = .imgReplyCell
                                    }
                                    else {
                                        data.rowType = .img
                                        data.cellIdentifier = .imgCell
                                    }
                                    
                                    chatDetails.share.saveImageLocally(image: img!, fileName: fileName)
                                    data.sender = 1
                                    data.mszID = String(messageId)
                                    data.replyMszID = String(replyMszId)
                                    data.sid = message.sid
                                    data.imgUrl = fileName
                                    data.txt = String(msz)
                                    data.profileImg = "\(sImage)"
                                    data.name = "\(senderName ?? "")"
                                    data.time = message.dateCreated
                                    data.privatechatUser = "\(privateUser ?? "")"
                                    completionHandler(data, false)
                                }
                                else {
                                    completionHandler(data, true)
                                }
                            }
                        }
                        else if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 2 {
                            let fileName = (CEnumClass.share.getcurrentdateAndTimeForChat() + ".\(urlExt!)").replacingOccurrences(of: " ", with: "")
                            downloadVideo(fileName: fileName, url: url) { success in
                                var data = RowData.init()
                                if success! {
                                    if replyMszId != "" {
                                        data.rowType = .imgReply
                                        data.cellIdentifier = .imgReplyCell
                                    }
                                    else {
                                        data.rowType = .img
                                        data.cellIdentifier = .imgCell
                                    }
                                    data.sender = 1
                                    data.mszID = String(messageId)
                                    data.replyMszID = String(replyMszId)
                                    data.vdoUrl = url
                                    data.sid = message.sid
                                    data.imgUrl = fileName
                                    data.txt = String(msz)
                                    data.profileImg = "\(sImage)"
                                    data.name = "\(senderName ?? "")"
                                    data.time = message.dateCreated
                                    data.privatechatUser = "\(privateUser ?? "")"
                                    completionHandler(data, false)
                                }
                                else {
                                    completionHandler(data, true)
                                }
                            }
                        }
                        else if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 3 {
                            let fileName = (CEnumClass.share.getcurrentdateAndTimeForChat() + ".\(urlExt!)").replacingOccurrences(of: " ", with: "")
                            downloadVideo(fileName: fileName, url: url) { success in
                                var data = RowData.init()
                                if success! {
                                    if replyMszId != "" {
                                        data.rowType = .audioReply
                                        data.cellIdentifier = .audioReplyCell
                                    }
                                    else {
                                        data.rowType = .audio
                                        data.cellIdentifier = .audioCell
                                    }
                                    
                                    data.sender = 1
                                    data.mszID = String(messageId)
                                    data.replyMszID = String(replyMszId)
                                    data.vdoUrl = url
                                    data.sid = message.sid
                                    data.imgUrl = fileName
                                    data.txt = String(msz)
                                    data.profileImg = "\(sImage)"
                                    data.name = "\(senderName ?? "")"
                                    data.time = message.dateCreated
                                    data.privatechatUser = "\(privateUser ?? "")"
                                    completionHandler(data, false)
                                }
                                else {
                                    completionHandler(data, true)
                                }
                            }}
                        else if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 4 {
                            let fileName = (CEnumClass.share.getcurrentdateAndTimeForChat() + ".\(urlExt!)").replacingOccurrences(of: " ", with: "")
                            downloadVideo(fileName: fileName, url: url) { success in
                                
                                var data = RowData.init()
                                if success! {
                                    if replyMszId != "" {
                                        data.rowType = .audioReply
                                        data.cellIdentifier = .audioReplyCell
                                    }
                                    else {
                                        data.rowType = .audio
                                        data.cellIdentifier = .audioCell
                                    }
                                    data.sender = 1
                                    data.mszID = String(messageId)
                                    data.replyMszID = String(replyMszId)
                                    data.vdoUrl = url
                                    data.sid = message.sid
                                    data.imgUrl = fileName
                                    data.txt = String(msz)
                                    data.profileImg = "\(sImage)"
                                    data.name = "\(senderName ?? "")"
                                    data.time = message.dateCreated
                                    data.privatechatUser = "\(privateUser ?? "")"
                                    completionHandler(data, false)
                                }
                                else {
                                    completionHandler(data, true)
                                }
                            }}
                    }
                    else {
                        completionHandler(nil, true)
                    }
                }
                else {
                    let lastObj = arr.last?.dropFirst()// drop first characters
                    let mszArr = lastObj?.split(separator: "#",omittingEmptySubsequences: false)
                    //   let sName2 = mszArr?.first
                    let messageId = senderName! + "\(mszArr![0])"
                    let replyMszid = mszArr![1]
                    let msz = mszArr?[2] ?? ""
                    let sImage = mszArr?[3]
                    // let sIdentity = mszArr?[3] ?? ""
                    
                    let imgName = msz.replacingOccurrences(of: " ", with: "%20")
                    let urlPath = URL(string: String(imgName))
                    let urlExt = urlPath?.pathExtension
                    if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 1 {
                        let fileName = (CEnumClass.share.getcurrentdateAndTimeForChat() + ".\(urlExt!)").replacingOccurrences(of: " ", with: "")
                        chatDetails.share.downloadImage(from: URL(string: url)!) { img, err in
                            var data = RowData.init()
                            if err == false {
                                chatDetails.share.saveImageLocally(image: img!, fileName: fileName)
                                if replyMszid != "" {
                                    data.rowType = .imgReply
                                    data.cellIdentifier = .imgReplyCell
                                }
                                else {
                                    data.rowType = .img
                                    data.cellIdentifier = .imgCell
                                }
                                
                                data.replyMszID = String(replyMszid)
                                data.mszID = String(messageId)
                                data.sender = 1
                                data.sid = message.sid
                                data.imgUrl = fileName
                                data.txt = String(msz)
                                data.profileImg = "\(sImage ?? "")"
                                data.name = "\(senderName ?? "")"
                                data.time = message.dateCreated
                                data.privatechatUser = ""
                                completionHandler(data, false)
                            }
                            else {
                                completionHandler(data, true)
                            }
                        }
                    }
                    else if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 2 {
                        let fileName = (CEnumClass.share.getcurrentdateAndTimeForChat() + ".\(urlExt!)").replacingOccurrences(of: " ", with: "")
                        downloadVideo(fileName: fileName, url: url) { success in
                            var data = RowData.init()
                            if success! {
                                if replyMszid != "" {
                                    data.rowType = .imgReply
                                    data.cellIdentifier = .imgReplyCell
                                }
                                else {
                                    data.rowType = .img
                                    data.cellIdentifier = .imgCell
                                }
                                data.mszID = String(messageId)
                                data.replyMszID = String(replyMszid)
                                data.sender = 1
                                data.vdoUrl = url
                                data.sid = message.sid
                                data.imgUrl = fileName
                                data.txt = String(msz)
                                data.profileImg = "\(sImage ?? "")"
                                data.name = "\(senderName ?? "")"
                                data.time = message.dateCreated
                                data.privatechatUser = ""
                                
                                completionHandler(data, false)
                            }
                            else {
                                completionHandler(data, true)
                            }
                        }
                    }
                    else if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 3 {
                        let fileName = (CEnumClass.share.getcurrentdateAndTimeForChat() + ".\(urlExt!)").replacingOccurrences(of: " ", with: "")
                        downloadVideo(fileName: fileName, url: url) { success in
                            var data = RowData.init()
                            if success! {
                                
                                if replyMszid != "" {
                                    data.rowType = .audioReply
                                    data.cellIdentifier = .audioReplyCell
                                }
                                else {
                                    data.rowType = .audio
                                    data.cellIdentifier = .audioCell
                                }
                                data.sender = 1
                                data.mszID = String(messageId)
                                data.replyMszID = String(replyMszid)
                                data.vdoUrl = url
                                data.sid = message.sid
                                data.imgUrl = fileName
                                data.txt = String(msz)
                                data.profileImg = "\(sImage ?? "")"
                                data.name = "\(senderName ?? "")"
                                data.time = message.dateCreated
                                data.privatechatUser = ""
                                
                                completionHandler(data, false)
                            }
                            else {
                                completionHandler(data, true)
                            }
                        }
                        
                    }
                    else if chatDetails.share.getUploadedFileExtension(file: urlExt!) == 4 {
                        let fileName = (CEnumClass.share.getcurrentdateAndTimeForChat() + ".\(urlExt!)").replacingOccurrences(of: " ", with: "")
                        downloadVideo(fileName: fileName, url: url) { success in
                            var data = RowData.init()
                            if success! {
                                if replyMszid != "" {
                                    data.rowType = .audioReply
                                    data.cellIdentifier = .audioReplyCell
                                }
                                else {
                                    data.rowType = .audio
                                    data.cellIdentifier = .audioCell
                                }
                                data.mszID = String(messageId)
                                data.replyMszID = String(replyMszid)
                                data.sender = 1
                                data.vdoUrl = url
                                data.sid = message.sid
                                data.imgUrl = fileName
                                data.txt = String(msz)
                                data.profileImg = "\(sImage ?? "")"
                                data.name = "\(senderName ?? "")"
                                data.time = message.dateCreated
                                data.privatechatUser = ""
                                
                                completionHandler(data, false)
                            }
                            else {
                                completionHandler(data, true)
                            }
                        }}
                }}}
        else {
            let mszStr = message.body ?? ""
            print("mszStr---->",mszStr)
            if mszStr.contains(":") && mszStr.contains("#") {
                var data = RowData.init()
                var messageID = ""
                var replymszId = ""
                var msz = ""
                var sImage = ""
                var sIdentity = ""
                let nMsz = message.body!.replacingOccurrences(of: "\n", with: "")
                let arr = nMsz.split(separator: ":",maxSplits: 1)
                let senderName = arr.first
                let tags = "\(arr.last!)"
                let splitAt = tags.split(separator: "#")
                if tags.contains("@") && (splitAt[0].starts(with: "@") || splitAt[1].starts(with: "@") || splitAt[2].starts(with: "@")){
                    let privateMSZ = "@" + "\(userDefaults.string(forKey: "firstName") ?? "")"
                    if tags.contains(privateMSZ){
                        let tagsArr = tags.split(separator: "#",omittingEmptySubsequences: false)
                        data.privatechatUser = "\(tagsArr.first!)"
                        messageID = senderName! + "\(tagsArr[1])"
                        replymszId = "\(tagsArr[2])"
                        msz = "\(tagsArr[3])"
                        if tagsArr[4] != "" {
                            sImage = "\(tagsArr[4])"
                        }
                        else {
                            sImage = ""
                        }
                        // print("messageid-------1>",messageID,"sname:", senderName)
                        if replymszId != "" {
                            
                            data.rowType = .txtReply
                            data.cellIdentifier = .txtReplyCell
                        }
                        else {
                            data.rowType = .txt
                            data.cellIdentifier = .txtCell
                        }
                        // sIdentity = "\(tagsArr[4])"
                        data.sender = 1
                        data.mszID = messageID
                        data.replyMszID = replymszId
                        //  sIdentity == (userDefaults.string(forKey: "twilioIdentity") ?? "") ? (data.sender = 0) : (data.sender = 1)
                        data.sid = message.sid
                        data.txt = msz
                        data.profileImg = sImage
                        data.name = "\(senderName ?? "")"
                        data.time = message.dateCreated
                        completionHandler(data, false)
                    }
                    else {
                        completionHandler(data, true)
                    }}
                else {
                    let lastObj = arr.last?.dropFirst()
                    let mszArr = lastObj?.split(separator: "#",omittingEmptySubsequences: false)
                    messageID = senderName! + "\(mszArr?.first ?? "")"
                    replymszId = String(mszArr?[1] ?? "")
                    msz = "\(mszArr?[2] ?? "")"
                    //                    if mszArr?[3] != "" {
                    //                        sImage = "\(mszArr![3])"
                    //                    }
                    //                    else {
                    //                        sImage = ""
                    //                    }
                    sImage = (mszArr?[3] != nil) ? "\(mszArr![3])" : ""
                    // print("messageid-------2>",messageID,"sname:", senderName)
                    if replymszId != "" {
                        replymszId = "\(mszArr![1])".replacingOccurrences(of: senderName!, with: "")
                        data.rowType = .txtReply
                        data.cellIdentifier = .txtReplyCell
                    }
                    else {
                        data.rowType = .txt
                        data.cellIdentifier = .txtCell
                    }
                    sIdentity = "\(mszArr?[4] ?? "")"
                    data.mszID = messageID
                    data.replyMszID = replymszId
                    data.sender = 1
                    data.sid = message.sid
                    data.txt = msz
                    data.profileImg = sImage
                    data.name = "\(senderName ?? "")"
                    data.time = message.dateCreated
                    completionHandler(data, false)
                }
                
                // print("senderName1:\(senderName),sName21:\(messageID), sImage1:\(sImage),sIdentity1:\(sIdentity), msz::\(msz)")
                
            }
        }
    }
    func downloadVideo(fileName: String, url: String, handlers:@escaping(Bool?) ->()){
        
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = docsUrl?.appendingPathComponent(fileName)
        
        if let vdoUrl = URL(string: url) {
            URLSession.shared.downloadTask(with: vdoUrl) {(tempUrl,response,error) in
                if let fullUrl = tempUrl {
                    do
                    {
                        let vData = try Data(contentsOf: fullUrl)
                        print("download video temp url--------->", fullUrl)
                        // 2
                        try vData.write(to: destinationURL!,options: .atomic)
                        handlers(true)
                        
                    }
                    catch{
                        handlers(false)
                        print("dowload error video")
                    }
                }
            }.resume()
        }
    }
}


//Important points doucments types access
/*
 
 let docsTypes = ["public.text",
 "com.apple.iwork.pages.pages",
 "public.data",
 "kUTTypeItem",
 "kUTTypeContent",
 "kUTTypeCompositeContent",
 "kUTTypeData",
 "public.database",
 "public.calendar-event",
 "public.message",
 "public.presentation",
 "public.contact",
 "public.archive",
 "public.disk-image",
 "public.plain-text",
 "public.utf8-plain-text",
 "public.utf16-external-plain-​text",
 "public.utf16-plain-text",
 "com.apple.traditional-mac-​plain-text",
 "public.rtf",
 "com.apple.ink.inktext",
 "public.html",
 "public.xml",
 "public.source-code",
 "public.c-source",
 "public.objective-c-source",
 "public.c-plus-plus-source",
 "public.objective-c-plus-​plus-source",
 "public.c-header",
 "public.c-plus-plus-header",
 "com.sun.java-source",
 "public.script",
 "public.assembly-source",
 "com.apple.rez-source",
 "public.mig-source",
 "com.apple.symbol-export",
 "com.netscape.javascript-​source",
 "public.shell-script",
 "public.csh-script",
 "public.perl-script",
 "public.python-script",
 "public.ruby-script",
 "public.php-script",
 "com.sun.java-web-start",
 "com.apple.applescript.text",
 "com.apple.applescript.​script",
 "public.object-code",
 "com.apple.mach-o-binary",
 "com.apple.pef-binary",
 "com.microsoft.windows-​executable",
 "com.microsoft.windows-​dynamic-link-library",
 "com.sun.java-class",
 "com.sun.java-archive",
 "com.apple.quartz-​composer-composition",
 "org.gnu.gnu-tar-archive",
 "public.tar-archive",
 "org.gnu.gnu-zip-archive",
 "org.gnu.gnu-zip-tar-archive",
 "com.apple.binhex-archive",
 "com.apple.macbinary-​archive",
 "public.url",
 "public.file-url",
 "public.url-name",
 "public.vcard",
 "public.image",
 "public.fax",
 "public.jpeg",
 "public.jpeg-2000",
 "public.tiff",
 "public.camera-raw-image",
 "com.apple.pict",
 "com.apple.macpaint-image",
 "public.png",
 "public.xbitmap-image",
 "com.apple.quicktime-image",
 "com.apple.icns",
 "com.apple.txn.text-​multimedia-data",
 "public.audiovisual-​content",
 "public.movie",
 "public.video",
 "com.apple.quicktime-movie",
 "public.avi",
 "public.mpeg",
 "public.mpeg-4",
 "public.3gpp",
 "public.3gpp2",
 "public.audio",
 "public.mp3",
 "public.mpeg-4-audio",
 "com.apple.protected-​mpeg-4-audio",
 "public.ulaw-audio",
 "public.aifc-audio",
 "public.aiff-audio",
 "com.apple.coreaudio-​format",
 "public.directory",
 "public.folder",
 "public.volume",
 "com.apple.package",
 "com.apple.bundle",
 "public.executable",
 "com.apple.application",
 "com.apple.application-​bundle",
 "com.apple.application-file",
 "com.apple.deprecated-​application-file",
 "com.apple.plugin",
 "com.apple.metadata-​importer",
 "com.apple.dashboard-​widget",
 "public.cpio-archive",
 "com.pkware.zip-archive",
 "com.apple.webarchive",
 "com.apple.framework",
 "com.apple.rtfd",
 "com.apple.flat-rtfd",
 "com.apple.resolvable",
 "public.symlink",
 "com.apple.mount-point",
 "com.apple.alias-record",
 "com.apple.alias-file",
 "public.font",
 "public.truetype-font",
 "com.adobe.postscript-font",
 "com.apple.truetype-​datafork-suitcase-font",
 "public.opentype-font",
 "public.truetype-ttf-font",
 "public.truetype-collection-​font",
 "com.apple.font-suitcase",
 "com.adobe.postscript-lwfn​-font",
 "com.adobe.postscript-pfb-​font",
 "com.adobe.postscript.pfa-​font",
 "com.apple.colorsync-profile",
 "public.filename-extension",
 "public.mime-type",
 "com.apple.ostype",
 "com.apple.nspboard-type",
 "com.adobe.pdf",
 "com.adobe.postscript",
 "com.adobe.encapsulated-​postscript",
 "com.adobe.photoshop-​image",
 "com.adobe.illustrator.ai-​image",
 "com.compuserve.gif",
 "com.microsoft.bmp",
 "com.microsoft.ico",
 "com.microsoft.word.doc",
 "com.microsoft.excel.xls",
 "com.microsoft.powerpoint.​ppt",
 "com.microsoft.waveform-​audio",
 "com.microsoft.advanced-​systems-format",
 "com.microsoft.windows-​media-wm",
 "com.microsoft.windows-​media-wmv",
 "com.microsoft.windows-​media-wmp",
 "com.microsoft.windows-​media-wma",
 "com.microsoft.advanced-​stream-redirector",
 "com.microsoft.windows-​media-wmx",
 "com.microsoft.windows-​media-wvx",
 "com.microsoft.windows-​media-wax",
 "com.apple.keynote.key",
 "com.apple.keynote.kth",
 "com.truevision.tga-image",
 "com.sgi.sgi-image",
 "com.ilm.openexr-image",
 "com.kodak.flashpix.image",
 "com.j2.jfx-fax",
 "com.js.efx-fax",
 "com.digidesign.sd2-audio",
 "com.real.realmedia",
 "com.real.realaudio",
 "com.real.smil",
 "com.allume.stuffit-archive",
 "org.openxmlformats.wordprocessingml.document",
 "com.microsoft.powerpoint.​ppt",
 "org.openxmlformats.presentationml.presentation",
 "com.microsoft.excel.xls",
 "org.openxmlformats.spreadsheetml.sheet",
 
 
 ]
 let documentPicker = UIDocumentPickerViewController(documentTypes: Utils.docsTypes, in: .import)
 documentPicker.delegate = self
 documentPicker.allowsMultipleSelection = true
 present(documentPicker, animated: true, completion: nil)
 */
