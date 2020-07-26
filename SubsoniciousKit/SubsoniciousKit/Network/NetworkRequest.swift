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

    func url() throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = authentication.scheme
        urlComponents.host = authentication.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = defaultQueryItems + authentication.queryItems + endpoint.queryItems

        guard let url = urlComponents.url else {
            throw Error.nilURL
        }
        return url
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
