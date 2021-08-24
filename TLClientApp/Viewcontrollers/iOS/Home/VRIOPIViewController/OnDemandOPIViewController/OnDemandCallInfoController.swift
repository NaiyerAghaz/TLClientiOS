//
//  OnDemandCallInfoController.swift
//  TLClientApp
//
//  Created by Mac on 23/08/21.
//

import UIKit

class OnDemandCallInfoController: UIViewController {

    @IBOutlet var txtFieldName: UITextField!
    @IBOutlet var txtFieldNumber: UITextField!
    @IBOutlet var btnSkip: UIButton!
    @IBOutlet var btnCall: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
}
//MARK: Extension
extension OnDemandCallInfoController {
    private func configUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.3)
    }
}

//MARK: Button Actions
extension OnDemandCallInfoController {
    @IBAction func clickOnCancel() {
        self.DISMISS(false)
    }
    @IBAction func clickOnSkip() {
        //TODO: 
    }
    @IBAction func clickOnCall() {
        //TODO:
    }
}
