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

extension NetworkRequest.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .nilURL:
            return "NetworkRequest.Error.nilURL \n The url is nil."
        }
    }
}

private extension NetworkRequest {
    typealias ParameterName = Constant.NetworkRequest.Parameter.Name
    typealias ParameterValue = Constant.NetworkRequest.Parameter.Value

    var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = authentication.scheme
        urlComponents.host = authentication.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = defaultQueryItems + authentication.queryItems + endpoint.queryItems
        return urlComponents
    }

    var defaultQueryItems: [URLQueryItem] {
        [URLQueryItem(name: ParameterName.version, value: ParameterValue.version),
         URLQueryItem(name: ParameterName.clientApplication, value: ParameterValue.clientApplication),
         URLQueryItem(name: ParameterName.dataFormat, value: ParameterValue.dataFormat)]
    }
}
