//
//  CallingModel.swift
//  TLClientApp
//
//  Created by Naiyer on 8/26/21.
//

import Foundation
import UIKit


struct RoomResultModel : Codable{
    var RoomNo: String?
    enum CodingKeys:String, CodingKey {
        case RoomNo = "RoomNo"
    }
    init(from decoder: Decoder) throws {
        let item = try decoder.container(keyedBy: CodingKeys.self)
        RoomNo = try item.decodeIfPresent(String.self, forKey: .RoomNo)
        
    }
}
struct ConferenceResult : Codable {
    var result : [ConferenceResultModel]?
    enum CodingKeys: String, CodingKey {
        case result = "result"
        
    }
    init(from decoder: Decoder) throws {
        let item = try decoder.container(keyedBy: CodingKeys.self)
        result = try item.decodeIfPresent([ConferenceResultModel].self, forKey: .result)
    }
    
}

struct ConferenceResultModel:Codable {
    var tOTALRECORDS : String?
    var cONFERENCEInfo : [ConferenceInfoModel]?
    enum CodingKeys: String, CodingKey {
        case cONFERENCEInfo = "CONFERENCEInfo"
        case tOTALRECORDS = "TOTALRECORDS"
    }
    init(from decoder: Decoder) throws {
        let item = try decoder.container(keyedBy: CodingKeys.self)
        cONFERENCEInfo = try item.decodeIfPresent([ConferenceInfoModel].self, forKey: .cONFERENCEInfo)
        tOTALRECORDS = try item.decodeIfPresent(String.self, forKey: .tOTALRECORDS)
    }
}

struct ConferenceInfoModel : Codable{
    var ID: String?
    var UserName: String?
    var EMAIL: String?
    var FROMUSERID: String?
    var ACTUALROOM: String?
    var PARTSID: String?
    var ROOMSID: String?
    var TOUSERID: String?
    var FNAME: String?
    var LNAME: String?
    var MUTE: String?
    var TYPE: String?
    
    var ROOMNO: String?
    var DAILCALL: String?
    var VIDEO: String?
   
    enum CodingKeys:String, CodingKey {
        case ID = "ID"
        case UserName = "UserName"
        case EMAIL = "EMAIL"
        case FROMUSERID = "FROMUSERID"
        case ACTUALROOM = "ACTUALROOM"
        case PARTSID = "PARTSID"
        case ROOMSID = "ROOMSID"
        case TOUSERID = "TOUSERID"
        case FNAME = "FNAME"
        case LNAME = "LNAME"
        case MUTE = "MUTE"
        case TYPE = "TYPE"
        
