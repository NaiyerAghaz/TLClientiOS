//
//  ApiAppointmentTypeDattaModel.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 14/03/22.
//

import Foundation
struct ApiAppointmentTypeDattaModel : Codable {
    let id : Int?
    let code : String?
    let value : String?
    let type : String?
    let sortOrder : Int?
    let exactValue : String?
    let color : String?
    let flag : String?

    enum CodingKeys: String, CodingKey {

        case id = "Id"
        case code = "Code"
        case value = "Value"
        case type = "Type"
        case sortOrder = "SortOrder"
        case exactValue = "ExactValue"
        case color = "Color"
        case flag = "Flag"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        sortOrder = try values.decodeIfPresent(Int.self, forKey: .sortOrder)
        exactValue = try values.decodeIfPresent(String.self, forKey: .exactValue)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        flag = try values.decodeIfPresent(String.self, forKey: .flag)
    }

}
