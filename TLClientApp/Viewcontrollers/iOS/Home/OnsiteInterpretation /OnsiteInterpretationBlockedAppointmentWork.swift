//
//  OnsiteInterpretationBlockedAppointmentWork.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 04/02/22.
//

import Foundation
import UIKit
extension OnsiteInterpretationNewViewController {
    func showLanguageForBlocked(){
        self.blockedLanguageTF.optionArray = self.languageArray
        print("OPTIONS ARRYA \(GetPublicData.sharedInstance.languageArray)")
        print("OPTIONS NEW ARRAY \(languageTF.optionArray)")
        blockedLanguageTF.checkMarkEnabled = true
        blockedLanguageTF.isSearchEnable = true
        blockedLanguageTF.selectedRowColor = UIColor.clear
        blockedLanguageTF.didSelect{(selectedText , index , id) in
            self.blockedLanguageTF.text = "\(selectedText)"
            self.BlockedLanguage = "\(selectedText)"
            self.blockedAppointmentTV.reloadData()
            self.languageDetail.forEach({ languageData in
                print("language data.... \(languageData.languageName ?? "")")
                if selectedText == languageData.languageName ?? "" {
                    self.languageID = "\(languageData.languageID ?? 0)"
                    print("languageId \(self.languageID)")
                    self.languageName = languageData.languageName ?? ""
                    self.blockedAppointmentArr.forEach { BlockedAppointmentData in
                        BlockedAppointmentData.languageName = selectedText
                        BlockedAppointmentData.languageID = languageData.languageID ?? 0
                        print(BlockedAppointmentData.languageName, BlockedAppointmentData.languageID)
                    }
                    
                    
                    
                }
            })
        }
    }
    
    func showblockedGenderDropdown(){
        
        blockedGenderTF.optionArray = self.genderArray
        
        print("OPTIONS NEW ARRAY \(blockedGenderTF.optionArray)")
        
        blockedGenderTF.checkMarkEnabled = true
        blockedGenderTF.isSearchEnable = true
        blockedGenderTF.selectedRowColor = UIColor.clear
        blockedGenderTF.didSelect{(selectedText , index , id) in
            self.blockedGenderTF.text = "\(selectedText)"
            
            self.genderDetail.forEach({ languageData in
                print("language data......... \(languageData.Value ?? "")")
                if selectedText == languageData.Value ?? "" {
                    self.genderID = languageData.Code ?? ""
                    print("languageId \(self.genderID)")
                    self.isGenderSelect = true
                }
            })
        }
    }
}
