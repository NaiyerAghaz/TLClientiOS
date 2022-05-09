//
//  EditUpdateAnDeleteVC.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 13/04/22.
//

import UIKit
import BottomPopup

class EditUpdateAnDeleteVC: BottomPopupViewController {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var popupDismisAlphaVal : CGFloat?
    @IBOutlet weak var lblDepartmentWithunderline: UILabel!
    @IBOutlet weak var lblDepartment: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtEditField: UITextField!
    var apType = 0
    var nameStr: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfigure()
        // Do any additional setup after loading the view.
    }
    func uiConfigure(){
        if apType == 0 {
            btnAdd.setTitle("Add", for: .normal)
            lblDepartment.text = nameStr
            lblDepartmentWithunderline.text = nameStr
            
        }
        else {
            btnAdd.setTitle("Add", for: .normal)
            lblDepartment.text = "Department"
            lblDepartmentWithunderline.text = "Department"
        }
    }
    @IBAction func btnClosetapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func btnAddAndUpdateTapped(_ sender: Any) {
        
    }
    override var popupHeight: CGFloat { height ?? 150 }
    override var popupTopCornerRadius: CGFloat { topCornerRadius ?? 30.0 }
    override var popupPresentDuration: Double { presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { dismissDuration ?? 1.0 }
    override var popupShouldDismissInteractivelty: Bool { shouldDismissInteractivelty ?? true }
    override var popupDimmingViewAlpha: CGFloat { popupDismisAlphaVal ?? 1.0}
}
