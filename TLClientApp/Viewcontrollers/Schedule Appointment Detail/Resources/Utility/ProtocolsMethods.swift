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
    @objc optional func chatRefresh()
}
protocol chatDelegateMethods{
    func chatRefreshed(chats:[RowData]?)
}
protocol DownloadQRCodeDelegate{
    func downloadMethod()
}
