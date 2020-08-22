//
//  FetchStatus.swift
//  SubsoniciousKit
//
//  Created by Bilal on 02/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public enum FetchStatus {
    case notFetchedYet
    case fetching
    case fetched(Result<Decodable, Error>)
}

extension FetchStatus: Equatable {
    public static func == (lhs: FetchStatus, rhs: FetchStatus) -> Bool {
        switch (lhs, rhs) {
        case (.notFetchedYet, .notFetchedYet):
            return true
        case (.fetching, .fetching):
            return true
        case (.fetched, .fetched):
            return true
        default:
            return false
        }
    }
}

public extension FetchStatus {
    func decodable<T: Decodable, V: SingleCodingKey>(for singleCodingKey: V) -> T? {
        let container = decodable as? SubsonicResponseContainer<T, V>
        return container?.content
    }

    var decodable: Decodable? {
        switch self {
        case .fetched(let result):
            switch result {
            case .success(let response):
                return response
            default:
                return nil
            }
        default:
            return nil
        }
    }

    var errorDescription: String? {
        switch self {
        case .fetched(let result):
            return result.errorDescription
        default:
            return nil
        }
    }
}
