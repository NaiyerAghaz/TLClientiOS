//
//  VideoCodec.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 29/07/22.
//

import Foundation
enum VideoCodec: String, SettingOptions {
    case auto
    case h264
    case vp8
    case vp8Simulcast

    var title: String {
        switch self {
        case .auto: return "Auto"
        case .h264: return "H.264"
        case .vp8: return "VP8"
        case .vp8Simulcast: return "VP8 Simulcast"
        }
    }
}
