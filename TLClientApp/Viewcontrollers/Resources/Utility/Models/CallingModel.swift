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
