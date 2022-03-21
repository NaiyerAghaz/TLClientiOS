//
//  VendorCallStatusModel.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 17/03/22.
//

import Foundation

struct VendorCallStatusModel : Codable{
    var UserInfo: [VendorCallUserInfoModel]?
    enum CodingKeys:String, CodingKey {
        case UserInfo = "UserInfo"
    }
    init(from decoder: Decoder) throws {
        let item = try decoder.container(keyedBy: CodingKeys.self)
        UserInfo = try item.decodeIfPresent([VendorCallUserInfoModel].self, forKey: .UserInfo)
        
    }
}
/*[
 {
     "result": "[{\"UserInfo\":[{\"UserId\":218925,\"username\":\"Naiyer\",\"CustomerDisplayName\":\"Naiyer Aghaz\",\"SLangID\":3,\"TLangID\":1205,\"SLangName\":\"English\",\"TLangName\":\"Language Test\",\"VendorDeviceType\":\"W\",\"VendorTokenID\":\"\",\"VendorVOIPTokenID\":\"\",\"CustDeviceType\":\"I\",\"CustTokenID\":\"dlHurmKBj0_yvIiWIPufvT:APA91bE69TXOZ75T8X5WRE75gJx_gav5y0doGk5btTxYThy9fRrUODLkNypHvFbsy4LoiRZGXSp8Ynlm5_b52lHZyg7VGTSWrfB7cmN_6F1EAzSGtCtwMZYk6cTRSIVjpu0-RPyo2J8K\",\"Address\":\"\",\"City\":\"\",\"Zipcode\":\"\",\"CustomerImage\":\"\/images\/noProfile.jpg\",\"ServerKey\":\"key=AAAAwFzL4r8:APA91bEEQWENO6Zc1koty-h0R3-lgg_djfK4Y-x1dIYyyfoBM9odda-jzfvcGxB66tpvo9SCiFsKDh-QTXFGIdZAwcSwPgwpFt4IklQzPq8v-dI7u_gO3w3bTDHKu_a24hwEVUZtcSlR\",\"VendorLat\":\"\",\"VendorLng\":\"\",\"inHouse\":0,\"thirdparty\":0,\"thirdPartyAccess\":false,\"EffectiveAccess\":false,\"RatingCode\":9,\"RowNumber\":1,\"PriceRowNumber\":1,\"TotalRank\":1}],\"StatusInfo\":[{\"EndCallStatus\":0,\"AnswerCallStatus\":0,\"AllStatus\":1}]}]"
 }
]*/
struct VendorCallUserInfoModel : Codable{
    var UserId: Int?
    var username: String?
    var CustomerDisplayName: String?
    var SLangID: Int?
    var TLangID : Int?
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
    var ServerKey: String?
    var VendorLat: String?
    var VendorLng: String?
    var inHouse: Int?
    var thirdparty: Int?
    var thirdPartyAccess: Bool?
    var RatingCode: Int?
    var RowNumber: Int?
    var PriceRowNumber: Int?
    var TotalRank: Int?
    var EffectiveAccess: Bool?
    var StatusInfo: [StatusInfoModel]?
    enum CodingKeys:String, CodingKey {
        case UserId = "UserId"
        case username = "username"
        case CustomerDisplayName = "CustomerDisplayName"
        case SLangID = "SLangID"
        case SLangName = "SLangName"
        case TLangName = "TLangName"
        case VendorDeviceType = "VendorDeviceType"
        case VendorTokenID = "VendorTokenID"
        case VendorVOIPTokenID = "VendorVOIPTokenID"
        case CustDeviceType = "CustDeviceType"
        case CustTokenID = "CustTokenID"
        case Address = "Address"
        case City = "City"
        case Zipcode = "Zipcode"
        case CustomerImage = "CustomerImage"
        case ServerKey = "ServerKey"
        case VendorLat = "VendorLat"
        case VendorLng = "VendorLng"
        case inHouse = "inHouse"
        case thirdparty = "thirdparty"
        case thirdPartyAccess = "thirdPartyAccess"
        case RatingCode = "RatingCode"
        case RowNumber = "RowNumber"
        case PriceRowNumber = "PriceRowNumber"
        case TotalRank = "TotalRank"
        case EffectiveAccess = "EffectiveAccess"
        case StatusInfo = "StatusInfo"
        case TLangID = "TLangID"
        
    }
    init(from decoder: Decoder) throws {
        let item = try decoder.container(keyedBy: CodingKeys.self)
        UserId = try item.decodeIfPresent(Int.self, forKey: .UserId)
        username = try item.decodeIfPresent(String.self, forKey: .username)
        CustomerDisplayName = try item.decodeIfPresent(String.self, forKey: .CustomerDisplayName)
        SLangID = try item.decodeIfPresent(Int.self, forKey: .SLangID)
        SLangName = try item.decodeIfPresent(String.self, forKey: .SLangName)
        TLangName = try item.decodeIfPresent(String.self, forKey: .TLangName)
        VendorDeviceType = try item.decodeIfPresent(String.self, forKey: .VendorDeviceType)
        VendorTokenID = try item.decodeIfPresent(String.self, forKey: .VendorTokenID)
        VendorVOIPTokenID = try item.decodeIfPresent(String.self, forKey: .VendorVOIPTokenID)
        CustDeviceType = try item.decodeIfPresent(String.self, forKey: .CustDeviceType)
        CustTokenID = try item.decodeIfPresent(String.self, forKey: .CustTokenID)
        Address = try item.decodeIfPresent(String.self, forKey: .Address)
        Zipcode = try item.decodeIfPresent(String.self, forKey: .Zipcode)
        City = try item.decodeIfPresent(String.self, forKey: .City)
        CustomerImage = try item.decodeIfPresent(String.self, forKey: .CustomerImage)
        ServerKey = try item.decodeIfPresent(String.self, forKey: .ServerKey)
        VendorLat = try item.decodeIfPresent(String.self, forKey: .VendorLat)
        VendorLng = try item.decodeIfPresent(String.self, forKey: .VendorLng)
        thirdparty = try item.decodeIfPresent(Int.self, forKey: .thirdparty)
        thirdPartyAccess = try item.decodeIfPresent(Bool.self, forKey: .thirdPartyAccess)
        RatingCode = try item.decodeIfPresent(Int.self, forKey: .RatingCode)
        RowNumber = try item.decodeIfPresent(Int.self, forKey: .RowNumber)
        PriceRowNumber = try item.decodeIfPresent(Int.self, forKey: .PriceRowNumber)
        TotalRank = try item.decodeIfPresent(Int.self, forKey: .TotalRank)
        EffectiveAccess = try item.decodeIfPresent(Bool.self, forKey: .EffectiveAccess)
        StatusInfo = try item.decodeIfPresent([StatusInfoModel].self, forKey: .StatusInfo)
        VendorLat = try item.decodeIfPresent(String.self, forKey: .VendorLat)
        TLangID = try item.decodeIfPresent(Int.self, forKey: .TLangID)
        
    }
}
struct StatusInfoModel : Codable{
    var EndCallStatus: Int?
    var AnswerCallStatus: Int?
    var AllStatus: Int?
    enum CodingKeys:String, CodingKey {
        case EndCallStatus = "EndCallStatus"
        case AnswerCallStatus = "AnswerCallStatus"
        case AllStatus = "AllStatus"
    }
    init(from decoder: Decoder) throws {
        let item = try decoder.container(keyedBy: CodingKeys.self)
        EndCallStatus = try item.decodeIfPresent(Int.self, forKey: .EndCallStatus)
        AnswerCallStatus = try item.decodeIfPresent(Int.self, forKey: .AnswerCallStatus)
        AllStatus = try item.decodeIfPresent(Int.self, forKey: .AllStatus)
        
    }
}
