//
//  CoreDataError.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/1/24.
//

import Foundation

public enum CoreDataError: Error {
    case entityNotFound(String)
    case saveError(String)
    case readError(String)
    case deleteError(String)
    case updateError(String)

    public var description: String {
        switch self {
        case .entityNotFound(let object): return "CoreData 데이터 \(object) Not found"
        case .saveError(let message): return "CoreData 저장 에러 \(message)"
        case .readError(let message): return "CoreData 불러오기 에러 \(message)"
        case .deleteError(let message): return "CoreData 삭제 에러 \(message)"
        case .updateError(let message): return "CoreData 수정 에러 \(message)"
        }
    }
}
