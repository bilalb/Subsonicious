//
//  URLBuilder.swift
//  SubsoniciousKit
//
//  Created by Bilal on 02/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

struct URLBuilder {

    private let authentication: Authentication
    private let endpoint: Endpoint

    init(authentication: Authentication? = nil, endpoint: Endpoint) throws {
        if let authentication = authentication {
            self.authentication = authentication
        } else {
            let serverPersistenceManager = try ServerPersistenceManager()
            let server = try serverPersistenceManager.persistedServer()
            self.authentication = Authentication(server: server)
        }

        self.endpoint = endpoint
    }

    func url() throws -> URL {
        let request = NetworkRequest(authentication: authentication,
                                     endpoint: endpoint)
        return try request.url()
    }
}
