//
//  CallingPopupVC.swift
//  TLClientApp
//
//  Created by Naiyer on 8/25/21.
//

import UIKit
import Alamofire
class CallingPopupVC: UIViewController,URLSessionDownloadDelegate {
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
        //downloadForm()
       // DownlondFromUrl()
        //savePdf(urlString: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf")
    }
    //demo download data
    //URLSessionDownloadDelegate remove this from controller
    var vUrl : URL?
    func savePdf(urlString:String) {
        let url = URL(string: urlString)!
        let downloadTask = URLSession.shared.downloadTask(with: url) {
            urlOrNil, responseOrNil, errorOrNil in
            // check for and handle errors:
            // * errorOrNil should be nil
            // * responseOrNil should be an HTTPURLResponse with statusCode in 200..<299
            
            guard let fileURL = urlOrNil else { return }
            do {
                let documentsURL = try
                    FileManager.default.url(for: .documentDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: false)
                let savedURL = documentsURL.appendingPathComponent(fileURL.lastPathComponent)
                print("savedURL:",savedURL)
                try FileManager.default.moveItem(at: fileURL, to: savedURL)
            } catch {
                print ("file error: \(error)")
            }
        }
        downloadTask.resume()
        }
    func DownlondFromUrl(){
       // Create destination URL
        
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
        let destinationFileUrl = documentsUrl!.appendingPathComponent("downloadedFile.pdf")

    //Create URL to the source file you want to download
    let fileURL = URL(string: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf")

    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig)

    let request = URLRequest(url:fileURL!)

    let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
        if let tempLocalUrl = tempLocalUrl, error == nil {
            // Success
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                print("Successfully downloaded. Status code: \(statusCode)")
            }

            do {
                try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
            } catch (let writeError) {
                print("Error creating a file \(destinationFileUrl) : \(writeError)")
            }

        } else {
            print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
        }
    }
    task.resume()
    }
    public func downloadForm(){
        vUrl = URL(string: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf")
        let urlString = "https://docs.google.com/gview?url=https%3A%2F%2Fdevelopmentailogic.s3.us-west-2.amazonaws.com%2FTotalLanguage%2FTempServiceFile%2FServiceVerificationForm_DTC1-1111267.doc%3FX-Amz-Expires%3D300%26response-content-disposition%3Dattachement%26response-content-type%3Dapplication%252Foctet-stream%26X-Amz-Algorithm%3DAWS4-HMAC-SHA256%26X-Amz-Credential%3DAKIAUPNGHXFKFXABUIGT%2F20220222%2Fus-west-2%2Fs3%2Faws4_request%26X-Amz-Date%3D20220222T122633Z%26X-Amz-SignedHeaders%3Dhost%26X-Amz-Signature%3D5df7f9f1a108e2d1b84f8812ddd7108cb8374ff921eba25cf82a760aad77867d"
        let url = URL(string: urlString)
        let fileName = String((url!.lastPathComponent)) as NSString
        // Create destination URL
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName)")
        //Create URL to the source file you want to download
        let fileURL = URL(string: urlString)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fileURL!)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    do {
                        //Show UIActivityViewController to save the downloaded file
                        let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                        for indexx in 0..<contents.count {
                            if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                                let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                                self.present(activityViewController, animated: true, completion: nil)
                            }
                        }
                    }
                    catch (let err) {
                        print("error: \(err)")
                    }
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            } else {
                print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
            }
        }
        
        task.resume()
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            print("downloadLocation:", location)
        // create destination URL with the original pdf name
        //copy downloaded data to your documents directory with same names as source file
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let destinationUrl = documentsUrl!.appendingPathComponent(vUrl!.lastPathComponent)
            let dataFromURL = NSData(contentsOf: location)
            dataFromURL?.write(to: destinationUrl, atomically: true)
               
           
        }
    
    //============end=====================================
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
            }else if self.calltype == "OPI" {
                print("OPI call start" , roomId)
                if roomId != nil {
                    getVRICallClient()
                    postOPIAcceptCall()
                }else {
                    self.view.makeToast("No roomID.")
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
