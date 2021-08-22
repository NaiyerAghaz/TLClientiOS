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
        super.viewDidLoad()
        settings.style.buttonBarItemBackgroundColor = UIColor(red:0.0/255.0, green:65.0/255.0, blue:128.0/255.0, alpha:1.0)
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 0.5
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .lightGray
            newCell?.label.textColor = UIColor.white
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func btnBackTapped(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController]
    {
        
       //here are the my VC the number of VC u give u can get those many upon swipe left to right,Right to left....
        let vri = navigator.homeStoryBoard.instantiateViewController(withIdentifier:"OnDemandVRIViewController") as! OnDemandVRIViewController
        let opi = navigator.homeStoryBoard.instantiateViewController(withIdentifier:"OnDemandOPIViewController") as! OnDemandOPIViewController
        let scheduleVRI = navigator.homeStoryBoard.instantiateViewController(withIdentifier:"ScheduledVRIVIewController") as! ScheduledVRIVIewController
        let scheduleOPI = navigator.homeStoryBoard.instantiateViewController(withIdentifier:"ScheduledOPIViewController") as! ScheduledOPIViewController
        
        return [vri,opi,scheduleVRI, scheduleOPI]
    }
}
