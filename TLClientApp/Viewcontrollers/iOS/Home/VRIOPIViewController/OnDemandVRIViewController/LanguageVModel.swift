//
//  LanguageVModel.swift
//  TLClientApp
//
//  Created by Naiyer on 8/21/21.
//

import Foundation
import UIKit

class LanguageVM {
    var lanuageList = LanguageList()
    var languageListArr = [LanguageModel]()
    func languageData(complitionBlock: @escaping(LanguageList?, Error?) -> ()){
        
        WebServices.get(url: APi.languagedata.url) { (response, _) in
            self.lanuageList  = LanguageList.getLanguagedata(dicts: response as! NSDictionary)
            self.languageListArr = self.lanuageList.LanguageData as! [LanguageModel]
            complitionBlock(self.lanuageList,nil)
            SwiftLoader.hide()
        } failureHandler: { (error, _) in
            complitionBlock(nil,nil)
            SwiftLoader.hide()
        }
        
    }
    
    func totalNumberOfrow() -> Int {
        return lanuageList.LanguageData?.count ?? 0
    }
    func titleForList(row: Int) -> String{
        let item = lanuageList.LanguageData![row] as! LanguageModel
        return item.LanguageName
    }
    func titleToTxtField(row: Int, txtField: UITextField) {
        
        txtField.text = titleForList(row: row)
        
        
    }
    func getSournceSelectedLID(stlanguage:String) -> String {
        if let stIndex = languageListArr.first(where: {$0.LanguageName == stlanguage}) {
           
            return stIndex.LanguageID
           
        }
        else {
            return ""
        }
       
    }
    

    
}
