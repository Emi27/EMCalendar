//
//  Task.swift
//  CarFit
//
//  Created by imran malik on 25/12/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

// MARK: - Task
struct Task: Codable {
    let taskID, title: String
    let isTemplate: Bool
    let timesInMinutes: Int
    let price: Double
    let paymentTypeID, createDateUTC, lastUpdateDateUTC: String
    let paymentTypes: String?

    enum CodingKeys: String, CodingKey {
        case taskID = "taskId"
        case title, isTemplate, timesInMinutes, price
        case paymentTypeID = "paymentTypeId"
        case createDateUTC = "createDateUtc"
        case lastUpdateDateUTC = "lastUpdateDateUtc"
        case paymentTypes
    }
}
