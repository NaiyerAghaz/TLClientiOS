//
//  AudioCallViewController.swift
//  TLClientApp
//
//  Created by SMIT 005 on 10/12/21.
//

import UIKit
import Alamofire
import TwilioVoice
import CallKit
import SteppableSlider
import AVFoundation
class AddParticipantsCollectionsViewCell : UICollectionViewCell {
    
    @IBOutlet weak var participatsNumberLbl: UILabel!
    @IBOutlet weak var endCallBtn: UIButton!
    @IBOutlet weak var participatsImg: UIImageView!
}
class AudioCallViewController: UIViewController, AVAudioPlayerDelegate, MICountryPickerDelegate  {
    
    @IBOutlet weak var participentListView: UIView!
    @IBOutlet weak var showParticipantsListCV: UICollectionView!
    
    @IBOutlet weak var translationlbl: UILabel!
    
    @IBOutlet weak var callTypeLbl: UILabel!
    @IBOutlet weak var dateAndTimeLbl: UILabel!
    @IBOutlet weak var roomNoLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var vendorNameRatingLbl: UILabel!
    @IBOutlet weak var ratingChangelbl: UILabel!
    @IBOutlet weak var vendorImgView: UIImageView!
    @IBOutlet weak var audioCallView: UIView!
    
    @IBOutlet weak var experienceLbl: UILabel!
    @IBOutlet weak var lblTargetLang: UILabel!
    var isCallReceivedNotify = false
    var ratingValue:Int? = nil
    var callQualityValue = ""
    var callDuration = ""
    var callStartDate = ""
    var apiOPiCallRoomDetailsResponseModel:ApiOPiCallRoomDetailsResponseModel?
    var roomID,sourceLangID,targetLangID,sourceLangName,targetLangName,patientname,patientno: String?
    var apiCheckCallStatusResponseModel = [ApiCheckCallStatusResponseModel]()
    var apiGetProfileResponseModel:ApiGetProfileResponseModel?
    var timer = Timer()
    var ringToneTimer = Timer()
    var ringingTime = 60
    var isToThirdPartyCall = false
    var ccid = ""
    var vendorID = ""
    var vendorName = ""
    var vendorImg = ""
    var apiPostFeedbackResponseModel:ApiPostFeedbackResponseModel?
    var apiGetMemberInRoomDetailDataModel:ApiGetMemberInRoomDetailDataModel?
    var userInitiatedDisconnect: Bool = false
    var ringtonePlayer: AVAudioPlayer?
    var activeCallInvites: [String: CallInvite]! = [:]
    var incomingPushCompletionCallback: (() -> Void)?
    var outgoingValue = ""
    var isClientDisconnectCall = false
    var playCustomRingback = false
    var audioDevice = DefaultAudioDevice()
    var callKitCompletionCallback: ((Bool) -> Void)? = nil
    var callKitProvider: CXProvider?
    var twilioToken : String?
    var activeCall: Call? = nil
    @IBOutlet weak var hosterView: UIView!
    var activeCalls: [String: Call]! = [:]
    var vdoCallVM = VDOCallViewModel()
    @IBOutlet weak var conferenceCallView: UIView!
    @IBOutlet weak var countryCodeImg: UIImageView!
    @IBOutlet weak var countryCodeTF: UITextField!
    let kCachedDeviceToken = "CachedDeviceToken"
    @IBOutlet weak var phoneNumTF: UITextField!
    let kCachedBindingDate = "CachedBindingDate"
    @IBOutlet weak var hostNameLbl: UILabel!
    
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var vendorIMG: UIImageView!
    @IBOutlet weak var vendorNameLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var hostImg: UIImageView!
    @IBOutlet weak var callDurationLbl: UILabel!
    @IBOutlet weak var callTimeTitleLbl: UILabel!
    
