//
//  Date+Extensions.swift
//  CarFit
//
//  Created by imran malik on 27/12/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation


extension Date {
    var weekdayName: String {
        let formatter = DateFormatter(); formatter.dateFormat = "E"
        return formatter.string(from: self as Date)
    }

    var monthWithYear: String {
        let formatter = DateFormatter(); formatter.dateFormat = "MMM YYYY"
        return formatter.string(from: self as Date)
    }

    func isSame(to date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }

    var toString: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)
    }

    var toTimeString: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm"
        return dateFormatter.string(from: self)
    }

    var dayString: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }

    var fullDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }

    func offsetFrom(date: Date) -> String {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)

        let seconds = difference.second! > 0 ? "\(difference.second ?? 0)s" : ""
        let minutes = difference.minute! > 0 ? "\(difference.minute ?? 0)m" + " " + seconds : ""
        let hours = difference.hour != nil ? "\(difference.hour ?? 0)h" + " " + minutes : ""
        let days = difference.day != nil ? "\(difference.day ?? 0)d" + " " + hours : ""

        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
}
