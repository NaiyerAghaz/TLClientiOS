import UIKit
import BottomPopup

class InviteParticipantVC: BottomPopupViewController {
    @IBOutlet weak var dialContainerView: UIView!
    
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var inviteSegments: UISegmentedControl!
   
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var popupDismisAlphaVal : CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
            .withAlphaComponent(0.7)
        dialContainerView.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnInviteTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmetControlTapped(_ sender: Any) {
        switch inviteSegments.selectedSegmentIndex {
        case 0:
            emailContainerView.isHidden = false
            dialContainerView.isHidden = true
        case 1:
            emailContainerView.isHidden = true
            dialContainerView.isHidden = false
        default:
            print("default call")
        }
    }
    override var popupHeight: CGFloat { height ?? 500.0 }
    override var popupTopCornerRadius: CGFloat { topCornerRadius ?? 10.0 }
    override var popupPresentDuration: Double { presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { dismissDuration ?? 1.0 }
    override var popupShouldDismissInteractivelty: Bool { shouldDismissInteractivelty ?? true }
    override var popupDimmingViewAlpha: CGFloat { popupDismisAlphaVal ?? 1.0}
    
}
