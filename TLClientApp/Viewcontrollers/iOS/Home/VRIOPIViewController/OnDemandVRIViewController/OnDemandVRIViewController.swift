//
//  OnDemandVRIViewController.swift
//  TLClientApp
//
//  Created by Naiyer on 8/20/21.
//

import UIKit
import XLPagerTabStrip


class OnDemandVRIViewController: UIViewController,IndicatorInfoProvider, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var txtTargetlanguage: ACFloatingTextfield!
    @IBOutlet weak var txtSourceLanguage: ACFloatingTextfield!
    
    var vriPickerView = UIPickerView()
    var sourceLang = true
    var languageViewModel = LanguageVM()
    var isShownParti = false
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo
    {
        
        return IndicatorInfo(title:"Ondemand VRI")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        uiUpdate()
        
        // Do any additional setup after loading the view.
    }
    
    public func uiUpdate(){
        txtTargetlanguage.delegate = self
        txtSourceLanguage.delegate = self
        txtTargetlanguage.inputView = vriPickerView
        txtSourceLanguage.inputView = vriPickerView
        SwiftLoader.show(animated: true)
        languageViewModel.languageData { list, err in
            if err == nil {
                SwiftLoader.hide()
                self.txtSourceLanguage.text = "English"
                //self.languageViewModel.titleToTxtField(row: 0, txtField: self.txtSourceLanguage)
                //
                
            }}
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
            pickerView.updateConstraints()
            languageViewModel.titleToTxtField(row: row, txtField: txtSourceLanguage)
        }
        else {
            pickerView.updateConstraints()
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
            
            vcontrol.sourceID = languageViewModel.getSournceSelectedLID(stlanguage: txtSourceLanguage.text!)
            vcontrol.sourceName = txtSourceLanguage.text!
            vcontrol.targetID = languageViewModel.getSournceSelectedLID(stlanguage: txtTargetlanguage.text!)
            vcontrol.targetName = txtTargetlanguage.text!
            self.present(vcontrol, animated: true, completion: nil)
        }
        else {
            self.view.makeToast(validate.error, duration: 1, position: .center)
        }
    }
    }



