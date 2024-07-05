//
//  BookInfoUsecase.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/5/24.
//

import Foundation

public protocol BookInfoUsecaseProtocol {
    func requestBook(a: BookInfo, b: BookInfo) async -> Result<BookResultInfo, NetworkError>
    func getLocationNickname(latitude: Double, longitude: Double) -> String?
}

public struct BookInfoUsecase: BookInfoUsecaseProtocol {
    private let repository: BookRepositoryProtocol
    public init(repository: BookRepositoryProtocol) {
        self.repository = repository
    }
    
    public func requestBook(a: BookInfo, b: BookInfo) async -> Result<BookResultInfo, NetworkError> {
        await repository.requestBook(a: a, b: b)
    }
    
    public func getLocationNickname(latitude: Double, longitude: Double) -> String? {
        repository.getLocationNickname(latitude: latitude, longitude: longitude)
    }
}
