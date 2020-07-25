//
//  Service.swift
//  SubsoniciousKit
//
//  Created by Bilal on 10/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public class Service {

    let session: URLSession
    let jsonDecoder = JSONDecoder()
    var authentication: Authentication?

    public init(sessionConfiguration: URLSessionConfiguration = .default) throws {
        self.session = URLSession(configuration: sessionConfiguration)

        let serverPersistenceManager = try ServerPersistenceManager()
        let server = try serverPersistenceManager.persistedServer()
        self.authentication = Authentication(server: server)
    }
}

extension Service {
    enum ServiceError: Error {
        case nilAuthentication
    }
}
