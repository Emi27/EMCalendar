//
//  CarwashVisit.swift
//  CarFit
//
//  Created by imran malik on 25/12/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

// MARK: - CarwashVisit
struct CarwashVisit: Codable {
    let visitID, homeBobEmployeeID, houseOwnerID, title: String
    let isBlocked: Bool
    let startTimeUTC, endTimeUTC: Date
    let isReviewed, isFirstVisit, isManual: Bool
    let visitTimeUsed: Int
    let rememberToday: Bool?
    let houseOwnerFirstName, houseOwnerLastName, houseOwnerMobilePhone, houseOwnerAddress: String
    let houseOwnerZip, houseOwnerCity: String
    let houseOwnerLatitude, houseOwnerLongitude: Double
    let isSubscriber: Bool
    let rememberAlways: Bool?
    let professional: String
    let visitState: VisitStatus
    let stateOrder: Int
    let expectedTime: String?
    let tasks: [Task]
    let houseOwnerAssets, visitAssets, visitMessages: [String]?

    var fullName: String {
        return houseOwnerFirstName + " " + houseOwnerLastName
    }

    var fullAddress: String {
        return houseOwnerAddress + " " + houseOwnerZip + " " + houseOwnerCity
    }

    enum CodingKeys: String, CodingKey {
        case visitID = "visitId"
        case homeBobEmployeeID = "homeBobEmployeeId"
        case houseOwnerID = "houseOwnerId"
        case isBlocked
        case startTimeUTC = "startTimeUtc"
        case endTimeUTC = "endTimeUtc"
        case title, isReviewed, isFirstVisit, isManual, visitTimeUsed, houseOwnerFirstName, houseOwnerLastName, houseOwnerMobilePhone, houseOwnerAddress, houseOwnerZip, houseOwnerCity, houseOwnerLatitude, houseOwnerLongitude, isSubscriber, professional, visitState, stateOrder, expectedTime, tasks,
             rememberToday, rememberAlways, houseOwnerAssets, visitAssets, visitMessages
    }
}

extension CarwashVisit {
    func distanceFrom(_ previousVisit: CarwashVisit) -> Double {
        let coordinate₀ = CLLocation(latitude: self.houseOwnerLatitude, longitude: self.houseOwnerLongitude)
        let coordinate₁ = CLLocation(latitude: previousVisit.houseOwnerLatitude, longitude: previousVisit.houseOwnerLongitude)
        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
        let distanceInKm =  distanceInMeters / 1000
        return distanceInKm.rounded(toPlaces: 1)
    }
}

enum VisitStatus: String, Codable {
    case done = "Done"
    case toDo = "ToDo"
    case inProgress = "InProgress"
    case rejected = "Rejected"

    var color: UIColor {
        switch self {
        case .done: return .doneOption
        case .toDo: return .todoOption
        case .inProgress: return .inProgressOption
        case .rejected: return .rejectedOption
        }
    }

    var name: String {
        switch self {
        case .done: return "Done"
        case .toDo: return "ToDo"
        case .inProgress: return "InProgress"
        case .rejected: return "Rejected"
        }
    }
}
