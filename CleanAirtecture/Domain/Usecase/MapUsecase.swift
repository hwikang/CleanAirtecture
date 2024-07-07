//
//  Usecase.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/1/24.
//

import Foundation

protocol MapUsecaseProtocol {
    func getLocationInfo(latitude: Double, longitude: Double) async -> Result<Location, NetworkError>
    func fetchAQI(latitude: Double, longitude: Double) async -> Result<Int, NetworkError>
    func saveLocation(location: Location)
}

public struct MapUsecase: MapUsecaseProtocol {
    private let repository: LocationRepositoryProtocol
    public init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    public func getLocationInfo(latitude: Double, longitude: Double) async -> Result<Location, NetworkError> {
        if let location = repository.getLocation(latitude: latitude, longitude: longitude) {
            return .success(location)
        }
        let result = await fetchLocationInfo(latitude: latitude, longitude: longitude)
        
        switch result {
        case .success(let location):
            repository.saveLocation(location: location)
            return .success(location)
        case .failure(let error):
            return .failure(error)
        }
        
    }
    
    public func fetchAQI(latitude: Double, longitude: Double) async -> Result<Int, NetworkError> {
        let result = await repository.fetchAQI(latitude: latitude, longitude: longitude)
        switch result {
        case .success(let result):
            return .success(result.aqi)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func saveLocation(location: Location) {
        repository.saveLocation(location: location)
    }
    
    private func fetchLocationInfo(latitude: Double, longitude: Double) async -> Result<Location, NetworkError> {
        
        let result = await repository.fetchLocation(latitude: latitude, longitude: longitude)
        switch result {
        case .success(let locationResult):
            let name = locationResult.localInfos.sorted { $0.order > $1.order }.prefix(2)
                .map {$0.name}.joined(separator: ", ")
            return .success(Location(latitude: locationResult.latitude, longitude: locationResult.longitude, name: name))
        case .failure(let error):
            return .failure(error)
        }
    }
    
}
