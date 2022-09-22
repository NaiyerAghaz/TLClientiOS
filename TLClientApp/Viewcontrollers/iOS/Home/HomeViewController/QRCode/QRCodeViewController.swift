//
//  QRCodeViewController.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 14/09/22.
//

import UIKit
import BottomPopup
class QRCodeViewController: BottomPopupViewController {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var popupDismisAlphaVal : CGFloat?
    var qrCodeImage : UIImage?
    var QrUIDStr : String = ""
    var delegate:DownloadQRCodeDelegate?
    @IBOutlet weak var lblTL: UILabel!
    @IBOutlet weak var qrImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if qrCodeImage != nil {
            qrImage.image = qrCodeImage
        }
        lblTL.text = QrUIDStr
        // Do any additional setup after loading the view.
    }
    override var popupHeight: CGFloat { height ?? 500.0 }
    override var popupTopCornerRadius: CGFloat { topCornerRadius ?? 10.0 }
    override var popupPresentDuration: Double { presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { dismissDuration ?? 1.0 }
    override var popupShouldDismissInteractivelty: Bool { shouldDismissInteractivelty ?? true }
    override var popupDimmingViewAlpha: CGFloat { popupDismisAlphaVal ?? 1.0}
    

    @IBAction func btnClodeTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func btnDownloadTapped(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(qrCodeImage!, nil, nil, nil)
        delegate?.downloadMethod()
       
        dismiss(animated: true)
    }
    
}
