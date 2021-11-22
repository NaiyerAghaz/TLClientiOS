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
    
    var roomID,sourceLangID,targetLangID,sourceLangName,targetLangName,patientname,patientno: String?
    var roomlocalParticipantSIDrule: String?
    var isClientDetails,isScheduled : Bool?
    var twilioToken : String?
    var vdoCallVM = VDOCallViewModel()
    var timer = Timer()
    var ringToneTimer = Timer()
    var ringingTime = 80
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
    
    @IBOutlet weak var moreView: UIView!
    var vendorTbl : UITableView = UITableView()
    var lblParticipant = UILabel()
    var callingImageView = UIImageView()
    var isShownParti = false
    var chatManager = ChatManager()
    var isMeetingCall = false
    var clientStatusModel: ClientStatusModel?
    
    //More dropdown
    let moreDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.moreDropDown
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
            .withAlphaComponent(0.7)
        configure()
        isMeetingCall = true
        vdoCollectionView.isHidden = true
        self.vdoCollectionView.delegate = self
        self.vdoCollectionView.dataSource = self
        self.vdoCollectionView.bounces = false
        genarateChatTokenCreate()
       // print("roomID------------>2:", self.roomID)
        // Do any additional setup after loading the view.
    }
    
    //MARK: Configure With Twilio
    
    @IBAction func btnDisconnected(_ sender: UIButton) {
    }
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
        CEnumClass.share.playSounds(audioName: "incoming")
        self.ringToneTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { timer in
            CEnumClass.share.playSounds(audioName: "incoming")
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
                    }
                    
                    
                }
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
                self.view.makeToast("genarateChatTokenLobby")
                print("genarateChatTokenLobby-------------->")
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
        
    }
    func getMeetingClientStatusLobbyRefreshAccept(roomId: String){
        let req = vdoCallVM.meetingClientReq(roomID: roomId)
        vdoCallVM.getMeetingClientStatusLobbyWithCompletion(parameter: req) { success, result in
            if success  == true{
                print("result?.INVITEDATA2----->",result?.INVITEDATA2)
                if result?.INVITEDATA2 == "0"{
                    self.clientStatusModel = nil
                   
                    print("clientStatusModel refresh----------->", success)
                }
                DispatchQueue.global(qos: .background).async { [self] in
                    vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: roomID!) { success, err in
                        print("getParticipant22222----------->", success)
                    }
                    
                }
                
            }
            
            
        }
    }
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
            
        }
        
    }
    
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
    //MARK: Participant List
    /*  public func vendorList(isShow:Bool){
     if !isShow {
     isShownParti = true
     self.view.insertSubview(vendorTbl, at: 2)
     vendorTbl.invalidateIntrinsicContentSize()
     vendorTbl.estimatedRowHeight = 50
     vendorTbl.delegate = self
     vendorTbl.dataSource = self
     vendorTbl.reloadData()
     }
     else {
     isShownParti = false
     vendorTbl.removeFromSuperview()
     }
     }*/
    
    @IBAction func btnParticipantTapped(_ sender: Any) {
        let callVC = UIStoryboard(name: Storyboard_name.home, bundle: nil)
        let vcontrol = callVC.instantiateViewController(identifier: "TotalParticipantVC") as! TotalParticipantVC
        vcontrol.height = 500
        vcontrol.topCornerRadius = 20
        vcontrol.presentDuration = 0.5
        vcontrol.dismissDuration = 0.5
        vcontrol.shouldDismissInteractivelty = true
        vcontrol.popupDismisAlphaVal = 0.4
        /*  var callChannel : TCHChannel?
         var vdoCallVM = VDOCallViewModel()
         var roomlocalParticipantSIDrule: String?
         var conferrenceInfoArr : NSMutableArray?*/
        vcontrol.room = room
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
        // We will share local audio and video when we connect to the Room.
        
        // Create an audio track.
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
       
           // CEnumClass.share.playSounds(audioName: "incoming")
        
       
        
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
                    self.view.makeToast("Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    
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
                        self.preview.shouldMirror = (captureDevice.position == .front)
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
        // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
        let videoPublications = participant.remoteVideoTracks
        /*  for publication in videoPublications {
         if let subscribedVideoTrack = publication.remoteTrack,
         publication.isTrackSubscribed {
         timer.invalidate()
         if myAudio != nil{
         myAudio.stop()
         }
         setupRemoteVideoView()
         subscribedVideoTrack.addRenderer(self.remoteView!)
         
         self.remoteParticipant = participant
         return true
         }
         }*/
        //New changes
      //  remoteParticipantArr.append(participant)
        DispatchQueue.main.async {
            
            
            self.vdoCollectionView.reloadData()
        }
        
        //end changes
        
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
        self.view.makeToast("Camera source failed with error: \(error.localizedDescription)")
        
    }
}
//MARK: RoomDelegate
extension VideoCallViewController:RoomDelegate{
    func roomDidConnect(room: Room) {
        // At the moment, this example only supports rendering one Participant at a time.
        self.view.makeToast("Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")
        //logMessage(messageText: "Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")
        
        // This example only renders 1 RemoteVideoTrack at a time. Listen for all events to decide which track to render.
        for remoteParticipant in room.remoteParticipants {
            print("remoteParticipant::")
            remoteParticipant.delegate = self
        }
        print("roomSID:------------------------->", room.sid, "roomLocalParicipatSID:", room.localParticipant?.sid, "::", room.localParticipant?.identity)
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
        
        self.cleanupRemoteParticipant()
        self.room = nil
        //  self.showRoomUI(inRoom: false)
        self.callKitCompletionHandler = nil
        self.userInitiatedDisconnect = false
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
        self.view.makeToast( "Reconnecting to room \(room.name), error = \(String(describing: error))")
        //  logMessage(messageText: "Reconnecting to room \(room.name), error = \(String(describing: error))")
    }
    
