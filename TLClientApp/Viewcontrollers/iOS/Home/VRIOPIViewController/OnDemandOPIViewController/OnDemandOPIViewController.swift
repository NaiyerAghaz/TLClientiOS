//
//  OnDemandOPIViewController.swift
//  TLClientApp
//
//  Created by Naiyer on 8/20/21.
//

import UIKit
import XLPagerTabStrip

class OnDemandOPIViewController: UIViewController,IndicatorInfoProvider,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var txtTargetlanguage: ACFloatingTextfield! {
        didSet {
            self.txtTargetlanguage.tag = 101
        }
    }
    @IBOutlet weak var txtSourceLanguage: ACFloatingTextfield!{
        didSet {
            self.txtSourceLanguage.tag = 100
        }
    }
    
    var vriPickerView = UIPickerView()
    var sourceLang = true
    var languageViewModel = LanguageVM()
    var ondemandOPIVM = OnDemandOPIVM()
    private var accessToken: String? = ""
    
    var callManagerVM = CallManagerVM()
    
    lazy var userId: String = {
        return userDefaults.value(forKey: .kUSER_ID) as? String
    }() ?? ""
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Ondemand OPI")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        uiUpdate()
        self.getAccessToken(userId: userId)
    }
    public func uiUpdate(){
        txtTargetlanguage.delegate = self
        txtSourceLanguage.delegate = self
        txtTargetlanguage.inputView = vriPickerView
        txtSourceLanguage.inputView = vriPickerView
        languageViewModel.languageData { list, err in
            if err == nil {
//                print("Language List ====>\n", list?.LanguageData ?? [])
                let langArray = list?.LanguageData as? [LanguageModel]
                let index = langArray?.firstIndex { $0.LanguageID == "3" }
                if let row = index {
                    self.languageViewModel.titleToTxtField(row: row, txtField: self.txtSourceLanguage)
                    self.vriPickerView.reloadAllComponents()
                }
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtSourceLanguage{
            sourceLang = true
        } else {
            sourceLang = false
        }
        vriPickerView.delegate = self
        vriPickerView.dataSource = self
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return languageViewModel.totalNumberOfrow()
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return languageViewModel.titleForList(row: row, tag: 0)
        
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if sourceLang {
            
            languageViewModel.titleToTxtField(row: row, txtField: txtSourceLanguage)
        }
        else {
            languageViewModel.titleToTxtField(row: row, txtField: txtTargetlanguage)
        }
    }
    @IBAction func btnCallNowTapped(_ sender: Any) {
//        self.getVriVendorsbyLid_KE()
        self.openVRI_OPI_popup()
    }
}
//MARK: Api calling
extension OnDemandOPIViewController {
    
//    func getVriVendorsbyLid_KE() {
//        guard let userId = userDefaults.value(forKey: .kUSER_ID) as? String else { return }
//        let params: [String: Any] = ["Slid": self.languageViewModel.sID!,
//                                     "LId": "1205",//self.languageViewModel.lID!,
//                                     "UserId": userId,
//                                     "Calltype":"O",
//                                     "MembersType":"app",]
//        self.callManagerVM.getVriVendorsbyLid_KE(parameter: params) { memberLists, error in
//            //Validate response if success then call below method
//            if memberLists.count > 0 {
//                self.openVRI_OPI_popup()
//            }
//        }
//    }
    func getAccessToken(isTokenRefresh: Bool = false, userId: String) {
        self.ondemandOPIVM.getTwilioAccessToken(userId: userId) { token, error in
           // guard token.length > 0 else {
            guard token != nil else {
                return
            }
            self.accessToken = token
        }
    }
    //
    private func openVRI_OPI_popup() {
        let request = TxtRequest(txt: self.txtTargetlanguage.text)
        let validate = ValidationReq().validate(txtfield: request)
        if validate.success {
          //  let vc = OnDemandCallInfoController.instantiate(from: .Home)
            let vc = storyboard?.instantiateViewController(identifier: "OnDemandCallInfoController") as! OnDemandCallInfoController
            vc.sID = self.languageViewModel.sID ?? ""
            vc.modalPresentationStyle = .overCurrentContext
            vc.dissmissVC = {[weak self] (isSuccess, clientName, clientNumber) in
               // vc.DISMISS(false)
                
                if isSuccess {
                    self?.moveVC(with: self?.accessToken ?? "",
                                 clientName: clientName,
                                 clientNumber: clientNumber)
                }
            }
            //self.PRESENT(vc, false)
            self.present(vc, animated: true, completion: nil)
        } else {
            self.view.makeToast(validate.error, duration: 1, position: .center)
        }
    }
    private func moveVC(with token: String, clientName: String, clientNumber: String) {
       // let vc = OPIViewController.instantiate(from: .Home)
        let vc = storyboard?.instantiateViewController(identifier: "OPIViewController") as! OPIViewController
        vc.accessToken = token
        vc.sourceLang = self.txtSourceLanguage.text
        vc.slID = self.languageViewModel.sID ?? ""
        vc.LID = self.languageViewModel.lID ?? ""
        vc.clientName = clientName
        vc.clientNumber = clientNumber
        vc.destinationLang = self.txtTargetlanguage.text
        //self.PUSH(vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
