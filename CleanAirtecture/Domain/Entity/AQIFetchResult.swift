//
//  AQIFetchResult.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/1/24.
//

import Foundation

public struct AQIFetchResult: Decodable {
    let aqi: Int
    enum CodingKeys: CodingKey {
        case data
    }
    enum DataCodingKeys: CodingKey {
        case aqi
    }
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .data)
        self.aqi = try dataContainer.decode(Int.self, forKey: .aqi)
    }
}
