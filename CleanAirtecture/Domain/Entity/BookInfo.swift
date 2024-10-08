//
//  BookInfo.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/4/24.
//

import Foundation

public struct BookInfo: Codable {
    public let latitude: Double
    public let longitude: Double
    public let aqi: Int
    public var name: String
    
    public mutating func changeName(name: String) {
        self.name = name
    }
    public func toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self),
              let jsonString = String(data: data, encoding: .utf8) else { return nil }
        return jsonString
    }
}
