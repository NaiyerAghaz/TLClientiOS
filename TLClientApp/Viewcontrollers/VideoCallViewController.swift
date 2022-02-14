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



class VideoCallViewController: UIViewController, LocalParticipantDelegate, TCHChannelDelegate,TwilioChatClientDelegate,AcceptAndRejectDelegate {
    
    
    
    // Video SDK components
    /**
     * We will create an audio device and manage it's lifecycle in response to CallKit events.
     */
    @IBOutlet weak var lblTotalParticipant: UILabel!
    @IBOutlet weak var userRemoteView: UIView!
    var audioDevice: DefaultAudioDevice = DefaultAudioDevice()
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
    var callKitCompletionHandler: ((Bool)->Swift.Void?)? = nil
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
    var ringingTime = 60
    var localParicipantDictionary: NSMutableDictionary?
    var remoteParicipantDictionary: NSMutableDictionary?
    var remoteParticipantArr = [RemoteParticipant]()
    
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var preview: VideoView!
    
    @IBOutlet weak var muteView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var stopVideoView: UIView!
    
    @IBOutlet weak var vdoCollectionView: UICollectionView!
    @IBOutlet weak var participantView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var moreView: UIView!
    var vendorTbl : UITableView = UITableView()
    
    
    @IBOutlet weak var imgLocalPrivacy: UIImageView!
    var lblParticipant = UILabel()
    var callingImageView = UIImageView()
    var isShownParti = false
    var chatManager = ChatManager()
    var isMeetingCall = false
    var clientStatusModel: ClientStatusModel?
    var isAttendMultiPart = false
    //More dropdown
    let moreDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.moreDropDown
        ]
    }()
    var lView = VideoView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // print("roomID------------>2:", self.roomID)
        // Do any additional setup after loading the view.
    }
    
    //MARK: Configure With Twilio
    
    
    func configure(){
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
        // CEnumClass.share.playSounds(audioName: "incoming")
        self.ringToneTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { timer in
            DispatchQueue.main.async {
                CEnumClass.share.playSounds(audioName: "incoming")
            }
            
        })
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.ringingCallStart), userInfo: nil, repeats: true)
        }
        vendorTbl.frame = CGRect(x: 0, y: 55, width: self.view.bounds.size.width, height: 200)
        vendorTbl.backgroundColor = UIColor.clear
        vendorTbl.separatorStyle = .none
        vendorTbl.layoutSubviews()
        vendorTbl.tableFooterView = UIView(frame: .zero)
        let cellNib = UINib(nibName: "VendorTVCell", bundle: nil)
        vendorTbl.register(cellNib, forCellReuseIdentifier: cellIndentifier.vendorTVCell.rawValue)
        
    }
    
    func ringingView(ishide: Bool){
        
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
        
        // Action triggered on selection
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
            // self?.chooseButton.setTitle(item, for: .normal)
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
                guard let cell = cell as? MoreCell else { return }
                
                // Setup your custom UI components
                cell.logoImageView.image = UIImage(named: "ic_more\(index % 10)")
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
    var isChatCreated = false
    var isChatConnected  = false
    var myChannel : TCHChannel?
    var client : TwilioChatClient?
    var channels :NSMutableOrderedSet?
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
    }
    func getMeetingClientStatusLobbyRefreshAccept(roomId: String){
        let req = vdoCallVM.meetingClientReq(roomID: roomId)
        vdoCallVM.getMeetingClientStatusLobbyWithCompletion(parameter: req) { success, result in
            if success  == true{
                print("result?.INVITEDATA2----->",result?.INVITEDATA2)
                if result?.INVITEDATA2 == "0"{
                    self.clientStatusModel = nil
                }
            }
        }}
    // MARK:TwilioChatClientDelegate
    //MARK: Actions and Outlet
    
    @IBOutlet weak var btnMic: UIButton!
    @IBAction func btnMicTapped(_ sender: Any) {
        if (localAudioTrack != nil){
            localAudioTrack?.isEnabled = !localAudioTrack!.isEnabled
            btnMic.isSelected = !btnMic.isSelected
        }
        
    }
    
    @IBOutlet weak var btnStopVideo: UIButton!
    @IBAction func btnStopVideoTapped(_ sender: Any) {
        
        if localVideoTrack != nil {
            localVideoTrack?.isEnabled = !localVideoTrack!.isEnabled
            btnStopVideo.isSelected = !btnStopVideo.isSelected
            
            btnCameraFlip.isEnabled = !btnCameraFlip.isEnabled
            if remoteParticipantArr.count > 1 {
                
                self.vdoCollectionView.reloadData()
            }
            else {
                vdoCallVM.videoTrackEnableOrDisable(isenable: localVideoTrack!.isEnabled, img: imgLocalPrivacy)
            }
        }}
    @IBAction func btnEndCallTapped(_ sender: Any) {
        UIAlertController.showAlert(title: "", message: "Are you sure you want to hangup this call?", style: .alert, cancelButton: "Delete", distrutiveButton: "End Call", otherButtons: nil) { [self] index, _ in
            if index == 0 {
                timer.invalidate()
                ringToneTimer.invalidate()
                if myAudio != nil{
                    myAudio.stop()
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
                    self.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: nil)
                }
            }}}
    
    
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
        vcontrol.callChannel = callChannel
        vcontrol.roomlocalParticipantSIDrule = roomlocalParticipantSIDrule
        vcontrol.conferrenceInfoArr = vdoCallVM.conferrenceDetail.CONFERENCEInfo
        // if clientStatusModel != nil {
        vcontrol.conferenceStatusModel = clientStatusModel
        // }
        vcontrol.acceptAndRejectDelegate = self
        // vcontrol.popupDelegate = self
        present(vcontrol, animated: true, completion: nil)
        // vendorList(isShow: isShownParti)
    }
    
    @IBAction func btnMoreTapped(_ sender: Any) {
        moreDropDown.show()
        
    }
    
    @IBOutlet weak var btnSpeak: UIButton!
    @IBAction func btnSpeakTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var btnCameraFlip: UIButton!
    @IBAction func btnCameraFlipTapped(_ sender: Any) {
        flipCamera()
    }
    
    @IBOutlet weak var lblTimeSpeak: UILabel!
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
        
        ringingTime -= 1
        if ringingTime <= 0 {
            myAudio.stop()
            timer.invalidate()
            ringToneTimer.invalidate()
            self.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: nil)
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
                    // self.view.makeToast("Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    
                } else {
                    
                    localView.shouldMirror = (captureDevice.position == .front)
                }
            }
        }
        else {
            self.view.makeToast("No front or back capture device found!")
            // self.logMessage(messageText:"No front or back capture device found!")
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
    //MARK: Remote Participant add
    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
        print("renderParticipant Call:")
        ringingView(ishide: false)
        timer.invalidate()
        ringToneTimer.invalidate()
        if myAudio != nil{
            myAudio.stop()
        }
        DispatchQueue.main.async {
            self.vdoCollectionView.reloadData()
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
//MARK: RoomDelegate
extension VideoCallViewController:RoomDelegate{
    func roomDidConnect(room: Room) {
        // At the moment, this example only supports rendering one Participant at a time.
        // self.view.makeToast("Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")
        
        for remoteParticipant in room.remoteParticipants {
            print("remoteParticipant::")
            remoteParticipant.delegate = self
        }
        
        localParticipant = room.localParticipant
        roomlocalParticipantSIDrule = room.localParticipant?.sid
        localParticipant?.delegate = self
        
        self.localParicipantDictionary?["0"] = ["participant":localParticipant]
        for i in 0 ..< room.remoteParticipants.count {
            let nParticipant = room.remoteParticipants[i]
            remoteParticipantArr.append(nParticipant)
            // if let participant = room.remoteParticipants[i] {
            nParticipant.delegate = self
            self.remoteParicipantDictionary?["\(i)"] = ["participant":nParticipant]
            
            //  }
        }
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
        // logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")
        recordTime.invalidate()
        if !self.userInitiatedDisconnect, let uuid = room.uuid, let error = error as? TwilioVideoSDK.Error {
            var reason = CXCallEndedReason.remoteEnded
            
            if error.code != .roomRoomCompletedError {
                reason = .failed
            }
            
            // self.callKitProvider.reportCall(with: uuid, endedAt: nil, reason: reason)
        }
        
        // self.cleanupRemoteParticipant()
        
        //  self.showRoomUI(inRoom: false)
        self.callKitCompletionHandler = nil
        self.userInitiatedDisconnect = false
        room.disconnect()
        self.room = nil
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
        
        self.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    func roomDidFailToConnect(room: Room, error: Error) {
        //logMessage(messageText: "Failed to connect to room with error: \(error.localizedDescription)")
        self.view.makeToast("Failed to connect to room with error: \(error.localizedDescription)")
        self.callKitCompletionHandler!(false)
        self.room = nil
        // self.showRoomUI(inRoom: false)
    }
    
    func roomIsReconnecting(room: Room, error: Error) {
        self.view.makeToast( "Reconnecting to room internet is too slow..")
        //  logMessage(messageText: "Reconnecting to room \(room.name), error = \(String(describing: error))")
    }
    
    func roomDidReconnect(room: Room) {
        // self.view.makeToast( "Reconnected to room \(room.name)")
        //  logMessage(messageText: "Reconnected to room \(room.name)")
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        print("participant added times---------------:",participant.remoteAudioTracks.count)
        recordTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(recordTimer), userInfo: nil, repeats: true)
        participant.delegate = self
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        
        // self.view.makeToast( "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
        var saveParticipant = true
        var index = 0
        for i in 0...self.remoteParticipantArr.count
        {
            //(self.localParicipantDictionary?.value(forKey: "0") as? NSObject)?.value(forKey: "participant") as?
            let newParticipant = (remoteParicipantDictionary?.value(forKey: "\(i)") as? NSObject)?.value(forKey: "participant") as? RemoteParticipant
            
            if newParticipant == participant {
                saveParticipant = false
            }
            index = i + 1
        }
        if saveParticipant{
            self.remoteParticipantArr.append(participant)
            participant.delegate = self
            self.remoteParicipantDictionary?["\(index)"] = ["participant":participant]
            
        }
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        recordTime.invalidate()
        timer.invalidate()
        if myAudio != nil{
            myAudio.stop()
        }
    }
    
}
extension VideoCallViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
                isAttendMultiPart = true
                self.lView = VideoView(frame: CGRect(x: 0, y: 0, width: vdoCollectionView.bounds.width, height: vdoCollectionView.bounds.height))
                self.lView.contentMode = .scaleAspectFill
                self.lView.clipsToBounds = false
                localVideoTrack!.addRenderer(lView)
                vdoCallVM.videoTrackEnableOrDisable(isenable: localVideoTrack!.isEnabled, img: cell.imgRemotePrivacy)
                cell.remoteView.addSubview(lView)
                
                return cell
            }
            else {
                if  indexPath.row > 0 {
                    cell.btnMic.isHidden = false
                    let videoPublications = remoteParticipantArr[indexPath.row - 1].remoteVideoTracks
                    //self.preview.isHidden = false
                    for publication in videoPublications {
                        
                        if let subscribedVideoTrack = publication.remoteTrack,
                           publication.isTrackSubscribed {
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
                        if let audio = audioPub.audioTrack {
                            audio.isEnabled == true ? (cell.btnMic.isSelected = false) : (cell.btnMic.isSelected = true)
                        }
                    }
                    return cell
                }
            }
            
        }
        else {
            let videoPublications = remoteParticipantArr[indexPath.row].remoteVideoTracks
            if isAttendMultiPart {
                if (localAudioTrack == nil) {
                    localAudioTrack = LocalAudioTrack()
                    if (localAudioTrack == nil) {
                        self.view.makeToast("Failed to create audio track")
                    }
                }
                self.preview.isHidden = false
                cell.btnMic.isHidden = false
            }
            for publication in videoPublications {
                if let subscribedVideoTrack = publication.remoteTrack,
                   publication.isTrackSubscribed {
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
                        cell.remoteView.addSubview(remote)
                    }
                }
                
            }
            let audioPublications = remoteParticipantArr[indexPath.row].audioTracks
            for audioPub in audioPublications {
                if let audio = audioPub.audioTrack {
                    
                    audio.isEnabled == true ? (cell.btnMic.isSelected = false) : (cell.btnMic.isSelected = true)
                }
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
                    return CGSize(width: vdoCollectionView.frame.size.width, height: vdoCollectionView.frame.size.height/2-5)
                    
                }
                else {
                    return CGSize(width: vdoCollectionView.frame.size.width/2-5, height: vdoCollectionView.frame.size.height/2-5)
                }
            }
            else if self.remoteParticipantArr.count == 3 {
                
                return CGSize(width: vdoCollectionView.frame.size.width/2-5, height: vdoCollectionView.frame.size.height/2-5)
            }
            else if self.remoteParticipantArr.count == 4 {
                if indexPath.row == 3 {
                    return CGSize(width: vdoCollectionView.frame.size.width, height: vdoCollectionView.frame.size.height/3-5)
                }
                else {
                    
                    return CGSize(width: vdoCollectionView.frame.size.width/2-5, height: vdoCollectionView.frame.size.height/3-5)
                }
            }
            else if self.remoteParticipantArr.count == 5 {
                return CGSize(width: vdoCollectionView.frame.size.width/2-5, height: vdoCollectionView.frame.size.height/3-5)
            }
            else if self.remoteParticipantArr.count == 6 {
                
                if indexPath.row == 5 {
                    return CGSize(width: vdoCollectionView.frame.size.width/3-5, height: vdoCollectionView.frame.size.height/3-5)
                }
                return CGSize(width: vdoCollectionView.frame.size.width/2-5, height: vdoCollectionView.frame.size.height/3-5)
                
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
        }
    }
}
extension VideoCallViewController:VideoViewDelegate {
    func videoViewDidReceiveData(view: VideoView) {
        print("vv:",view)
    }
    func remoteParticipantSwitchedOnVideoTrack(participant: RemoteParticipant, track: RemoteVideoTrack) {
        print("track:",participant)
    }
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        print("vv2:",view)
    }
    func chatClient(_ client: TwilioChatClient, channelAdded channel: TCHChannel) {
        print("call-----------------------------100")
    }
    //When new client added in call this method will call
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, messageAdded message: TCHMessage) {
        print("call-----------------------------101")
        print("message body:", message.body)
        let messString = message.body!
        if messString.contains("meetingfrominvitenotification") {
            showLobbyAlert()
        }}}
class MoreCell: DropDownCell {
    @IBOutlet weak var logoImageView: UIImageView!
}
class VDOCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var btnMic: UIButton!
    @IBOutlet weak var remoteView: VideoView!
    @IBOutlet weak var imgRemotePrivacy: UIImageView!
}
