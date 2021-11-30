//
//  OnDemandOPIViewController.swift
//  TLClientApp
//
//  Created by Naiyer on 8/20/21.
//

import UIKit
import XLPagerTabStrip

class OnDemandOPIViewController: UIViewController,IndicatorInfoProvider,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var txtTargetlanguage: ACFloatingTextfield!
    @IBOutlet weak var txtSourceLanguage: ACFloatingTextfield!
    
    var vriPickerView = UIPickerView()
    var sourceLang = true
    var languageViewModel = LanguageVM()
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo
    {
        
        return IndicatorInfo(title:"Ondemand OPI")
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
        languageViewModel.languageData { list, err in
            if err == nil {
                self.languageViewModel.titleToTxtField(row: 0, txtField: self.txtSourceLanguage)
               
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
        let request = TxtRequest(txt: txtTargetlanguage.text)
        let validate = ValidationReq().validate(txtfield: request)
        if validate.success {
            
        }
        else {
            self.view.makeToast(validate.error, duration: 1, position: .center)
        }
    }
    
    
}
