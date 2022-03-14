//
//  FeedbackVC.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 21/02/22.
//

import UIKit
import SteppableSlider

class FeedbackVC: UIViewController {
    @IBOutlet weak var vendorImgView: UIImageView!
    @IBOutlet weak var lblVendorName: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var roomNoLbl: UILabel!
    @IBOutlet weak var dateAndTimeLbl: UILabel!
    @IBOutlet weak var callTypeLbl: UILabel!
    @IBOutlet weak var translationlbl: UILabel!
    @IBOutlet weak var callRatingSlider: SteppableSlider!
    @IBOutlet weak var callExperienceSlider: SteppableSlider!
    var callQualityValue = ""
    @IBOutlet weak var lblCallExp: UILabel!
    @IBOutlet weak var lblOverallRating: UILabel!
    var ratingValue:Int? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callExperienceSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        callRatingSlider.addTarget(self, action: #selector(slider2ValueChanged(_:)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionRatingSubmitBtn(_ sender: UIButton) {
        if self.ratingValue == nil || self.callQualityValue == "" {
            self.view.makeToast("Please select rating.")
        }else {
            // postFeedbackDetail()
        }
        
    }
    @IBAction func actionRatingCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func sliderValueChanged(_ sender: SteppableSlider) {
        print(sender.value) // 0 ~ 4
        sender.value = round(sender.value)
        switch sender.value {
        case 0:
            print("SENDER VALUE IS 0")
            self.callQualityValue = ""
            lblCallExp.text = ""
        case 1:
            print("SENDER VALUE IS 1")
            self.callQualityValue = "Poor"
            lblCallExp.text = "Poor"
        case 2:
            print("SENDER VALUE IS 2")
            self.callQualityValue = "Average"
            lblCallExp.text = "Average"
        case 3:
            print("SENDER VALUE IS 3")
            self.callQualityValue = "Good"
            lblCallExp.text = "Good"
        case 4:
            print("SENDER VALUE IS 4")
            self.callQualityValue = "Very Good"
            lblCallExp.text = "Very Good"
        case 5:
            print("SENDER VALUE IS 4")
            self.callQualityValue = "Excellent"
            lblCallExp.text = "Excellent"
        default:
            print("Awesome")
        }
    }
    @objc func slider2ValueChanged(_ sender: SteppableSlider) {
        print(sender.value) // 0 ~ 4
        sender.value = round(sender.value)
        switch sender.value {
        case 0:
            print("SENDER VALUE IS 0")
            ratingValue = 0
            lblOverallRating.text = ""
        case 1:
            print("SENDER VALUE IS 1")
            ratingValue = 1
            lblOverallRating.text = "Poor"
        case 2:
            print("SENDER VALUE IS 2")
            ratingValue = 2
            lblOverallRating.text = "Average"
        case 3:
            print("SENDER VALUE IS 3")
            ratingValue = 3
            lblOverallRating.text = "Good"
        case 4:
            print("SENDER VALUE IS 4")
            ratingValue = 4
            lblOverallRating.text = "Very Good"
        case 5:
            print("SENDER VALUE IS 5")
            ratingValue = 5
            lblOverallRating.text = "Excellent"
        default:
            print("Awesome")
        }
        
    }
    
    
}
