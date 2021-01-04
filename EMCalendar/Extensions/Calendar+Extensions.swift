//
//  Calendar+Extensions.swift
//  CarFit
//
//  Created by imran malik on 27/12/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

extension Calendar {
    func startOfMonth(_ date: Date) -> Date {
        return self.date(from: self.dateComponents([.year, .month], from: date))!
    }

    func endOfMonth(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(date))!
    }
}
