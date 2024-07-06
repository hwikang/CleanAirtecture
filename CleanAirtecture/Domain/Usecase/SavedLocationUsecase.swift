//
//  SavedLocationUsecase.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/6/24.
//

import Foundation

public protocol SavedLocationUsecaseProtocol {
    func getLocations() -> [Location]
}
public struct SavedLocationUsecase: SavedLocationUsecaseProtocol {
    private let repository: LocationRepositoryProtocol
    public init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    public func getLocations() -> [Location] {
        repository.getLocations()
    }
}
