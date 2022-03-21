//
//  CallingPopupVC.swift
//  TLClientApp
//
//  Created by Naiyer on 8/25/21.
//

import UIKit
import Alamofire
protocol VideocallDelegate {
    func switchToAudioMethods(roomId:String,sourceLangID: String,targetLangID:String,ccid:String,sourceLangName:String,targetLangName: String,patientno: String,patientname: String, vendorDetails: VendorCallUserInfoModel?)
}
class CallingPopupVC: UIViewController,VideocallDelegate {
    func switchToAudioMethods(roomId:String,sourceLangID: String,targetLangID:String,ccid:String,sourceLangName:String,targetLangName: String,patientno: String,patientname: String,vendorDetails: VendorCallUserInfoModel?) {
        print("roomId!:",roomId,"sourceLangID:",sourceLangID,"targetLangID:",targetLangID,"ccid:",ccid,"sourceLangName:",sourceLangName,"patientno:",patientno,"patientname:",patientname)
        let sB = UIStoryboard(name: Storyboard_name.home, bundle: nil)
        let odoCall = sB.instantiateViewController(identifier: "AudioCallViewController") as! AudioCallViewController
        odoCall.roomID = roomId
        odoCall.sourceLangID = sourceLangID
        odoCall.targetLangID = targetLangID
        odoCall.ccid = ccid
        odoCall.isToThirdPartyCall = false
        odoCall.sourceLangName = sourceLangName
        odoCall.targetLangName = targetLangName
        odoCall.patientno = patientno
        odoCall.patientname = patientname
        odoCall.vendorID = "\(vendorDetails?.UserId ?? 0)"
        odoCall.vendorName = vendorDetails?.CustomerDisplayName ?? ""
        odoCall.vendorImg = vendorDetails?.CustomerImage ?? ""
        odoCall.modalPresentationStyle = .overFullScreen
       
        self.present(odoCall, animated: true, completion: nil)
        
//        odoCall.roomID = roomId
//        odoCall.sourceLangID = sourceID
//        odoCall.targetLangID = targetID
//        odoCall.ccid = self.ccid
//        odoCall.isToThirdPartyCall = false
//        odoCall.sourceLangName = sourceName
//        odoCall.targetLangName = targetName
//        odoCall.patientno = txtPatientClientNumber.text ?? ""
//        odoCall.patientname = txtPatientClientName.text ?? ""
        
//        n.putExtra("tokens", "");
//                            in.putExtra("statustype", "O");
//                            in.putExtra("sourceLid", sourceLid);
//                            in.putExtra("selectedLanguageId", selectedLanguageId);
//                            in.putExtra("touserid", "0");
//                            in.putExtra("pClientName", pClientName);
//                            in.putExtra("pClientNumber", pClientNumber);
//                            in.putExtra("Type", AppConstants.VRIOPIOndemand);
//                            in.putExtra("cId", cId);
    }
    
    @IBOutlet weak var txtPatientClientName: ACFloatingTextfield!
    @IBOutlet weak var txtPatientClientNumber: ACFloatingTextfield!
    var callManagerVM = CallManagerVM()
    var sourceID ,targetID,roomId,sourceName, targetName: String?
    var calltype = ""
    var ccid = ""
    var vendorID = ""
    var vendorImgUrl = ""
    var vendorName = ""
    var isToThirdPartyCall = false
    var apiCheckCallStatusResponseModel = [ApiCheckCallStatusResponseModel]()
    var apiCreateVRICallClientResponseModel = [ApiCreateVRICallClientResponseModel]()
    let app = UIApplication.shared.delegate as? AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
            .withAlphaComponent(0.7)
        configureUI()
        
    }

