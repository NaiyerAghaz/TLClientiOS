//
//  ConstantString.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 15/02/22.
//

import Foundation
enum ConstantStr {
    case noItnernet
    var val:String {
        switch self {
        case .noItnernet:
            return "No internet connection!"
        
        }
    }}

