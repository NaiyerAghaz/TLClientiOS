//
//  LanguageModel.swift
//  TLClientApp
//
//  Created by Naiyer on 8/21/21.
//

import Foundation
/*
 {
 "LanguageData": [
 {
 "LanguageID": 1198,
 "LanguageName": "Abkhazian",
 "Active": false,
 "Type": null,
 "Rate": 0,
 "VendorLanguageID": null,
 "LanguageColorCode": null
 },
 */

class LanguageList: NSObject {
    var LanguageData: NSMutableArray?
    override init() {
        LanguageData = NSMutableArray()
    }
    class func getLanguagedata(dicts: NSDictionary) -> LanguageList {
        let item = LanguageList()
        item.LanguageData = NSMutableArray()
        let arr: NSArray = dicts["LanguageData"] as! NSArray
        for obj in arr {
            let nItem :LanguageModel = LanguageModel.getLanguageList(dicts: obj as! NSDictionary)
            item.LanguageData?.add(nItem)
        }
        return item
    }
}
class LanguageModel : NSObject{
    var LanguageID: String
    var LanguageName : String
    var Active : Bool
    var Types: String
    var Rate: String
    var VendorLanguageID: String
    var LanguageColorCode : String
    override init() {
        LanguageID = ""
        LanguageName = ""
        Active = false
        Types = ""
        Rate = ""
        VendorLanguageID = ""
        LanguageColorCode = ""
    }
    class func getLanguageList(dicts: NSDictionary) -> LanguageModel {
        
        let item = LanguageModel()
        item.LanguageID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "LanguageID") ?? "") as String
        item.LanguageName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "LanguageName") ?? "") as String
        if let active = dicts.value(forKey: "Active") as? Bool {
            item.Active = active
        }
        else {
            item.Active = false
        }
        item.Types = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Type") ?? "") as String
        item.Rate = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Rate") ?? "") as String
        item.VendorLanguageID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "VendorLanguageID") ?? "") as String
        item.LanguageColorCode = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "LanguageColorCode") ?? "") as String
         return item
        
    }
}
