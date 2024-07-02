//
//  RepositoryProtocol.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/1/24.
//

import Foundation

public protocol LocationRepositoryProtocol {
    func fetchLocation(latitude: Double, longitude: Double) async -> Result<LocationFetchResult, NetworkError>
    func fetchAQI(latitude: Double, longitude: Double) async -> Result<AQIFetchResult, NetworkError>
}
