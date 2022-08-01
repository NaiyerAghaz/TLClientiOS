//
//  RemoteConfigStore.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 29/07/22.
//

import Foundation
protocol RemoteConfigStoreReading: AnyObject {
    var roomType: CreateTwilioAccessTokenResponse.RoomType { get }
}

protocol RemoteConfigStoreWriting: RemoteConfigStoreReading {
    var roomType: CreateTwilioAccessTokenResponse.RoomType { get set }
}

class RemoteConfigStore: RemoteConfigStoreWriting {
    private let appSettingsStore: AppSettingsStoreWriting
    private let appInfoStore: AppInfoStoreReading
    
    init(appSettingsStore: AppSettingsStoreWriting, appInfoStore: AppInfoStoreReading) {
        self.appSettingsStore = appSettingsStore
        self.appInfoStore = appInfoStore
    }
    
    var roomType: CreateTwilioAccessTokenResponse.RoomType {
        get {
            guard let remoteRoomType = appSettingsStore.remoteRoomType else {
                switch appInfoStore.appInfo.target {
                case .videoCommunity:
                    return .peerToPeer
                case .videoInternal:
                    return .group
                }
            }
            
            return remoteRoomType
        }
        set {
            guard newValue != appSettingsStore.remoteRoomType else { return }

            appSettingsStore.videoCodec = .auto
            appSettingsStore.remoteRoomType = newValue
        }
    }
}
struct CreateTwilioAccessTokenResponse: Decodable {
    enum RoomType: String, Codable { // Codable because it's persisted to track changes
        case go = "go"
        case group
        case groupSmall = "group-small"
        case peerToPeer = "peer-to-peer"
        case unknown

        init(from decoder: Decoder) throws {
            self = try RoomType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
        }
    }

    let token: String
    let roomType: RoomType?
}
protocol AppInfoStoreReading: AnyObject {
    var appInfo: AppInfo { get }
}

class AppInfoStore: AppInfoStoreReading {
    var appInfo: AppInfo {
        AppInfo(
            appCenterAppSecret: bundle.object(forInfoDictionaryKey: "AppCenterAppSecret") as! String,
            version: bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String,
            target: AppInfo.Target(rawValue: bundle.object(forInfoDictionaryKey: "TargetName") as! String)!
        )
    }
    private let bundle: BundleProtocol

    init(bundle: BundleProtocol) {
        self.bundle = bundle
    }
}
protocol BundleProtocol: AnyObject {
    func object(forInfoDictionaryKey key: String) -> Any?
}

extension Bundle: BundleProtocol {}


struct AppInfo {
    enum Target: String, Equatable {
        case videoInternal = "Video-Internal"
        case videoCommunity = "TLClientApp"//"Video-Community"
    }
    
    let appCenterAppSecret: String
    let version: String
    let target: Target
}
