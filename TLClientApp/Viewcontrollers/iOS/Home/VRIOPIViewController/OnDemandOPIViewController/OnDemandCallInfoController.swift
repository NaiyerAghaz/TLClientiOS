//
//  OnDemandCallInfoController.swift
//  TLClientApp
//
//  Created by Mac on 23/08/21.
//

import UIKit

class OnDemandCallInfoController: UIViewController {

    //All Outlets
    @IBOutlet var txtFieldName: UITextField!
    @IBOutlet var txtFieldNumber: UITextField!
    @IBOutlet var btnSkip: UIButton!
    @IBOutlet var btnCall: UIButton!
    @IBOutlet var btnCancel: UIButton! {
        didSet {
            self.btnCancel.isHidden = true
        }
    }
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    //All Variables
    var callManagerVM = CallManagerVM()
    var sID: String?
    var dissmissVC:((Bool, String, String)->())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getVriVendorsbyLid_KE()
    }
}
//MARK: Extension
extension OnDemandCallInfoController {
    private func configUI() {

    }
}

//MARK: Button Actions
extension OnDemandCallInfoController {
    @IBAction func clickOnCancel() {
        self.dissmissVC?(false, "", "")
    }
    @IBAction func clickOnSkip() {
        self.dissmissVC?(true, "", "")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func clickOnCall() {
       
    }
}
//MARK: Get VRI Vendor Lid KE
extension OnDemandCallInfoController  {
    
    func getVriVendorsbyLid_KE() {
        guard let userId = userDefaults.value(forKey: .kUSER_ID) as? String else { return }
        self.indicator.startAnimating()
        self.showHideItems(false)
        let params: [String: Any] = ["Slid": self.sID!,
                                     "LId": "1205",//self.languageViewModel.lID!,
                                     "UserId": userId,
                                     "Calltype":"O",
                                     "MembersType":"app",]
        self.callManagerVM.getVriVendorsbyLid_KE(parameter: params) { memberLists, error in
            if memberLists.count > 0 {
                
            }
        }
    }
    //MARK: Show Hide Items
    private func showHideItems(_ isShow: Bool) {
        self.btnCancel.isHidden = !isShow
    }
}
