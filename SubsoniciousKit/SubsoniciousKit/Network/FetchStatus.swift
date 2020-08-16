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
    var errorDescription: String? {
        switch self {
        case .fetched(let result):
            return result.errorDescription
        default:
            return nil
        }
    }
}
