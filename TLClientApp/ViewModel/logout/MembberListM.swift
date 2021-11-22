//
//  MembberListM.swift
//  TLClientApp
//
//  Created by Mac on 13/09/21.
//

import Foundation

struct MemberListM {
    
    var username: String?
    var userid: String?
    var languagename: String?
    var customerdisplayname: String?
    var flag: String?
    var tokenid: String?
    var rating: Int?
    var devicetype: String?
    var streetaddress: String?
    var city: String?
    var zipcode: String?
    var SourceLat: String?
    var SourceLng: String?
    var AcceptUser: String?
    var CustomerImage: String?
    var ServerKey: String?
    var VOIPTokenID: String?
    var inHouse: Int?
    var thirdparty: Int?
    var thirdPartyAccess: Bool?
    var EffectiveAccess: Bool?
    
    init(json: [String: Any]) {
        
        self.username = json["username"] as? String
        self.userid = json["userid"] as? String
        self.languagename = json["languagename"] as? String
        self.customerdisplayname = json["customerdisplayname"] as? String
        self.flag = json["flag"] as? String
        self.tokenid = json["tokenid"] as? String
        self.rating = json["rating"] as? Int
        self.devicetype = json["devicetype"] as? String
        self.streetaddress = json["streetaddress"] as? String
        self.city = json["city"] as? String
        self.zipcode = json["zipcode"] as? String
        self.SourceLat = json["SourceLat"] as? String
        self.SourceLng = json["SourceLng"] as? String
        self.AcceptUser = json["AcceptUser"] as? String
        self.CustomerImage = json["CustomerImage"] as? String
        self.ServerKey = json["ServerKey"] as? String
        self.VOIPTokenID = json["VOIPTokenID"] as? String
        self.inHouse = json["inHouse"] as? Int
        self.thirdparty = json["thirdparty"] as? Int
        self.thirdPartyAccess = json["thirdPartyAccess"] as? Bool
        self.EffectiveAccess = json["EffectiveAccess"] as? Bool
        
        
        
    }
}
