//
//  Authentication.swift
//  SubsoniciousKit
//
//  Created by Bilal on 25/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

struct Authentication {

    let server: Server

    private let salt = String.random(length: 8)

    var queryItems: [URLQueryItem] {
        [URLQueryItem(name: ParameterName.username, value: username),
         URLQueryItem(name: ParameterName.authenticationToken, value: authenticationToken),
         URLQueryItem(name: ParameterName.salt, value: salt)]
    }

    var scheme: String {
        baseURLComponents.first ?? ""
    }

    var host: String {
        baseURLComponents[safe: 1] ?? ""
    }
}

private extension Authentication {

    typealias ParameterName = Constant.NetworkRequest.Parameter.Name

    var username: String {
        server.username
    }

    var authenticationToken: String {
        let saltedPassword = server.password + salt
        guard let data = saltedPassword.data(using: .utf8) else { return "" }
        return data.md5()
    }

    var baseURLComponents: [String] {
        server.baseURL.components(separatedBy: "://")
    }
}
