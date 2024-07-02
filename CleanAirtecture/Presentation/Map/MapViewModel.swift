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
    private let locationA = BehaviorRelay<Location?>(value: nil)
    private let locationB = BehaviorRelay<Location?>(value: nil)
    private let error = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    init(usecase: MapUsecaseProtocol) {
        self.usecase = usecase
    }
    public struct Input {
        let mapPosition: Observable<(latitude: Double, longitude: Double)>
        let getLocation: Observable<Void>
    }
    public struct Output {
        let aqi: Observable<Int>
        let locationA: Observable<Location?>
        let locationB: Observable<Location?>
    }
    public func transform(input: Input) -> Output {
        input.mapPosition.bind { (latitude, longitude) in
            getAQI(latitude: latitude, longitude: longitude)
        }.disposed(by: disposeBag)
        input.getLocation.withLatestFrom(input.mapPosition).bind {(latitude, longitude) in
            getLocation(latitude: latitude, longitude: longitude)
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
    private func getLocation(latitude: Double, longitude: Double) {
        Task {
            let result = await usecase.getLocationInfo(latitude: latitude, longitude: longitude)
            switch result {
            case .success(let location):
                if locationA.value == nil {
                    locationA.accept(location)
                } else {
                    locationB.accept(location)
                }

            case .failure(let error):
                self.error.accept(error.description)
            }
        }
       
    }
}
