//
//  TrackPriority.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 29/07/22.
//

import Foundation

enum TrackPriority: String, SettingOptions {
    case serverDefault
    case low
    case standard
    case high
    
    var title: String {
        switch self {
        case .serverDefault: return "Server Default"
        case .low: return "Low"
        case .standard: return "Standard"
        case .high: return "High"
        }
    }
}
