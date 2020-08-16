//
//  Endpoint.swift
//  SubsoniciousKit
//
//  Created by Bilal on 25/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public enum Endpoint {
    case authentication

    var path: String {
        switch self {
        case .authentication:
            return Constant.NetworkRequest.Authentication.path
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        default:
            return []
        }
    }
}
