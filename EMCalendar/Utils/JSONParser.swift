//
//  JSONParser.swift
//  CarFit
//
//  Created by imran malik on 24/12/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

typealias Completion<T> = ((Result<T, DataError>) -> Void)

class JSONParser {

    private static var dateFormatter: DateFormatter {
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormattor
    }

    /// Its a generic function to load and parse JSON local file
    /// - Parameters:
    ///   - type: Decodable class type that we are expecting from decoded JSON file
    ///   - name: JSON file name, that exists in document directory of app
    ///   - completion: It will return the same response that we pass in type parameter.
    static func loadJSON<T: Decodable>(of type: T.Type, name: String, completion: Completion<T>) {
        if let url = Bundle.main.url(forResource: name, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let jsonData: T = try decoder.decode(T.self, from: data)
                completion(.success(jsonData))
                } catch {
                    print(error.localizedDescription)
                    let model = String(describing: T.self)
                    let body = String(data: data, encoding: .ascii) ?? "{}"
                    let additional: [String: String] = ["model": model, "body": body]
                    print(additional)
                    completion(.failure(.decodingError))
                }
            } catch {
                print(error.localizedDescription)
                completion(.failure(.invalidData))
            }
        } else {
            completion(.failure(.fileNotFound))
        }
    }
}

enum DataError: Error {
    case decodingError
    case fileNotFound
    case invalidData

    var localizedDescription: String {
        switch self {
        case .decodingError: return "There is some problem in decoding the data."
        case .fileNotFound: return "Given file name not found."
        case .invalidData: return "File data is not valid."
        }
    }
}
