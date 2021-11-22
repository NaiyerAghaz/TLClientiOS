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
