//
//  LogPrint.swift
//  ZuberDriver
//
//  Created by JMD on 12/11/19.
//  Copyright © 2019 Spice. All rights reserved.
//

import Foundation


class Log {
    
    static func print(_ items: Any..., separator: String = " ", terminator: String = "\n"){
        #if DEBUG
        var idx = items.startIndex
        let endIdx = items.endIndex
        if items.count > 0 {
            repeat {
                Swift.print(items[idx], separator: separator, terminator: idx == (endIdx - 1) ? terminator : separator)
                idx += 1
            }
                while idx < endIdx
        }
        #endif
    }
}
//MARK: Check platform Device Or Simulator
struct Target {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}
