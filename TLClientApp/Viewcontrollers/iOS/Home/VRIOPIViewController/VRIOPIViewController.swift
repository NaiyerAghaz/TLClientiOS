//
//  VRIOPIViewController.swift
//  TLClientApp
//
//  Created by Naiyer on 8/20/21.
//

import UIKit
import XLPagerTabStrip
class VRIOPIViewController: ButtonBarPagerTabStripViewController {
    var navigator = Navigator()
    static func createWith(navigator: Navigator, storyboard: UIStoryboard) -> ScheduledVRIVIewController {
        return storyboard.instantiateViewController(ofType: ScheduledVRIVIewController.self).then { viewController in
            
        }
    }
    override func viewDidLoad() {
        containerView.isScrollEnabled = true
            containerView.delegate = self
        settings.style.buttonBarItemBackgroundColor = UIColor(red:0.0/255.0, green:65.0/255.0, blue:128.0/255.0, alpha:1.0)
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 14)
        settings.style.selectedBarHeight = 0.5
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            newCell?.label.frame.size.width = 120
            oldCell?.label.frame.size.width = 120
            newCell?.label.lineBreakMode = .byCharWrapping
                   oldCell?.label.lineBreakMode = .byCharWrapping
            oldCell?.label.textColor = .lightGray
            newCell?.label.textColor = UIColor.white
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnBackTapped(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController]
    {
       // ChildExampleViewController(itemInfo: "YOU")
       // let vri1 = OnDemandVRIViewController(itemInfo: "Ondemand VRI")
       //here are the my VC the number of VC u give u can get those many upon swipe left to right,Right to left....
        let vri = navigator.homeStoryBoard.instantiateViewController(withIdentifier:"OnDemandVRIViewController") as! OnDemandVRIViewController
        vri.itemInfo = IndicatorInfo(title: "Ondemand VRI")
        let opi = navigator.homeStoryBoard.instantiateViewController(withIdentifier:"OnDemandOPIViewController") as! OnDemandOPIViewController
        opi.itemInfo = IndicatorInfo(title: "Ondemand OPI")
        let scheduleVRI = navigator.homeStoryBoard.instantiateViewController(withIdentifier:"ScheduledVRIVIewController") as! ScheduledVRIVIewController
        let scheduleOPI = navigator.homeStoryBoard.instantiateViewController(withIdentifier:"ScheduledOPIViewController") as! ScheduledOPIViewController
        let meetingVC = navigator.homeStoryBoard.instantiateViewController(withIdentifier:"MeetingViewController") as! MeetingViewController
        
       // return [vri,opi]
        
        return [vri,opi,scheduleVRI, scheduleOPI , meetingVC]
    }
}
