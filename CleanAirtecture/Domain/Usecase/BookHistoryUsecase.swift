//
//  BookHistoryUsecase.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/6/24.
//

import Foundation

public protocol BookHistoryUsecaseProtocol {
    func fetchBookHistory() async -> Result<[BookResultInfo], NetworkError>
    func getLocationNickname(latitude: Double, longitude: Double) -> String?
}

public struct BookHistoryUsecase: BookHistoryUsecaseProtocol {
    private let repository: BookRepositoryProtocol
    public init(repository: BookRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchBookHistory() async -> Result<[BookResultInfo], NetworkError> {
        let today = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)

        return await repository.fetchBookHistory(year: year, month: month)
    }
    
    public func getLocationNickname(latitude: Double, longitude: Double) -> String? {
        repository.getLocationNickname(latitude: latitude, longitude: longitude)
    }
}