        case ROOMNO = "ROOMNO"
        case DAILCALL = "DAILCALL"
        case VIDEO = "VIDEO"
       
    }
    init(from decoder: Decoder) throws {
        let item = try decoder.container(keyedBy: CodingKeys.self)
        ID = try item.decodeIfPresent(String.self, forKey: .ID)
        UserName = try item.decodeIfPresent(String.self, forKey: .UserName)
        EMAIL = try item.decodeIfPresent(String.self, forKey: .EMAIL)
        FROMUSERID = try item.decodeIfPresent(String.self, forKey: .FROMUSERID)
        ACTUALROOM = try item.decodeIfPresent(String.self, forKey: .ACTUALROOM)
        PARTSID = try item.decodeIfPresent(String.self, forKey: .PARTSID)
        ROOMSID = try item.decodeIfPresent(String.self, forKey: .ROOMSID)
        TOUSERID = try item.decodeIfPresent(String.self, forKey: .TOUSERID)
        FNAME = try item.decodeIfPresent(String.self, forKey: .FNAME)
        LNAME = try item.decodeIfPresent(String.self, forKey: .LNAME)
        MUTE = try item.decodeIfPresent(String.self, forKey: .MUTE)
        TYPE = try item.decodeIfPresent(String.self, forKey: .TYPE)
        ROOMNO = try item.decodeIfPresent(String.self, forKey: .ROOMNO)
        DAILCALL = try item.decodeIfPresent(String.self, forKey: .DAILCALL)
        VIDEO = try item.decodeIfPresent(String.self, forKey: .VIDEO)
       
        
        
    }
}
class ConferenceInfoResultModel: NSObject {
    var CONFERENCEInfo: NSMutableArray?
    var TOTALRECORDS: String?
    override init() {
        CONFERENCEInfo = NSMutableArray()
        TOTALRECORDS = ""
    }
    class func getDetails(dicts: NSDictionary) -> ConferenceInfoResultModel {
        let item = ConferenceInfoResultModel()
        let confArr = dicts["CONFERENCEInfo"] as! NSArray
        for obj in confArr {
            let nObject :ConferenceInfoModels = ConferenceInfoModels.getDetails(dicts: obj as! NSDictionary)
            item.CONFERENCEInfo?.add(nObject)
        }
        return item
        
    }
    
}
class ConferenceInfoModels: NSObject {
    var ACTUALROOM: String?
    var CALL: String?
    var DAILCALL: String
    var EMAIL: String?
    var FNAME: String?
    var FROMUSERID: String?
    var ID: String?
    var LNAME: String?
    var MUTE: String?
    var PARTSID: String?
    var ROOMNO: String?
    var ROOMSID: String?
    var TOUSERID: String?
    var TYPE: String?
    var UserName: String?
    var VIDEO: String?
    override init() {
        ACTUALROOM = ""
        CALL = ""
        DAILCALL = ""
        EMAIL = ""
        FNAME = ""
        FROMUSERID = ""
        ID = ""
        LNAME = ""
        MUTE = ""
        PARTSID = ""
        ROOMNO = ""
        ROOMSID = ""
        TOUSERID = ""
        TYPE = ""
        UserName = ""
        VIDEO = ""
    }
    class func getDetails(dicts: NSDictionary) -> ConferenceInfoModels {
        let item = ConferenceInfoModels()
        item.ACTUALROOM = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "ACTUALROOM") ?? "") as String
        item.CALL = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CALL") ?? "") as String
        item.DAILCALL = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "DAILCALL") ?? "") as String
        item.EMAIL = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "EMAIL") ?? "") as String
        item.FNAME = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "FNAME") ?? "") as String
        item.FROMUSERID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "FROMUSERID") ?? "") as String
        item.ID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "ID") ?? "") as String
        item.LNAME = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "LNAME") ?? "") as String
        item.MUTE = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "MUTE") ?? "") as String
        item.PARTSID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "PARTSID") ?? "") as String
        item.ROOMNO = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "ROOMNO") ?? "") as String
        item.ROOMSID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "ROOMSID") ?? "") as String
        item.TOUSERID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "TOUSERID") ?? "") as String
        item.TYPE = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "TYPE") ?? "") as String
        item.UserName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "UserName") ?? "") as String
        item.VIDEO = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "VIDEO") ?? "") as String
        
        return item
    }
}


class CallStatusResultModel: NSObject {
    var UserInfo: NSMutableArray?
    
    override init() {
        UserInfo = NSMutableArray()
        
    }
    class func getDetails(dicts: NSDictionary) -> CallStatusResultModel {
        let item = CallStatusResultModel()
        let confArr = dicts["UserInfo"] as! NSArray
        for obj in confArr {
            let nObject :UserInfoModel = UserInfoModel.getDetails(dicts: obj as! NSDictionary)
            item.UserInfo?.add(nObject)
        }
        return item
        
    }
    
}
class UserInfoModel: NSObject {
    var UserId: String?
    var username: String?
    var CustomerDisplayName: String
    var SLangID: String?
    var TLangID: String?
    var SLangName: String?
    var TLangName: String?
    var VendorDeviceType: String?
    var VendorTokenID: String?
    var VendorVOIPTokenID: String?
    var CustDeviceType: String?
    var CustTokenID: String?
    var Address: String?
    var City: String?
    var Zipcode: String?
    var CustomerImage: String?
    override init() {
        UserId = ""
        username = ""
        CustomerDisplayName = ""
        SLangID = ""
        TLangID = ""
        SLangName = ""
        TLangName = ""
        VendorDeviceType = ""
        VendorTokenID = ""
        VendorVOIPTokenID = ""
        CustDeviceType = ""
        CustTokenID = ""
        Address = ""
        City = ""
        Zipcode = ""
        CustomerImage = ""
    }
    class func getDetails(dicts: NSDictionary) -> UserInfoModel {
        let item = UserInfoModel()
        item.UserId = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "UserId") ?? "") as String
        item.username = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "username") ?? "") as String
        item.CustomerDisplayName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CustomerDisplayName") ?? "") as String
        item.SLangID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "SLangID") ?? "") as String
        item.TLangID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "TLangID") ?? "") as String
        item.SLangName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "SLangName") ?? "") as String
        item.VendorDeviceType = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "VendorDeviceType") ?? "") as String
        item.VendorTokenID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "VendorTokenID") ?? "") as String
        item.VendorVOIPTokenID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "VendorVOIPTokenID") ?? "") as String
        item.CustDeviceType = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CustDeviceType") ?? "") as String
        item.CustTokenID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CustTokenID") ?? "") as String
        item.Address = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Address") ?? "") as String
        item.City = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "City") ?? "") as String
        item.Zipcode = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Zipcode") ?? "") as String
        item.CustomerImage = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CustomerImage") ?? "") as String
        item.TLangName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "TLangName") ?? "") as String
        
        return item
    }
}
