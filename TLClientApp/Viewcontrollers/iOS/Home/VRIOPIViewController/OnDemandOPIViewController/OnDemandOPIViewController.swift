//
//  OnDemandOPIViewController.swift
//  TLClientApp
//
//  Created by Naiyer on 8/20/21.
//

import UIKit
import XLPagerTabStrip
import iOSDropDown
class OnDemandOPIViewController: UIViewController,IndicatorInfoProvider,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var txtTargetlanguage: iOSDropDown!
    @IBOutlet weak var txtSourceLanguage: iOSDropDown!
    
    var vriPickerView = UIPickerView()
    var sourceLang = true
    var languageViewModel = LanguageVM()
    var onDemandOPIVM = OnDemandOPIVM()
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo
    {
        
        return IndicatorInfo(title:"Ondemand OPI")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        uiUpdate()
        let userID = GetPublicData.sharedInstance.userID
        onDemandOPIVM.getTwilioAccessToken(userId: userID) { (token, error) in
            print("Twillio OPI Token ", token)
        }
        // Do any additional setup after loading the view.
    }
    public func uiUpdate(){
        //txtTargetlanguage.delegate = self
        //txtSourceLanguage.delegate = self
        //txtTargetlanguage.inputView = vriPickerView
       // txtSourceLanguage.inputView = vriPickerView
        
        self.txtSourceLanguage.layer.borderWidth = 0.6
        self.txtSourceLanguage.layer.cornerRadius = 10
        self.txtSourceLanguage.layer.borderColor = UIColor.gray.cgColor
        self.txtSourceLanguage.setLeftPaddingPoints(20)
        
        self.txtTargetlanguage.layer.borderWidth = 0.6
        self.txtTargetlanguage.layer.cornerRadius = 10
        self.txtTargetlanguage.layer.borderColor = UIColor.gray.cgColor
        self.txtTargetlanguage.setLeftPaddingPoints(20)
        
        txtSourceLanguage.optionArray = GetPublicData.sharedInstance.languageArray
        txtSourceLanguage.checkMarkEnabled = true
        txtSourceLanguage.isSearchEnable = true
        txtSourceLanguage.selectedRowColor = UIColor.clear
        txtSourceLanguage.didSelect{(selectedText , index , id) in
           self.txtSourceLanguage.text = "\(selectedText)"
       }
        
        txtTargetlanguage.optionArray = GetPublicData.sharedInstance.languageArray
        txtTargetlanguage.checkMarkEnabled = true
        txtTargetlanguage.isSearchEnable = true
        txtTargetlanguage.selectedRowColor = UIColor.clear
        txtTargetlanguage.didSelect{(selectedText , index , id) in
           self.txtTargetlanguage.text = "\(selectedText)"
       }
        languageViewModel.languageData { list, err in
            if err == nil {
                //self.languageViewModel.titleToTxtField(row: 0, txtField: self.txtSourceLanguage)
               
            }
          }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtSourceLanguage{
            sourceLang = true
         }
        else {
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
        
        return languageViewModel.titleForList(row: row)
        
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
        print("LANGUAGE LIST ARRAY IS \(languageViewModel.languageListArr)")
        let request = TxtRequest(txt: txtTargetlanguage.text)
        let validate = ValidationReq().validate(txtfield: request)
        if validate.success {
            let callVC = UIStoryboard(name: Storyboard_name.home, bundle: nil)
            let vcontrol = callVC.instantiateViewController(identifier: viewIndentifier.CallingPopupVC.rawValue) as! CallingPopupVC
            vcontrol.modalPresentationStyle = .overFullScreen
            vcontrol.calltype = "OPI"
            vcontrol.sourceID = languageViewModel.getSournceSelectedLID(stlanguage: txtSourceLanguage.text!)
            vcontrol.sourceName = txtSourceLanguage.text!
            vcontrol.targetID = languageViewModel.getSournceSelectedLID(stlanguage: txtTargetlanguage.text!)
            vcontrol.targetName = txtTargetlanguage.text!
            print("Language ID for call is ,",vcontrol.sourceID , vcontrol.targetID)
            self.present(vcontrol, animated: true, completion: nil)
        }
        else {
            self.view.makeToast(validate.error, duration: 1, position: .center)
        }
    }
    
    
}

/*
 call button previous data 
let request = TxtRequest(txt: txtTargetlanguage.text)
let validate = ValidationReq().validate(txtfield: request)
if validate.success {
    
}
else {
    self.view.makeToast(validate.error, duration: 1, position: .center)
}*/
