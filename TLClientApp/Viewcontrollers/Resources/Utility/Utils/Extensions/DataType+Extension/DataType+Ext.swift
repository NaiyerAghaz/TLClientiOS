//
//  DataType+Ext.swift
//  VOD
//
//  Created by JMD on 13/04/21.
//

import Foundation

extension Double {
    func to2PlaceString() -> String {
        String(format: "%.02f", self)
    }
    func toString()-> String {
        "\(self)"
    }
}
extension Int {
    func toString() -> String {
        "\(self)"
    }
}
extension String {
    func toInt() -> Int {
        if let myNumber = NumberFormatter().number(from: self) {
            let myInt = myNumber.intValue
            return myInt
        } else {
            return 0
        }
    }
    func toFloat() -> Float {
        return (self as NSString).floatValue
    }
}

