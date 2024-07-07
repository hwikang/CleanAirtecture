//
//  Extension + Double.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/2/24.
//

import Foundation
extension Double {

    func truncateValue(point: Int) -> Double {
        let multiplier = pow(10.0, Double(point))
        return (self * multiplier).rounded(.down) / multiplier
    }
}
