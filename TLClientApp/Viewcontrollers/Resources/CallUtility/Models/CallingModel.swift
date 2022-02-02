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
/* ACTUALROOM = 21092529;
 CALL = 1;
 DAILCALL = N;
 EMAIL = "";
 FNAME = "";
 FROMUSERID = 0;
 ID = 35181;
 LNAME = "";
 MUTE = 1;
 PARTSID = PA72be4615c644f55ece7960015443e2cb;
 ROOMNO = "";
 ROOMSID = RM8054049ba2d5fed02a8fa2801f4409ac;
 TOUSERID = 218925;
 TYPE = V;
 UserName = vendor;
 VIDEO = 1;*/
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



/*[
 {
     "result": "[{\"CONFERENCEInfo\":[{\"ID\":35138,\"UserName\":\"vendor\",\"EMAIL\":\"\",\"FROMUSERID\":0,\"ACTUALROOM\":\"21092111\",\"PARTSID\":\"PAbfa45f0004b4e57e22b2c2c885f8e61c\",\"ROOMSID\":\"RMe3eea7744963e572a3db850e1dcf7979\",\"TOUSERID\":218925,\"FNAME\":\"\",\"LNAME\":\"\",\"MUTE\":1,\"VIDEO\":1,\"CALL\":1,\"TYPE\":\"V\",\"ROOMNO\":\"\",\"DAILCALL\":\"N\"}],\"TOTALRECORDS\":1}]"
 }
]*/

/*{
 CONFERENCEInfo =         (
                 {
         ACTUALROOM = 21092515;
         CALL = 1;
         DAILCALL = N;
         EMAIL = "";
         FNAME = "";
         FROMUSERID = 0;
         ID = 35176;
         LNAME = "";
         MUTE = 1;
         PARTSID = PA669efb0081be7a6aa503b4f534992844;
         ROOMNO = "";
         ROOMSID = RMcac0b76864735ad293cbf9fd563d6a14;
         TOUSERID = 218925;
         TYPE = V;
         UserName = vendor;
         VIDEO = 1;
     }
 );
 TOTALRECORDS = 1;
}*/

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
