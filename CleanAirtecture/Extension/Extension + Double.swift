//
//  Extension + Double.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/2/24.
//

import Foundation
extension Double {
    func truncateValue() -> Double {
        let truncatedValue = String(format: "%.4f", self)
        if let value = Double(truncatedValue) {
            return value
        } else {
            return self
        }
    }
}
