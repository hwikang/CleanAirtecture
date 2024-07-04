//
//  BookRepository.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/4/24.
//

import Foundation
public struct BookRepository: BookRepositoryProtocol {
    
    private let bookNetwork: BookNetwork, coreData: LocationCoreData
    public init(bookNetwork: BookNetwork, coreData: LocationCoreData) {
        self.bookNetwork = bookNetwork
        self.coreData = coreData
    }
    public func requestBook(a: BookInfo, b: BookInfo) async -> Result<BookResultInfo, NetworkError> {
        await bookNetwork.requestBook(a: a, b: b)
    }
}
