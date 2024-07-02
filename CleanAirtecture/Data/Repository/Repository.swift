//
//  Repository.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/1/24.
//

import Foundation

public struct LocationRepository: LocationRepositoryProtocol {

    private let locationNetwok: LocationNetwork, aqiNetwork: AQINetwork, coreData: LocationCoreData
    public init(locationNetwok: LocationNetwork, aqiNetwork: AQINetwork, coreData: LocationCoreData) {
        self.locationNetwok = locationNetwok
        self.aqiNetwork = aqiNetwork
        self.coreData = coreData
    }
    
    public func fetchLocation(latitude: Double, longitude: Double) async -> Result<LocationFetchResult, NetworkError> {
        await locationNetwok.fetchLocation(latitude: latitude, longitude: longitude)
    }
    
    public func fetchAQI(latitude: Double, longitude: Double) async -> Result<AQIFetchResult, NetworkError> {
        await aqiNetwork.fetchAQI(latitude: latitude, longitude: longitude)
    }
    
    public func getSavedLocation(latitude: Double, longitude: Double) -> Location? {
        let result = coreData.getSavedLocation(latitude: latitude, longitude: longitude)
        switch result {
        case .success(let location):
            return location
        case .failure(let error):
            print(error.description)
            return nil
        }
    }
    
    public func saveLocation(location: Location) {
        let result = coreData.saveLocation(location: location)
        switch result {
        case .success:
            return
        case .failure(let error):
            print(error.description)
            return
        }
    }
    
}
