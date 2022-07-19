//
//  Constant.swift
//  TLClientApp
//
//  Created by Naiyer on 8/7/21.
//

import Foundation
import UIKit

struct Storyboard_name {
    static let login = "Auth"
    static let home = "Home"
    static let scheduleApnt = "SchedulingAppointments"
    static let chat = "TLCChat"
}
struct Control_Name {
    static let recurrenceCV = "RecurrenceCalendarView"
    static let reEditVC = "EditRecurrenceStatusVC"
    static let updateDeptAndCont = "UpdateDepartmentAndContactVC"
    static let tTotalP = "TotalParticipantVC"
    static let vrifeedback = "VRIOPIFeedbackController"
    static let chatVC = "ChatViewController"
    static let imgPopup = "ImagePopupViewController"
    static let vdoCall = "VideoCallViewController"
}
struct nibNamed {
    static let calendarTVCell = "CalenderVCell"
}
var mszCounts = 0
var isFeedback = false 
var userDefaults = UserDefaults.standard
var callid: String?
var chatArr = [RowData]()
enum cellIndentifier: String {
    case vendorTVCell = "VendorTVCell"
    case VDOCollectionViewCell = "VDOCollectionViewCell"
}
enum viewIndentifier: String {
    case CallingPopupVC  = "CallingPopupVC"
    case CallingOPIPopUpVC = "CallingOPIPopUpVC"
    case InviteParticipantVC  = "InviteParticipantVC"
}

class DynamicTableView: UITableView {

    /// Will assign automatic dimension to the rowHeight variable
    /// Will asign the value of this variable to estimated row height.
    var dynamicRowHeight: CGFloat = UITableView.automaticDimension {
        didSet {
            rowHeight = UITableView.automaticDimension
            estimatedRowHeight = dynamicRowHeight
        }
    }

    public override var intrinsicContentSize: CGSize { contentSize }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if !bounds.size.equalTo(intrinsicContentSize) {
            invalidateIntrinsicContentSize()
        }
    }
}