    func roomDidReconnect(room: Room) {
        self.view.makeToast( "Reconnected to room \(room.name)")
        //  logMessage(messageText: "Reconnected to room \(room.name)")
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        print("participant added times---------------:",participant.remoteAudioTracks.count)
        recordTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(recordTimer), userInfo: nil, repeats: true)
        // let req = vdoCallVM.addParticipantReqApi(Lsid: roomlocalParticipantSIDrule!, roomID: roomID!)
        
        // remoteParticipantArr.append(participant)
        ///getParticipantListWithoutLoading is call below.
        DispatchQueue.global(qos: .background).async { [self] in
            vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: roomID!) { success, err in
                print("getParticipant----------->", success)
            }
            
        }
        
        participant.delegate = self
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        
        self.view.makeToast( "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
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
        
        
       /* bool saveParticipant = true;
        int index = 0;
        for (int i= 0; i< self.remoteParticipantsList.count; i++) {
            TVIRemoteParticipant * participant1 = [[self.remoteParticipantsDictionary valueForKey:[NSString stringWithFormat:@"%d",i]] valueForKey:@"participant"];
            
            if(participant1 == participant){
                saveParticipant = false;
            }
            index = i+1;
        }
        if(saveParticipant){
            [self.remoteParticipantsList addObject:participant];
            participant.delegate = self;
            [self.remoteParticipantsDictionary setObject:@{
                @"participant" : participant,
            } forKey:[NSString stringWithFormat:@"%d",index]];
        }*/
        
    
        
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        recordTime.invalidate()
        timer.invalidate()
        if myAudio != nil{
            myAudio.stop()
        }
        self.view.makeToast("Room \(room.name), Participant \(participant.identity) disconnected")
        
        
        // Nothing to do in this example. Subscription events are used to add/remove renderers.
    }
    
}
extension VideoCallViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return remoteParticipantArr.count
        
       
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = vdoCollectionView.dequeueReusableCell(withReuseIdentifier: cellIndentifier.VDOCollectionViewCell.rawValue, for: indexPath) as!  VDOCollectionViewCell
        print("remoteParticipantArr:",remoteParticipantArr.count)
       //participant.remoteVideoTracks
       // print("videoPublications:",videoPublications.count)
       
        
       /* if remoteParticipantArr.count > 1 {
           /* if([[self.remoteParticipantsDictionary valueForKey:[NSString stringWithFormat:@"%d",i]] valueForKey:@"videoTrak"] != nil){
                callCell.audioCallImg.hidden = YES;
                callCell.pinBtn.hidden = NO;
                TVIRemoteVideoTrack * videoT = [[self.remoteParticipantsDictionary valueForKey:[NSString stringWithFormat:@"%d",i]] valueForKey:@"videoTrak"];
                [videoT addRenderer:remoteView];
             
            }*/
            if indexPath.row == 0 {
                let localParticipant = (self.localParicipantDictionary?.value(forKey: "0") as? NSObject)?.value(forKey: "videoTrak") as? LocalVideoTrack
                if localParticipant != nil {
                    localParticipant?.addRenderer(cell.remoteView)
                }
               
              //  startPreview(localView: cell.remoteView)
                self.preview.isHidden = true
               
            }
           else {
           /* let videoPublications = remoteParticipantArr[indexPath.row].remoteVideoTracks
                for publication in videoPublications {
                    if let subscribedVideoTrack = publication.remoteTrack,
                       publication.isTrackSubscribed {
                        print("videoPublications--->",publication.isTrackSubscribed)
                        /// setupRemoteVideoView()
                        let remote = VideoView(frame: CGRect(x: 0, y: 0, width: self.vdoCollectionView.frame.size.width, height: self.vdoCollectionView.frame.size.height))
                        remote.contentMode = .scaleAspectFill
                        remote.clipsToBounds = false
                        cell.remoteView?.contentMode = .scaleAspectFill
                        cell.remoteView?.clipsToBounds = false
                        subscribedVideoTrack.addRenderer(remote)
                        
                        
                        cell.remoteView.addSubview(remote)
                        
                        
                    }
                }*/
            for i in 0...remoteParticipantArr.count {
                if i+1 == indexPath.row {
                    print("remote--------------->",i)
                    
                    if let vTrack = (self.remoteParicipantDictionary?.value(forKey: "\(i)") as? NSObject)?.value(forKey: "videoTrak") as? RemoteVideoTrack {
                        print("remote---------------2>",vTrack)
//                        let remote = VideoView(frame: CGRect(x: 0, y: 0, width: self.vdoCollectionView.frame.size.width, height: self.vdoCollectionView.frame.size.height))
//                        remote.contentMode = .scaleAspectFill
//                        remote.clipsToBounds = false
//                        cell.remoteView?.contentMode = .scaleAspectFill
//                        cell.remoteView?.clipsToBounds = false
                        vTrack.addRenderer(remote)
                        cell.remoteView.addSubview(remote)
                       // vTrack.addRenderer(cell.remoteView)
                    }
                   
                }
            }
            }

        }
        else {*/
            let videoPublications = remoteParticipantArr[indexPath.row].remoteVideoTracks

            self.preview.isHidden = false
            for publication in videoPublications {
                if let subscribedVideoTrack = publication.remoteTrack,
                   publication.isTrackSubscribed {
                    print("videoPublications--->",publication.isTrackSubscribed)
                   
                    let remote = VideoView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                    remote.contentMode = .scaleAspectFill
                    remote.clipsToBounds = false
                    cell.remoteView?.contentMode = .scaleAspectFill
                    cell.remoteView.layer.cornerRadius = 10
                    cell.remoteView.clipsToBounds = false
                    cell.remoteView?.clipsToBounds = false
                    subscribedVideoTrack.addRenderer(remote)
                     cell.remoteView.addSubview(remote)
                   
                    
                }
        
                
            }
       // }

        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == vdoCollectionView {
            
           
            if self.remoteParticipantArr.count == 1 {
                return CGSize(width: vdoCollectionView.frame.size.width, height: vdoCollectionView.frame.size.height)
            }
            else if self.remoteParticipantArr.count == 2 {
               
                    return CGSize(width: vdoCollectionView.frame.size.width, height: vdoCollectionView.frame.size.height/2-10)
                
                
            }
            else if self.remoteParticipantArr.count == 3 {
                return CGSize(width: vdoCollectionView.frame.size.width/2, height: vdoCollectionView.frame.size.height/2-10)
            }
            else if self.remoteParticipantArr.count == 4 {
               
               
                    return CGSize(width: vdoCollectionView.frame.size.width/2, height: vdoCollectionView.frame.size.height/3-10)
                
                
            }
            else if self.remoteParticipantArr.count == 5 {
                return CGSize(width: vdoCollectionView.frame.size.width/2-10, height: vdoCollectionView.frame.size.height/3-10)
            }
            else if self.remoteParticipantArr.count == 6 {
                if indexPath.row == 4 {
                    return CGSize(width: vdoCollectionView.frame.size.width, height: vdoCollectionView.frame.size.height/4-10)
                }
                else{
                    
                    return CGSize(width: vdoCollectionView.frame.size.width/2, height: vdoCollectionView.frame.size.height/3-10)
                    
                }
                }
            else if self.remoteParticipantArr.count == 7 {
                return CGSize(width: vdoCollectionView.frame.size.width/2-10, height: vdoCollectionView.frame.size.height/4-10)
            }
            
            return CGSize(width: vdoCollectionView.frame.size.width/2 - 10, height: vdoCollectionView.frame.size.height/2-10)
           // Collection View size right?
        }
        else {
            return CGSize(width: 370, height: 490)
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
        }
       
    }
    
    
}


