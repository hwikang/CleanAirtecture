//
//  LocationNetwork.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/1/24.
//

import Foundation

public struct LocationNetwork {
    private let manager: NetworkManager
    init(manager: NetworkManager) {
        self.manager = manager
    }
    public func fetchLocation(latitude: Double, longitude: Double) async -> Result<LocationFetchResult, NetworkError> {
        let url = "https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=\(latitude)&longitude=\(longitude)"
        return await manager.fetchData(url: url, method: .get)
    }
}
