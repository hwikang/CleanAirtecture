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
            "b": bJSONString
        ]
        #if DEBUG
        return .success(BookResultInfo(a: a, b: b, price: Double.random(in: 100...10000000).truncateValue(point: 1)))
        #else
        return await manager.fetchData(url: url, method: .post, parameters: parameters, encoding: JSONEncoding.default)

        #endif
    }
    
    public func fetchBookHistory(year: Int, month: Int) async -> Result<[BookResultInfo], NetworkError> {
        let url = "https://mvchain/books"
        let parameters: Parameters = [
            "year": year,
            "month": month
        ]
        #if DEBUG
        return .success([
            BookResultInfo(a:  BookInfo(latitude: Double.random(in: 30...40).truncateValue(point: 3), longitude: Double.random(in: 120...130).truncateValue(point: 3), aqi: Int.random(in: 1...100), name: "서울 A 위치"),
                           b:  BookInfo(latitude: Double.random(in: 30...40).truncateValue(point: 3), longitude: Double.random(in: 120...130).truncateValue(point: 3), aqi: Int.random(in: 1...100), name: "서울 B 위치"),
                           price: Double.random(in: 100...10000000).truncateValue(point: 1)),
           BookResultInfo(a:  BookInfo(latitude: Double.random(in: 30...40).truncateValue(point: 3), longitude: Double.random(in: 120...130).truncateValue(point: 3), aqi: Int.random(in: 1...100), name: "서울 C 위치"),
                          b:  BookInfo(latitude: Double.random(in: 30...40).truncateValue(point: 3), longitude: Double.random(in: 120...130).truncateValue(point: 3), aqi: Int.random(in: 1...100), name: "서울 D 위치"),
                          price: Double.random(in: 100...10000000).truncateValue(point: 1))
        ])
        #else
        return await manager.fetchData(url: url, method: .get, parameters: parameters)
        #endif

    }
}
