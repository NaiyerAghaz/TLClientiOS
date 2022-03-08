//
//  VirtualMeetingParentNewVC.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 07/03/22.
//

import UIKit

class VirtualMeetingParentNewVC: UIViewController {
    
    @IBOutlet weak var recuriingContainerView: UIView!
    @IBOutlet weak var blockedContainerView: UIView!
    @IBOutlet weak var regularConatinerView: UIView!
    @IBOutlet weak var appointmentTypeSegmentControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.regularConatinerView.alpha = 1
        self.blockedContainerView.alpha = 0
        self.recuriingContainerView.alpha = 0
        self.appointmentTypeSegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        //self.appointmentTypeSegmentControl.
        //appointmentTypeSegmentControl.setSelectedSegmentColor(with: .white, and: .red)
    }
    
    @IBAction func actionBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
