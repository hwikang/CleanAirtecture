//
//  LocationDetailUsecase\.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/3/24.
//

import Foundation

public protocol LocationDetailUsecaseProtocol {
    func updateNickname(latitude: Double, longitude: Double, nickname: String) -> Bool
}

public struct LocationDetailUsecase: LocationDetailUsecaseProtocol {
    private let repository: LocationRepositoryProtocol
    public init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    public func updateNickname(latitude: Double, longitude: Double, nickname: String) -> Bool {
        return repository.updateLocation(latitude: latitude, longitude: longitude, nickname: nickname)
    }
}
