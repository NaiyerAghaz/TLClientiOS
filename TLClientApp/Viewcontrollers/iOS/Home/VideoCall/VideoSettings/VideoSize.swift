//
//  VideoSize.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 29/07/22.
//

import Foundation
enum VideoSize: String, SettingOptions {
    case vga
    case quarterHD

    var title: String {
        switch self {
        case .vga: return "VGA"
        case .quarterHD: return "qHD"
        }
    }
}
