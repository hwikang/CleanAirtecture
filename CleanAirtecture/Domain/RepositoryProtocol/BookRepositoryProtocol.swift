//
//  BookRepositoryProtocol.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/4/24.
//

import Foundation

public protocol BookRepositoryProtocol {
    func requestBook(a: BookInfo, b: BookInfo) async -> Result<BookResultInfo, NetworkError>
    func fetchBookHistory(year: Int, month: Int) async -> Result<[BookResultInfo], NetworkError>
    func getLocationNickname(latitude: Double, longitude: Double) -> String?
}
