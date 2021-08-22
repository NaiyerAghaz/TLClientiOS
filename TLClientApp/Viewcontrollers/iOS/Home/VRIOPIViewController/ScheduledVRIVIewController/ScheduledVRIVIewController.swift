//
//  ScheduledVRIVIewController.swift
//  TLClientApp
//
//  Created by Naiyer on 8/20/21.
//

import UIKit
import XLPagerTabStrip

class ScheduledVRIVIewController: UIViewController,IndicatorInfoProvider {

    
    static func createWith(navigator: Navigator, storyboard: UIStoryboard) -> ScheduledVRIVIewController {
        return storyboard.instantiateViewController(ofType: ScheduledVRIVIewController.self).then { viewController in
            
        }
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo
        {
            
            return IndicatorInfo(title:"Scheduled VRI")
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
