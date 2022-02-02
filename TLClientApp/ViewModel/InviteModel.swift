//
//  InviteModel.swift
//  TLClientApp
//
//  Created by Naiyer on 10/8/21.
//

import Foundation

var actualRoom: String?
var sID: String?
var fromUserID: String?

class InviteModel: NSObject {
    var Id: String?
    var ErrorId : String?
    override init() {
        Id = ""
        ErrorId = ""
        
    }
    class func getData(dicts: NSDictionary) -> InviteModel {
        
        let item = InviteModel()
        item.Id = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Id") ?? "") as String
        item.ErrorId = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "ErrorId") ?? "") as String
       return item
        
    }
}
