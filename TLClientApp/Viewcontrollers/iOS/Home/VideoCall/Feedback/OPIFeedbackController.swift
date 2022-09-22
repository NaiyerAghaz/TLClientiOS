//
//  OPIFeedbackController.swift
//  TLClientApp
//
//  Created by Mac on 25/08/21.
//

import UIKit
import SteppableSlider

class VRIOPIFeedbackController: UIViewController {
    
    @IBOutlet var imgViewCaller: UIImageView!
    @IBOutlet var lblRoomId: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblTranslate: UILabel!
    @IBOutlet var lblVoice: UILabel!
    @IBOutlet weak var expSlider: SteppableSlider!
    @IBOutlet weak var overallRatingSlider: SteppableSlider!
    
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblExpr: UILabel!
    var feedbackVM = FeedbackVModel()
    var calltype : String = ""
    var roomID :String?
    var duration : String?
    var dateAndTime: String?
    var targetLang: String?
    var ratingValue = 3
    var isScheduled = false
    var apiGetfeedbackDetail:APIGetfeedbackDetail?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
            .withAlphaComponent(0.7)
       
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getFeedback()
    }
    func uiConfigure(){
        lblDuration.text = duration
        lblRoomId.text = roomID
        lblDateTime.text = dateAndTime
        if calltype == "O"{
            lblVoice.text = "Voice"
        }
        else {
            lblVoice.text = "Video"
        }
        
        
        lblUserName.text = apiGetfeedbackDetail?.getMembers?[0].customerName ?? ""
        
        let custImage = apiGetfeedbackDetail?.getMembers?[0].custImg ?? ""
        
        imgViewCaller.sd_setImage(with: URL(string: nBaseUrl + custImage), placeholderImage: UIImage(named: "ic_user"))
        expSlider.value = 2
        overallRatingSlider.value = 2
        expSlider.layer.cornerRadius = expSlider.frame.height/2
        overallRatingSlider.layer.cornerRadius = overallRatingSlider.frame.height/2
        let lng = "English >> \(apiGetfeedbackDetail?.getMembers?[0].languageName ?? "")"
       
        lblTranslate.text = lng
        expSlider.addTarget(self, action: #selector(expSliderValueChanged(_:)), for: .valueChanged)
        overallRatingSlider.addTarget(self, action: #selector(overallRatingValueChanged(_:)), for: .valueChanged)
        
    }
    
    func getFeedback(){
       // DispatchQueue.main.async {
            SwiftLoader.show(animated: true)
       // }
       
        let req = feedbackVM.feedbackReq(roomId: roomID ?? "", calltype: calltype)
        print("feedback details req:", req)
        feedbackVM.getFeedbackDetails(parameter: req) { details, err in
            print("feedback details req2:", details)
            self.apiGetfeedbackDetail = details
           // DispatchQueue.main.async {
                SwiftLoader.hide()
                self.uiConfigure()
          //  }
          
        }
    }
    @objc func expSliderValueChanged(_ sender: SteppableSlider) {
        print(sender.value) // 0 ~ 4
        sender.value = round(sender.value)
        switch sender.value {
        case 0:
            
            lblExpr.text = "Poor"
            
        case 1:
            
            lblExpr.text = "Average"
            
        case 2:
            
            lblExpr.text = "Good"
        case 3:
            
            lblExpr.text = "Very Good"
            
        case 4:
            
            lblExpr.text = "Excellent"
            
        default:
            print("Awesome")
        }
    }
    
    @objc func overallRatingValueChanged(_ sender: SteppableSlider) {
        print(sender.value) // 0 ~ 4
        sender.value = round(sender.value)
        switch sender.value {
        case 0:
            
            
            ratingValue = 1
            lblRating.text = "Poor"
        case 1:
            
            ratingValue = 2
            lblRating.text = "Average"
        case 2:
            
            ratingValue = 3
            lblRating.text = "Good"
        case 3:
            
            ratingValue = 4
            lblRating.text = "Very Good"
        case 4:
            
            ratingValue = 5
            lblRating.text = "Excellent"
            
        default:
            print("Awesome")
        }
        
    }
}
//MARK: Button Actions
extension VRIOPIFeedbackController {
    
    @IBAction func clickOnCancel(_ sender: UIButton) {
        dismissToVC()
    }
    @IBAction func clickOnSubmit(_ sender: UIButton) {
        SwiftLoader.show(title: "Submit..", animated: true)
        
        let reqparameter = feedbackVM.requestFeedback(callquality:  lblExpr.text ?? "", VendID: "\(apiGetfeedbackDetail?.getMembers![0].vendID ?? 0)", roomno: roomID!, CustID: "\(apiGetfeedbackDetail?.getMembers![0].custID ?? 0)", LID: "\(apiGetfeedbackDetail?.getMembers![0].lID ?? 0)", rating: ratingValue, calltype: calltype)
        print("para-->",reqparameter)
        feedbackVM.submitfeedbackMethod(parameter: reqparameter) { success, err in
            SwiftLoader.hide()
            if success {
                
                self.dismissToVC()
            }
            else {
                self.view.makeToast("Please try again your feedback is not being submitted")
            }
        }
        //dismissToVC()
    }
    
    public func dismissToVC(){
        //  dismiss(animated: true, completion: nil)
        if isScheduled == true {
            self.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: nil)
        }
        else {
            self.presentingViewController?.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: nil)
        }
        
    }
}
//MARK: Common Functions
extension VRIOPIFeedbackController {
    private func popToVc() {
        let navArray: [UIViewController] = self.navigationController?.viewControllers ?? []
        for vc in navArray {
            if vc is VRIOPIViewController {
                self.navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }
}

