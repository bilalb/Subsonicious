//
//  Result.swift
//  SubsoniciousKit
//
//  Created by Bilal on 02/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

extension Result where Failure == Error {
    var errorDescription: String? {
        switch self {
        case .failure(let error):
            switch error {
            case DecodingError.Subsonic.error(let subsonicError):
                return subsonicError.message
            default:
                return error.localizedDescription
            }
        default:
            return nil
        }
    }
}
