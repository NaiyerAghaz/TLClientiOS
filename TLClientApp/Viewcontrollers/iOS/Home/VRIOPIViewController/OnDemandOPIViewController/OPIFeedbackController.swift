//
//  OPIFeedbackController.swift
//  TLClientApp
//
//  Created by Mac on 25/08/21.
//

import UIKit

class OPIFeedbackController: UIViewController {

    @IBOutlet var imgViewCaller: UIImageView!
    @IBOutlet var lblRoomId: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblTranslate: UILabel!
    @IBOutlet var lblVoice: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderRate: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // PUGradientSlider().setSlider(slider: slider)
       // PUGradientSlider().setSlider(slider: sliderRate)
    }
}
//MARK: Button Actions
extension OPIFeedbackController {
    
    @IBAction func clickOnCancel(_ sender: UIButton) {
        self.popToVc()
    }
    @IBAction func clickOnSubmit(_ sender: UIButton) {
        self.popToVc()
    }
    @IBAction func sliderValueChanged(_ slider: UISlider) {
        //Log.print("Slider Value =====> ", slider.roundOffValue())
        print("Slider Value =====> ", slider.roundOffValue())
    }
    @IBAction func sliderRateValueChanged(_ slider: UISlider) {
       // Log.print("Slider Value =====> ", slider.roundOffValue())
        print("Slider Value =====> ", slider.roundOffValue())
    }
}
//MARK: Common Functions
extension OPIFeedbackController {
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