    var isVoiceConnected = false
    var timerDuration : Timer?
    var isNewVendor = false
    var notLifttimerDuration = Timer()
    var seconds = 0, CountNumber = 0
    var countryCode = ""
    var phoneCallsList  = [String]()
    var callSIDList = [String]()
    var conferenceSIDList = [String]()
    var participantsList = [ParticipantsList]()
    var callKitCallController = CXCallController()
    @IBOutlet weak var addParticipantsBtn: UIButton!
    var apiAddparticipantsOPIResponseModle:ApiAddparticipantsOPIResponseModle?
    override func viewDidLoad() {
        super.viewDidLoad()
        addParticipantsBtn.isHidden = true
        //  self.vendorIMG.layer.cornerRadius = self.vendorIMG.bounds.height / 2
        
        createVRICallVendor()
        self.addParticipantsBtn.isUserInteractionEnabled = false
        self.showParticipantsListCV.delegate = self
        self.showParticipantsListCV.dataSource = self
        hosterView.isHidden = true
        self.audioCallView.isHidden = false
        
        self.callTimeTitleLbl.isHidden = true
        self.callDurationLbl.isHidden = true
        self.participentListView.isHidden = true
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.vendorAnswered(notification:)), name: Notification.Name("vendorAnswered"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeParticipants(notification:)), name: Notification.Name("removeParticipants"), object: nil)
        
        self.hostImg.layer.cornerRadius = self.hostImg.bounds.height / 2
        
        self.vendorNameLbl.text = ""
        self.titleLbl.text = "Connecting To Interpreters"
        //        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "call", withExtension: "gif")!)
        //        let advTimeGif = UIImage.gifImageWithData(imageData!)
        //        let callingImageView = UIImageView(image: advTimeGif)
        //        callingImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100.0)
        //        self.ringingImgView.addSubview(callingImageView)
        self.playCustomRingback = true
        let configuration = CXProviderConfiguration(localizedName: "Voice Quickstart")
        configuration.maximumCallGroups = 1
        configuration.maximumCallsPerCallGroup = 1
        callKitProvider = CXProvider(configuration: configuration)
        if let provider = callKitProvider {
            provider.setDelegate(self, queue: nil)
        }
        self.conferenceCallView.isHidden = true
        self.conferenceCallView.layer.cornerRadius = 20
        self.conferenceCallView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        TwilioVoiceSDK.audioDevice = audioDevice
        getProfileimg()
        
        self.countryCodeTF.setLeftPaddingPoints(60)
        self.countryCodeTF.attributedPlaceholder = NSAttributedString(string: "(US)+1", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        setFlagAndPhoneNumberCodeLeftViewIcon(icon: UIImage(named: "down button arrow")!)
    }
    @objc func removeParticipants(notification: Notification){
        
        let conferenceSID = notification.userInfo?["conferenceSID"] as? String
        
        let participantsArr = self.participantsList
        for (index , item) in participantsArr.enumerated() {
            if item.callSid == conferenceSID ?? "" {
                self.participantsList.remove(at: index)
                
            }
        }
        DispatchQueue.main.async {
            self.showParticipantsListCV.reloadData()
        }
        
    }
    func setFlagAndPhoneNumberCodeLeftViewIcon(icon: UIImage) {
        let btnView = UIButton(frame: CGRect(x: 0, y: 0, width: 6.32, height: 3.08))
        btnView.setImage(icon, for: .normal)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right:  10)
        self.countryCodeTF.rightViewMode = .always
        self.countryCodeTF.rightView = btnView
    }
    //MARK:recallVendor
    @objc func recallVendor(){
        if self.isVoiceConnected {
            self.notLifttimerDuration.invalidate()
        }else {
            if self.isNewVendor {
                //show alert here
                let refreshAlert = UIAlertController(title: "Alert", message: "We couldn't find any vendors at this moment, Please try again.", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    print("Handle Ok logic here")
                    self.notLifttimerDuration.invalidate()
                    //                      self.ringToneTimer.invalidate()
                    //                    if self.activeCall != nil {
                    //                        print("active call not empty ")
                    //                        let uuid = self.activeCall?.uuid ?? UUID()
                    //                        self.performEndCallAction(uuid: uuid)
                    //                    }
                    DispatchQueue.main.async {
                        self.callDisconnetedByVendorAndCustomerEnd()
                    }
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            }else {
                if isClientDisconnectCall == false {
                    getVendorID()
                }
                
                
            }
        }
    }
    @objc func sliderValueChanged(_ sender: SteppableSlider) {
        print(sender.value) // 0 ~ 4
        sender.value = round(sender.value)
        switch sender.value {
        case 0:
           
            self.callQualityValue = "Poor"
            experienceLbl.text = "Poor"
        case 1:
            
            self.callQualityValue = "Average"
            experienceLbl.text = "Average"
        case 2:
            
            self.callQualityValue = "Good"
            experienceLbl.text = "Good"
        case 3:
           
            self.callQualityValue = "Very Good"
            experienceLbl.text = "Very Good"
        case 4:
            
            self.callQualityValue = "Excellent"
            experienceLbl.text = "Excellent"
        case 5:
            
            self.callQualityValue = "Excellent"
            experienceLbl.text = "Excellent"
        default:
            print("Awesome")
        }
    }
    
    @objc func slider2ValueChanged(_ sender: SteppableSlider) {
        print(sender.value) // 0 ~ 4
        sender.value = round(sender.value)
        switch sender.value {
        case 0:
            
            ratingValue = 1
            ratingChangelbl.text = "Poor"
        case 1:
            
            ratingValue = 2
            ratingChangelbl.text = "Average"
        case 2:
            
            ratingValue = 3
            ratingChangelbl.text = "Good"
        case 3:
            
            ratingValue = 4
            ratingChangelbl.text = "Very Good"
        case 4:
           
            ratingValue = 5
            ratingChangelbl.text = "Excellent"
        case 5:
            
            ratingValue = 5
            ratingChangelbl.text = "Excellent"
        default:
            print("Awesome")
        }
        
    }
    @objc func vendorAnswered(notification: Notification){
        print("vendor answer")
        self.timerDuration = nil
        self.isCallReceivedNotify = true
        self.addParticipantsBtn.isHidden = false
        self.isVoiceConnected = true
        self.stopRingback()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        let startDate = dateFormatter.string(from: Date())
        self.callStartDate = startDate
        self.callDurationLbl.isHidden = false
        self.callTimeTitleLbl.isHidden = false
        self.ringToneTimer.invalidate()
        self.notLifttimerDuration.invalidate()
        self.addParticipantsBtn.isUserInteractionEnabled = true
        //getfeedbackDatils()
        getOPIDetailsByRoomID()
        seconds = 0;
        CountNumber = 0;
        
        self.timerDuration = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onTimerStart), userInfo: nil, repeats: true)
        
        
    }
    @objc func onTimerStart(){
        if isVoiceConnected {
            CountNumber = CountNumber + 1;
            let seconds = CountNumber % 60;
            let  minutes = (CountNumber / 60) % 60;
            let hours = (CountNumber / 3600);
            print("time duration ",hours,minutes,seconds)
            self.titleLbl.text = "OPI Call"
            //   self.callDurationLbl.text = "\(hours):\(minutes):\(seconds)"
            self.callDurationLbl.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            self.callDuration = String(format: "%02d:%02d:%02d", hours, minutes, seconds)//"\(hours):\(minutes):\(seconds)"
        }
    }
    
    @IBAction func actionCountryCode(_ sender: UIButton) {
        print("action country code ")
        self.navigationItem.setHidesBackButton(false, animated: true)
        
        let picker = MICountryPicker { (name, code ) -> () in
            
            //            print("picked code : ",code)
            //            print("PICKED COUNTRY IS \(name)")
            //            let bundle = "assets.bundle/"
            //            print("IMAGE IS \(UIImage( named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil))")
        }
        picker.delegate = self
        // Display calling codes
        picker.showCallingCodes = true
        // or closure
        picker.didSelectCountryClosure = { name, code in
            picker.navigationController?.isNavigationBarHidden=true
            //picker.navigationController?.popViewController(animated: true)
            picker.dismiss(animated: true, completion: nil)
            //            print("code is ",code)
            //            let bundle = "assets.bundle/"
            //
            //            let image = UIImage( named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
            //            print("IMAGE IS \(image)")
            
        }
        picker.didSelectCountryWithCallingCodeClosure = { name , code , dialCode in
            picker.navigationController?.isNavigationBarHidden=true
            //picker.navigationController?.popViewController(animated: true)
            print("code is ",code)
            let bundle = "assets.bundle/"
            
            let image = UIImage( named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
          
            self.countryCodeTF.text = dialCode
            self.countryCode = dialCode
            self.countryCodeImg.image = image
            
        }
        self.present(picker, animated: true, completion: nil)
        //navigationController?.pushViewController(picker, animated: true)
    }
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String ) {
        picker.navigationController?.isNavigationBarHidden=true //?.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: true)
        //                print("CODE IS \(code)")
        //
        //                print("Dial Code ",dialCode)
        //                let bundle = "assets.bundle/"
        //                print("IMAGE IS \(UIImage( named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil))")
        
        
        //DialCode = "\(dialCode)"
        // countryCodeTF.text = "\(dialCode)"//"Selected Country: \(name) , \(code)"
        //tempImageView.image = UIImage( named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
        
    }
    @IBAction func cancelConferenceCallView(_ sender: UIButton) {
        self.conferenceCallView.isHidden = true
    }
    @IBAction func actionAddConferenceCall(_ sender: UIButton) {
        //self.conferenceCallView.isHidden = false
        if phoneNumTF.text == "" {
            self.view.makeToast("Please enter phone number.")
        }else if countryCodeTF.text == "" {
            self.view.makeToast("Please enter country code.")
        }else {
            if self.participantsList.count > 4 {
                self.view.makeToast("Conference call limit 5 members.")
            }else {
                conferenceCall()
            }
            
        }
    }
    @IBAction func actionRatingCancelBtn(_ sender: UIButton) {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    @IBAction func actionMicBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if (sender.isSelected) {
            // setImage here volume
            self.activeCall?.isMuted = true
            // sender.setImage(UIImage(named: "ic_mic_mute"), for: .normal)
            print("voice muted")
        }else {
            //setImage for volume muted
            self.activeCall?.isMuted = false
            //  sender.setImage(UIImage(named: "ic_mic"), for: .normal)
            print("voice un muted")
        }
    }
    @IBAction func actionInviteParticipants(_ sender: UIButton) {
        print("button tapped")
        self.conferenceCallView.isHidden = false
        
    }
    @IBAction func actionSpeakerBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if (sender.isSelected) {
            // setImage here volume
            // sender.setImage(UIImage(named: "speaker.slash.fill"), for: .normal)
            toggleAudioRoute(toSpeaker: true)
        }else {
            //setImage for volume muted
            //  sender.setImage(UIImage(named: "speaker.wave.2"), for: .normal)
            toggleAudioRoute(toSpeaker: true)
        }
        
    }
    func getVendorIDs(request : [String : Any], completionHandler : @escaping(Bool?, Error?) -> ()){
        self.apiCheckCallStatusResponseModel.removeAll()
        
        let urlString = APi.getCheckCallStatus.url
        print("url and parameter are getVendorIDs", request , urlString)
        AF.request(urlString, method: .post, parameters: request, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    guard let daata86 = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiCheckCallStatusResponseModel = try jsonDecoder.decode([ApiCheckCallStatusResponseModel].self, from: daata86)
                        print("Success getVendorIDs Model ",self.apiCheckCallStatusResponseModel.first?.result ?? "")
                        let str = self.apiCheckCallStatusResponseModel.first?.result ?? ""
                        
                        print("STRING DATA IS \(str)")
                        let data = str.data(using: .utf8)!
                        do {
                            //
                            print("DATAAA ISSS \(data)")
                            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                            {
                                
                                let newjson = jsonArray.first
                                let userInfo = newjson?["UserInfo"] as? [[String:Any]]
                                let statusInfo = newjson?["StatusInfo"] as? [[String:Any]] // use the json here
                                let userIfo = userInfo?.first
                                let vendorId = userIfo?["UserId"] as? Int
                                let vendorName = userIfo?["CustomerDisplayName"] as? String
                                let vendorimg = userIfo?["CustomerImage"] as? String
                                self.vendorID = String(vendorId ?? 0)
                                self.vendorName = vendorName ?? ""
                                self.vendorImg = vendorimg ?? ""
                                self.vendorNameLbl.text = ""// self.vendorName
                                // let baseUrl = "https://lsp.totallanguage.com/"
                                let vendorImgUrl = nBaseUrl + self.vendorImg
                                
                                self.vendorIMG.sd_setImage(with: URL(string: vendorImgUrl), placeholderImage: UIImage(named: "person.circle.fill"))
                                
                                completionHandler(true , nil)
                                
                            } else {
                                print("bad json")
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                        
                    } catch{
                        
                        print("error block getVendorIDs Data  " ,error)
                    }
                case .failure(_):
                    print("Respose Failure getVendorIDs ")
                    
                }
            })
    }
    func getVendorID(){
        let userID = GetPublicData.sharedInstance.userID
        let sourceID = self.sourceLangID ?? ""
        let targetID = self.targetLangID ?? ""
        let ccid = self.ccid
        let srchString = "<Info><CUSTOMERID>\(userID)</CUSTOMERID><TYPE>O</TYPE><SOURCE>\(sourceID)</SOURCE><TARGET>\(targetID)</TARGET><CC_ID>\(ccid)</CC_ID></Info>"
        let param = ["strSearchString" :srchString]
        self.getVendorIDs(request: param) { (completion, error) in
            if completion ?? false {
                self.isNewVendor = true
                self.createVRICallVendor()
            }else {
                
            }
        }
    }
    func getfeedbackDatils(){
        //new changes
        let sB = UIStoryboard(name: Storyboard_name.home, bundle: nil)
        let fb = sB.instantiateViewController(identifier: "VRIOPIFeedbackController") as! VRIOPIFeedbackController
        fb.roomID = roomID
        fb.targetLang = targetLangName
        fb.duration = self.callDuration //lblTimeSpeak.text//callStartTime
        fb.dateAndTime = self.callStartDate
        fb.calltype = "O"
        fb.modalPresentationStyle = .overFullScreen
        // SwiftLoader.hide()
        self.present(fb, animated: true, completion: nil)
        
    }
    
    func endVRICallOPI(){
        let roomID = self.roomID ?? ""
        let srchString = "<VRIHANGUP><ACTION>C</ACTION><ROOMID>\(roomID)</ROOMID></VRIHANGUP>"
        let param = ["strSearchString":srchString]
        endVRICallOPI(request: param) { (completion, error) in
            if completion ?? false{
                print("completion true  end vri call ")
                
                self.isVoiceConnected = false
                
                self.audioCallView.isHidden = true
                if self.isCallReceivedNotify{
                    
                    self.getfeedbackDatils()
                }
                else {
                    self.dismissViewControllers()
                }
                
            }else{
                print("completion false")
            }
        }
        
    }
    func endVRICallOPI(request:[String:Any], completionHandler :@escaping(Bool?, Error?) -> ()){
        debugPrint("endVRICallOPI--->", request)
        let urlString = APi.endVRICall.url
        // self.apiCreateVRICallClientResponseModel.removeAll()
        print("url and parameter for endVRICallOPI", urlString, request)
        AF.request(urlString, method: .post, parameters: request, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    
                    print("call endVRICallOPI")
                    completionHandler(true , nil)
                    
                case .failure(_):
                    print("Respose Failure endVRICallOPI ")
                    
                }
            })
    }
    func opiEndCall(){
        self.opiEndCallWithCompletion { (completion, error) in
            if completion ?? false {
                print("success end call")
            }else {
                print("failed endcall ")
            }
        }
    }
    func opiEndCallWithCompletion(completionHandler :@escaping(Bool?, Error?) -> ()){
        
        let roomID = self.roomID ?? ""
        let urlString = "https://lsp.totallanguage.com/OPI/HangupCall?roomno=\(roomID)"
        // self.apiCreateVRICallClientResponseModel.removeAll()
        print("url and parameter for endVRICallOPI", urlString )
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    
                    print("call endVRICallOPI")
                    completionHandler(true , nil)
                    
                case .failure(_):
                    print("Respose Failure endVRICallOPI ")
                    
                }
            })
    }
    func getProfileimg(){
        if Reachability.isConnectedToNetwork() {
            SwiftLoader.show(animated: true)
            
            let userId = userDefaults.string(forKey: "userId") ?? ""
            let urlPrefix = "userid=\(userId)"
            let urlString = "\(APi.getProfileImg.url)" + urlPrefix
            print("url to get image is \(urlString)")
            AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseData(completionHandler: { [self] (response) in
                    SwiftLoader.hide()
                    switch(response.result){
                        
                    case .success(_):
                        print("Respose Success ")
                        guard let daata87 = response.data else { return }
                        do {
                            let jsonDecoder = JSONDecoder()
                            self.apiGetProfileResponseModel = try jsonDecoder.decode(ApiGetProfileResponseModel.self, from: daata87)
                            print("Success")
                            // let baseUrl = "https://lsp.totallanguage.com"
                            let postUrl = self.apiGetProfileResponseModel?.uSERLOGOS?.first?.imageData ?? ""
                            let imgUrl = nBaseUrl + postUrl
                            // let vendorImgUrl = nBaseUrl + self.vendorImg
                            hostImg.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "person.circle.fill"))
                            
                            //print("vendorImg",vendorImgUrl)
                            userImageURl = imgUrl
                            let userName = userDefaults.string(forKey: "username")
                            self.hostNameLbl.text = userName
                            // self.vendorNameLbl.text = self.vendorName
                            
                            self.languageLbl.text = sourceLangName ?? ""
                            self.lblTargetLang.text =  targetLangName ?? ""
                        } catch{
                            
                            print("error block forgot password " ,error)
                        }
                    case .failure(_):
                        print("Respose Failure ")
                        
                    }
                })}
        else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
    }
    @IBAction func actionBtnDisconnect(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "OPI call END", message: "Are you sure you want to Discoonect?", preferredStyle: UIAlertController.Style.alert)
        // showAlert(title: "", message: "Are you sure you want to hangup this call?", style: .alert, cancelButton: "Delete", distrutiveButton: "End Call", otherButtons: nil)
        refreshAlert.addAction(UIAlertAction(title: "End Call", style: .default, handler: { (action: UIAlertAction!) in
            //            let uuid = self.activeCall?.uuid ?? UUID()
            //            self.performEndCallAction(uuid: uuid)
            //          print("Handle Ok logic here")
            //               self.endVRICallOPI()
            //               self.opiEndCall()
            //               self.ringToneTimer.invalidate()
            //            self.timerDuration.invalidate()
            //               self.isClientDisconnectCall = true
            //            DispatchQueue.main.async {
            //                if (self.callKitProvider != nil) {
            //                    self.callKitProvider?.invalidate()
            //                }
            //                self.audioDevice.isEnabled = false
            //
            //            }
            DispatchQueue.main.async {
                self.callDisconnetedByVendorAndCustomerEnd()
            }
            
            
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    public func callDisconnetedByVendorAndCustomerEnd(){
        TwilioVoiceSDK.audioDevice.stopCapturing()
        let uuid = self.activeCall?.uuid ?? UUID()
        self.performEndCallAction(uuid: uuid)
        DispatchQueue.main.async {
            self.ringToneTimer.invalidate()
            if self.timerDuration != nil {
                self.timerDuration!.invalidate()
                self.timerDuration = nil
            }
           
            self.isClientDisconnectCall = true
            
            if (self.callKitProvider != nil) {
                self.callKitProvider?.invalidate()
            }
            if self.activeCall != nil && self.activeCall?.state == .connected  {
                
                self.activeCall?.disconnect()
            }
            self.endVRICallOPI()
            self.opiEndCall()
        }
        
        // self.audioDevice.isEnabled = true
        
    }
    func createVRICallVendor(){
        print("vendorId is ",self.vendorID)
        if self.vendorID == "" || self.vendorID == "0" {
            print("alertShow")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                let refreshAlert = UIAlertController(title: "Alert", message: "We couldn't find any vendors at this moment,Please try again.", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    print("Handle Ok logic here")
                   
                    /*  self.ringToneTimer.invalidate()
                     if self.activeCall != nil{
                     
                     let uuid = self.activeCall?.uuid ?? UUID()
                     self.performEndCallAction(uuid: uuid)
                     }*/
                    DispatchQueue.main.async {
                        self.callDisconnetedByVendorAndCustomerEnd()
                    }
                    
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            }
            
            
        }else {
            let ccid = self.ccid
            let vendorID = self.vendorID//"218925"
            let searchStr = "<VRIVENDOR><ACTION>R</ACTION><ID>0</ID><CCID>\(ccid)</CCID><VENDORIDS>\(vendorID)</VENDORIDS></VRIVENDOR>"
            let parameter = ["strSearchString":searchStr]
            self.getCreateVRICallVendor(req: parameter) { (completion, error) in
                if completion ?? false {
                    print("getCreateVRICallVendor ")
                    // call get vendor id here
                    self.callOption()
                }else {
                    print("getVRICallClient false ")
                }
            }
        }
        
    }
    func getOPIDetailsByRoomID(){
        self.apiOPiCallRoomDetailsResponseModel = nil
        let urlString = APi.getOPIDetailsByRoomID.url
        // self.apiCreateVRICallClientResponseModel.removeAll()
        let parameter = [
            "RoomNo":self.roomID ?? ""
        ]
        print("url and parameter for getCreateVRICallVendor", urlString)
        AF.request(urlString, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    
                    print("call start Audio Controller ")
                    guard let daata88 = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiOPiCallRoomDetailsResponseModel = try jsonDecoder.decode(ApiOPiCallRoomDetailsResponseModel.self, from: daata88)
                        self.vendorImg = self.apiOPiCallRoomDetailsResponseModel?.roomDetails?.first?.vendorImage ?? ""
                        self.vendorName = self.apiOPiCallRoomDetailsResponseModel?.roomDetails?.first?.vendorName ?? ""
                        
                        let vendorImgUrl = nBaseUrl + self.vendorImg
                        print("vendorImgUrl--->",vendorImgUrl)
                        self.vendorIMG.sd_setImage(with: URL(string: vendorImgUrl), placeholderImage: UIImage(named: "person.circle.fill"))
                        self.vendorNameLbl.text = self.vendorName
                    }catch {
                        
                    }
                    
                case .failure(_):
                    print("Respose Failure getCreateVRICallClient ")
                    
                }
            })
        
    }
    func getCreateVRICallVendor(req:[String:Any], completionHandler:@escaping(Bool?, Error?) -> ()){
        debugPrint("priorityPara--->", req)
        let urlString = APi.createVRICallVendor.url
        // self.apiCreateVRICallClientResponseModel.removeAll()
        print("url and parameter for getCreateVRICallVendor", urlString, req)
        AF.request(urlString, method: .post, parameters: req, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    
                    print("call start Audio Controller ",response)
                    completionHandler(true , nil)
                    
                case .failure(_):
                    completionHandler(false , nil)
                    print("Respose Failure getCreateVRICallClient ")
                    
                }
            })
        
    }
    func callOption(){
        // self.outgoingValue = "211683"
        let uuid = UUID()
        let handle = "Voice Call"
        self.performStartCallAction(uuid: uuid, handle: handle)
        
    }
    func toggleAudioRoute(toSpeaker: Bool) {
        // The mode set by the Voice SDK is "VoiceChat" so the default audio route is the built-in receiver. Use port override to switch the route.
        audioDevice.block = {
            DefaultAudioDevice.DefaultAVAudioSessionConfigurationBlock()
            
            do {
                if toSpeaker {
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
                } else {
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
                }
            } catch {
                NSLog(error.localizedDescription)
            }
        }
        
        audioDevice.block()
    }
    func conferenceCall(){
        let phoneNum = (self.countryCodeTF.text ?? "") + (self.phoneNumTF.text ?? "")
        self.conferenceCallWithCompletion(phoneNumber: phoneNum) { (completionHandler, callSid , conferenceSid) in
            if completionHandler ?? false {
                print("callersid ", callSid)
                let newItem = ParticipantsList(phoneNum: phoneNum, callSid: callSid ?? "", conferenceSID: conferenceSid ?? "")
                self.conferenceCallView.isHidden = true
                
                
                self.participantsList.append(newItem)
                self.participentListView.isHidden = false
                self.showParticipantsListCV.reloadData()
                
                
                self.phoneCallsList.append(phoneNum)
                self.callSIDList.append(callSid ?? "")
                
            }else {
                
            }
        }
    }
    func conferenceCallWithCompletion(phoneNumber : String ,completionHandler :@escaping(Bool?, String? , String?) -> ()){
        let roomId = self.roomID ?? ""
        let userId = GetPublicData.sharedInstance.userID
        let companyId = GetPublicData.sharedInstance.companyID
        
        let urlString = "https://lsp.totallanguage.com/OPI/Addparticipant?roomno=\(roomId)&clientid=\(userId)&companyid=\(companyId)&participantcontact=\(phoneNumber)&usertype=Client"
        
        print("url  for conferenceCallWithCompletion", urlString )
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("conferenceCallWithCompletion")
                    guard let daata89 = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiAddparticipantsOPIResponseModle = try jsonDecoder.decode(ApiAddparticipantsOPIResponseModle.self, from: daata89)
                        let callSid = self.apiAddparticipantsOPIResponseModle?.callSid ?? ""
                        let conferenceSid  = self.apiAddparticipantsOPIResponseModle?.conferenceSid ?? ""
                        completionHandler(true , callSid , conferenceSid )
                    } catch  {
                        
                    }
                    
                    
                case .failure(_):
                    print("Respose Failure endVRICallOPI ")
                    
                }
            })
        
    }
    
    
    
    func removeParticipatnsWithCompletion(callSID : String ,conferenceSID : String ){
        //        let roomId = self.roomID ?? ""
        //        let userId = GetPublicData.sharedInstance.userID
        //        let companyId = GetPublicData.sharedInstance.companyID
        
        let urlString = "https://lsp.totallanguage.com/OPI/Removeparticipant?callsid=\(callSID)&roomno=\(conferenceSID)"
        
        print("url  for removeParticipatnsWithCompletion", urlString )
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("removeParticipatnsWithCompletion")
                    guard let daata90 = response.data else { return }
                    let participantsArr = self.participantsList ?? [ParticipantsList]()
                    for (indexx , itema) in participantsArr.enumerated() {
                        if itema.callSid == callSID {
                            print("item to remove in btn endcall",itema.callSid)
                            self.participantsList.remove(at: indexx)
                            self.showParticipantsListCV.reloadData()
                        }
                    }
                    print("participants list after deletion ",self.participantsList)
                    DispatchQueue.main.async {
                        self.showParticipantsListCV.reloadData()
                    }
                    
                    
                case .failure(_):
                    print("Respose Failure endVRICallOPI ")
                    
                }
            })
        
    }
    //MARK: - Call Kit Actions
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        NSLog("provider:performSetMutedAction:")
        
        if let call = activeCalls[action.callUUID.uuidString] {
            call.isMuted = action.isMuted
            action.fulfill()
        } else {
            action.fail()
        }
    }
    func performStartCallAction(uuid: UUID, handle: String) {
        guard let provider1 = callKitProvider else {
            NSLog("CallKit provider not available")
            return
        }
        
        let callHandle = CXHandle(type: .generic, value: handle)
        let startCallAction = CXStartCallAction(call: uuid, handle: callHandle)
        let transaction = CXTransaction(action: startCallAction)
        
        callKitCallController.request(transaction) { error in
            if let error = error {
                NSLog("StartCallAction transaction request failed: \(error.localizedDescription)")
                return
            }
            
            NSLog("StartCallAction transaction request successful")
            
            let callUpdate = CXCallUpdate()
            
            callUpdate.remoteHandle = callHandle
            callUpdate.supportsDTMF = true
            callUpdate.supportsHolding = true
            callUpdate.supportsGrouping = false
            callUpdate.supportsUngrouping = false
            callUpdate.hasVideo = false
            
            provider1.reportCall(with: uuid, updated: callUpdate)
            
        }
    }
    func reportIncomingCall(from: String, uuid: UUID) {
        guard let provider2 = callKitProvider else {
            NSLog("CallKit provider not available")
            return
        }
        
        let callHandle = CXHandle(type: .generic, value: from)
        let callUpdate = CXCallUpdate()
        
        callUpdate.remoteHandle = callHandle
        callUpdate.supportsDTMF = true
        callUpdate.supportsHolding = true
        callUpdate.supportsGrouping = false
        callUpdate.supportsUngrouping = false
        callUpdate.hasVideo = false
        
        provider2.reportNewIncomingCall(with: uuid, update: callUpdate) { error in
            if let error = error {
                NSLog("Failed to report incoming call successfully: \(error.localizedDescription).")
            } else {
                NSLog("Incoming call successfully reported.")
            }
        }
    }
    
    func getTwillioToken(completionHandler:@escaping(Bool?, String?,Error?) -> ()){
        
        let urlString = "https://lsp.totallanguage.com/OPI/GetOPIAccessToken?identity=USER_ID&deviceType=clientIos"
        
        print("url and parameter for getCreateVRICallVendor", urlString)
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    
                    print("get twillio token  ",response)
                    guard let daata90 = response.data else { return }
                    print(String(data: daata90, encoding: .utf8)!)
                    let token = String(data: daata90, encoding: .utf8)!
                    print("token is ",token)
                    completionHandler(true,token,nil)
                case .failure(_):
                    print("Respose Failure getCreateVRICallClient ")
                    
                }
            })
        
    }
    func performVoiceCall(uuid: UUID, client: String?, completionHandler: @escaping (Bool) -> Void) {
        print("performVoiceCall function called")
        
        getTwillioToken { (completion, token, error) in
            print("twillio token is",self.twilioToken)
            // self.startPreview()
            // myAudio.stop()
            // self.timer.invalidate()
            //self.doConnectTwilio(twilioToken: (model?.token)!)
            self.twilioToken = token ?? ""
            if self.twilioToken != nil {
                let roomId = self.roomID ?? ""
                let vendorId = self.vendorID//self.vendorID
                let twimlParamTo = [
                    "vendorids" :vendorId,
                    "roomno":roomId,
                    "clientid":GetPublicData.sharedInstance.userID,
                    "calltopropio":"directtoVendor"
                ]
                print("param for audio call in performVoiceCall",twimlParamTo , self.twilioToken)
                let connectOptions = ConnectOptions(accessToken: self.twilioToken ?? "") { builder in
                    builder.params = twimlParamTo
                    builder.uuid = uuid
                }
                
                let call = TwilioVoiceSDK.connect(options: connectOptions, delegate: self)
                
                self.activeCall = call
                self.activeCalls[call.uuid!.uuidString] = call
                self.callKitCompletionCallback = completionHandler
                completionHandler(true)
            }else {
                self.view.makeToast("Call failed")
                print("call Failed kf;lklns")
            }
        }
    }
    
    func performAnswerVoiceCall(uuid: UUID, completionHandler: @escaping (Bool) -> Void) {
        guard let callInvite = activeCallInvites[uuid.uuidString] else {
            NSLog("No CallInvite matches the UUID")
            return
        }
        
        let acceptOptions = AcceptOptions(callInvite: callInvite) { builder in
            builder.uuid = callInvite.uuid
        }
        
        let call = callInvite.accept(options: acceptOptions, delegate: self)
        activeCall = call
        activeCalls[call.uuid!.uuidString] = call
        callKitCompletionCallback = completionHandler
        
        activeCallInvites.removeValue(forKey: uuid.uuidString)
        
        guard #available(iOS 13, *) else {
            incomingPushHandled()
            return
        }
    }
    func incomingPushHandled() {
        guard let completion = incomingPushCompletionCallback else { return }
        
        incomingPushCompletionCallback = nil
        completion()
    }
    func performEndCallAction(uuid: UUID) {
        print("end call UDID:", uuid)
        let endCallAction = CXEndCallAction(call: uuid)
        let transaction = CXTransaction(action: endCallAction)
        
        callKitCallController.request(transaction) { error in
            if let error = error {
                NSLog("EndCallAction transaction request failed: \(error.localizedDescription).")
            } else {
                NSLog("EndCallAction transaction request successful")
            }
        }
    }
    @objc func playRingback() {
        
        
        let ringtonePath = URL(fileURLWithPath: Bundle.main.path(forResource: "incoming", ofType: "mp3")!)
        print("play ringtone")
        do {
            ringtonePlayer = try AVAudioPlayer(contentsOf: ringtonePath)
            ringtonePlayer?.delegate = self
            ringtonePlayer?.numberOfLoops = -1
            
            //ringtonePlayer?.volume = 1.0
            ringtonePlayer?.play()
            
            //            let sound = try AVAudioPlayer(contentsOf: ringtonePath)
            //
            //            sound.play()
        } catch {
            NSLog("Failed to initialize audio player")
        }
    }
    func stopRingback() {
        guard let ringtonePlayer = ringtonePlayer, ringtonePlayer.isPlaying else { return }
        
        ringtonePlayer.stop()
    }
    
    
}
//MARK: - Call Delegates
extension AudioCallViewController : CallDelegate{
    func callDidConnect(call: Call) {
        print("callDidConnect")
        if playCustomRingback {
            
        }
        if let callKitCompletionCallback = callKitCompletionCallback {
            
            callKitCompletionCallback(true)
            stopRingback()
        }
        
    }
    
