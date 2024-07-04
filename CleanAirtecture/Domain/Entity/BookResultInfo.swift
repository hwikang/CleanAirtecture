//
//  BookResultInfo.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/4/24.
//

import Foundation

public struct BookResultInfo: Decodable {
    public let a: BookInfo
    public let b:  BookInfo
    public let price: Double
    
    init(a: BookInfo, b: BookInfo, price: Double) {
        self.a = a
        self.b = b
        self.price = price
    }
}
