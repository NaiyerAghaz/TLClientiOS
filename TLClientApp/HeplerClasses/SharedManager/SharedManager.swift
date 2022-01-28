//
//  SharedManager.swift
//  TLClientApp
//
//  Created by Mac on 13/09/21.
//

import Foundation


class SharedManager: NSObject {
    static let shared: SharedManager = SharedManager()
    private override init() {
        
    }
    var C_ID: String?
    
}
