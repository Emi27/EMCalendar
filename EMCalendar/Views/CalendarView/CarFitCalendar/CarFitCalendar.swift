//
//  CarFitCalendar.swift
//  CarFit
//
//  Created by imran malik on 22/12/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

//MARK: - Calendar Delegate
protocol CarFitCalendarProtocol: AnyObject {
    func reloadData()
}

class CarFitCalendar {

    static let shared = CarFitCalendar(baseDate: Date())

    private let calendar = Calendar(identifier: .gregorian)

    weak var delegate: CarFitCalendarProtocol?

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()

    var selectedDate: Date {
        didSet {
            days = generateDaysInMonth(for: baseDate, shouldAdd: false)
            delegate?.reloadData()
        }
    }
    
    var baseDate: Date {
      didSet {
        days = generateDaysInMonth(for: baseDate, shouldAdd: false)
        delegate?.reloadData()
      }
    }

    var indexOfToday: Int {
        let index = days.firstIndex(where: {  $0.isSelected }) ?? 0
        return index
    }

    lazy var days = generateDaysInMonth(for: baseDate, shouldAdd: false)

    var numberOfWeeksInBaseDate: Int {
      calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
    }

    init(baseDate: Date) {
      self.selectedDate = baseDate
      self.baseDate = baseDate
    }

    // MARK:- To generate days of next month
    func nextMonth() {
        let nextMont = self.calendar.date(
            byAdding: .month,
            value: 1,
            to: baseDate
        )
        baseDate = self.calendar.startOfMonth(nextMont ?? baseDate)
    }

    // MARK:- To generate days of previous month
    func lastMonth() {
        let nextMont = self.calendar.date(
            byAdding: .month,
            value: -1,
            to: baseDate
        )
        baseDate = self.calendar.startOfMonth(nextMont ?? baseDate)
    }

    /// Generate metadata of a month
    /// - Parameter baseDate: Date for which we need to generate metadata
    /// - Throws: Month meta-data custom error
    /// - Returns: Month Meta Data custom object
    func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
        guard
            let numberOfDaysInMonth = calendar.range(
                of: .day,
                in: .month,
                for: baseDate)?.count,
            let firstDayOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            throw CalendarDataError.metadataGeneration
        }

        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)

        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday)
    }

    /// Generate Days of a month
    /// - Parameters:
    ///   - baseDate: Date for which we need to generate the days
    ///   - offset: If we need to generate few days of next month as well
    /// - Returns: Array of Days custom objects
    func generateDaysInMonth(for baseDate: Date, shouldAdd offset: Bool = true) -> [Day] {

        guard let metadata = try? monthMetadata(for: baseDate) else {
            preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
        }

        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = offset ? metadata.firstDayWeekday : 1
        let firstDayOfMonth = metadata.firstDay

        let days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
            .map { day in
                let isWithinDisplayedMonth = day >= offsetInInitialRow
                let dayOffset =
                    isWithinDisplayedMonth ?
                    day - offsetInInitialRow :
                    -(offsetInInitialRow - day)

                return generateDay(
                    offsetBy: dayOffset,
                    for: firstDayOfMonth,
                    isWithinDisplayedMonth: isWithinDisplayedMonth)
            }

        return days
    }

    // MARK: - Helper function to generate days and converting them to Custom Days object.
    func generateDay(
        offsetBy dayOffset: Int,
        for baseDate: Date,
        isWithinDisplayedMonth: Bool
    ) -> Day {
        let date = calendar.date(
            byAdding: .day,
            value: dayOffset,
            to: baseDate)
            ?? baseDate

        return Day(
            date: date,
            number: dateFormatter.string(from: date),
            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
            isWithinDisplayedMonth: isWithinDisplayedMonth
        )
    }

    // MARK: - Calendar custom error enum, we can add more errors if needed.
    enum CalendarDataError: Error {
        case metadataGeneration
    }
}
