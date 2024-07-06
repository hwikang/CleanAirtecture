//
//  SavedLocationViewModel.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/6/24.
//


import Foundation
import RxCocoa
import RxSwift

protocol SavedLocationViewModelProtocol {
    func transform() -> SavedLocationViewModel.Output
}

public struct SavedLocationViewModel: SavedLocationViewModelProtocol {
    private let usecase: SavedLocationUsecaseProtocol
    private let errorMessage = PublishRelay<String>()
    private let locations = BehaviorRelay<[Location]>(value: [])
    
    public init(usecase: SavedLocationUsecaseProtocol) {
        self.usecase = usecase
        getLocations()
    }
    
    public struct Output {
        let locations: Observable<[Location]>
        let errorMessage: Observable<String>
    }
    
    public func transform() -> Output {
        return Output(locations: locations.asObservable(),
                      errorMessage: errorMessage.asObservable())
    }
    
    private func getLocations() {
        let locations = usecase.getLocations()
        self.locations.accept(locations)
    }
}
