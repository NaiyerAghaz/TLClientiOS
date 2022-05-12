//
//  ProtocolsMethods.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 10/05/22.
//

import Foundation
@objc protocol CommonDelegates {
    @objc optional func getCaledarSelectedData(range: [Date]?)
    @objc optional func getEditRecurrenceUpdate()
}
