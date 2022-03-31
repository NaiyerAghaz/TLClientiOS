//
//  Models.swift
//  TLClientApp
//
//  Created by Naiyer on 8/28/21.
//

import Foundation
/*
 {
     "identity": "IgnominiousKendraLiberty",
     "sname": "",
     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTSzIxMDI5Y2QyODNkMDMwNzBhMDMwMjMyZjc3YmIxOGI2LTE2MzAxNTE0NzgiLCJncmFudHMiOnsiaWRlbnRpdHkiOiJJZ25vbWluaW91c0tlbmRyYUxpYmVydHkiLCJ2aWRlbyI6e319LCJpYXQiOjE2MzAxNTE0NzgsImV4cCI6MTYzMDE1NTA3OCwiaXNzIjoiU0syMTAyOWNkMjgzZDAzMDcwYTAzMDIzMmY3N2JiMThiNiIsInN1YiI6IkFDYzBmZTUzMDdlN2ZiYmIxYjRkYTc4MGMxN2QzYzljMGUifQ.sZUVgtebRwRz9Z7TxJPNxWDyzVbBiAzh5KJIswxhf14",
     "twiliobalance": 278.29,
     "currency": "USD"
 }
 */
//struct TwilioModel : Codable{
//    var identity,sname,token,currency: String?
//    var twiliobalance: String?
//    enum CodingKeys:String, CodingKey {
//        case identity = "identity"
//        case sname = "sname"
//        case token = "token"
//        case currency = "currency"
//        case twiliobalance = "twiliobalance"
//    }
//    init(from decoder: Decoder) throws {
//        let item = try decoder.container(keyedBy: CodingKeys.self)
//        identity = try item.decodeIfPresent(String.self, forKey: .identity)
//        sname = try item.decodeIfPresent(String.self, forKey: .sname)
//        token = try item.decodeIfPresent(String.self, forKey: .token)
//        currency = try item.decodeIfPresent(String.self, forKey: .currency)
//        twiliobalance = try item.decodeIfPresent(String.self, forKey: .twiliobalance)
//
//    }
//}
class TwilioModel : NSObject{
    var identity,sname,token,currency,twiliobalance: String?
    override init() {
        identity = ""
        sname = ""
        currency = ""
        twiliobalance = ""
        token = ""
       
    }
    class func getTwilioData(dicts: NSDictionary) -> TwilioModel {
        
        let item = TwilioModel()
        item.identity = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "identity") ?? "") as String
        item.sname = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "sname") ?? "") as String
        
       
        item.currency = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "currency") ?? "") as String
        item.twiliobalance = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "twiliobalance") ?? "") as String
        item.token = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "token") ?? "") as String
        
         return item
        
    }
}

class TwilioChatModel: NSObject {
    var identity,token: String?
    override init(){
        identity = ""
        token = ""
    }
    class func getData(dicts: NSDictionary) -> TwilioChatModel {
        let item = TwilioChatModel()
        item.identity = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "identity") ?? "") as String
        item.token = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "token") ?? "") as String
        return item
    }
}
class MeetingResultModel: NSObject {
    var resultData : NSMutableArray?
    override init() {
       resultData = NSMutableArray()
        
    }
    class func getData(dicts: NSDictionary) -> MeetingResultModel{
        let items = MeetingResultModel()
        items.resultData = NSMutableArray()
        let arr = dicts["ResultData"] as! NSArray
        for item in arr {
            let obj :ClientStatusModel = ClientStatusModel.getData(dicts: item as! NSDictionary)
            items.resultData?.add(obj)
        }
      return items
    }
}
//ClientStatusModel:
class ClientStatusModel: NSObject {
    var CLIENTSTATUS: String?
    var DURATION: String?
    var INVITECOUNT: String?
    var INVITEDATA: NSMutableArray?
    var INVITESTATUS: String?
    var ROOMNO: String?
    var INVITEDATA2: String?
   override init() {
    CLIENTSTATUS = ""
    DURATION = ""
    INVITECOUNT = ""
    INVITEDATA = NSMutableArray()
    INVITESTATUS = ""
    ROOMNO = ""
    INVITEDATA2 = ""
    
    }
    class func getData(dicts: NSDictionary) -> ClientStatusModel {
        print("coferenceDict:--------------------->", dicts)
        let item = ClientStatusModel()
        item.CLIENTSTATUS = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CLIENTSTATUS") ?? "") as String
        item.DURATION = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "DURATION") ?? "") as String
        item.INVITECOUNT = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "INVITECOUNT") ?? "") as String
        item.ROOMNO = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "ROOMNO") ?? "") as String
        item.INVITESTATUS = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "INVITESTATUS") ?? "") as String
        
        if let invitedata =  dicts.value(forKey: "INVITEDATA") as? Int {
            item.INVITEDATA2 = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "INVITEDATA") ?? "") as String
        }
        else {
            item.INVITEDATA = NSMutableArray()
            let arr = dicts["INVITEDATA"] as! NSArray
            for nItem in arr {
                let obj:INVITEDATAMODEL = INVITEDATAMODEL.getData(dicts: nItem as! NSDictionary)
                item.INVITEDATA?.add(obj)
            }
        }
       return item
    }

}
class INVITEDATAMODEL: NSObject {
    var name: String?
    var partstatus: String?
    var pid: String?
    override init() {
        name = ""
        partstatus = ""
        pid = ""
        
    }
    class func getData(dicts: NSDictionary) -> INVITEDATAMODEL{
        let items = INVITEDATAMODEL()
        items.name = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "name") ?? "") as String
        items.partstatus = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "partstatus") ?? "") as String
        items.pid = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "pid") ?? "") as String
        return items
    }
}
