//
//  Date+Extension.swift
//  EssayWriter
//
//  Created Shiv Kumar 02/08/18.
//  Copyright © 2018 Ankit.Gohel. All rights reserved.
//

import UIKit

class DateExtension: NSObject {
    
}

struct DateFormat {
    static let dd_MMM_yyyy  = "dd-MMM-yyyy"
    static let ddMMMyyyy    = "dd/MMM/yyyy"
    static let dd_MM_yyyy   = "dd-MM-yyyy"
    static let yyyy_MM_dd   = "yyyy-MM-dd"
    static let ddMMyyyy     = "dd/MM/yyyy"
    static let MMddyyyy     = "MM/dd/yyyy"
    static let EEEddMMM     = "EEE dd MMM"
    static let EEE_ddMMM    = "EEE, dd MMM"
    static let EEEddMMMyyyy = "EEE dd MMM, yyyy"
    static let yyyy_MM_dd_HHmm = "yyyy-MM-dd HH:mm a"
    static let yyyy_MM_dd_T_HHmm = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static let dd_MMM_yyyyHHmm  = "dd-MMM-yyyy HH:mm"
    static let yyyy_MM_dd_HHmmss  = "yyyy-MM-dd HH:mm:ss"
}

extension Date {
    var formatted: String {
        let df = DateFormatter()
        df.dateFormat = DateFormat.dd_MMM_yyyy
        df.locale = Locale(identifier: "en_US_POSIX")
        return df.string(from: self)
    }
    var formattedMM: String {
        let df = DateFormatter()
        df.dateFormat = DateFormat.ddMMyyyy
        df.locale = Locale(identifier: "en_US_POSIX")
        return df.string(from: self)
    }
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the amount of nanoseconds from another date
    func nanoseconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        if nanoseconds(from: date) > 0 { return "\(nanoseconds(from: date))ns" }
        return ""
    }
    func date(from selectedDay: Int) -> (String, String) {
        guard let selectedDate = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.date(byAdding: .day, value: selectedDay, to: self, options: []) else {
            return ("", "")
        }
        return (selectedDate.formatted, selectedDate.formattedMM)
    }
}
