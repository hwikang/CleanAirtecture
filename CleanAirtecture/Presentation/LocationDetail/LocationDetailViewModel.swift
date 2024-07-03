//
//  LocationDetailViewModel.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/3/24.
//

import Foundation

public protocol LocationDetailViewModelProtocol {
    
}

public struct LocationDetailViewModel: LocationDetailViewModelProtocol {
    private let usecase: LocationDetailUsecaseProtocol
    private let location: Location
    init(usecase: LocationDetailUsecaseProtocol, location: Location) {
        self.usecase = usecase
        self.location = location
    }
}

