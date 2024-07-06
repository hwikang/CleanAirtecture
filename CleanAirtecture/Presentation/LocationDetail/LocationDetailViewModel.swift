//
//  LocationDetailViewModel.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/3/24.
//

import Foundation
import RxSwift
import RxCocoa

public protocol LocationDetailViewModelProtocol {
    var location: Location { get }
    var aqi: Int { get }
    func transform(input: LocationDetailViewModel.Input) -> LocationDetailViewModel.Output
}

public struct LocationDetailViewModel: LocationDetailViewModelProtocol {
    private let usecase: LocationDetailUsecaseProtocol
    public let location: Location
    public let aqi: Int
    private let errorMessage = PublishRelay<String>()
    private let isChangeSuccess = PublishRelay<Bool>()
    private let nickname = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()

    init(usecase: LocationDetailUsecaseProtocol, location: Location, aqi: Int) {
        self.usecase = usecase
        self.location = location
        self.aqi = aqi
    }
    public struct Input {
        let nickname: Observable<String>
        let change: Observable<Void>
    }
    public struct Output {
        let isChangeSuccess: Observable<Bool>
        let errorMessage: Observable<String>
    }
    
    public func transform(input: Input) -> Output {
        input.nickname.bind { nickname in
            self.nickname.accept(nickname)
        }.disposed(by: disposeBag)
        input.change.bind {
            validateAndSaveNickname()
        }.disposed(by: disposeBag)
        return Output(isChangeSuccess: isChangeSuccess.asObservable(),
                      errorMessage: errorMessage.asObservable())
    }
    
    private func validateAndSaveNickname() {
        
        if nickname.value.count > 20 {
            errorMessage.accept("닉네임은 최대 20자 까지 가능합니다.")
        } else if nickname.value.isEmpty {
            errorMessage.accept("닉네임을 입력 해주세요")
        } else {
            let result = usecase.updateNickname(latitude: location.latitude, longitude: location.longitude,
                                                nickname: nickname.value)
            isChangeSuccess.accept(result)
        }
    }
}