    func callDidFailToConnect(call: Call, error: Error) {
        print("callDidFailToConnect", error.localizedDescription)
        NSLog("Call failed to connect: \(error.localizedDescription)")
        
        if let completion = callKitCompletionCallback {
            completion(false)
        }
        
        if let provider = callKitProvider {
            provider.reportCall(with: call.uuid!, endedAt: Date(), reason: CXCallEndedReason.failed)
        }
        
        callDisconnected(call: call)
    }
    
    func callDidDisconnect(call: Call, error: Error?) {
        print("without answer call disconnect")
        if let error = error {
            NSLog("Call failed: \(error.localizedDescription)")
        } else {
            NSLog("Call disconnected")
        }
        
        if !userInitiatedDisconnect {
            var reason = CXCallEndedReason.remoteEnded
            
            if error != nil {
                reason = .failed
            }
            
            if let provider = callKitProvider {
                provider.reportCall(with: call.uuid!, endedAt: Date(), reason: reason)
            }
        }
        
        callDisconnected(call: call)
        
        //        self.endVRICallOPI()
        //        self.opiEndCall()
        //        self.ringToneTimer.invalidate()
        //        self.isClientDisconnectCall = true
        
        // let uuid = self.activeCall?.uuid ?? UUID()
        //  self.performEndCallAction(uuid: uuid)
        
    }
    func callDidStartRinging(call: Call) {
        print("callDidStartRinging")
        if playCustomRingback {
            CEnumClass.share.playSounds(audioName: "incoming")
            self.ringToneTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { timer in
                CEnumClass.share.playSounds(audioName: "incoming")
            })
            self.notLifttimerDuration = Timer.scheduledTimer(timeInterval: 18.0, target: self, selector: #selector(recallVendor), userInfo: nil, repeats: true)
            //            DispatchQueue.main.async {
            //                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.ringingCallStart), userInfo: nil, repeats: true)
            //            }
            
            
        }
        
    }
    
