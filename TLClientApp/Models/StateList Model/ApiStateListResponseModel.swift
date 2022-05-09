//
//  ApiStateListResponseModel.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 14/03/22.
//

import Foundation
struct ApiStateListResponseModel : Codable {
    let states : [ApiStateDataModel]?
    let appointmentType : [ApiAppointmentTypeDattaModel]?

    enum CodingKeys: String, CodingKey {

        case states = "States"
        case appointmentType = "AppointmentType"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        states = try values.decodeIfPresent([ApiStateDataModel].self, forKey: .states)
        appointmentType = try values.decodeIfPresent([ApiAppointmentTypeDattaModel].self, forKey: .appointmentType)
    }

}
