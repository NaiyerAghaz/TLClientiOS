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


class VideoCallViewController: UIViewController, LocalParticipantDelegate, TCHChannelDelegate,TwilioChatClientDelegate,AcceptAndRejectDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    // Video SDK components
    /**
     * We will create an audio device and manage it's lifecycle in response to CallKit events.
     */
    
    
    @IBOutlet weak var lblParticipantTalking: UILabel!
    @IBOutlet weak var lblTotalParticipant: UILabel!
    @IBOutlet weak var userRemoteView: UIView!
    var audioDevice = DefaultAudioDevice()
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var room: Room?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    var localParticipant : LocalParticipant?
    var remoteView : VideoView?
    var callChannel : TCHChannel?
    var seconds = 0
    var recordTime = Timer()
    // CallKit components
    let callKitProvider: CXProvider? = nil
    let callKitCallController: CXCallController? = nil
    //var callKitCompletionHandler: ((Bool)->Swift.Void?)? = nil
    var userInitiatedDisconnect: Bool = false
    var ifComeFromMeet = false
    var ifTimereach = false
    var roomID,sourceLangID,targetLangID,sourceLangName,targetLangName,patientname,patientno: String?
    var roomlocalParticipantSIDrule: String?
    var isClientDetails,isScheduled : Bool?
    var twilioToken : String?
    var vdoCallVM = VDOCallViewModel()
    var timer = Timer()
    var ringToneTimer = Timer()
    var ringingTime = 46
    var localParicipantDictionary: NSMutableDictionary?
    var remoteParicipantDictionary: NSMutableDictionary?
    var remoteParticipantArr = [RemoteParticipant]()
    @IBOutlet weak var btnSpeak: UIButton!
    @IBOutlet weak var btnCameraFlip: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var preview: VideoView!
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
    //More dropdown
    //dragged view
    var panGesture       = UIPanGestureRecognizer()
    @IBOutlet weak var mainPreview: UIView!
    let imageView = UIImageView()
    var lblParticipantSearching = UILabel()
    //end--
    let moreDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.moreDropDown
        ]
    }()
    var lView = VideoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainPreview.frame = CGRect(x: self.view.frame.size.width - 140, y: 60, width: 160, height: 160)
        preview.frame = CGRect(x: 30, y: 25, width: 100, height: 110)
        mainPreview.addSubview(preview)
        imgLocalPrivacy.frame = CGRect(x: 30, y: 25, width: 100, height: 110)
        mainPreview.addSubview(imgLocalPrivacy)
        
        NotificationCenter.default.addObserver(self, selector: #selector(participantNotAvailable(noti:)), name: Notification.Name("notAvailableParticipant"), object: nil)
        if ifComeFromMeet {
            if ifTimereach {
                // start call here
                self.topView.isHidden = false
                
                configure()
                isMeetingCall = true
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
            isMeetingCall = true
            vdoCollectionView.isHidden = true
            self.vdoCollectionView.delegate = self
            self.vdoCollectionView.dataSource = self
            
            self.vdoCollectionView.bounces = false
            genarateChatTokenCreate()
        }
        
    }
    
    //MARK: Configure With Twilio
    
    
    func configure(){
        self.mainPreview.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handler)))
        mainPreview.isUserInteractionEnabled = true
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
   
  
    @objc func handler(gesture: UIPanGestureRecognizer){
        isTapGesture = true
        topView.isHidden = true
        bottomView.isHidden = true
        let location = gesture.location(in: self.view)
        let draggedView = gesture.view
        draggedView?.center = location
       
        if gesture.state == .ended {
            print("location--",location.x, location.y)
            print("location.y:",location.y, "location.x")
            if self.mainPreview.frame.midX >= self.view.layer.frame.width / 2 {
                print("01------",self.mainPreview.frame.midX,self.view.layer.frame.width)
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
                print("02------",self.mainPreview.frame.midX,self.view.layer.frame.width)
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
func ringingView(ishide: Bool){
        mainPreview.isHidden = ishide
        preview.contentMode = .scaleToFill
        preview.clipsToBounds = true
        preview.isHidden = ishide
        muteView.isHidden = ishide
        stopVideoView.isHidden = ishide
        participantView.isHidden = ishide
        moreView.isHidden = ishide
        if ishide == true {
            //myAudio.stop()
            //timer.invalidate()
            lblParticipant.frame = CGRect(x: 0, y: 0, width: topView.frame.size.width, height: topView.frame.size.height)
            lblParticipant.text = "Connecting To Interpreters..."
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
            self.topView.backgroundColor = UIColor.black
                .withAlphaComponent(0.7)
            self.bottomView.backgroundColor = UIColor.black
                .withAlphaComponent(0.7)
            vdoCollectionView.isHidden = ishide
            lblParticipant.removeFromSuperview()
            callingImageView.removeFromSuperview()
        }
    }
    
    //MARK: More Dropdown
    
    func setupChooseDropDown() {
        moreDropDown.anchorView = btnMore
        moreDropDown.topOffset = CGPoint(x: 0, y: btnMore.bounds.height - 90)
        
        moreDropDown.dataSource = [
            "Chat",
            "Change View",
            "Pin Video",
            "Meeting Settings"
        ]
        
        moreDropDown.selectionAction = { (index, item) in
            print("Index seletected more:", index, item)
            if index == 0 {
                print(item)
            }else if index == 1{
                print(item)
            }else if index == 2 {
                print(item)
            }else if index == 3 {
                print(item)
            }
            
        }
    }
    func customizeDropDown() {
        let appearance = DropDown.appearance()
        appearance.direction = .top
        // appearance.backgroundColor = UIColor.black
        appearance.cellHeight = 60
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
            else {
                print("genarateChatTokenCreate-------------->")
            }
        }
    }
    
    func newChannelPrivateCreate(){
        
        var channelList = TCHChannels()
        channelList = (chatManager.client?.channelsList())!
        print("roomID------------>", self.roomID)
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
            else {
                print("genarateChatTokenCreate-------------->")
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
                    print("channel------\(self.channels?.count)------>:friendlyName:\(channel?.friendlyName), roomID:\(self.roomID):")
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
                }
            }
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
        UIAlertController.showAlert(title: "", message: "Participants are waiting in this Lobby", style: .alert, cancelButton: "View Lobby", otherButtons: nil) { [self] index, _ in
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
            print("meeting----------------------->:", success, "result:", result?.ROOMNO)
            
        }
    }
    //MARK: Refresh accept the participant
    func refresh(isaccept: Bool, pid: String) {
        if isaccept{
            let bodyMsz = "acceptfromclient:\(pid)"
            print("acceptmessagebody-------------------------->:",bodyMsz)
            // self.dismiss(animated: true, completion: nil)
            let messageOption = TCHMessageOptions.init()
            messageOption.withBody(bodyMsz)
            self.myChannel?.messages?.sendMessage(with: messageOption, completion: { result, message in
                if result.isSuccessful(){
                    print("result.isSuccessful()------------------>:",result.isSuccessful())
                    self.getMeetingClientStatusLobbyRefreshAccept(roomId: self.roomID!)
                }
            })
        }
        else {
            let bodyMsz = "rejectfromclient:\(pid)"
            print("acceptmessagebody-------------------------->:",bodyMsz)
            // self.dismiss(animated: true, completion: nil)
            let messageOption = TCHMessageOptions.init()
            messageOption.withBody(bodyMsz)
            self.myChannel?.messages?.sendMessage(with: messageOption, completion: { result, message in
                if result.isSuccessful(){
                    print("result.isSuccessful()------------------>:",result.isSuccessful())
                    self.getMeetingClientStatusLobbyRefreshAccept(roomId: self.roomID!)
                }
                
            })
        }
        
    }
    func getHostControl(obj: ConferenceInfoResultModel) {
        
        vdoCallVM.conferrenceDetail = obj
        DispatchQueue.main.async {
            self.vdoCollectionView.reloadData()
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
    
    @IBAction func btnMicTapped(_ sender: Any) {
        if (localAudioTrack != nil){
            localAudioTrack?.isEnabled = !localAudioTrack!.isEnabled
            btnMic.isSelected = !btnMic.isSelected
        }
        
    }
    @IBAction func btnStopVideoTapped(_ sender: Any) {
        
        if localVideoTrack != nil {
            localVideoTrack?.isEnabled = !localVideoTrack!.isEnabled
            btnStopVideo.isSelected = !btnStopVideo.isSelected
            
            btnCameraFlip.isEnabled = !btnCameraFlip.isEnabled
            if remoteParticipantArr.count > 1 {
                DispatchQueue.main.async {
                    self.vdoCollectionView.reloadData()
                }
                
                
            }
            else {
                vdoCallVM.videoTrackEnableOrDisable(isenable: localVideoTrack!.isEnabled, img: imgLocalPrivacy)
            }
        }}
    @IBAction func btnEndCallTapped(_ sender: Any) {
        UIAlertController.showAlert(title: "", message: "Are you sure you want to hangup this call?", style: .alert, cancelButton: "Delete", distrutiveButton: "End Call", otherButtons: nil) { [self] index, _ in
            if index == 0 {
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
                    if remoteParticipantArr.count > 0 {
                        vdoCallVM.customerEndCallWithoutConnect(roomID: roomID ?? "") { success, err in
                            if success! {
                                DispatchQueue.main.async {
                                    self.updateYourFeedback()
                                }
                                
                            }
                            self.view.makeToast("Please try again to hangup this call")
                        }
                        
                    }
                    else {
                        vdoCallVM.customerEndCallWithoutConnect(roomID: roomID ?? "") { success, err in
                            if success! {
                                DispatchQueue.main.async {
                                    self.dismissViewControllers()
                                }
                                
                            }
                            self.view.makeToast("Please try again to hangup this call")
                        }
                        
                    }
                    
                }
            }}}
    
    //MARK: Feedback Method call:
    public func updateYourFeedback(){
        recordTime.invalidate()
        let sB = UIStoryboard(name: Storyboard_name.home, bundle: nil)
        let fb = sB.instantiateViewController(identifier: "VRIOPIFeedbackController") as! VRIOPIFeedbackController
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
        let vcontrol = callVC.instantiateViewController(identifier: "TotalParticipantVC") as! TotalParticipantVC
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
            
            
            self.startPreview(localView: preview)
        }
    }
    //====================END=============================
    @objc  func ringingCallStart(){
        
        ringingTime -= 2
        if ringingTime <= 0 {
            myAudio!.stop()
            timer.invalidate()
            if (self.camera != nil){
                camera?.stopCapture()
                camera = nil
            }
            dismissViewControllers()
            
        }
        else {
            CEnumClass.share.playSounds(audioName: "incoming")
        }
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
                let tap = UITapGestureRecognizer(target: self, action: #selector(VideoCallViewController.flipCamera))
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
            
        }
        
    }
    // MAKR: Flip Camera--
    @objc func flipCamera() {
        var newDevice: AVCaptureDevice?
        
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
                            self.lView.shouldMirror = (captureDevice.position == .front)
                        }
                        else{
                            self.preview.shouldMirror = (captureDevice.position == .front)
                        }
                        
                    }
                }
            }
        }
    }
    
    //MARK: Collectionview Delegate and Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if remoteParticipantArr.count > 1 {
            
            return remoteParticipantArr.count + 1
        }
        else {
            return remoteParticipantArr.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = vdoCollectionView.dequeueReusableCell(withReuseIdentifier: cellIndentifier.VDOCollectionViewCell.rawValue, for: indexPath) as!  VDOCollectionViewCell
        cell.remoteView?.contentMode = .scaleAspectFill
        cell.remoteView.layer.cornerRadius = 0
        cell.remoteView.clipsToBounds = false
        cell.remoteView.frame.size.width = vdoCollectionView.bounds.width
        cell.remoteView.frame.size.height = vdoCollectionView.bounds.height
        
        if remoteParticipantArr.count > 1 {
            if indexPath.row == 0 {
                
                cell.btnMic.isHidden = true
                preview.isHidden = true
                mainPreview.isHidden = true
                isAttendMultiPart = true
                self.lView = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                self.lView.contentMode = .scaleAspectFill
                self.lView.clipsToBounds = false
                localVideoTrack!.addRenderer(lView)
                vdoCallVM.videoTrackEnableOrDisable(isenable: localVideoTrack!.isEnabled, img: cell.imgRemotePrivacy)
                cell.audioLbl.isHidden = true
                cell.lblVideo.isHidden = true
                cell.isSpeakingLbl.isHidden = true
                cell.participantName.isHidden = true
                cell.remoteView.addSubview(lView)
                
                return cell
            }
            else {
                if  indexPath.row > 0 {
                    cell.btnMic.isHidden = false
                    
                    let videoPublications = remoteParticipantArr[indexPath.row - 1].remoteVideoTracks
                    let obj = self.vdoCallVM.conferrenceDetail.CONFERENCEInfo![indexPath.row - 1] as! ConferenceInfoModels
                    let objSID = remoteParticipantArr[indexPath.row - 1].sid
                    for publication in videoPublications {
                        print("vdoTrackSid:", publication.trackSid, publication.trackName)
                        if let subscribedVideoTrack = publication.remoteTrack,
                           publication.isTrackSubscribed {
                            print("vdosubscribedVideoTrack2-------------->:", subscribedVideoTrack.sid)
                            if subscribedVideoTrack.isEnabled {
                                cell.imgRemotePrivacy.isHidden = true
                                let remote = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                                remote.contentMode = .scaleAspectFill
                                remote.clipsToBounds = false
                                
                                subscribedVideoTrack.addRenderer(remote)
                                cell.remoteView.addSubview(remote)
                            }
                            else {
                                vdoCallVM.videoTrackEnableOrDisable(isenable: false, img: cell.imgRemotePrivacy)
                                let remote = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                                remote.backgroundColor = UIColor.black
                                remote.contentMode = .scaleAspectFill
                                remote.clipsToBounds = false
                                cell.remoteView.addSubview(remote)
                            }
                            
                        }}
                    let audioPublications = remoteParticipantArr[indexPath.row - 1].audioTracks
                    for audioPub in audioPublications {
                        print("audioTrackSid:", audioPub.trackSid, audioPub.trackName)
                        if let audio = audioPub.audioTrack {
                            audio.isEnabled == true ? (cell.btnMic.isSelected = false) : (cell.btnMic.isSelected = true)
                        }
                        
                    }
                    if vdoCallVM.conferrenceDetail.CONFERENCEInfo?.count ?? 0 > 0 {
                        let pSID = remoteParticipantArr[indexPath.row - 1].sid
                        
                        for pObj in  self.vdoCallVM.conferrenceDetail.CONFERENCEInfo! {
                            let participantSID = pObj as! ConferenceInfoModels
                            if participantSID.PARTSID == pSID {
                                cell.participantName.isHidden = false
                                
                                
                                cell.participantName.text = participantSID.UserName
                                cell.configure(obj: participantSID)
                                
                            }
                        }
                    }
                    if objSID == currentSpeakerParticipant?.sid{
                        
                        cell.isSpeakingLbl.isHidden = false
                    }
                    else {
                        cell.isSpeakingLbl.isHidden = true
                        
                    }
                    return cell
                }
            }}
        else {
            let videoPublications = remoteParticipantArr[indexPath.row].remoteVideoTracks
            let pSID = remoteParticipantArr[indexPath.row].sid
            print("vdosubscribedVideoTrack01-------------->:", pSID)
            if isAttendMultiPart {
                if (localAudioTrack == nil) {
                    localAudioTrack = LocalAudioTrack()
                    if (localAudioTrack == nil) {
                        self.view.makeToast("Failed to create audio track")
                    }
                }
                self.preview.isHidden = false
                self.mainPreview.isHidden = false
                cell.btnMic.isHidden = false
            }
            for publication in videoPublications {
                print("vdoTrackSid2:", publication.trackSid, publication.trackName)
                if let subscribedVideoTrack = publication.remoteTrack,
                   publication.isTrackSubscribed {
                    print("vdosubscribedVideoTrack1-------------->:", subscribedVideoTrack.sid)
                    if subscribedVideoTrack.isEnabled {
                        vdoCallVM.videoTrackEnableOrDisable(isenable: subscribedVideoTrack.isEnabled, img: cell.imgRemotePrivacy)
                        let remote = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                        remote.contentMode = .scaleAspectFill
                        remote.clipsToBounds = false
                        subscribedVideoTrack.addRenderer(remote)
                        
                        cell.remoteView.addSubview(remote)
                    }
                    else {
                        vdoCallVM.videoTrackEnableOrDisable(isenable: false, img: cell.imgRemotePrivacy)
                        let remote = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                        remote.backgroundColor = UIColor.black
                        remote.contentMode = .scaleAspectFill
                        remote.clipsToBounds = false
                        // cell.audioLbl.isHidden = true
                        //cell.lblVideo.isHidden = true
                        // cell.participantName.isHidden = true
                        cell.remoteView.addSubview(remote)
                    }
                }}
            
            let audioPublications = remoteParticipantArr[indexPath.row].audioTracks
            for audioPub in audioPublications {
                print("audioTrackSid2:", audioPub.trackSid, audioPub.trackName)
                if let audio = audioPub.audioTrack {
                    audio.isEnabled == true ? (cell.btnMic.isSelected = false) : (cell.btnMic.isSelected = true)
                }
                if (audioPub.trackSid == currentSpeakerParticipant?.sid) && audioPub.audioTrack?.isEnabled == true{
                    
                    cell.isSpeakingLbl.isHidden = false
                }
                else {
                    cell.isSpeakingLbl.isHidden = true
                    
                }
            }
            if vdoCallVM.conferrenceDetail.CONFERENCEInfo?.count ?? 0 > 0 {
                let obj = self.vdoCallVM.conferrenceDetail.CONFERENCEInfo![indexPath.row] as! ConferenceInfoModels
               
                if pSID == obj.PARTSID {
                    cell.participantName.isHidden = false
                    cell.participantName.text = "\(obj.UserName!)"
                    cell.configure(obj: obj)
                }
                
            }
            if pSID == currentSpeakerParticipant?.sid{
                
                cell.isSpeakingLbl.isHidden = false
            }
            else {
                cell.isSpeakingLbl.isHidden = true
                
            }
            
            
            return cell
            
        }
        
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == vdoCollectionView {
            if self.remoteParticipantArr.count == 1 {
                return CGSize(width: vdoCollectionView.frame.size.width, height: vdoCollectionView.frame.size.height)
            }
            else if self.remoteParticipantArr.count == 2 {
                if indexPath.row == 0 {
                    return CGSize(width: vdoCollectionView.frame.size.width, height: (vdoCollectionView.frame.size.height/2) - 10)
                    
                }
                else {
                   
                    return CGSize(width: (self.vdoCollectionView.frame.size.width/2) - 10, height: (self.vdoCollectionView.frame.size.height/2) - 10)
                }
            }
            else if self.remoteParticipantArr.count == 3 {
                
                return CGSize(width: vdoCollectionView.frame.size.width/2-10, height: vdoCollectionView.frame.size.height/2-10)
            }
            else if self.remoteParticipantArr.count == 4 {
                if indexPath.row == 3 {
                    return CGSize(width: vdoCollectionView.frame.size.width, height: vdoCollectionView.frame.size.height/3-6)
                }
                else {
                    
                    return CGSize(width: vdoCollectionView.frame.size.width/2-6, height: vdoCollectionView.frame.size.height/3-6)
                }
            }
            else if self.remoteParticipantArr.count == 5 {
                return CGSize(width: vdoCollectionView.frame.size.width/2-6, height: vdoCollectionView.frame.size.height/3-6)
            }
            else if self.remoteParticipantArr.count == 6 {
                
                if indexPath.row == 5 {
                    return CGSize(width: vdoCollectionView.frame.size.width/3-6, height: vdoCollectionView.frame.size.height/3-6)
                }
                return CGSize(width: vdoCollectionView.frame.size.width/2-6, height: vdoCollectionView.frame.size.height/3-6)
                
            }
            else if self.remoteParticipantArr.count == 7 {
                if indexPath.row == 6 {
                    return CGSize(width: vdoCollectionView.frame.size.width/3-5, height: vdoCollectionView.frame.size.height/3-5)
                }
                
                return CGSize(width: vdoCollectionView.frame.size.width/2-5, height: vdoCollectionView.frame.size.height/3-5)
            }
            else if self.remoteParticipantArr.count == 8 {
                return CGSize(width: vdoCollectionView.frame.size.width/3-5, height: vdoCollectionView.frame.size.height/3-5)
            }
            return CGSize(width: vdoCollectionView.frame.size.width/2 - 5, height: vdoCollectionView.frame.size.height/2-5)
            
        }
        else {
            return CGSize(width: 370, height: 490)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if bottomView.isHidden != true && topView.isHidden != true {
            bottomView.isHidden = true
            topView.isHidden = true
        }
        else {
            bottomView.isHidden = false
            topView.isHidden = false
//            if isTapGesture {
//                print("originX11->",self.mainPreview.frame.origin.x,"originY11:",self.mainPreview.frame.origin.y)
//            }
        // print("originX11->",self.mainPreview.frame.origin.x,"originY11:",self.mainPreview.frame.origin.y)
//            if self.mainPreview.frame.midX >= self.view.layer.frame.width / 2 {
//                
//            }
//            
//            else{
//                
//                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
//                    print("originX->",self.mainPreview.frame.origin.x,"originY:",self.mainPreview.frame.origin.y)
////                    self.mainPreview.center.x = 60
////                    if location.y < 20 {
////                        self.mainPreview.center.y = 60
////                    }
////                    else if location.y > self.view.frame.size.height - 20 {
////                        self.mainPreview.center.y = self.view.frame.size.height - 60
////                    }
//                    // self.mainPreview.center.y = 40
//                }, completion: nil)
//            }
        }
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
        
        lblTotalParticipant.text = "\(remoteParticipantArr.count)"
        
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
            self.remoteView = nil
            self.remoteParticipant = nil
        }
    }
    func holdCall(onHold: Bool) {
        localAudioTrack?.isEnabled = !onHold
        localVideoTrack?.isEnabled = !onHold
    }
    //Mark: setupRemoteVideoView
    func setupRemoteVideoView() {
        self.remoteView = VideoView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        remoteView?.contentMode = UIView.ContentMode.scaleAspectFill
        remoteView?.clipsToBounds = false
        self.userRemoteView.insertSubview(self.remoteView!, at: 0)
        
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