    func callDisconnected(call: Call) {
        if call == activeCall {
            activeCall = nil
        }
        
        activeCalls.removeValue(forKey: call.uuid!.uuidString)
        
        userInitiatedDisconnect = false
        
        if playCustomRingback {
            stopRingback()
        }
        self.callDisconnetedByVendorAndCustomerEnd()
        //stopSpin()
        // toggleUIState(isEnabled: true, showCallControl: false)
        // placeCallButton.setTitle("Call", for: .normal)
    }
    @objc  func ringingCallStart(){
        
        // CEnumClass.share.playSounds(audioName: "incoming")
        ringingTime -= 1
        if ringingTime <= 0 {
            myAudio!.stop()
            timer.invalidate()
            ringToneTimer.invalidate()
            dismissViewControllers()
        }
        
    }
}
//MARK: - CXProviderDelegate

extension AudioCallViewController : CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        NSLog("providerDidReset:")
        self.audioDevice.isEnabled = true
    }
    func providerDidBegin(_ provider: CXProvider) {
        NSLog("providerDidBegin")
    }
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        NSLog("provider:didActivateAudioSession:")
        audioDevice.isEnabled = true
    }
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        NSLog("provider:didDeactivateAudioSession:")
        audioDevice.isEnabled = false
    }
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        NSLog("provider:timedOutPerformingAction:")
        audioDevice.isEnabled = false
    }
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        NSLog("provider:performStartCallAction:")
        
        //toggleUIState(isEnabled: false, showCallControl: false)
        //startSpin()
        
        self.callKitProvider?.reportOutgoingCall(with: action.callUUID, startedConnectingAt: Date())
        print("provider start call run ")
        
        performVoiceCall(uuid: action.callUUID, client: "") { success in
            if success {
                NSLog("performVoiceCall() successful")
                self.callKitProvider?.reportOutgoingCall(with: action.callUUID, connectedAt: Date())
            } else {
                NSLog("performVoiceCall() failed")
            }
        }
        
        action.fulfill()
    }
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        NSLog("-------provider:performAnswerCallAction:-------")
        
        self.addParticipantsBtn.isHidden = false
        isCallReceivedNotify = true
        performAnswerVoiceCall(uuid: action.callUUID) { success in
            if success {
                NSLog("performAnswerVoiceCall() successful")
            } else {
                NSLog("performAnswerVoiceCall() failed")
            }
        }
        
        action.fulfill()
    }
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        NSLog("--------provider:performEndCallAction:-------")
        audioDevice.isEnabled = false
        if let invite = activeCallInvites[action.callUUID.uuidString] {
            NSLog("invite.reject() provider:performEndCallAction:")
            invite.reject()
            activeCallInvites.removeValue(forKey: action.callUUID.uuidString)
        } else if let call = activeCalls[action.callUUID.uuidString] {
            NSLog("call.disconnect() provider:performEndCallAction:")
            call.disconnect()
        } else {
            NSLog("Unknown UUID to perform end-call action with")
        }
        
        action.fulfill()
    }
    
}
//MARK: - TVONotificaitonDelegate

