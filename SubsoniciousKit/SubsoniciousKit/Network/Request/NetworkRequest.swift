//
//  NetworkRequest.swift
//  SubsoniciousKit
//
//  Created by Bilal on 05/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import CryptoKit
import Foundation

class NetworkRequest {

    let server: Server

    init(server: Server) {
        self.server = server
    }

    var path: String { "" }

    var queryItems: [URLQueryItem] {
        [URLQueryItem(name: ParameterName.version, value: ParameterValue.version),
         URLQueryItem(name: ParameterName.clientApplication, value: ParameterValue.clientApplication),
         URLQueryItem(name: ParameterName.dataFormat, value: ParameterValue.dataFormat),
         URLQueryItem(name: ParameterName.username, value: username),
         URLQueryItem(name: ParameterName.authenticationToken, value: authenticationToken),
         URLQueryItem(name: ParameterName.salt, value: salt)]
    }

    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems

        return urlComponents.url
    }

    private lazy var username: String = {
        server.username
    }()

    private lazy var authenticationToken: String = {
        let saltedPassword = server.password + salt
        guard let data = saltedPassword.data(using: .utf8) else { return "" }
        return md5(data: data)
    }()

    private lazy var salt: String = {
        randomString(length: 8)
    }()

    private lazy var baseURLComponents: [String] = {
        server.baseURL.components(separatedBy: "://")
    }()

    private lazy var scheme: String = {
        baseURLComponents.first ?? ""
    }()

    private lazy var host: String = {
        baseURLComponents[safe: 1] ?? ""
    }()
}

extension NetworkRequest {
    enum Error: Swift.Error {
        case nilURL
    }
}

private extension NetworkRequest {

    typealias ParameterName = Constant.NetworkRequest.ParameterName
    typealias ParameterValue = Constant.NetworkRequest.ParameterValue

    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }

    func md5(data: Data) -> String {
        return Insecure.MD5
            .hash(data: data)
            .map { String(format: "%02hhx", $0) }
            .joined()
    }
}
