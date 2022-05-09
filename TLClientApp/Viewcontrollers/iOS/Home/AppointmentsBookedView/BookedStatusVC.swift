//
//  BookedStatusVC.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 18/04/22.
//

import UIKit
import BottomPopup

class BookedStatusVC: BottomPopupViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var tblStatus: UITableView!
    var height: CGFloat?
     var topCornerRadius: CGFloat?
     var presentDuration: Double?
     var dismissDuration: Double?
     var shouldDismissInteractivelty: Bool?
     var popupDismisAlphaVal : CGFloat?
    var tblHeighConstant : Int?
    @IBOutlet weak var lblMessage: UILabel!
    var msz: String?
    var ismultiple = false
    var authcode: String?
    var apntArr = [String]()
    
    var delegate : ReloadBlockedTable?
    override func viewDidLoad() {
        super.viewDidLoad()
     print("authcode------",authcode)
        let mainRoom = msz!
        let range = (mainRoom as NSString).range(of: authcode!)
        let mutableStr = NSMutableAttributedString.init(string: mainRoom)
        mutableStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red:25/255, green:157/255, blue:217/255, alpha:1.0), range: range)
        self.lblMessage.attributedText = mutableStr
        if ismultiple {
            tblHeight.constant = CGFloat(tblHeighConstant ?? 0)
            tblStatus.visibility = .visible
            tblStatus.delegate = self
            tblStatus.dataSource = self
            tblStatus.reloadData()
        }
        else {
            tblStatus.visibility = .gone
        }
    }
    
    @IBAction func btnOkayTapped(_ sender: Any) {
        dismiss(animated: true)
        delegate?.bookedAppointment()
    }
 
    override var popupHeight: CGFloat { height ?? 500.0 }
    override var popupTopCornerRadius: CGFloat { topCornerRadius ?? 10.0 }
    override var popupPresentDuration: Double { presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { dismissDuration ?? 1.0 }
    override var popupShouldDismissInteractivelty: Bool { shouldDismissInteractivelty ?? true }
    override var popupDimmingViewAlpha: CGFloat { popupDismisAlphaVal ?? 1.0}
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblStatus.dequeueReusableCell(withIdentifier: "TblStatusCell", for: indexPath) as! TblStatusCell
        cell.lblAppointment.text = apntArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apntArr.count
    }
    
    

}
class TblStatusCell: UITableViewCell {
    
    @IBOutlet weak var lblAppointment: UILabel!
}
