//
//  Optional+Ext.swift
//  VOD
//
//  Created by Shiva Kr. on 19/06/21.
//

import Foundation

extension Optional {
    var asString: String {
        switch self {
            case .some(let value):
                return String(describing: value)
            case _:
                return ""
        }
    }
    var asBool: Bool {
        switch self {
            case .some(let value):
                return value as! Bool
            case _:
                return false
        }
    }
    var asInt: Int {
        switch self {
            case .some(let value):
                return value as! Int
            case _:
                return 0
        }
    }
    var asDictinory: [String: Any] {
        switch self {
            case .some(let value):
                return value as? [String : Any] ?? [:]
            case _:
                return [:]
        }
    }
    var asArray: [[String: Any]] {
        switch self {
            case .some(let value):
                return value as? [[String : Any]] ?? []
            case _:
                return []
        }
    }
}
// let str = "Hi"
// str.asString
