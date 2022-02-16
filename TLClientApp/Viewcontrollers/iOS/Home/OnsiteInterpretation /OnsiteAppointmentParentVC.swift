//
//  OnsiteAppointmentParentVC.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 16/02/22.
//

import UIKit

class OnsiteAppointmentParentVC: UIViewController {

    @IBOutlet weak var recuriingContainerView: UIView!
    @IBOutlet weak var blockedContainerView: UIView!
    @IBOutlet weak var regularConatinerView: UIView!
    @IBOutlet weak var appointmentTypeSegmentControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.regularConatinerView.alpha = 1
        self.blockedContainerView.alpha = 0
        self.recuriingContainerView.alpha = 0
        
    }
    

    @IBAction func actionChangeTyoe(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            self.regularConatinerView.alpha = 1
            self.blockedContainerView.alpha = 0
            self.recuriingContainerView.alpha = 0
        }else if sender.selectedSegmentIndex == 1{
            self.regularConatinerView.alpha = 0
            self.blockedContainerView.alpha = 1
            self.recuriingContainerView.alpha = 0
        }else {
            self.regularConatinerView.alpha = 0
            self.blockedContainerView.alpha = 0
            self.recuriingContainerView.alpha = 1
        }
    }
    
}
