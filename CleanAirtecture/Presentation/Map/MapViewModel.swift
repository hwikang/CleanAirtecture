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
        let changeLocation: Observable<(locationA: Location, locationB: Location)>
        let setLocation: Observable<Location>
    }
    public struct Output {
        let aqi: Observable<Int>
        let locationA: Observable<(location: Location, aqi: Int)?>
        let locationB: Observable<(location: Location, aqi: Int)?>
        let error: Observable<String>
    }
    public func transform(input: Input) -> Output {
        input.mapPosition.bind { (latitude, longitude) in
            setAQI(latitude: latitude, longitude: longitude)
        }.disposed(by: disposeBag)
        input.getLocation.withLatestFrom(input.mapPosition).bind { (latitude, longitude) in
            fetchAndSetLocation(latitude: latitude, longitude: longitude)
        }.disposed(by: disposeBag)
        input.refreshLocation.bind {
            refreshCurrentLocation()
        }.disposed(by: disposeBag)
        input.changeLocation.bind { newLocations in
            changeCurrentLocation(locationA: newLocations.locationA, locationB: newLocations.locationB)
        }.disposed(by: disposeBag)
        input.setLocation.bind { location in
            setLocationWithNewAQI(location: location)
        }.disposed(by: disposeBag)
        return Output(aqi: aqi.asObservable(), locationA: locationA.asObservable(),
                      locationB: locationB.asObservable(),
                      error: error.asObservable())
    }
    
    private func setAQI(latitude: Double, longitude: Double) {
        Task {
            let aqi = await fetchAQI(latitude: latitude, longitude: longitude)
            self.aqi.accept(aqi)
        }
    }
    
    private func fetchAQI(latitude: Double, longitude: Double) async -> Int {
        let result = await usecase.fetchAQI(latitude: latitude, longitude: longitude)
        switch result {
        case .success(let aqi):
            return aqi
        case .failure(let error):
            self.error.accept(error.description)
            return 0
        }
    }
    
    private func fetchAndSetLocation(latitude: Double, longitude: Double) {
        Task {
            guard let location = await fetchLocation(latitude: latitude, longitude: longitude) else { return }
            setEmptyLocation(location: location, aqi: aqi.value)
        }
    }
    
    private func setEmptyLocation(location:Location, aqi: Int) {
        if locationA.value == nil {
            locationA.accept((location, aqi))
        } else {
            locationB.accept((location, aqi))
        }
    }
    
    private func fetchLocation(latitude: Double, longitude: Double) async -> Location? {
        
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
                guard let newLocation = await fetchLocation(latitude: location.latitude, longitude: location.longitude) else { return }
                locationA.accept((newLocation, aqi))
            }
            if let (location, aqi) = locationB.value {
                guard let newLocation = await fetchLocation(latitude: location.latitude, longitude: location.longitude) else { return }
                locationB.accept((newLocation, aqi))
            }
        }
    }
    
    private func changeCurrentLocation(locationA: Location, locationB: Location) {
        Task {
            usecase.saveLocation(location: locationA)
            usecase.saveLocation(location: locationB)
            let aqiA = await fetchAQI(latitude: locationA.latitude, longitude: locationA.longitude)
            let aqiB = await fetchAQI(latitude: locationB.latitude, longitude: locationB.longitude)
            self.locationA.accept((location: locationA, aqi: aqiA))
            self.locationB.accept((location: locationB, aqi: aqiB))
        }
    }
    
    private func setLocationWithNewAQI(location: Location) {
        Task {
            let aqi = await fetchAQI(latitude: location.latitude, longitude: location.longitude)
            setEmptyLocation(location: location, aqi: aqi)
        }
    }
}
