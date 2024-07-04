//
//  BookNetwork.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/4/24.
//

import Foundation
import Alamofire

public struct BookNetwork {
    private let manager: NetworkManager
    init(manager: NetworkManager) {
        self.manager = manager
    }
    public func requestBook(a: BookInfo, b: BookInfo) async -> Result<BookResultInfo, NetworkError> {
        let url = "https://mvlchain/books"
        guard let aJSONString = a.toJSONString(), let bJSONString = b.toJSONString() else { return .failure(.encodingError)}
        let parameters: Parameters = [
            "a": aJSONString,
            "b": bJSONString,
            "price": 123
        ]
        
        print(parameters)
        #if DEBUG
        return .success(BookResultInfo(a: a, b: b, price: Double.random(in: 100...10000000)))
        #else
        return await manager.fetchData(url: url, method: .post, parameters: parameters, encoding: JSONEncoding.default)

        #endif
    }

}
