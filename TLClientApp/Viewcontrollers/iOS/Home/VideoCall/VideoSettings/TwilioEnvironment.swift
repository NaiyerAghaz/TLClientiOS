//
//  TwilioEnvironment.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 29/07/22.
//

import Foundation
enum TwilioEnvironment: String, SettingOptions {
    case production
    case staging
    case development
    
    var title: String {
        switch self {
        case .production: return "Production"
        case .staging: return "Staging"
        case .development: return "Development"
        }
    }
}

enum SDKLogLevel: String, SettingOptions {
    case off
    case fatal
    case error
    case warning
    case info
    case debug
    case trace
    case all
    
    var title: String {
        switch self {
        case .off: return "Off"
        case .fatal: return "Fatal"
        case .error: return "Error"
        case .warning: return "Warning"
        case .info: return "Info"
        case .debug: return "Debug"
        case .trace: return "Trace"
        case .all: return "All"
        }
    }
}


enum BandwidthProfileMode: String, SettingOptions {
    case serverDefault
    case collaboration
    case grid
    case presentation
    
    var title: String {
        switch self {
        case .serverDefault: return "Server Default"
        case .collaboration: return "Collaboration"
        case .grid: return "Grid"
        case .presentation: return "Presentation"
        }
    }
}
enum TrackSwitchOffMode: String, SettingOptions {
    case serverDefault
    case disabled
    case detected
    case predicted
    
    var title: String {
        switch self {
        case .serverDefault: return "Server Default"
        case .disabled: return "Disabled"
        case .detected: return "Detected"
        case .predicted: return "Predicted"
        }
    }
}
