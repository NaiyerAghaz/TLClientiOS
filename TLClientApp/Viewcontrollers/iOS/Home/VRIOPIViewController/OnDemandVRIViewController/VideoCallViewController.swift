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



class VideoCallViewController: UIViewController, VideoViewDelegate, LocalParticipantDelegate {
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
    var ringingTime = 80
    var localParicipantDictionary: NSMutableDictionary?
    var remoteParicipantDictionary: NSMutableDictionary?
    var rometParticipantList = [RemoteParticipant]()
    
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var preview: VideoView!
    
    @IBOutlet weak var muteView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var stopVideoView: UIView!
    
    @IBOutlet weak var participantView: UIView!
    
    @IBOutlet weak var moreView: UIView!
    var vendorTbl : UITableView = UITableView()
    var lblParticipant = UILabel()
    var callingImageView = UIImageView()
    var isShownParti = false
    
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ringingCallStart), userInfo: nil, repeats: true)
        
        vendorTbl.frame = CGRect(x: 0, y: 55, width: self.view.bounds.size.width, height: 200)
        vendorTbl.backgroundColor = UIColor.clear
        vendorTbl.separatorStyle = .none
        vendorTbl.layoutSubviews()
        vendorTbl.tableFooterView = UIView(frame: .zero)
        let cellNib = UINib(nibName: "VendorTVCell", bundle: nil)
        vendorTbl.register(cellNib, forCellReuseIdentifier: tableCellIndentifier.vendorTVCell.rawValue)
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
        /* if (self.localVideoTrack) {
         if(self.localVideoTrack.enabled == TRUE){
         self.localVideoTrack.enabled = FALSE;
         //  self.isLowNetwork =  YES;
         self.flipCamera.enabled = NO;
         self.isLocalVideoPaused = YES;
         [self.videoPauseBtn setImage:[UIImage imageNamed:@"vrivideo_mute"] forState:UIControlStateNormal];
         self.videoPauseBtn.clipsToBounds = YES;
         self.videoPauseBtn.contentMode = UIViewContentModeScaleAspectFit;
         
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
         
         [self.videoCollectionView performBatchUpdates:^{
         //  self.currentIndex = [NSNumber numberWithInteger:i+1];
         
         [self.videoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
         
         } completion:^(BOOL finished) {
         //                                           [self.videoCollectionView reloadData];
         //                                           [self.speakerVideoCollectionView reloadData];
         }];
         
         [self.speakerVideoCollectionView performBatchUpdates:^{
         //  self.currentIndex = [NSNumber numberWithInteger:i+1];
         
         [self.speakerVideoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
         
         } completion:^(BOOL finished) {
         //                                           [self.videoCollectionView reloadData];
         //                                           [self.speakerVideoCollectionView reloadData];
         }];
         }
         else{
         //  self.isLowNetwork =  NO;
         self.flipCamera.enabled = YES;
         self.localVideoTrack.enabled = TRUE;
         [self.videoPauseBtn setImage:[UIImage imageNamed:@"vrivideo"] forState:UIControlStateNormal];
         self.videoPauseBtn.clipsToBounds = YES;
         self.videoPauseBtn.contentMode = UIViewContentModeScaleAspectFit;
         
         self.isLocalVideoPaused = NO;
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
         
         [self.videoCollectionView performBatchUpdates:^{
         //  self.currentIndex = [NSNumber numberWithInteger:i+1];
         
         [self.videoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
         
         } completion:^(BOOL finished) {
         //                                                      [self.videoCollectionView reloadData];
         //                                                      [self.speakerVideoCollectionView reloadData];
         }];
         
         
         [self.speakerVideoCollectionView performBatchUpdates:^{
         //  self.currentIndex = [NSNumber numberWithInteger:i+1];
         
         [self.speakerVideoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
         
         } completion:^(BOOL finished) {
         //                                                      [self.videoCollectionView reloadData];
         //                                                      [self.speakerVideoCollectionView reloadData];
         }];
         }
         
         
         
         
         
         
         }*/
    }
    
    @IBAction func btnEndCallTapped(_ sender: Any) {
        
        /*{
         [self deleteChat];
         if(self.isConnectedVendor){
         NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
         [self participantEndActionD:index];
         if(self.room){
         [self.room disconnect];
         if (self.camera) {
         
         [self.camera stopCapture];
         self.camera = nil;
         }
         if (!self.localVideoTrack) {
         self.localVideoTrack = nil;
         }
         }
         [self roomCompleted];
         [self updateVRIRoomData];
         self.inviteBGView.hidden = YES;
         self.participantBtn.hidden = YES;
         self.participateTableView.hidden = YES;
         self.participantBGView.hidden = YES;
         //                             if(!self.isMeetingCall){
         //                                                               self.ratingPopup.hidden = NO;
         //                                                           }
         //                                                           else{
         
         self.ratingPopup.hidden = NO;
         [[APIManager sharedManager] raiseToastWithMessage:@"Conversation has been completed" WithColor:HeaderColor];
         
         // [self dismissViewControllerAnimated:NO completion:nil];
         
         //  }
         
         
         }
         else{
         
         if(self.isMeetingCall){
         [self endCallBeforeCallConnect];
         }
         else{
         [self endCallDurationWithOutConnected];
         }
         }
         });
         */
        UIAlertController.showAlert(title: "", message: "Are you sure you want to hangup this call?", style: .alert, cancelButton: "Delete", distrutiveButton: "End Call", otherButtons: nil) { [self] index, _ in
            if index == 0 {
                timer.invalidate()
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
            self.startPreview()
        }
    }
    //====================END=============================
    @objc  func ringingCallStart(){
        CEnumClass.share.playSounds(audioName: "incoming")
        
        ringingTime -= 1
        if ringingTime <= 0 {
            myAudio.stop()
            timer.invalidate()
            
            self.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    // MARK:- Private
    func startPreview() {
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
            localVideoTrack!.addRenderer(self.preview)
            // logMessage(messageText: "Video track created")
            
            if (frontCamera != nil && backCamera != nil) {
                // We will flip camera on tap.
                let tap = UITapGestureRecognizer(target: self, action: #selector(VideoCallViewController.flipCamera))
                self.preview.addGestureRecognizer(tap)
            }
            
            camera!.startCapture(device: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                if let error = error {
                    self.view.makeToast("Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    
                } else {
                    self.preview.shouldMirror = (captureDevice.position == .front)
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
    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
        print("renderParticipant Call:")
        ringingView(ishide: false)
        // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
        let videoPublications = participant.remoteVideoTracks
        for publication in videoPublications {
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
        }
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
        //Old code set
        /* [self.localParticipantsDictionary setObject:@{
         @"participant" : participantLocal,
         } forKey:@"0"];
         
         
         
         for (int i= 0; i< room.remoteParticipants.count; i++) {
         TVIRemoteParticipant * participant = room.remoteParticipants[i];
         [self.remoteParticipantsList addObject:participant];
         participant.delegate = self;
         [self.remoteParticipantsDictionary setObject:@{
         @"participant" : participant,
         } forKey:[NSString stringWithFormat:@"%d",i]];
         }
         
         NSLog(@"");
         dispatch_async(dispatch_get_main_queue(), ^(void){
         //                 [self.videoCollectionView reloadData];
         //                 [self.speakerVideoCollectionView reloadData];
         
         });*/
        
        
        /* let cxObserver = callKitCallController.callObserver
         let calls = cxObserver.calls
         
         // Let the call provider know that the outgoing call has connected
         if let uuid = room.uuid, let call = calls.first(where:{$0.uuid == uuid}) {
         if call.isOutgoing {
         callKitProvider.reportOutgoingCall(with: uuid, connectedAt: nil)
         }
         }
         */
        // self.callKitCompletionHandler!(true)
        
        ///
        self.localParicipantDictionary?["0"] = ["participant":localParticipant]
        for i in 0 ..< room.remoteParticipants.count {
            if  let participant = room.remoteParticipants[i] as? RemoteParticipant {
                participant.delegate = self
                self.remoteParicipantDictionary?["\(i)"] = ["participant":participant]
                
            }
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
        recordTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(recordTimer), userInfo: nil, repeats: true)
        // let req = vdoCallVM.addParticipantReqApi(Lsid: roomlocalParticipantSIDrule!, roomID: roomID!)
        DispatchQueue.global(qos: .background).async { [self] in
            vdoCallVM.getParticipantList2(lid: roomlocalParticipantSIDrule!, roomID: roomID!) { success, err in
                print("getParticipant----------->", success)
            }
            
        }
        
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        participant.delegate = self
        self.view.makeToast( "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
        
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        recordTime.invalidate()
        timer.invalidate()
        if myAudio != nil{
            myAudio.stop()
        }
        self.view.makeToast( "Room \(room.name), Participant \(participant.identity) disconnected")
        
        
        // Nothing to do in this example. Subscription events are used to add/remove renderers.
    }
    
}


