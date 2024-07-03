//
//  LocationDetailUsecase\.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/3/24.
//

import Foundation

public protocol LocationDetailUsecaseProtocol {
    
}

public struct LocationDetailUsecase: LocationDetailUsecaseProtocol {
    private let repository: LocationRepositoryProtocol
    public init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
}
