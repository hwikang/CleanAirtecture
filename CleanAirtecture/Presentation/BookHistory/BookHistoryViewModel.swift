//
//  BookHistoryViewModel.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/6/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol BookHistoryViewModelProtocol {
    func transform() -> BookHistoryViewModel.Output
    func getBookInfo(index: Int) -> BookResultInfo
}

public struct BookHistoryViewModel: BookHistoryViewModelProtocol {
    private let usecase: BookHistoryUsecaseProtocol
    private let errorMessage = PublishRelay<String>()
    private let bookHistory = BehaviorRelay<[BookResultInfo]>(value: [])

    public init(usecase: BookHistoryUsecaseProtocol) {
        self.usecase = usecase
        requestBookHistory()
    }
 
    public struct Output {
        let bookHistory: Observable<[BookResultInfo]>
        let errorMessage: Observable<String>
    }
    
    public func transform() -> Output {
        let nameChangedBookHistory = bookHistory.map { history in
            return history.map { info in
                return BookResultInfo(a: changeNameToNickname(bookInfo: info.a),
                                      b: changeNameToNickname(bookInfo: info.b),
                                      price: info.price)
            }
        }
        return Output(bookHistory: nameChangedBookHistory,
                      errorMessage: errorMessage.asObservable())
    }
    
    public func getBookInfo(index: Int) -> BookResultInfo {
        bookHistory.value[index]
    }
    
    private func requestBookHistory() {
        Task {
            let result = await usecase.fetchBookHistory()
            switch result {
            case .success(let history):
                let nameChangedHistory = history.map { info in
                    return BookResultInfo(a: changeNameToNickname(bookInfo: info.a),
                                          b: changeNameToNickname(bookInfo: info.b),
                                          price: info.price)
                }
                bookHistory.accept(nameChangedHistory)
            case .failure(let error):
                errorMessage.accept("예약 내역 조회에 실패하였습니다 \(error.description)")

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
