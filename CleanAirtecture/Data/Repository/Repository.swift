//
//  Repository.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/1/24.
//

import Foundation

public struct LocationRepository: LocationRepositoryProtocol {

    private let locationNetwok: LocationNetwork, aqiNetwork: AQINetwork
    public init(locationNetwok: LocationNetwork, aqiNetwork: AQINetwork) {
        self.locationNetwok = locationNetwok
        self.aqiNetwork = aqiNetwork
    }
    
    public func fetchLocation(latitude: Double, longitude: Double) async -> Result<LocationFetchResult, NetworkError> {
        await locationNetwok.fetchLocation(latitude: latitude, longitude: longitude)
    }
    
    public func fetchAQI(latitude: Double, longitude: Double) async -> Result<AQIFetchResult, NetworkError> {
        await aqiNetwork.fetchAQI(latitude: latitude, longitude: longitude)
    }
    
}
