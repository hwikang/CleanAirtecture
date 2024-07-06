//
//  BookInfoViewModel.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/4/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol BookInfoViewModelProtocol {
    func transform() -> BookInfoViewModel.Output
}

public struct BookInfoViewModel: BookInfoViewModelProtocol {
    private let usecase: BookInfoUsecaseProtocol
    private let requestInfoA: BookInfo, requestInfoB: BookInfo
    private let bookResultInfo = BehaviorRelay<BookResultInfo?>(value: nil)
    private let errorMessage = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    public init(usecase: BookInfoUsecaseProtocol, requestInfoA: BookInfo, requestInfoB: BookInfo) {
        self.usecase = usecase
        self.requestInfoA = requestInfoA
        self.requestInfoB = requestInfoB
        requestBook(requestInfoA: requestInfoA, requestInfoB: requestInfoB)

    }
    public struct Output {
        let bookResultInfo: Observable<BookResultInfo>
        let errorMessage: Observable<String>
    }
    
    public func transform() -> Output {
        return Output(bookResultInfo: bookResultInfo.asObservable().compactMap({ $0 }),
                      errorMessage: errorMessage.asObservable())
    }
    
    private func requestBook(requestInfoA: BookInfo, requestInfoB: BookInfo) {
        Task {
            let result = await usecase.requestBook(a: requestInfoA, b: requestInfoB)
            switch result {
            case .success(let bookResult):
                let nameChangedResult = BookResultInfo(a: changeNameToNickname(bookInfo: bookResult.a),
                                                       b: changeNameToNickname(bookInfo: bookResult.b),
                                                       price: bookResult.price)
                bookResultInfo.accept(nameChangedResult)
                
            case .failure(let error):
                errorMessage.accept("예약 조회에 실패하였습니다 \(error.description)")
            }
        }
    }
    
    private func changeNameToNickname(bookInfo: BookInfo) -> BookInfo {
        guard let nickname = usecase.getLocationNickname(latitude: bookInfo.latitude, longitude: bookInfo.longitude) else { return bookInfo }
        var bookInfo = bookInfo
        bookInfo.changeName(name: nickname)
        return bookInfo
    }
}
