//
//  ApiStateDataModel.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 14/03/22.
//

import Foundation
struct ApiStateDataModel : Codable {
    let stateID : Int?
    let stateAbbrivation : String?
    let stateName : String?
    let active : Bool?

    enum CodingKeys: String, CodingKey {

        case stateID = "StateID"
        case stateAbbrivation = "StateAbbrivation"
        case stateName = "StateName"
        case active = "Active"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stateID = try values.decodeIfPresent(Int.self, forKey: .stateID)
        stateAbbrivation = try values.decodeIfPresent(String.self, forKey: .stateAbbrivation)
        stateName = try values.decodeIfPresent(String.self, forKey: .stateName)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
    }

}
