//
//  AQINetwork.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/1/24.
//

import Foundation

public struct AQINetwork {
    private let manager: NetworkManager
    init(manager: NetworkManager) {
        self.manager = manager
    }
    public func fetchAQI(latitude: Double, longitude: Double) async -> Result<AQIFetchResult, NetworkError> {
        let url = "https://api.waqi.info/feed/geo:\(latitude);\(longitude)?token=4523a87168ce17a8fe9693d51a742cd79bcecad8"
        return await manager.fetchData(url: url, method: .get)
    }
}
