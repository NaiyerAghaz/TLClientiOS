//
//  VideoCallViewController.swift
//  TLClientApp
//
//  Created by Naiyer on 8/27/21.
//

import Foundation
import UIKit
import TwilioVideo
import CallKit
import DropDown
import TwilioChatClient
import Malert
import IQKeyboardManager
import AVFoundation
import AVKit


class VideoCallViewController: UIViewController, LocalParticipantDelegate, TwilioChatClientDelegate,AcceptAndRejectDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    // Video SDK components
    /**
     * We will create an audio device and manage it's lifecycle in response to CallKit events.
     */
    
    @IBOutlet weak var lblReconecting: UILabel!
    @IBOutlet weak var lblTotalParticipant: UILabel!
    @IBOutlet weak var userRemoteView: UIView!
    var audioDevice = DefaultAudioDevice()
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var room: Room?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    var remoteParticiapntName: String = ""
    var localParticipant : LocalParticipant?
    var remoteView : VideoView?
    var callChannel : TCHChannel?
    var seconds = 0
    var recordTime = Timer()
    // CallKit components
    let callKitProvider: CXProvider? = nil
    let callKitCallController: CXCallController? = nil
    var userInitiatedDisconnect: Bool = false
    var ifComeFromMeet = false
    var ifTimereach = false
    var roomID,sourceLangID,targetLangID,sourceLangName,targetLangName,patientname,patientno: String?
    var roomlocalParticipantSIDrule: String?
    var isClientDetails,isScheduled : Bool?
    var twilioToken : String?
    var vdoCallVM = VDOCallViewModel()
    var timer = Timer()
    var customerEndCall = false
    var ringToneTimer = Timer()
    var ringingTime = 60
    var localParicipantDictionary: NSMutableDictionary?
    var remoteParicipantDictionary: NSMutableDictionary?
    var remoteParticipantArr = [RemoteParticipant]()
    
    
    @IBOutlet weak var btnSpeak: UIButton!
    @IBOutlet weak var btnCameraFlip: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var previewOriginal: UIView!
    var preview = VideoView()
    @IBOutlet weak var muteView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var stopVideoView: UIView!
    @IBOutlet weak var vdoCollectionView: UICollectionView!
    @IBOutlet weak var participantView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var btnStopVideo: UIButton!
    @IBOutlet weak var btnMic: UIButton!
    @IBOutlet weak var lblTimeSpeak: UILabel!
    @IBOutlet weak var imgLocalPrivacy: UIImageView!
    //Speakers Outlets
    @IBOutlet weak var speakerImgPrivacy: UIImageView!
    @IBOutlet weak var speakerViewOriginal: UIView!
    var speakerView = VideoView()
    @IBOutlet weak var parentSpeakerView: UIView!
    @IBOutlet weak var btnSpeakerMic: UIButton!
    @IBOutlet weak var lblVideo: PaddingLabel!
    @IBOutlet weak var lblParticipantName: PaddingLabel!
    @IBOutlet weak var lblAudio: PaddingLabel!
    @IBOutlet weak var lblPrivateChatCounts: UILabel!
    @IBOutlet weak var chatIndicatorView: UIView!
    //End
    //Chat Outlets and var
    
    @IBOutlet weak var lblTyping: UILabel!
    @IBOutlet weak var typingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var typingView: UIView!
    @IBOutlet weak var imgReplyWidth: NSLayoutConstraint!
    @IBOutlet weak var imgReplymsz: UIImageView!
    @IBOutlet weak var lblReplyMsz: UILabel!
    @IBOutlet weak var lblNameReplyUser: UILabel!
    @IBOutlet weak var mszReplyContainerHeight: NSLayoutConstraint!
    var privateChatArr = [String]()
    @IBOutlet weak var chatView: UIView!
    var replyId :String? = ""
    var isOpenChat = false
    var chatVModel = chatViewModels()
    @IBOutlet weak var chatBottomConstant: NSLayoutConstraint!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var tblView: UITableView!
    var playerViewController = AVPlayerViewController()
    
    
    // @IBOutlet weak var txtMessage: UITextField!
    
    @IBOutlet weak var txtMessageHeight: NSLayoutConstraint!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var tblPrivateView: UITableView!
    @IBOutlet weak var privateUserView: UIView!
    //END
    
    var vendorTbl : UITableView = UITableView()
    var lblParticipant = UILabel()
    var callingImageView = UIImageView()
    var isShownParti = false
    var chatManager = ChatManager()
    var isMeetingCall = false
    var clientStatusModel: ClientStatusModel?
    var isAttendMultiPart = false
    var callStartTime = ""
    var isChatCreated = false
    var isChatConnected  = false
    var myChannel : TCHChannel?
    var client : TwilioChatClient?
    var channels :NSMutableOrderedSet?
    var videocallDelegate: VideocallDelegate?
    var isSpeaking = false
    var currentSpeakerParticipant :RemoteParticipant?
    var previousSpeakerParticipant : RemoteParticipant?
    var isParticipanthasAdded = false
    var isTapGesture = false
    var isChangeView = false
    //More dropdown
    //dragged view
    var isLocalPinVideo = false
    var panGesture       = UIPanGestureRecognizer()
    @IBOutlet weak var mainPreview: UIView!
    @IBOutlet weak var btnPinLocal: UIButton!
    let imageView = UIImageView()
    var lblParticipantSearching = UILabel()
    var pinVideoArr = [pinModels]()
    var chatListArr = [RowData]()
    //end--
    let moreDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.moreDropDown
        ]
    }()
    var moreArr:[String] = ["Chat", "Change View","Pin Video"]
    var lView = VideoView()
    var primarylocalParticiapnt: LocalParticipant?
    var secondaryRemoteVdoTrack: RemoteParticipant?
    var isSwitchToRemote = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatView.isHidden = true
        chatIndicatorView.isHidden = true
        mainPreview.frame = CGRect(x: self.view.frame.size.width - 140, y: 60, width: 160, height: 160)
        reCreatePreview()
        lblReconecting.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(participantNotAvailable(noti:)), name: Notification.Name("notAvailableParticipant"), object: nil)
        if ifComeFromMeet {
            if ifTimereach {
                // start call here
                self.topView.isHidden = false
                configure()
                // isMeetingCall = true
                vdoCollectionView.isHidden = true
                self.vdoCollectionView.delegate = self
                self.vdoCollectionView.dataSource = self
                self.vdoCollectionView.bounces = false
                genarateChatTokenCreate()
            }else {
                self.topView.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    let refreshAlert = UIAlertController(title: "Alert", message: "Waiting for the Participants.", preferredStyle: UIAlertController.Style.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Close", style: .default, handler: { (action: UIAlertAction!) in
                        
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                }
            }
            
        }else {
            imgLocalPrivacy.isHidden = true
            self.topView.isHidden = false
            configure()
            // isMeetingCall = true
            vdoCollectionView.isHidden = true
            self.vdoCollectionView.delegate = self
            self.vdoCollectionView.dataSource = self
            self.vdoCollectionView.bounces = false
            genarateChatTokenCreate()
        }
        self.vdoCollectionView.isPrefetchingEnabled = false
        getChatConfig()
    }
    
    //MARK: Configure With Twilio
    func configure(){
        self.mainPreview.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handler)))
        self.mainPreview.isUserInteractionEnabled = true
        
        
        customizeDropDown()
        setupChooseDropDown()
        ringingView(ishide: true)
        vdoCallVM.getTwilioToken { model, err in
            if err == nil {
                self.twilioToken = model?.token
                // self.startPreview()
                // myAudio.stop()
                // self.timer.invalidate()
                self.doConnectTwilio(twilioToken: (model?.token)!)
            }
        }
        CEnumClass.share.playSounds(audioName: "incoming")
        
        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.ringingCallStart), userInfo: nil, repeats: true)
        vendorTbl.frame = CGRect(x: 0, y: 55, width: self.view.bounds.size.width, height: 200)
        vendorTbl.backgroundColor = UIColor.clear
        vendorTbl.separatorStyle = .none
        vendorTbl.layoutSubviews()
        vendorTbl.tableFooterView = UIView(frame: .zero)
        let cellNib = UINib(nibName: "VendorTVCell", bundle: nil)
        vendorTbl.register(cellNib, forCellReuseIdentifier: cellIndentifier.vendorTVCell.rawValue)
        
    }
    func reCreatePreview(){
        btnPinLocal.frame = CGRect(x: 45, y: 25, width: 70, height: 24)
        btnPinLocal.layer.cornerRadius = 5
        btnPinLocal.clipsToBounds = true
        preview.frame = CGRect(x: 0, y: 0, width: 100, height: 110)
        previewOriginal.frame = CGRect(x: 30, y: 25, width: 100, height: 110)
        preview.layer.borderColor = UIColor.black.cgColor
        preview.layer.borderWidth = 1
        previewOriginal.addSubview(preview)
        mainPreview.addSubview(previewOriginal)
        mainPreview.addSubview(btnPinLocal)
        btnMic.frame = CGRect(x: 100, y: 110, width: 22, height: 22)
        mainPreview.addSubview(btnMic)
        imgLocalPrivacy.frame = CGRect(x: 30, y: 25, width: 100, height: 110)
        mainPreview.addSubview(imgLocalPrivacy)
    }
    //MARK: btnPinVideoTapped
    @IBAction func btnPinVideoTapped(_ sender: UIButton) {
        self.pinVideoArr.removeAll()
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.pinVideoArr = [pinModels(isRemotePin: false, isLocalPin: true, lp: self.localParticipant, rp: remoteParticipant)]
            isSwitchToRemote = true
            fullFlashViewChangesMethod(isFlip:false)
        }
        else {
            isSwitchToRemote = false
        }
    }
    
    @objc func handler(gesture: UIPanGestureRecognizer){
        isTapGesture = true
        topView.isHidden = true
        bottomView.isHidden = true
        let location = gesture.location(in: self.view)
        let draggedView = gesture.view
        draggedView?.center = location
        
        if gesture.state == .ended {
            if self.mainPreview.frame.midX >= self.view.layer.frame.width / 2 {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.mainPreview.center.x = self.view.layer.frame.width - 60
                    if location.y < 20 {
                        self.mainPreview.center.y = 60
                    }
                    else if location.y > self.view.frame.size.height - 20 {
                        self.mainPreview.center.y = self.view.frame.size.height - 60
                    }
                }, completion: nil)
            }
            
            else{
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.mainPreview.center.x = 60
                    if location.y < 20 {
                        self.mainPreview.center.y = 60
                    }
                    else if location.y > self.view.frame.size.height - 20 {
                        self.mainPreview.center.y = self.view.frame.size.height - 60
                    }
                    // self.mainPreview.center.y = 40
                }, completion: nil)
            }
        }
    }
    @objc func handlerTopbottom(gesture: UITapGestureRecognizer){
        if bottomView.isHidden == true && topView.isHidden == true {
            bottomView.isHidden = false
            topView.isHidden = false
            
        }
        else {
            bottomView.isHidden = true
            topView.isHidden = true
        }
    }
    func ringingView(ishide: Bool){
        mainPreview.isHidden = ishide
        preview.contentMode = .scaleToFill
        preview.clipsToBounds = true
        
        muteView.isHidden = ishide
        stopVideoView.isHidden = ishide
        participantView.isHidden = ishide
        moreView.isHidden = ishide
        btnMic.isHidden = true
        if ishide == true {
            
            speakerImgPrivacy.isHidden = ishide
            parentSpeakerView.isHidden = ishide
            lblParticipant.frame = CGRect(x: 0, y: 0, width: topView.frame.size.width, height: topView.frame.size.height)
            lblParticipant.text = "Searching Interpreters.."
            lblParticipant.backgroundColor = UIColor.black
            lblParticipant.textAlignment = .center
            lblParticipant.textColor = .white
            topView.addSubview(lblParticipant)
            let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "call", withExtension: "gif")!)
            let advTimeGif = UIImage.gifImageWithData(imageData!)
            callingImageView = UIImageView(image: advTimeGif)
            callingImageView.frame = CGRect(x: userRemoteView.frame.size.width / 2 - 70, y: userRemoteView.frame.size.height / 2 - 100, width: 140, height: 140.0)
            
            self.userRemoteView.addSubview(callingImageView)
        }
        else {
            self.speakerView.contentMode = .scaleAspectFill
            self.speakerView.layer.cornerRadius = 0
            self.speakerView.clipsToBounds = false
            self.speakerView.frame.size.width = self.view.bounds.width
            self.speakerView.frame.size.height = self.view.bounds.height
            self.speakerViewOriginal.addSubview(speakerView)
            self.speakerView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(VideoCallViewController.handlerTopbottom(gesture:)))
            self.speakerView.addGestureRecognizer(tap)
            self.topView.backgroundColor = UIColor.black
                .withAlphaComponent(0.7)
            self.bottomView.backgroundColor = UIColor.black
                .withAlphaComponent(0.7)
            vdoCollectionView.isHidden = true
            
            parentSpeakerView.isHidden = ishide
            lblParticipant.removeFromSuperview()
            callingImageView.removeFromSuperview()
        }
    }
    
    //MARK: More Dropdown
    
    func setupChooseDropDown() {
        moreDropDown.anchorView = btnMore
        moreDropDown.topOffset = CGPoint(x: 0, y: btnMore.bounds.height - 90)
        
        moreDropDown.dataSource = moreArr
        
        moreDropDown.selectionAction = { [self] (index, item) in
            print("Index seletected more:", index, item)
            if index == 0 {
                (vdoCallVM.conferrenceDetail.CONFERENCEInfo!.count > 1) ? (self.privateUserView.isHidden = false) : (self.privateUserView.isHidden = true)
                tblPrivateView.isHidden = true
                self.chatIndicatorView.isHidden = true
                self.chatView.isHidden = false
                self.chatView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                isOpenChat = true
                if chatListArr.count > 0 {
                    self.tblView.reloadData()
                }
                
            }else if index == 1{
                
                if self.isChangeView == false  {
                    
                    DispatchQueue.main.async {
                        self.previewOriginal.removeAllSubViews()
                        self.speakerViewOriginal.removeAllSubViews()
                        self.vdoCollectionView.isHidden = false
                        self.mainPreview.isHidden = true
                        self.isChangeView = true
                        self.parentSpeakerView.isHidden = true
                        self.vdoCollectionView.reloadData()
                    } }
                else {
                    
                    DispatchQueue.main.async {
                        
                        self.isChangeView = false
                        self.vdoCollectionView.isHidden = true
                        self.parentSpeakerView.isHidden = false
                        self.mainPreview.isHidden = false
                        self.fullFlashViewChangesMethod(isFlip: false)
                        
                    }
                }
            }else if index == 2 {
                if self.pinVideoArr.count > 0 {
                    self.pinVideoArr.removeAll()
                    self.moreArr[2] = "Pin Video"
                    moreDropDown.dataSource = moreArr
                    if self.isChangeView {
                        self.vdoCollectionView.reloadData()
                    }
                }
                else {
                    if self.isChangeView {
                        moreArr[2] = "Unpin video"
                        moreDropDown.dataSource = moreArr
                        // self.remoteParticiapntName = cell.participantName.text ?? ""
                        btnPinLocal.isSelected = false
                        self.isSwitchToRemote = false
                        print("other index remote")
                        self.remoteParticipant = remoteParticipantArr[0]
                        self.pinVideoArr = [pinModels(isRemotePin: true, isLocalPin: false, lp: localParticipant, rp: remoteParticipantArr[0])]
                        self.vdoCollectionView.isHidden = true
                        self.parentSpeakerView.isHidden = false
                        self.mainPreview.isHidden = false
                        isChangeView = false
                        self.fullFlashViewChangesMethod(isFlip: false)
                    }
                    else {
                        self.moreArr[2] = "Unpin Video"
                        moreDropDown.dataSource = moreArr
                        self.pinVideoArr = [pinModels(isRemotePin: true, isLocalPin: false, lp: self.localParticipant, rp: self.remoteParticipantArr[0])]
                    }
                }
                
            }else if index == 3 {
                print(item)
            }
            
        }
    }
    func customizeDropDown() {
        let appearance = DropDown.appearance()
        appearance.direction = .top
        // appearance.backgroundColor = UIColor.black
        // appearance.cellHeight = 60
        appearance.backgroundColor = UIColor.black
        appearance.selectionBackgroundColor = UIColor.darkGray
        //        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.clipsToBounds = true
        appearance.textColor = .white
        //        appearance.textFont = UIFont(name: "Georgia", size: 14)
        
        if #available(iOS 11.0, *) {
            appearance.setupMaskedCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner,.layerMinXMinYCorner])
        }
        
        dropDowns.forEach {
            /*** FOR CUSTOM CELLS ***/
            $0.cellNib = UINib(nibName: "MoreCell", bundle: nil)
            
            $0.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                guard let cell11 = cell as? MoreCell else { return }
                
                // Setup your custom UI components
                cell11.logoImageView.image = UIImage(named: "ic_more\(index % 10)")
            }
            /*** ---------------- ***/
        }
    }
    //MARK:******** Generate Chat token creation  ********
    func genarateChatTokenCreate(){
        chatManager.loginWithIdentityChat(indentityName: userDefaults.string(forKey: "username")!) { success, err in
            if success! {
                if self.chatManager.client != nil {
                    self.chatManager.client?.delegate = self
                    self.newChannelPrivateCreate()
                }
            }
            
        }
    }
    
    func newChannelPrivateCreate(){
        
        var channelList = TCHChannels()
        channelList = (chatManager.client?.channelsList())!
        
        let dic:[String:Any] = [TCHChannelOptionFriendlyName:self.roomID!,TCHChannelOptionUniqueName:roomID!,TCHChannelOptionType:TCHChannelType.public]
        channelList.createChannel(options: dic) { [self] result, channel in
            if result.isSuccessful() {
                isChatCreated = true
                myChannel = channel
                
                populateChannelsJoin()
                joinChannelCreate(channel: channel!)
            }
            else {
                if result.resultCode == 50307 {
                    if channel != nil {
                        isChatCreated = true
                        myChannel = channel
                        joinChannelCreate(channel: channel!)
                    }
                    else {
                        if !isChatCreated {
                            genarateChatTokenJoin()
                        }
                    }}
            }
            
        }
    }
    
    func joinChannelCreate(channel: TCHChannel)  {
        channel.join { [self] result in
            if result.isSuccessful() {
                isChatConnected = true
            }
            else {
                isChatConnected = false
            }
        }
    }
    func genarateChatTokenLobby(){
        chatManager.loginWithIdentityChat(indentityName: userDefaults.string(forKey: "username")!) { success, err in
            if success! {
                let client = self.chatManager.client
                client?.delegate = self
                //  [self populateChannelsLobby];
                // [self newChannelPrivateLobby:NO];
            }
            else {
                //  self.view.makeToast("genarateChatTokenLobby")
                // print("genarateChatTokenLobby-------------->")
            }
        }
    }
    func genarateChatTokenJoin(){
        chatManager.loginWithIdentityChat(indentityName: userDefaults.string(forKey: "username")!) { success, err in
            if success! {
                if self.chatManager.client != nil {
                    let client = self.chatManager.client
                    client?.delegate = self
                    self.populateChannelsJoin()
                    self.newChannelPrivateJoin()
                    //  [self newChannelPrivateJoin:NO];
                }
            }
        }
    }
    func populateChannelsJoin(){
        self.channels = nil
        let channelList:TCHChannels = (chatManager.client?.channelsList())!
        let newChannels: NSMutableOrderedSet? = []
        
        newChannels?.add(channelList.subscribedChannels())
        
        DispatchQueue.main.async {
            self.channels = newChannels
            if self.channels != nil {
                for i in 0...self.channels!.count - 1 {
                    let channel = self.channels![i] as? TCHChannel
                    
                    if channel?.friendlyName != nil {
                        if (channel?.friendlyName!.count)! > 0 {
                            if channel?.friendlyName == self.roomID {
                                self.myChannel = channel
                            }
                        }
                    }
                    
                }
            }
        }
    }
    func newChannelPrivateJoin(){
        
        var channelList = TCHChannels()
        channelList = (chatManager.client?.channelsList())!
        
        channelList.channel(withSidOrUniqueName: self.roomID!) {[self] result, channel in
            if result.isSuccessful() {
                isChatCreated = true
                myChannel = channel
                joinChannelJoin(channel: channel!)
            }
            else {
                if result.resultCode == 50307 {
                    if channel != nil {
                        isChatCreated = true
                        myChannel = channel
                        joinChannelJoin(channel: channel!)
                    }
                    else {
                        if !isChatCreated {
                            genarateChatTokenJoin()
                        }
                    }
                }
                else {
                    if channel != nil {
                        myChannel = channel
                        joinChannelJoin(channel: channel!)
                        
                    }
                    else {
                        if !isChatCreated {
                            genarateChatTokenJoin()
                        }
                    }
                } }
        }
    }
    func joinChannelJoin(channel:TCHChannel){
        channel.join {[self] result in
            if result.isSuccessful(){
                isChatCreated = false
                myChannel = channel
                if isMeetingCall {
                    showLobbyAlert()
                }
            }
        }
        
    }
    func showLobbyAlert(){
        UIAlertController.showAlert(title: "", message: "Participant(s) are waiting in the lobby.", style: .alert, cancelButton: "View Lobby", otherButtons: nil) { [self] index, _ in
            if index == 0 {
                getMeetingClientStatusLobby()
            }
        }
    }
    func getMeetingClientStatusLobby(){
        let req = vdoCallVM.meetingClientReq(roomID: self.roomID!)
        vdoCallVM.getMeetingClientStatusLobbyWithCompletion(parameter: req) { success, result in
            self.clientStatusModel = result
            self.btnParticipantTapped(self)
            
            
        }
    }
    //MARK: Refresh accept the participant
    func refresh(isaccept: Bool, pid: String) {
        if isaccept{
            let bodyMsz = "acceptfromclient:\(pid)"
            
            // self.dismiss(animated: true, completion: nil)
            let messageOption = TCHMessageOptions.init()
            messageOption.withBody(bodyMsz)
            self.myChannel?.messages?.sendMessage(with: messageOption, completion: { result, message in
                if result.isSuccessful(){
                    
                    self.getMeetingClientStatusLobbyRefreshAccept(roomId: self.roomID!)
                }
            })
        }
        else {
            let bodyMsz = "rejectfromclient:\(pid)"
            
            // self.dismiss(animated: true, completion: nil)
            let messageOption = TCHMessageOptions.init()
            messageOption.withBody(bodyMsz)
            self.myChannel?.messages?.sendMessage(with: messageOption, completion: { result, message in
                if result.isSuccessful(){
                    
                    self.getMeetingClientStatusLobbyRefreshAccept(roomId: self.roomID!)
                }
                
            })
        }
        
    }
    func getHostControl(obj: ConferenceInfoResultModel) {
        
        vdoCallVM.conferrenceDetail = obj
        if isChangeView {
            vdoCallVM.conferrenceDetail = obj
            DispatchQueue.main.async {
                
                self.vdoCollectionView.reloadData()
            }
        }
        else {
            for ndata in obj.CONFERENCEInfo! {
                let nobj =  ndata as! ConferenceInfoModels
                if nobj.PARTSID == remoteParticipant?.sid {
                    print("remote-particiapnt-sid:",remoteParticipant?.sid)
                    DispatchQueue.main.async {
                        self.configureHost(obj: nobj)
                    }
                    
                }
            }
        }
        
        
    }
    func getMeetingClientStatusLobbyRefreshAccept(roomId: String){
        let req = vdoCallVM.meetingClientReq(roomID: roomId)
        vdoCallVM.getMeetingClientStatusLobbyWithCompletion(parameter: req) { success, result in
            if success  == true{
                
                if result?.INVITEDATA2 == "0"{
                    self.clientStatusModel = nil
                }
            }
        }}
    // MARK:TwilioChatClientDelegate
    //MARK: Actions and Outlet
    
    @IBAction func btnMicTapped(_ sender: UIButton) {
        
        if (localAudioTrack != nil){
            localAudioTrack?.isEnabled = !localAudioTrack!.isEnabled
            sender.isSelected = !sender.isSelected
        }
        
    }
    @IBAction func btnStopVideoTapped(_ sender: Any) {
        
        if localVideoTrack != nil {
            localVideoTrack?.isEnabled = !localVideoTrack!.isEnabled
            btnStopVideo.isSelected = !btnStopVideo.isSelected
            btnCameraFlip.isEnabled = !btnCameraFlip.isEnabled
            if remoteParticipantArr.count > 0 && isChangeView {
                
                DispatchQueue.main.async {
                    self.vdoCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
                    // self.vdoCollectionView.reloadData()
                }
            }
            else {
                if isSwitchToRemote {
                    vdoCallVM.videoTrackEnableOrDisable(isenable: localVideoTrack!.isEnabled, img: speakerImgPrivacy)
                }
                else {
                    vdoCallVM.videoTrackEnableOrDisable(isenable: localVideoTrack!.isEnabled, img: imgLocalPrivacy)
                }
                
            }
        }}
    @IBAction func btnEndCallTapped(_ sender: Any) {
        UIAlertController.showAlert(title: "", message: "Are you sure you want to hangup this call?", style: .alert, cancelButton: "Cancel", distrutiveButton: "End Call", otherButtons: nil) { [self] index, _ in
            if index == 0 {
                self.customerEndCall = true
                timer.invalidate()
                // ringToneTimer.invalidate()
                if myAudio != nil{
                    myAudio!.stop()
                }
                if (room != nil){
                    room?.disconnect()
                    if (self.camera != nil){
                        camera?.stopCapture()
                        camera = nil
                    }
                    if (localVideoTrack != nil){
                        localVideoTrack = nil
                    }
                    if localAudioTrack != nil {
                        localAudioTrack = nil
                    }
                    if remoteParticipantArr.count > 0 {
                        vdoCallVM.customerEndCallWithoutConnect(roomID: roomID ?? "") { success, err in
                            if success! {
                                SwiftLoader.hide()
                                DispatchQueue.main.async {
                                    print("backtomain---------->3")
                                    self.updateYourFeedback()
                                }}
                            else {
                                SwiftLoader.hide()
                                self.view.makeToast("Please try again to hangup this call")
                            }}}
                    else {
                        vdoCallVM.customerEndCallWithoutConnect(roomID: roomID ?? "") { success, err in
                            if success! {
                                DispatchQueue.main.async {
                                    SwiftLoader.hide()
                                    self.dismissViewControllers()
                                }
                                
                            }
                            else {
                                SwiftLoader.hide()
                                self.view.makeToast("Please try again to hangup this call")
                            }
                            
                        }}}
            }}}
    
    //MARK: Feedback Method call:
    public func updateYourFeedback(){
        chatArr.removeAll()
        recordTime.invalidate()
        let sB = UIStoryboard(name: Storyboard_name.home, bundle: nil)
        let fb = sB.instantiateViewController(identifier: Control_Name.vrifeedback) as! VRIOPIFeedbackController
        fb.roomID = roomID
        fb.targetLang = targetLangName
        fb.duration = lblTimeSpeak.text//callStartTime
        fb.dateAndTime = callStartTime
        fb.calltype = "V"
        fb.modalPresentationStyle = .overFullScreen
        // SwiftLoader.hide()
        self.present(fb, animated: true, completion: nil)
        
        
    }
    @IBAction func btnParticipantTapped(_ sender: Any) {
        
        let callVC = UIStoryboard(name: Storyboard_name.home, bundle: nil)
        let vcontrol = callVC.instantiateViewController(identifier: Control_Name.tTotalP) as! TotalParticipantVC
        vcontrol.height = 500
        vcontrol.topCornerRadius = 20
        vcontrol.presentDuration = 0.5
        vcontrol.dismissDuration = 0.5
        vcontrol.shouldDismissInteractivelty = true
        vcontrol.popupDismisAlphaVal = 0.4
        vcontrol.room = room
        vcontrol.roomID = roomID
        vcontrol.localVideoTrack = localVideoTrack
        vcontrol.camera = camera
        vcontrol.isChangeView = isChangeView
        vcontrol.callChannel = myChannel
        vcontrol.roomlocalParticipantSIDrule = roomlocalParticipantSIDrule
        vcontrol.conferrenceInfoArr = vdoCallVM.conferrenceDetail.CONFERENCEInfo
        
        vcontrol.conferenceStatusModel = clientStatusModel
        
        vcontrol.acceptAndRejectDelegate = self
        
        present(vcontrol, animated: true, completion: nil)
        
    }
    @IBAction func btnMoreTapped(_ sender: Any) {
        moreDropDown.show()
    }
    
    @IBAction func btnSpeakTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.audioDevice.block = {
            do {
                let audioSession = AVAudioSession.sharedInstance()
                if(!sender.isSelected) {
                    try audioSession.setMode(AVAudioSession.Mode.videoChat)
                } else {
                    try audioSession.setMode(AVAudioSession.Mode.voiceChat)
                }
                
            } catch {
                print("Fail: \(error.localizedDescription)")
            }
        }
        self.audioDevice.block()
    }
    
    @IBAction func btnCameraFlipTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        flipCamera()
    }
    
    //Join member
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, memberJoined member: TCHMember) {
        print("memberJoin:",channel.members)
    }
    public func join(with completion: TCHCompletion?) {
        print("memberJoin:2")
    }
    
    //================Twilio connect================
    
    func doConnectTwilio(twilioToken: String){
        prepareLocalMedia()
        let connectionOption = ConnectOptions.init(token: twilioToken) { builder in
            
            // builder.preferredVideoCodecs =   [TVIVideoCodec.H264.rawValue]
            //new added code
            builder.isNetworkQualityEnabled = true
            builder.networkQualityConfiguration =
            NetworkQualityConfiguration(localVerbosity: .minimal, remoteVerbosity: .minimal)
            builder.encodingParameters = EncodingParameters(audioBitrate:16, videoBitrate:0)
            // Enable recommended Collaboration mode Bandwidth Profile Options
            let videoBandwidthProfileOptions = VideoBandwidthProfileOptions { builder in
                builder.mode = .grid
                builder.dominantSpeakerPriority = .high
                
            }
            builder.bandwidthProfileOptions = BandwidthProfileOptions(videoOptions: videoBandwidthProfileOptions)
            builder.preferredVideoCodecs = [Vp8Codec(simulcast: true)]
            //end
            builder.isDominantSpeakerEnabled = true
            builder.roomName = self.roomID
            if let audioTrack = self.localAudioTrack {
                builder.audioTracks = [audioTrack]
            }
            if let videoTrack = self.localVideoTrack {
                builder.videoTracks = [videoTrack]
            }
        }
        self.room = TwilioVideoSDK.connect(options: connectionOption, delegate: self)
        
    }
    func prepareLocalMedia() {
        if (localAudioTrack == nil) {
            localAudioTrack = LocalAudioTrack()
            
            if (localAudioTrack == nil) {
                self.view.makeToast("Failed to create audio track")
            }
        }
        // Create a video track which captures from the camera.
        if (localVideoTrack == nil) {
            
            
            //preview.addGestureRecognizer(tap)
            self.startPreview(localView: preview)
        }
    }
    //====================END=============================
    @objc  func ringingCallStart(){
        CEnumClass.share.playSounds(audioName: "incoming")
        
    }
    
    // MARK:- Private
    func startPreview(localView: VideoView) {
        
        if PlatformUtils.isSimulator {
            return
        }
        let frontCamera = CameraSource.captureDevice(position: .front)
        let backCamera = CameraSource.captureDevice(position: .back)
        localAudioTrack = LocalAudioTrack()
        if (frontCamera != nil || backCamera != nil) {
            // Preview our local camera track in the local video preview view.
            camera = CameraSource(delegate: self)
            localVideoTrack = LocalVideoTrack(source: camera!, enabled: true, name: "Camera")
            
            // Add renderer to video track for local preview
            localVideoTrack!.addRenderer(localView)
            // logMessage(messageText: "Video track created")
            
            if (frontCamera != nil && backCamera != nil) {
                // We will flip camera on tap.
                let tap = UITapGestureRecognizer(target: self, action: #selector(VideoCallViewController.getFlipLocalView(gesture:)))
                localView.addGestureRecognizer(tap)
            }
            
            camera!.startCapture(device: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                if let error = error {
                    
                    
                } else {
                    
                    localView.shouldMirror = (captureDevice.position == .front)
                }
            }
        }
        else {
            self.view.makeToast("No front or back capture device found!")
            
        }}
    
    func remotePreview(remoteView:VideoView, remoteTracks:VideoTrack){
        remoteTracks.addRenderer(remoteView)
    }
    
    // MAKR: Flip Camera--
    var newDevice: AVCaptureDevice?
    @objc func flipCamera() {
        
        if let camera = self.camera, let captureDevice = camera.device {
            if captureDevice.position == .front {
                newDevice = CameraSource.captureDevice(position: .back)
            } else {
                newDevice = CameraSource.captureDevice(position: .front)
            }
            
            if let newDevice = newDevice {
                camera.selectCaptureDevice(newDevice) { (captureDevice, videoFormat, error) in
                    if let error = error {
                        self.view.makeToast("Error selecting capture device.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                        
                    } else {
                        if self.remoteParticipantArr.count > 1 {
                            self.speakerView.shouldMirror = (captureDevice.position == .front)
                        }
                        else{
                            self.preview.shouldMirror = (captureDevice.position == .front)
                        }
                        
                    }
                }
            }
        }
    }
    //MARK: GetFlip Changeview
    @objc func getFlipLocalView(gesture:UITapGestureRecognizer){
        
        isSwitchToRemote = !isSwitchToRemote
        fullFlashViewChangesMethod(isFlip:false)
    }
    func fullFlashViewChangesMethod(isFlip:Bool){
        if isFlip {
            if isSwitchToRemote {
                
                //speakerView.removeFromSuperview()
                btnPinLocal.isHidden = true
                btnMic.isHidden = false
                lblParticipantName.text = "You"
                btnSpeakerMic.isHidden = true
                let locTrack = localVideoTrack
                localVideoTrack?.removeRenderer(preview)
                localVideoTrack = locTrack
                let videoPublications2 = self.remoteParticipant!.remoteVideoTracks
                for publication in videoPublications2 {
                    if let subscribedVideoTrack = publication.remoteTrack,
                       publication.isTrackSubscribed {
                        subscribedVideoTrack.removeRenderer(speakerView)
                    }
                }
                let videoPublications = self.remoteParticipant!.remoteVideoTracks
                for publication in videoPublications {
                    if let subscribedVideoTrack = publication.remoteTrack,
                       publication.isTrackSubscribed {
                        subscribedVideoTrack.addRenderer(self.preview)
                    }
                }
                localVideoTrack!.addRenderer(speakerView)
                
            }
            else {
                
                lblParticipantName.text = remoteParticiapntName
                btnSpeakerMic.isHidden = false
                btnMic.isHidden = true
                btnPinLocal.isHidden = false
                let locTrack = localVideoTrack
                localVideoTrack?.removeRenderer(speakerView)
                localVideoTrack = locTrack
                let videoPublications2 = self.remoteParticipant!.remoteVideoTracks
                for publication in videoPublications2 {
                    if let subscribedVideoTrack = publication.remoteTrack,
                       publication.isTrackSubscribed {
                        subscribedVideoTrack.removeRenderer(preview)
                    }
                }
                
                let videoPublications = self.remoteParticipant!.remoteVideoTracks
                for publication in videoPublications {
                    if let subscribedVideoTrack = publication.remoteTrack,
                       publication.isTrackSubscribed {
                        
                        subscribedVideoTrack.addRenderer(speakerView)
                    }
                }
                if localVideoTrack != nil {
                    localVideoTrack!.addRenderer(preview)
                }
            }}
        else {
            previewOriginal.removeAllSubViews()
            speakerViewOriginal.removeAllSubViews()
            if isSwitchToRemote {
                
                btnPinLocal.isHidden = true
                btnMic.isHidden = false
                lblAudio.isHidden = true
                lblVideo.isHidden = true
                lblParticipantName.text = "You"
                btnSpeakerMic.isHidden = true
                self.preview = VideoView(frame: CGRect(x: 0, y: 0, width: 100, height: 110))
                preview.contentMode = .scaleAspectFill
                preview.layer.cornerRadius = 0
                preview.clipsToBounds = false
                self.previewOriginal.addSubview(self.preview)
                previewTapped(nView: self.preview)
                let videoPublications = self.remoteParticipant!.remoteVideoTracks
                for publication in videoPublications {
                    if let subscribedVideoTrack = publication.remoteTrack,
                       publication.isTrackSubscribed {
                        subscribedVideoTrack.addRenderer(self.preview)
                    }
                }
                let audioPublications = remoteParticipant!.audioTracks
                for audioPub in audioPublications {
                    
                    if let audio = audioPub.audioTrack {
                        audio.isEnabled == true ? (btnMic.isSelected = false) : (btnMic.isSelected = true)
                    }
                }
                self.speakerView = VideoView(frame: CGRect(x: 0, y: 0, width:  self.view.bounds.width, height: self.view.bounds.height))
                self.speakerView.contentMode = .scaleAspectFill
                self.speakerView.layer.cornerRadius = 0
                self.speakerView.clipsToBounds = false
                self.speakerViewOriginal.addSubview(self.speakerView)
                localVideoTrack!.addRenderer(self.speakerView)
                self.speakerView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(VideoCallViewController.handlerTopbottom(gesture:)))
                self.speakerView.addGestureRecognizer(tap)
            }
            
            else {
                print("localParticiapant------------>2:",localVideoTrack)
                // add remote particiapnts name and host
                for pObj in  self.vdoCallVM.conferrenceDetail.CONFERENCEInfo! {
                    let obj = pObj as! ConferenceInfoModels
                    if obj.PARTSID == remoteParticipant?.sid {
                        DispatchQueue.main.async {
                            self.lblParticipantName.text = obj.UserName
                            self.configureHost(obj: obj)
                        }
                        
                    }
                }
                let audioPublications = remoteParticipant!.audioTracks
                for audioPub in audioPublications {
                    
                    if let audio = audioPub.audioTrack {
                        audio.isEnabled == true ? (btnSpeakerMic.isSelected = false) : (btnSpeakerMic.isSelected = true)
                    }
                    
                }
                btnSpeakerMic.isHidden = false
                btnMic.isHidden = true
                btnPinLocal.isHidden = false
                self.preview = VideoView(frame: CGRect(x: 0, y: 0, width: 100, height: 110))
                preview.contentMode = .scaleAspectFill
                preview.layer.cornerRadius = 0
                preview.clipsToBounds = false
                self.previewOriginal.addSubview(self.preview)
                previewTapped(nView: self.preview)
                self.speakerView = VideoView(frame: CGRect(x: 0, y: 0, width:  self.view.bounds.width, height: self.view.bounds.height))
                self.speakerView.contentMode = .scaleAspectFill
                self.speakerView.layer.cornerRadius = 0
                self.speakerView.clipsToBounds = false
                self.speakerViewOriginal.addSubview(self.speakerView)
                
                let videoPublications = self.remoteParticipant!.remoteVideoTracks
                for publication in videoPublications {
                    if let subscribedVideoTrack = publication.remoteTrack,
                       publication.isTrackSubscribed {
                        subscribedVideoTrack.addRenderer(speakerView)
                    }
                }
                if localVideoTrack != nil {
                    localVideoTrack!.addRenderer(preview)
                }
                self.speakerView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(VideoCallViewController.handlerTopbottom(gesture:)))
                self.speakerView.addGestureRecognizer(tap)
            }
        }}
    public func previewTapped(nView:VideoView){
        let tap = UITapGestureRecognizer(target: self, action: #selector(VideoCallViewController.getFlipLocalView(gesture:)))
        nView.addGestureRecognizer(tap)
    }
    
    
    //MARK: Remote Participant add
    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
        print("renderParticipant Call:")
        ringingView(ishide: false)
        timer.invalidate()
        //  ringToneTimer.invalidate()
        if myAudio != nil{
            myAudio!.stop()
        }
        
        let videoPublications = participant.remoteVideoTracks
        for publication in videoPublications {
            self.remoteParticipant = participant
            if let subscribedVideoTrack = publication.remoteTrack,
               publication.isTrackSubscribed {
                
                subscribedVideoTrack.addRenderer(self.speakerView)
                
                return true
            }
        }
        
        lblTotalParticipant.text = "\(remoteParticipantArr.count)"
        print("totalparticipants-6--->",remoteParticipantArr.count)
        
        return false
    }
    
    func renderRemoteParticipants(participants : Array<RemoteParticipant>) {
        for participant in participants {
            // Find the first renderable track.
            if participant.remoteVideoTracks.count > 0,
               renderRemoteParticipant(participant: participant) {
                break
            }
        }
    }
    
    func cleanupRemoteParticipant() {
        if self.remoteParticipant != nil {
            self.remoteView?.removeFromSuperview()
            //  self.remoteView = nil
            self.remoteParticipant = nil
        }
    }
    func cleanRemoteParticipants(){
        if self.remoteParticipant != nil {
            self.speakerView.removeFromSuperview()
            //  self.speakerView = nil
            self.remoteParticipant = nil
        }
    }
    func holdCall(onHold: Bool) {
        localAudioTrack?.isEnabled = !onHold
        localVideoTrack?.isEnabled = !onHold
    }
    
    //MARK: Record Timer
    @objc func recordTimer(){
        
        seconds += 1
        lblTimeSpeak.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    //MARK: Chat Implementations
    //<************Chat Implementation start******************>//
    func getChatConfig(){
        // showAnimatingDotsInImageView()
        typingView.isHidden = true
        mszReplyContainerHeight.constant = 0.0
        txtMessage.text = "Type a message here.."
        txtMessage.inputAccessoryView = UIView()
        imagePicker.delegate = self
        self.tblView.register(UINib(nibName: NibChatNames.replyImg, bundle: nil), forCellReuseIdentifier: chatDetailIndentifier.imgReplyCell.rawValue)
        
        self.tblView.register(UINib(nibName: NibChatNames.chat, bundle: nil), forCellReuseIdentifier: chatDetailIndentifier.txtCell.rawValue)
        
        self.tblView.register(UINib(nibName: NibChatNames.replyChatTxt, bundle: nil), forCellReuseIdentifier: chatDetailIndentifier.txtReplyCell.rawValue)
        
        self.tblView.register(UINib(nibName: NibChatNames.chatImg, bundle: nil), forCellReuseIdentifier: chatDetailIndentifier.imgCell.rawValue)
        self.tblView.register(UINib(nibName: NibChatNames.audio, bundle: nil), forCellReuseIdentifier: chatDetailIndentifier.audioCell.rawValue)
        self.tblView.register(UINib(nibName: NibChatNames.replyAudio, bundle: nil), forCellReuseIdentifier: chatDetailIndentifier.audioReplyCell.rawValue)
        addKeyBoardListener()
        txtMessage.delegate = self
        txtMessage.returnKeyType = UIReturnKeyType.done
        tblView.tableFooterView = UIView(frame: .zero)
        tblView.rowHeight = UITableView.automaticDimension
        tblView.separatorStyle = .none
        tblPrivateView.tableFooterView = UIView(frame: .zero)
        tblPrivateView.rowHeight = UITableView.automaticDimension
        tblPrivateView.separatorStyle = .none
    }
    
    @IBAction func btnSendMszTapped(_ sender: Any) {
        
        //@Test #Narendra2##hi#/ProfileImages/Profiles/2022-Mar-30-0313541648624430629.png#SneakyBobbySaintPaul
        let trimmed = txtMessage.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty && trimmed != "Type a message here.."{
            mszCounts = mszCounts + 1
            
            var mszReq = chatDetails.share.getchatTextReq(msz: txtMessage.text!, mszCount: mszCounts, replyID: replyId!)
            var privateMSz = ""
            for pChat in privateChatArr {
                privateMSz = privateMSz + "@\(pChat)"
                print("pchat--->",pChat)
                mszReq = "@\(pChat)" + mszReq
            }
            let finalMsz = "\(userDefaults.string(forKey: "firstName") ?? ""):" + mszReq
            print("message body->", mszReq,"finalMsz--",finalMsz)
            var data = RowData.init()
            if replyId != "" {
                data.rowType = .txtReply
                data.cellIdentifier = .txtReplyCell
            }
            else {
                data.rowType = .txt
                data.cellIdentifier = .txtCell
            }
            
            data.privatechatUser = privateMSz
            data.replyMszID = replyId
            data.mszID = "\(userDefaults.string(forKey: "firstName") ?? "")\(userDefaults.string(forKey: "firstName") ?? "")\(mszCounts)"
            data.sender = 0
            data.txt =  self.txtMessage.text
            let pImage = ((userDefaults.string(forKey: "ImageData") != "" ) && (userDefaults.string(forKey: "ImageData") != nil)) ? (userDefaults.string(forKey: "ImageData")) : "/images/noprofile.jpg"
            data.profileImg = pImage
            data.name = "\(userDefaults.string(forKey: "firstName") ?? "")"
            data.time = CEnumClass.share.createDateAndTimeChat()
            self.chatListArr.append(data)
            self.tblView.reloadData()
            self.view.layoutIfNeeded()
            self.tblView.scrollToBottomRow()
            self.txtMessage.text = ""
            self.replyId = ""
            lblNameReplyUser.text = ""
            lblReplyMsz.text = ""
            mszReplyContainerHeight.constant = 0.0
            let mszOption = TCHMessageOptions.init()
            mszOption.withBody(finalMsz)
            self.myChannel?.messages?.sendMessage(with: mszOption, completion: { chResult, chMessage in
                if chResult.isSuccessful() {
                }
            })
        }
        else {
            self.view.makeToast(ConstantStr.msz.val)
        }
    }
    
    @IBAction func btnCloseReplyTapped(_ sender: Any) {
        lblNameReplyUser.text = ""
        lblReplyMsz.text = ""
        mszReplyContainerHeight.constant = 0.0
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
    //end chats code
}

// MARK:- CameraSourceDelegate
extension VideoCallViewController : CameraSourceDelegate {
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        print("camera source failed")
        self.view.makeToast("Camera source failed with error: \(error.localizedDescription)")
        
    }
}

class MoreCell: DropDownCell {
    @IBOutlet weak var logoImageView: UIImageView!
}

