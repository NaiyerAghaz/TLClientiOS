//
//  AddParticipantController.swift
//  TLClientApp
//
//  Created by Mac on 25/08/21.
//

import UIKit

class AddParticipantController: UIViewController {
    
    //All Outlets
    @IBOutlet var txtFieldMobile: UITextField!
    @IBOutlet var txtFieldCCode: UITextField!
    @IBOutlet var al_Bottom: NSLayoutConstraint!
    @IBOutlet var al_Height: NSLayoutConstraint! {
        didSet {
            self.al_Height.constant = 215
        }
    }
    //VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.al_Bottom.constant = -al_Height.constant
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showBottonSheet()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.configTxtFieldsUI()
    }
}

//MARK: =====: Configuration :====
extension AddParticipantController {
    private func configTxtFieldsUI() {
        let txtFields = [txtFieldMobile, txtFieldCCode]
    }
}

//MARK: Button Actions
extension AddParticipantController {
    @IBAction func clickOnCancel(_ sender: UIButton) {
        self.hideBottonSheet()
    }
    @IBAction func clickOnCall(_ sender: UIButton) {
        
    }
}
//MARK: Custom Method
extension AddParticipantController {
    private func showBottonSheet() {
        UIView.animate(withDuration: 0.3) {
            self.al_Bottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    private func hideBottonSheet() {
        UIView.animate(withDuration: 0.3) {
            self.al_Bottom.constant = -self.al_Height.constant
            self.view.layoutIfNeeded()
        } completion: { finished in
            if finished {
                
            }
        }
    }
}
