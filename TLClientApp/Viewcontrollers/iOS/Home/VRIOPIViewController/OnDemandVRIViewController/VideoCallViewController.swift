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

class VideoCallViewController: UIViewController, VideoViewDelegate, LocalParticipantDelegate {
    // Video SDK components
    var room: Room?
    /**
     * We will create an audio device and manage it's lifecycle in response to CallKit events.
     */
    var audioDevice: DefaultAudioDevice = DefaultAudioDevice()
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    var localParticipant : LocalParticipant?
    var remoteView: VideoView?
    
    // CallKit components
    let callKitProvider: CXProvider? = nil
    let callKitCallController: CXCallController? = nil
    var callKitCompletionHandler: ((Bool)->Swift.Void?)? = nil
    var userInitiatedDisconnect: Bool = false

    var roomID,sourceLangID,targetLangID,sourceLangName,targetLangName,patientname,patientno: String?
    var isClientDetails,isScheduled : Bool?
    var twilioToken : String?
    var vdoCallVM = VDOCallViewModel()
    var timer = Timer()
    var ringingTime = 15
    
    @IBOutlet weak var preview: VideoView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
            .withAlphaComponent(0.7)
        configure()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
      //  timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ringingCallStart), userInfo: nil, repeats: true)
    }
    //MARK: Configure With Twilio
    
    @IBAction func btnDisconnected(_ sender: UIButton) {
    }
    func configure(){
        vdoCallVM.getTwilioToken { model, err in
            if err == nil {
               
                self.twilioToken = model?.token
               // self.startPreview()
               // myAudio.stop()
                //self.timer.invalidate()
                self.doConnectTwilio(twilioToken: (model?.token)!)
            }
        }
        
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
        print("token:")
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
        // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
        let videoPublications = participant.remoteVideoTracks
        for publication in videoPublications {
            if let subscribedVideoTrack = publication.remoteTrack,
                publication.isTrackSubscribed {
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
    
//    func logMessage(messageText: String) {
//        NSLog(messageText)
//        messageLabel.text = messageText
//    }

    func holdCall(onHold: Bool) {
        localAudioTrack?.isEnabled = !onHold
        localVideoTrack?.isEnabled = !onHold
    }
    func setupRemoteVideoView() {
        // Creating `VideoView` programmatically
        self.remoteView = VideoView(frame: CGRect.zero, delegate: self)
        
        self.view.insertSubview(self.remoteView!, at: 0)
        
        // `VideoView` supports scaleToFill, scaleAspectFill and scaleAspectFit
        // scaleAspectFit is the default mode when you create `VideoView` programmatically.
        self.remoteView!.contentMode = .scaleAspectFit;
        
        let centerX = NSLayoutConstraint(item: self.remoteView!,
                                         attribute: NSLayoutConstraint.Attribute.centerX,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutConstraint.Attribute.centerX,
                                         multiplier: 1,
                                         constant: 0);
        self.view.addConstraint(centerX)
        let centerY = NSLayoutConstraint(item: self.remoteView!,
                                         attribute: NSLayoutConstraint.Attribute.centerY,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutConstraint.Attribute.centerY,
                                         multiplier: 1,
                                         constant: 0);
        self.view.addConstraint(centerY)
        let width = NSLayoutConstraint(item: self.remoteView!,
                                       attribute: NSLayoutConstraint.Attribute.width,
                                       relatedBy: NSLayoutConstraint.Relation.equal,
                                       toItem: self.view,
                                       attribute: NSLayoutConstraint.Attribute.width,
                                       multiplier: 1,
                                       constant: 0);
        self.view.addConstraint(width)
        let height = NSLayoutConstraint(item: self.remoteView!,
                                        attribute: NSLayoutConstraint.Attribute.height,
                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                        toItem: self.view,
                                        attribute: NSLayoutConstraint.Attribute.height,
                                        multiplier: 1,
                                        constant: 0);
        self.view.addConstraint(height)
    }
}

// MARK:- CameraSourceDelegate
extension VideoCallViewController : CameraSourceDelegate {
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        self.view.makeToast("Camera source failed with error: \(error.localizedDescription)")
       
    }
}
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
        localParticipant?.delegate = self
        
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
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
       // logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")

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
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        participant.delegate = self
        self.view.makeToast( "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
        
    }

    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        self.view.makeToast( "Room \(room.name), Participant \(participant.identity) disconnected")
        

        // Nothing to do in this example. Subscription events are used to add/remove renderers.
    }

}