func configureUI(){
        DispatchQueue.main.async {[self] in
            if Reachability.isConnectedToNetwork() {
                SwiftLoader.show(animated: true)
                callManagerVM.getRoomList { roolist, error in
                    if error == nil {
                        self.roomId = roolist?[0].RoomNo ?? "0"
                        
                        SwiftLoader.hide()
                        self.app?.roomIDAppdel = self.roomId
                    }
                    else {
                        SwiftLoader.hide()
                    }
                    
                }}
            else {
                self.view.makeToast(ConstantStr.noItnernet.val)
            }
        }
        
    }
    @IBAction func btnCloseTapped(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCallTapped(_ sender: Any){
        if txtPatientClientNumber.text!.isEmpty {
            self.view.makeToast("Please fill Patient/Client Number.",duration: 2, position: .center)
            return
        }else if txtPatientClientName.text!.isEmpty {
            self.view.makeToast("Please fill Patient/Client Name.",duration: 2, position: .center)
            return
        }else{
            if self.calltype == "VRI" {
                
                if roomId != nil {
                   self.getCallPriorityVideoWithCompletion()
                    self.addAppCall()
                    
                   }
                else {
                    self.view.makeToast("Room is not being created. Please try again",duration: 1, position: .center)
                }
            }else if self.calltype == "OPI" {
                print("OPI call start" , roomId)
                if roomId != nil {
                    getVRICallClient()
                    postOPIAcceptCall()
                }else {
                    self.view.makeToast("Room is not being created. Please try again",duration: 1, position: .center)
                }
            }
        }
        
    }
    func callTOVRI(){
        
        let sB = UIStoryboard(name: Storyboard_name.home, bundle: nil)
        let vdoCall = sB.instantiateViewController(identifier: "VideoCallViewController") as! VideoCallViewController
        vdoCall.roomID = roomId
        vdoCall.sourceLangID = sourceID
        vdoCall.targetLangID = targetID
        vdoCall.isClientDetails = true
        vdoCall.isScheduled = false
        vdoCall.sourceLangName = sourceName
        vdoCall.targetLangName = targetName
        vdoCall.patientno = txtPatientClientNumber.text ?? ""
        vdoCall.patientname = txtPatientClientName.text ?? ""
        vdoCall.videocallDelegate = self
        vdoCall.modalPresentationStyle = .overFullScreen
        SwiftLoader.hide()
        self.present(vdoCall, animated: true, completion: nil)
    }
    
    @IBAction func btnSkipTapped(_ sender: Any){
        if Reachability.isConnectedToNetwork() {
            SwiftLoader.show(animated: true)
            
            if self.calltype == "VRI" {
                print("VRI call start ")
                if roomId != nil {
                   self.getCallPriorityVideoWithCompletion()
                    self.addAppCall()
                    
                   }
                else {
                    self.view.makeToast("No roomID.")
                }
            }else if self.calltype == "OPI" {
                
                if roomId != nil {
                    getVRICallClient()
                    postOPIAcceptCall()
                }else {
                    self.view.makeToast("No roomID.")
                }
            }
        }else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
    }
    
    func getVRICallClient(){
        let roomID = self.roomId ?? ""
        let clientID = GetPublicData.sharedInstance.userID
        let sourceId = self.sourceID ?? ""
        let targetID = self.targetID ?? ""
        let searchStr = "<VRICLIENT><ACTION>A</ACTION><ID>0</ID><CLIENTID>\(clientID)</CLIENTID><ROOMID>\(roomID)</ROOMID><CALLTYPE>OPI</CALLTYPE><CALLSTATUS>1</CALLSTATUS><SOURCE>\(sourceId)</SOURCE><TARGET>\(targetID)</TARGET></VRICLIENT>"
        let parameter = ["strSearchString":searchStr]
        self.getCreateVRICallClient(req: parameter) { (completion, error) in
            if completion ?? false {
                print("getVRICallClient true ")
                // call get vendor id here
                self.getVendorIDs()
            }else {
                print("getVRICallClient false ")
            }
        }
    }
    func postOPIAcceptCall(){
        let parameter = [
            "lid": targetID ?? "",
            "Roomno": self.roomId ?? "",
            "senderid": GetPublicData.sharedInstance.userID,
            "touserid": "0",
            "statustype": "O",
            "sourceLid": sourceID ?? "",
            "Accepttype": "C",
            "patientname": self.txtPatientClientName.text ?? "",
            "patientno": self.txtPatientClientNumber.text ?? ""
        ]
        self.postOPIAcceptCallWithCompletion(req: parameter) { (completion, error) in
            if completion ?? false {
                print("postOPIAcceptCall true ")
                
            }else {
                print("postOPIAcceptCall false ")
            }
        }
    }
    func getVendorIDs(){
        self.apiCheckCallStatusResponseModel.removeAll()
        let userID = GetPublicData.sharedInstance.userID
        let sourceID = self.sourceID ?? ""
        let targetID = self.targetID ?? ""
        let ccid = self.ccid
        let srchString = "<Info><CUSTOMERID>\(userID)</CUSTOMERID><TYPE>O</TYPE><SOURCE>\(sourceID)</SOURCE><TARGET>\(targetID)</TARGET><CC_ID>\(ccid)</CC_ID></Info>"
        let param = ["strSearchString" :srchString]
        let urlString = APi.getCheckCallStatus.url
        print("url and parameter are getVendorIDs", param , urlString)
        AF.request(urlString, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { (response) in
                SwiftLoader.hide()
                switch(response.result){
                
                case .success(_):
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiCheckCallStatusResponseModel = try jsonDecoder.decode([ApiCheckCallStatusResponseModel].self, from: daata)
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
                                self.vendorImgUrl = vendorimg ?? ""
                                print("vendor ID ", vendorId , userIfo ,vendorimg  )
                            } else {
                                print("bad json")
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                        self.twilioVoiceView()
                        
                        
                    } catch{
                        
                        print("error block getVendorIDs Data  " ,error)
                    }
                case .failure(_):
                    print("Respose Failure getVendorIDs ")
                    
                }
            })
    }
    func twilioVoiceView(){
        if (self.isToThirdPartyCall) {
            
        }else {
            let sB = UIStoryboard(name: Storyboard_name.home, bundle: nil)
            let odoCall = sB.instantiateViewController(identifier: "AudioCallViewController") as! AudioCallViewController
            odoCall.roomID = roomId
            odoCall.sourceLangID = sourceID
            odoCall.targetLangID = targetID
            odoCall.ccid = self.ccid
            odoCall.isToThirdPartyCall = false
            odoCall.sourceLangName = sourceName
            odoCall.targetLangName = targetName
            odoCall.patientno = txtPatientClientNumber.text ?? ""
            odoCall.patientname = txtPatientClientName.text ?? ""
            odoCall.vendorID = self.vendorID
            odoCall.vendorName = self.vendorName
            odoCall.vendorImg = self.vendorImgUrl
            odoCall.modalPresentationStyle = .overFullScreen
            
            self.present(odoCall, animated: true, completion: nil)
        }
    }
    func getCreateVRICallClient(req:[String:Any], completionHandler:@escaping(Bool?, Error?) -> ()){
        
        let urlString = APi.createVRICallClient.url
        self.apiCreateVRICallClientResponseModel.removeAll()
        AF.request(urlString, method: .post, parameters: req, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { (response) in
                SwiftLoader.hide()
                switch(response.result){
                
                case .success(_):
                    
                    
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiCreateVRICallClientResponseModel = try jsonDecoder.decode([ApiCreateVRICallClientResponseModel].self, from: daata)
                        print("Success getCreateVRICallClient Model ",self.apiCreateVRICallClientResponseModel)
                        
                        self.ccid = self.apiCreateVRICallClientResponseModel.first?.id ?? ""
                        
                        completionHandler(true, nil)
                    } catch{
                        
                        print("error block getCreateVRICallClient Data  " ,error)
                    }
                case .failure(_):
                    print("Respose Failure getCreateVRICallClient ")
                    
                }
            })
        
    }
    func postOPIAcceptCallWithCompletion(req:[String:Any], completionHandler:@escaping(Bool?, Error?) -> ()){
        ApiServices.shareInstace.getDataFromApi(url: APi.opiAcceptCall.url, para: req) { response, err in
            print("url and param for postOPi  ", APi.opiAcceptCall.url , req)
            print("respose",response)
            
            if response != nil {
                completionHandler(true, nil)
            }
            else {
                completionHandler(false, err)
            }
        }
    }
    func addAppCall(){
        let para = callManagerVM.addAppCallReqAPI(sourceID: sourceID ?? "", targetID: targetID ?? "", roomId: roomId ?? "", targetName: targetName ?? "", sourceName: sourceName ?? "", patientName: txtPatientClientName.text!,patientNo: txtPatientClientNumber.text!)
        callManagerVM.addAppCall(req: para) { success, err in
            if success! {
               
                
            }
            else{
                self.view.makeToast("Something is wrong, please try again")
            }
        }
    }
    func getCallPriorityVideoWithCompletion() {
        let reqpara = callManagerVM.priorityReqAPI(LtargetId: targetID ?? "", Calltype: "V", Slid: sourceID ?? "")
        
        callManagerVM.priorityVideoCall(req: reqpara) { success, err in
            if success! {
                DispatchQueue.main.async {
                    
                    self.callTOVRI()
                    
                }
                // handler(true, nil)
                print("priority success------>",success)
            }
            else {
                // handler(false, nil)
                print("priority failed------>",success)
            }
        }
        
    }
    
}