extension AudioCallViewController: NotificationDelegate {
    func callInviteReceived(callInvite: CallInvite) {
        NSLog("callInviteReceived:")
        
        /**
         * The TTL of a registration is 1 year. The TTL for registration for this device/identity
         * pair is reset to 1 year whenever a new registration occurs or a push notification is
         * sent to this device/identity pair.
         */
        UserDefaults.standard.set(Date(), forKey: kCachedBindingDate)
        
        let callerInfo: TVOCallerInfo = callInvite.callerInfo
        if let verified: NSNumber = callerInfo.verified {
            if verified.boolValue {
                NSLog("Call invite received from verified caller number!")
            }
        }
        
        let from = (callInvite.from ?? "Voice Bot").replacingOccurrences(of: "client:", with: "")
        
        // Always report to CallKit
        reportIncomingCall(from: from, uuid: callInvite.uuid)
        activeCallInvites[callInvite.uuid.uuidString] = callInvite
    }
    
    func cancelledCallInviteReceived(cancelledCallInvite: CancelledCallInvite, error: Error) {
        NSLog("cancelledCallInviteCanceled:error:, error: \(error.localizedDescription)")
        
        guard let activeCallInvites = activeCallInvites, !activeCallInvites.isEmpty else {
            NSLog("No pending call invite")
            return
        }
        
        let callInvite = activeCallInvites.values.first { invite in invite.callSid == cancelledCallInvite.callSid }
        
        if let callInvite = callInvite {
            performEndCallAction(uuid: callInvite.uuid)
            self.activeCallInvites.removeValue(forKey: callInvite.uuid.uuidString)
        }
    }
    
    
}
//MARK: - Collection Work
extension AudioCallViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participantsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddParticipantsCollectionsViewCell", for: indexPath) as! AddParticipantsCollectionsViewCell
        
        cell.participatsNumberLbl.text = participantsList[indexPath.row].phoneNum
        cell.endCallBtn.tag = indexPath.row
        cell.endCallBtn.addTarget(self , action: #selector(removeParticipantsFromCall), for: .touchUpInside)
        return cell
        
    }
    
    @objc func removeParticipantsFromCall(_ sender: UIButton){
        print("end call tapeed ")
        let callSid = self.participantsList[sender.tag].callSid
        
        let conferenceID = self.participantsList[sender.tag].conferenceSID ?? ""
        removeParticipatnsWithCompletion(callSID: callSid, conferenceSID: conferenceID)
    }
}
struct ParticipantsList {
    var phoneNum : String?
    var callSid : String
    var conferenceSID : String?
}
