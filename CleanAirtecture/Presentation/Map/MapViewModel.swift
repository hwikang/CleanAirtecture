//
//  MapViewModel.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/2/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol MapViewModelProtocol {
    func transform(input: MapViewModel.Input) -> MapViewModel.Output
}

public struct MapViewModel: MapViewModelProtocol {
    private let usecase: MapUsecaseProtocol
    private let aqi = BehaviorRelay<Int>(value: 0)
    private let locationA = BehaviorRelay<(location: Location, aqi: Int)?>(value: nil)
    private let locationB = BehaviorRelay<(location: Location, aqi: Int)?>(value: nil)
    private let error = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    init(usecase: MapUsecaseProtocol) {
        self.usecase = usecase
    }
    public struct Input {
        let mapPosition: Observable<(latitude: Double, longitude: Double)>
        let getLocation: Observable<Void>
        let refreshLocation: Observable<Void>
    }
    public struct Output {
        let aqi: Observable<Int>
        let locationA: Observable<(location: Location, aqi: Int)?>
        let locationB: Observable<(location: Location, aqi: Int)?>
    }
    public func transform(input: Input) -> Output {
        input.mapPosition.bind { (latitude, longitude) in
            getAQI(latitude: latitude, longitude: longitude)
        }.disposed(by: disposeBag)
        input.getLocation.withLatestFrom(input.mapPosition).bind { (latitude, longitude) in
            setLocation(latitude: latitude, longitude: longitude)
        }.disposed(by: disposeBag)
        input.refreshLocation.bind {
            refreshCurrentLocation()
        }.disposed(by: disposeBag)
        return Output(aqi: aqi.asObservable(), locationA: locationA.asObservable(), locationB: locationB.asObservable())
    }
    
    private func getAQI(latitude: Double, longitude: Double) {
        Task {
            let result = await usecase.fetchAQI(latitude: latitude, longitude: longitude)
            switch result {
            case .success(let aqi):
                self.aqi.accept(aqi)
            case .failure(let error):
                self.error.accept(error.description)
            }
        }
    }
    
    private func setLocation(latitude: Double, longitude: Double) {
        Task {
            guard let location = await getLocation(latitude: latitude, longitude: longitude) else { return }
            if locationA.value == nil {
                locationA.accept((location, aqi.value))
            } else {
                locationB.accept((location, aqi.value))
            }
        }
    }
    
    private func getLocation(latitude: Double, longitude: Double) async -> Location? {
        
        let result = await usecase.getLocationInfo(latitude: latitude, longitude: longitude)
        switch result {
        case .success(let location):
            return location
            
        case .failure(let error):
            self.error.accept(error.description)
            return nil
        }
    }
    
    private func refreshCurrentLocation() {
        Task {
            if let (location, aqi) = locationA.value {
                guard let newLocation = await getLocation(latitude: location.latitude, longitude: location.longitude) else { return }
                locationA.accept((newLocation, aqi))
            }
            if let (location, aqi) = locationB.value {
                guard let newLocation = await getLocation(latitude: location.latitude, longitude: location.longitude) else { return }
                locationB.accept((newLocation, aqi))
            }
        }
    }
}
