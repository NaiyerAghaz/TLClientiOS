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
    func languageData(complitionBlock: @escaping(LanguageList?, Error?) -> ()){
        
        WebServices.get(url: APi.languagedata.url) { (response, _) in
            self.lanuageList  = LanguageList.getLanguagedata(dicts: response as! NSDictionary)
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
}
