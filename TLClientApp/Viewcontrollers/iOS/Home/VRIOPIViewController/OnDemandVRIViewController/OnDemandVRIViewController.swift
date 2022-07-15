//
//  OnDemandVRIViewController.swift
//  TLClientApp
//
//  Created by Naiyer on 8/20/21.
//

import UIKit
import XLPagerTabStrip
import iOSDropDown
import Malert

class OnDemandVRIViewController: UIViewController,IndicatorInfoProvider {
    
    
    @IBOutlet weak var txtTargetlanguage: iOSDropDown!
    @IBOutlet weak var txtSourceLanguage: iOSDropDown!
    
    var vriPickerView = UIPickerView()
    var sourceLang = true
    var languageViewModel = LanguageVM()
    var isShownParti = false
   
    var itemInfo = IndicatorInfo(title: "view")
    
    
    
    init(itemInfo: IndicatorInfo)  {
        super.init(nibName: nil, bundle: nil)
        self.itemInfo = itemInfo
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        uiUpdate()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if isFeedback == true {
            
        }
    }
    
    public func uiUpdate(){
        // txtTargetlanguage.delegate = self
        // txtSourceLanguage.delegate = self
        // txtTargetlanguage.inputView = vriPickerView
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
        //        txtSourceLanguage.listWillAppear {
        //            self.txtSourceLanguage.text = self.txtSourceLanguage.text
        //        }
        txtSourceLanguage.didSelect{(selectedText , index , id) in
            //  self.txtSourceLanguage.resignFirstResponder()
            self.txtSourceLanguage.text = "\(selectedText)"
        }
        
        txtTargetlanguage.optionArray = GetPublicData.sharedInstance.languageArray
        txtTargetlanguage.checkMarkEnabled = true
        txtTargetlanguage.isSearchEnable = true
        txtTargetlanguage.selectedRowColor = UIColor.clear
        txtTargetlanguage.didSelect{(selectedText , index , id) in
            //  self.txtTargetlanguage.resignFirstResponder()
            self.txtTargetlanguage.text = "\(selectedText)"
        }
        
        if Reachability.isConnectedToNetwork() {
            SwiftLoader.show(animated: true)
            languageViewModel.languageData { list, err in
                if err == nil {
                    SwiftLoader.hide()
                    //
                    self.txtSourceLanguage.text = "English"
                    //self.languageViewModel.titleToTxtField(row: 0, txtField: self.txtSourceLanguage)
                    //
                    
                }}}else {
                    self.view.makeToast(ConstantStr.noItnernet.val)
                }
    }
    
    
    @IBAction func btnCallNowTapped(_ sender: Any) {
        
        let request = TxtRequest(txt: txtTargetlanguage.text)
        let t = ValidationReq().tValidate(txtfield: request)
        let sReq = TxtRequest(txt: txtSourceLanguage.text)
        let s = ValidationReq().sValidate(txtfield: sReq)
        
        if !s.success {
            return self.view.makeToast(s.error, duration: 1, position: .center)
        }
        if !t.success {
            return self.view.makeToast(t.error, duration: 1, position: .center)
        }
        if languageViewModel.getSournceSelectedLID(stlanguage: txtSourceLanguage.text!) == "" {
            return self.view.makeToast("Please select valid source language", position: .center)
        }
        else if languageViewModel.getSournceSelectedLID(stlanguage: txtTargetlanguage.text!) == ""{
            return self.view.makeToast("Please select valid target language",position: .center)
        }
        else {
            let callVC = UIStoryboard(name: Storyboard_name.home, bundle: nil)
            let vcontrol = callVC.instantiateViewController(identifier: viewIndentifier.CallingPopupVC.rawValue) as! CallingPopupVC
            
            vcontrol.calltype = "VRI"
            vcontrol.sourceID = languageViewModel.getSournceSelectedLID(stlanguage: txtSourceLanguage.text!)
            vcontrol.sourceName = txtSourceLanguage.text!
            vcontrol.targetID = languageViewModel.getSournceSelectedLID(stlanguage: txtTargetlanguage.text!)
            vcontrol.targetName = txtTargetlanguage.text!
            vcontrol.modalPresentationStyle = .overFullScreen
            self.present(vcontrol, animated: true, completion: nil)
        }
        
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo
    {
        
        return itemInfo
    }
    }



