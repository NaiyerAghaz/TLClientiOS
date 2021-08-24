//
//  NSUserDefaults.swift
//
//  Created by Shiv Kumar on 06/03/18.
//  Copyright © 2018 Shiv Kumar. All rights reserved.
//

import UIKit


class NSUserDefaults: UserDefaults {
    
    private var userDefaults: UserDefaults = {
        return UserDefaults.standard
    }()
}

//MARK: Extension
extension NSUserDefaults {
    ///- Note: Use for save Codable Model Object
    public func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            userDefaults.set(data, forKey: key)
        }
    }
    /** Return: Use for Retrive Decodable Model Object */
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = userDefaults.object(forKey: key) as? Data,
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
    ///- Note: Use for save Object
    func setData(_ value: Any, key: String) {
        let archivedPool = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
        userDefaults.set(archivedPool, forKey: key)
    }
    func getData<T>(key: String) -> T? where T: Any {
        if let val = userDefaults.value(forKey: key) as? Data,
           let obj = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(val) as? T {
            return obj
        }
        return nil
    }
    public func deleteObject(forKey key: String) {
        userDefaults.removeObject (forKey: key)
        userDefaults.synchronize ()
    }
    
    public func deleteAllValues () {
        if let bundle = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: bundle)
            userDefaults.synchronize()
        }
    }
    
    public func keyExist(_ key: String) -> Bool {
        if userDefaults.object(forKey: key) != nil {
            return true
        }
        return false
    }
}
