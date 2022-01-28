////
////  OPIViewController.swift
////  TLClientApp
////
////  Created by Mac on 23/08/21.
////
//
//import UIKit
//import AVKit
//import AVFoundation
//import PushKit
//import CallKit
//import TwilioVoice
//
//let twimlParamTo = "to"
//let kRegistrationTTLInDays = 365
//let kCachedDeviceToken = "CachedDeviceToken"
//let kCachedBindingDate = "CachedBindingDate"
//
//class OPIViewController: UIViewController {
//    
//    //Outlets
//    @IBOutlet var lblSourceLang: UILabel!
//    @IBOutlet var lblTargetLang: UILabel!
//    @IBOutlet var lblDuration: UILabel!
//    @IBOutlet var lbl_Mute: UILabel!
//    @IBOutlet var imgView_Caller: UIImageView!
//    @IBOutlet var imgViewCancel: UIImageView!
//    @IBOutlet var imgView_Mic: UIImageView!
//    @IBOutlet var view_Caller_Bg: UIView!
//    @IBOutlet var btnMute: UIButton!
//    @IBOutlet var btnAddParticipant: UIButton!
//    @IBOutlet var btnCallCancel: UIButton!
//    @IBOutlet var view_Mic: UIView!
//    @IBOutlet var view_CacelCall: UIView!
//    @IBOutlet var view_AddParticipent: UIView!
//    
//    //Variable
//    var accessToken: String = ""
//    var sourceLang: String?
//    var destinationLang: String?
//    var clientName: String?
//    var clientNumber: String?
//    var slID: String = ""
//    var LID: String = ""
//    var counter: Int = 0
//    var tlTimer: TLTimer?
//    
//    //#######
//    var incomingPushCompletionCallback: (() -> Void)? = nil
//
//    var isSpinning: Bool = false
//    var incomingAlertController: UIAlertController?
//
//    var callKitCompletionCallback: ((Bool) -> Void)? = nil
//    var audioDevice = DefaultAudioDevice()
//    var activeCallInvites: [String: CallInvite]! = [:]
//    var activeCalls: [String: Call]! = [:]
//    
//    // activeCall represents the last connected call
//    var activeCall: Call? = nil
//    var callKitProvider: CXProvider?
//    let callKitCallController = CXCallController()
//    var userInitiatedDisconnect: Bool = false
//    //##########
//    var playCustomRingback = true
//    var ringtonePlayer: AVAudioPlayer? = nil
//    var callManagerVM = CallManagerVM()
//    var roomId: String = ""
//    lazy var userId: String = {
//        return userDefaults.value(forKey: .kUSER_ID) as? String
//    }() ?? ""
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        isSpinning = false
//        self.configUI()
//        self.configCall()
//        self.getRoomId()
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//     
//    }
//}
//
////MARK: ==== Button Actions ====
//extension OPIViewController {
//    @IBAction func clickOnMute(_ sender: UIButton) {
//        
//        guard activeCall != nil else { return }
//        if sender.isSelected {
//            self.imgView_Mic.image = #imageLiteral(resourceName: "ic_mic")
//            self.lbl_Mute.text = "Mute"
//            self.activeCall?.isMuted = false
//        } else {
//            self.imgView_Mic.image = #imageLiteral(resourceName: "ic_mic_mute")
//            self.lbl_Mute.text = "Unmute"
//            self.activeCall?.isMuted = true
//        }
//        sender.isSelected = !sender.isSelected
//    }
//    @IBAction func clickOnCallCancel(_ sender: UIButton) {
//        
//        guard activeCall == nil else {
////                    toggleUIState(isEnabled: false, showCallControl: false)
//            userInitiatedDisconnect = true
//            performEndCallAction(uuid: activeCall!.uuid!)
//            return
//        }
//    }
//    @IBAction func clickOnAddParticipant(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "AddParticipantController") as! AddParticipantController
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}
//
////MARK: Configuration
//extension OPIViewController: CallDelegate {
//    func configUI() {
//        self.lblSourceLang.text = self.sourceLang
//        self.lblTargetLang.text = self.destinationLang
//        self.enableButton(enabled: false)
//    }
//    func enableButton(enabled: Bool) {
//        self.imgViewCancel.alpha = enabled ? 1 : 0.5
//    }
//    func showHideItems(enabled: Bool) {
//        self.imgViewCancel.alpha = enabled ? 1 : 0.5
//    }
//    func callDidConnect(call: Call) {
//        
//    }
//    
//    func callDidFailToConnect(call: Call, error: Error) {
//        
//    }
//    
//    func callDidDisconnect(call: Call, error: Error?) {
//        
//    }
//    
//
//}
////MARK: Call Configuration
//extension OPIViewController {
//    func configCall() {
//        /* Please note that the designated initializer `CXProviderConfiguration(localizedName: String)` has been deprecated on iOS 14. */
//        let configuration = CXProviderConfiguration(localizedName: "Voice Quickstart")
//        configuration.maximumCallGroups = 1
//        configuration.maximumCallsPerCallGroup = 1
//        callKitProvider = CXProvider(configuration: configuration)
//        if let provider = callKitProvider {
//            provider.setDelegate(self, queue: nil)
//        }
//        /*
//         * The important thing to remember when providing a TVOAudioDevice is that the device must be set
//         * before performing any other actions with the SDK (such as connecting a Call, or accepting an incoming Call).
//         * In this case we've already initialized our own `TVODefaultAudioDevice` instance which we will now set.
//         */
//        TwilioVoiceSDK.audioDevice = audioDevice
//    }
//
//    func checkRecordPermission(completion: @escaping (_ permissionGranted: Bool) -> Void) {
//        let permissionStatus = AVAudioSession.sharedInstance().recordPermission
//        
//        switch permissionStatus {
//        case .granted:
//            // Record permission already granted.
//            completion(true)
//        case .denied:
//            // Record permission denied.
//            completion(false)
//        case .undetermined:
//            // Requesting record permission.
//            // Optional: pop up app dialog to let the users know if they want to request.
//            AVAudioSession.sharedInstance().requestRecordPermission { granted in completion(granted) }
//        default:
//            completion(false)
//        }
//    }
//    func showMicrophoneAccessRequest(_ uuid: UUID, _ handle: String) {
//        let alertController = UIAlertController(title: "Voice Quick Start",
//                                                message: "Microphone permission not granted",
//                                                preferredStyle: .alert)
//        
//        let continueWithoutMic = UIAlertAction(title: "Continue without microphone", style: .default) { [weak self] _ in
//            self?.performStartCallAction(uuid: uuid, handle: handle)
//        }
//        let goToSettings = UIAlertAction(title: "Settings", style: .default) { _ in
//            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
//                                      options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: false],
//                                      completionHandler: nil)
//        }
//        
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
////            self?.toggleUIState(isEnabled: true, showCallControl: false)
////            self?.stopSpin()
//        }
//        [continueWithoutMic, goToSettings, cancel].forEach { alertController.addAction($0) }
//        self.present(alertController, animated: true, completion: nil)
//    }
//}
////MARK: API Calling...
//extension OPIViewController {
//    func getRoomId() {
//        self.callManagerVM.getRoomList {[weak self] (roomResult, error) in
//            guard let weakSelf = self else { return }
//            guard let roomid = roomResult?[0].RoomNo else {
//                return
//            }
//            weakSelf.roomId = roomid
//            weakSelf.getVRIandOPICallClient()
//        }
//    }
//    //MARK: Get VRI/OPI Call client
//    func getVRIandOPICallClient() -> () {
//        //CALLTYPESTATUS-  1 Means OnDemandOPI call, 2 Schedule Call
//        let str = String(format: "<VRICLIENT><ACTION>A</ACTION><ID>0</ID><CLIENTID>%@</CLIENTID><ROOMID>%@</ROOMID><CALLTYPE>OPI</CALLTYPE><CALLSTATUS>1</CALLSTATUS><SOURCE>%@</SOURCE><TARGET>%@</TARGET><CALLTYPESTATUS>1</CALLTYPESTATUS></VRICLIENT>", userId, self.roomId, self.slID, self.LID)
//    }
//    //MARK: Get Vender Id
//    func getVenderId(from cId: String) {
//        let str = String(format: "<Info><CUSTOMERID>%@</CUSTOMERID><TYPE>O</TYPE><SOURCE>%@</SOURCE><TARGET>%@</TARGET><CC_ID>%@</CC_ID></Info>", userId, self.slID, self.LID, cId)
//       
//    }
//    
//    func makeTwilioCall() {
//        guard activeCall == nil else {
//            userInitiatedDisconnect = true
//            performEndCallAction(uuid: activeCall!.uuid!)
////            toggleUIState(isEnabled: false, showCallControl: false)
//            return
//        }
//    }
//
//    // MARK: AVAudioSession
//    func toggleAudioRoute(toSpeaker: Bool) {
//        // The mode set by the Voice SDK is "VoiceChat" so the default audio route is the built-in receiver. Use port override to switch the route.
//        do {
//            try AVAudioSession.sharedInstance().overrideOutputAudioPort(toSpeaker ? .speaker : .none)
//        } catch {
//            NSLog(error.localizedDescription)
//        }
//    }
//}
//// MARK: - CXProviderDelegate
//
//extension OPIViewController: CXProviderDelegate {
//    func providerDidReset(_ provider: CXProvider) {
//        NSLog("providerDidReset:")
//        audioDevice.isEnabled = false
//    }
//
//    func providerDidBegin(_ provider: CXProvider) {
//        NSLog("providerDidBegin")
//    }
//
//    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
//        NSLog("provider:didActivateAudioSession:")
//        audioDevice.isEnabled = true
//    }
//
//    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
//        NSLog("provider:didDeactivateAudioSession:")
//        audioDevice.isEnabled = false
//    }
//
//    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
//        NSLog("provider:timedOutPerformingAction:")
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
//        NSLog("provider:performStartCallAction:")
//        
////        toggleUIState(isEnabled: false, showCallControl: false)
////        startSpin()
//        provider.reportOutgoingCall(with: action.callUUID, startedConnectingAt: Date())
//        
//        performVoiceCall(uuid: action.callUUID, client: "") { success in
//            if success {
//                NSLog("performVoiceCall() successful")
//                provider.reportOutgoingCall(with: action.callUUID, connectedAt: Date())
//            } else {
//                NSLog("performVoiceCall() failed")
//            }
//        }
//        action.fulfill()
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
//        NSLog("provider:performAnswerCallAction:")
//        
//        performAnswerVoiceCall(uuid: action.callUUID) { success in
//            if success {
//                NSLog("performAnswerVoiceCall() successful")
//            } else {
//                NSLog("performAnswerVoiceCall() failed")
//            }
//        }
//        action.fulfill()
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
//        NSLog("provider:performEndCallAction:")
//        
//        if let invite = activeCallInvites[action.callUUID.uuidString] {
//            invite.reject()
//            activeCallInvites.removeValue(forKey: action.callUUID.uuidString)
//        } else if let call = activeCalls[action.callUUID.uuidString] {
//            call.disconnect()
//        } else {
//            NSLog("Unknown UUID to perform end-call action with")
//        }
//        action.fulfill()
//    }
//    
//    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
//        NSLog("provider:performSetHeldAction:")
//        if let call = activeCalls[action.callUUID.uuidString] {
//            call.isOnHold = action.isOnHold
//            action.fulfill()
//        } else {
//            action.fail()
//        }
//    }
//    
//    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
//        NSLog("provider:performSetMutedAction:")
//        if let call = activeCalls[action.callUUID.uuidString] {
//            call.isMuted = action.isMuted
//            action.fulfill()
//        } else {
//            action.fail()
//        }
//    }
//
//    // MARK: Call Kit Actions
//    func performStartCallAction(uuid: UUID, handle: String) {
//        guard let provider = callKitProvider else {
//            NSLog("CallKit provider not available")
//            return
//        }
//        let callHandle = CXHandle(type: .generic, value: handle)
//        let startCallAction = CXStartCallAction(call: uuid, handle: callHandle)
//        let transaction = CXTransaction(action: startCallAction)
//
//        callKitCallController.request(transaction) { error in
//            if let error = error {
//                NSLog("StartCallAction transaction request failed: \(error.localizedDescription)")
//                return
//            }
//            NSLog("StartCallAction transaction request successful")
//
//            let callUpdate = CXCallUpdate()
//            callUpdate.remoteHandle = callHandle
//            callUpdate.supportsDTMF = true
//            callUpdate.supportsHolding = true
//            callUpdate.supportsGrouping = false
//            callUpdate.supportsUngrouping = false
//            callUpdate.hasVideo = false
//            provider.reportCall(with: uuid, updated: callUpdate)
//        }
//    }
//    func performEndCallAction(uuid: UUID) {
//
//        let endCallAction = CXEndCallAction(call: uuid)
//        let transaction = CXTransaction(action: endCallAction)
//        callKitCallController.request(transaction) { error in
//            if let error = error {
//                NSLog("EndCallAction transaction request failed: \(error.localizedDescription).")
//            } else {
//                NSLog("EndCallAction transaction request successful")
//            }
//        }
//    }
//    
//    func performVoiceCall(uuid: UUID, client: String?, completionHandler: @escaping (Bool) -> Void) {
//        let connectOptions = ConnectOptions(accessToken: self.accessToken) { builder in
//            builder.params = ["vendorids": "218038",
//                              "roomno": self.roomId,
//                              "clientid": self.userId,
//                              "calltopropio": "directtoVendor"]
//            builder.uuid = uuid
//        }
//        
//        let call = TwilioVoiceSDK.connect(options: connectOptions, delegate: self)
//        activeCall = call
//        activeCalls[call.uuid!.uuidString] = call
//        callKitCompletionCallback = completionHandler
//    }
//    
//    func reportIncomingCall(from: String, uuid: UUID) {
//        guard let provider = callKitProvider else {
//            NSLog("CallKit provider not available")
//            return
//        }
//        let callHandle = CXHandle(type: .generic, value: from)
//        let callUpdate = CXCallUpdate()
//        callUpdate.remoteHandle = callHandle
//        callUpdate.supportsDTMF = true
//        callUpdate.supportsHolding = true
//        callUpdate.supportsGrouping = false
//        callUpdate.supportsUngrouping = false
//        callUpdate.hasVideo = false
//        provider.reportNewIncomingCall(with: uuid, update: callUpdate) { error in
//            if let error = error {
//                NSLog("Failed to report incoming call successfully: \(error.localizedDescription).")
//            } else {
//                NSLog("Incoming call successfully reported.")
//            }
//        }
//    }
//    
//    func performAnswerVoiceCall(uuid: UUID, completionHandler: @escaping (Bool) -> Void) {
//        guard let callInvite = activeCallInvites[uuid.uuidString] else {
//            NSLog("No CallInvite matches the UUID")
//            return
//        }
//        
//        let acceptOptions = AcceptOptions(callInvite: callInvite) { builder in
//            builder.uuid = callInvite.uuid
//        }
//        
//        let call = callInvite.accept(options: acceptOptions, delegate: self)
//        activeCall = call
//        activeCalls[call.uuid!.uuidString] = call
//        callKitCompletionCallback = completionHandler
//        activeCallInvites.removeValue(forKey: uuid.uuidString)
//        
//        guard #available(iOS 13, *) else {
//          // incomingPushHandled()
//            return
//        }
//    }
//}
//
