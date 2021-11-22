//
//  TLCKeychain.swift
//  TLClientApp
//
//  Created by Naiyer on 8/11/21.
//

import Foundation

import Security

class keychainServices : NSObject {
    
    
    @discardableResult
    class func save(key: String, data: Data) -> OSStatus {
        //
        
        let query = [kSecClass as String:kSecClassGenericPassword as String,
                     kSecAttrAccount as String: key,
        kSecValueData as String: data] as [String: Any]
        //delete keychain item
        SecItemDelete(query as CFDictionary)
        // Add new item into key chain
        return SecItemAdd(query as CFDictionary, nil)
        
        
    }
    class func getKeychaindata(key: String) -> Data? {
        
        let query = [kSecClass as String: kSecClassGenericPassword,
                     kSecAttrAccount as String: key,
                     kSecReturnData as String: kCFBooleanTrue!,
        kSecMatchLimit as String: kSecMatchLimitOne] as [String: Any]
        // search for keychain item
        var dataTypeRef : AnyObject? = nil
        let status : OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        print("status for touch id \(status)")
        if status == noErr {
            return dataTypeRef as! Data?
        }
        else {
            return nil
        }
    }
}
