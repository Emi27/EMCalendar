//
//  APIResponse.swift
//  CarFit
//
//  Created by imran malik on 26/12/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

struct Response<T: Codable>: Codable {
    let data: T
    let code: Int?
    let success: Bool?
    let message: String?
}
