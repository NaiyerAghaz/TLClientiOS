//
//  ChatViewController.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 06/06/22.
//

import UIKit
import TwilioChatClient
import TwilioVideo
import SDWebImage
import IQKeyboardManager
import MobileCoreServices

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var chatDelegate: chatDelegateMethods?
    var arrChatSection = [RowData]()
    var chatChannel : TCHChannel?
    // var localParticipants : LocalParticipant?
   // var messages:Set<TCHMessage> = Set<TCHMessage>()
   // var sortedMessages:[TCHMessage]!
    var chatVModel = chatViewModels()
    @IBOutlet weak var chatBottomConstant: NSLayoutConstraint!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var tblView: UITableView!
  
   @IBOutlet weak var txtMessage: UITextField!
    var isOpenChat = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        imagePicker.delegate = self
        tblView.register(UINib(nibName: "ChatTVCell", bundle: nil), forCellReuseIdentifier: "TextChatCell")
        tblView.register(UINib(nibName: "ImageChatCell", bundle: nil), forCellReuseIdentifier: "ImageChatCell")
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        IQKeyboardManager.shared().isEnabled = false
       addKeyBoardListener()
        chatChannel?.delegate = self
        joinChannel()
        txtMessage.delegate = self
        tblView.tableFooterView = UIView(frame: .zero)
        tblView.separatorStyle = .none
  }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.shared().isEnabled = true
        uiConfig()
    }
    func uiConfig(){
      
            if self.arrChatSection.count > 0 {
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                    self.view.layoutIfNeeded()
                   self.tblView.scrollToBottomRow()
                }
                
            }
      
    }
    
    func addKeyBoardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil);
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
    @IBAction func btnSendMszTapped(_ sender: Any) {
        
        //@Test #Narendra2##hi#/ProfileImages/Profiles/2022-Mar-30-0313541648624430629.png#SneakyBobbySaintPaul
        
        if !txtMessage.text!.isEmpty {
            mszCounts = mszCounts + 1
            let msz = "\(userDefaults.string(forKey: "firstName") ?? ""):#\(userDefaults.string(forKey: "firstName") ?? "")\(mszCounts)##\(txtMessage.text!)#\((userDefaults.string(forKey: "ImageData") ?? "/images/noprofile.jpg"))#\(userDefaults.string(forKey: "twilioIdentity") ?? "")"
            print("message body->", msz)
          
            let mszOption = TCHMessageOptions.init()
            mszOption.withBody(msz)
            self.chatChannel?.messages?.sendMessage(with: mszOption, completion: { chResult, chMessage in
                if chResult.isSuccessful() {
                    self.txtMessage.text = ""
                    debugPrint("message has updated----------------->>",chMessage, "chResult:",chResult)
                }
            })
        }
        else {
            self.view.makeToast(ConstantStr.msz.val)
        }
        
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
    @IBAction func btnAttachedTapped(_ sender: Any) {
        let chatAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let doc = UIAlertAction(title: "Documnets", style: .default) { alert in
            self.showDocuments()
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { alert in
            //MARK:Show Gallery
            self.showPhotoGallery()
            
        }
        let audio = UIAlertAction(title: "Audio", style: .default) { alert in
            self.showAudio()
        }
        let video = UIAlertAction(title: "Video", style: .default) { alert in
            self.showVideo()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 26, weight: .bold, scale: .large)
        //doc
        let imgDoc = UIImage(systemName: "doc.circle.fill", withConfiguration: largeConfig)
        doc.setValue(imgDoc?.withRenderingMode(.alwaysOriginal), forKey: "image")
        chatAlert.addAction(doc)
       
        //gallery
        
        let imgGallery =  UIImage(systemName: "photo.on.rectangle.angled", withConfiguration: largeConfig)
        gallery.setValue(imgGallery?.withRenderingMode(.alwaysOriginal), forKey: "image")
        chatAlert.addAction(gallery)
        //Audio
      let imgAudio =  UIImage(systemName: "headphones.circle.fill", withConfiguration: largeConfig)
        audio.setValue(imgAudio?.withRenderingMode(.alwaysOriginal), forKey: "image")
       chatAlert.addAction(audio)
        //Video
        let imgVdo =  UIImage(systemName: "video.circle.fill", withConfiguration: largeConfig)
        video.setValue(imgVdo?.withRenderingMode(.alwaysOriginal), forKey: "image")
        chatAlert.addAction(video)
       
        chatAlert.addAction(cancel)
        self.present(chatAlert, animated: true)
    }
    
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        chatDelegate?.chatRefreshed(chats: self.arrChatSection)
        isOpenChat = false
        self.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = arrChatSection[indexPath.row]
      
            switch rowData.rowType {
            case .txt:
                let tCell = tableView.dequeueReusableCell(withIdentifier:"TextChatCell") as! ChatTVCell
                tCell.configureText(obj: rowData)
                return tCell
             case .img:
                let imgCell = tableView.dequeueReusableCell(withIdentifier:"ImageChatCell") as! ImageChatCell
                imgCell.configureImg(obj: rowData)
                return imgCell
             case .audio:
                print("audioP")
                break
          
            case .txtReply:
                print("txtReply")
            case .imgReply:
                print("txtReply")
            case .audioReply:
                print("audioReply")
            }
      return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrChatSection.count
    }
    //channel implementation:
    func joinChannel() {
        //  setViewOnHold(onHold: true)
        
        if chatChannel!.status != .joined {
            chatChannel!.join { result in
                print("Channel Joined")
            }
            return
        }
        
        //  loadMessages()
        // setViewOnHold(onHold: false)
    }
    
}


