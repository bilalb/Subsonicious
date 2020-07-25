//
//  NetworkRequest.swift
//  SubsoniciousKit
//
//  Created by Bilal on 05/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

struct NetworkRequest {
    let authentication: Authentication
    let endpoint: Endpoint

    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = authentication.scheme
        urlComponents.host = authentication.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = defaultQueryItems + authentication.queryItems + endpoint.queryItems

        return urlComponents.url
    }
}

extension NetworkRequest {
    enum Error: Swift.Error {
        case nilURL
    }
}

private extension NetworkRequest {
    typealias ParameterName = Constant.NetworkRequest.ParameterName
    typealias ParameterValue = Constant.NetworkRequest.ParameterValue

    var defaultQueryItems: [URLQueryItem] {
        [URLQueryItem(name: ParameterName.version, value: ParameterValue.version),
         URLQueryItem(name: ParameterName.clientApplication, value: ParameterValue.clientApplication),
         URLQueryItem(name: ParameterName.dataFormat, value: ParameterValue.dataFormat)]
    }
}
