//
//  ApiGetRatindScreenResponseModel.swift
//  TLClientApp
//
//  Created by SMIT 005 on 21/12/21.
//

import Foundation
struct ApiGetRatindScreenResponseModel : Codable {
    let getMembers : [ApiGetRatindScreenGetMembers]?

    enum CodingKeys: String, CodingKey {

        case getMembers = "GetMembers"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        getMembers = try values.decodeIfPresent([ApiGetRatindScreenGetMembers].self, forKey: .getMembers)
    }

}

struct ApiGetRatindScreenGetMembers : Codable {
    let custID : Int?
    let vendorName : String?
    let sourcelanguageName : String?
    let customerName : String?
    let vendorImg : String?
    let languageName : String?
    let vendorName1 : String?
    let custImg : String?
    let vendID : Int?
    let lID : Int?
    let roomno : String?
    let duration : String?

    enum CodingKeys: String, CodingKey {

        case custID = "CustID"
        case vendorName = "VendorName"
        case sourcelanguageName = "SourcelanguageName"
        case customerName = "customerName"
        case vendorImg = "vendorImg"
        case languageName = "languageName"
        case vendorName1 = "VendorName1"
        case custImg = "CustImg"
        case vendID = "VendID"
        case lID = "LID"
        case roomno = "roomno"
        case duration = "duration"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        custID = try values.decodeIfPresent(Int.self, forKey: .custID)
        vendorName = try values.decodeIfPresent(String.self, forKey: .vendorName)
        sourcelanguageName = try values.decodeIfPresent(String.self, forKey: .sourcelanguageName)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        vendorImg = try values.decodeIfPresent(String.self, forKey: .vendorImg)
        languageName = try values.decodeIfPresent(String.self, forKey: .languageName)
        vendorName1 = try values.decodeIfPresent(String.self, forKey: .vendorName1)
        custImg = try values.decodeIfPresent(String.self, forKey: .custImg)
        vendID = try values.decodeIfPresent(Int.self, forKey: .vendID)
        lID = try values.decodeIfPresent(Int.self, forKey: .lID)
        roomno = try values.decodeIfPresent(String.self, forKey: .roomno)
        duration = try values.decodeIfPresent(String.self, forKey: .duration)
    }

}
