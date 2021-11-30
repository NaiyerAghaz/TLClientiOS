//
//  CallingPopupVC.swift
//  TLClientApp
//
//  Created by Naiyer on 8/25/21.
//

import UIKit

class CallingPopupVC: UIViewController {
    @IBOutlet weak var txtPatientClientName: ACFloatingTextfield!
    @IBOutlet weak var txtPatientClientNumber: ACFloatingTextfield!
    var callManagerVM = CallManagerVM()
    var sourceID ,targetID,roomId,sourceName, targetName: String?
    
    let app = UIApplication.shared.delegate as? AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
            .withAlphaComponent(0.7)
        configureUI()
       
    }
    func configureUI(){
        SwiftLoader.show(animated: true)
        callManagerVM.getRoomList { roolist, error in
            if error == nil {
                self.roomId = roolist?[0].RoomNo ?? "0"
                SwiftLoader.hide()
                self.app?.roomIDAppdel = self.roomId
            }
            
        }
    }
    @IBAction func btnCloseTapped(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCallTapped(_ sender: Any){
        
    }
    @IBAction func btnSkipTapped(_ sender: Any){
       
        if roomId != nil {
            self.addAppCall()
          
        
            self.getCallPriorityVideoWithCompletion()
            debugPrint("roomId:\(roomId),sourceID:\(sourceID),targetID:\(targetID),sourceName:\(sourceName),targetName:\(targetName)")
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
            
            self.present(vdoCall, animated: true, completion: nil)
        
        }
        
    }
    func addAppCall(){
        let para = callManagerVM.addAppCallReqAPI(sourceID: sourceID ?? "", targetID: targetID ?? "", roomId: roomId ?? "", targetName: targetName ?? "", sourceName: sourceName ?? "", patientName: txtPatientClientName.text!,patientNo: txtPatientClientNumber.text!)
        callManagerVM.addAppCall(req: para) { success, err in
            debugPrint("success------------>", success)
        }
    }
    func getCallPriorityVideoWithCompletion() {
        let reqpara = callManagerVM.priorityReqAPI(LtargetId: targetID ?? "", Calltype: "V", Slid: sourceID ?? "")
        
        callManagerVM.priorityVideoCall(req: reqpara) { success, err in
            if success! {
               print("priority success------>",success)
            }
            else {
                print("priority failed------>",success)
            }
        }
        
    }
    
}
