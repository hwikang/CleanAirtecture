//
//  LocationFetchResult.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/1/24.
//

import Foundation

public struct LocationFetchResult: Decodable {
    public let longitude: Double
    public let latitude: Double
    public let localInfos: [LocalInfoFetchResult]
    
    enum CodingKeys: CodingKey {
        case longitude
        case latitude
        case localityInfo
    }
    enum LocaltyInfoCodingKeys: CodingKey {
        case administrative
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        let localInfoContainer = try container.nestedContainer(keyedBy: LocaltyInfoCodingKeys.self, forKey: .localityInfo)
        self.localInfos = try localInfoContainer.decode([LocalInfoFetchResult].self, forKey: .administrative)
    }
}

public struct LocalInfoFetchResult: Decodable {
    public let name: String
    public let order: Int
}
