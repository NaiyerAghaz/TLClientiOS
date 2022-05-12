//
//  EditRecurrenceStatusVC.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 11/05/22.
//

import UIKit
import BottomPopup

class EditRecurrenceStatusVC: BottomPopupViewController {

    var height: CGFloat?
     var topCornerRadius: CGFloat?
     var presentDuration: Double?
     var dismissDuration: Double?
     var shouldDismissInteractivelty: Bool?
     var popupDismisAlphaVal : CGFloat?
    
    var delegate : CommonDelegates?
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    override var popupHeight: CGFloat { height ?? 500.0 }
    override var popupTopCornerRadius: CGFloat { topCornerRadius ?? 10.0 }
    override var popupPresentDuration: Double { presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { dismissDuration ?? 1.0 }
    override var popupShouldDismissInteractivelty: Bool { shouldDismissInteractivelty ?? true }
    override var popupDimmingViewAlpha: CGFloat { popupDismisAlphaVal ?? 1.0}


    @IBAction func btnCloseTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnOkayTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.getEditRecurrenceUpdate?()
    }
    
}
