//
//  Array+Extensions.swift
//  CarFit
//
//  Created by imran malik on 27/12/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

extension Array {
    func safelyAt(index: Int) -> Element? {
        guard index < count && index >= 0 else { return nil }
        return self[index]
    }
}

extension Sequence  {
    func sum<T: AdditiveArithmetic>(_ keyPath: KeyPath<Element, T>) -> T { reduce(.zero) { $0 + $1[keyPath: keyPath] } }
}
