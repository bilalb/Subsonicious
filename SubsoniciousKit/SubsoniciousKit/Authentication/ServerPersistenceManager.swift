//
//  ServerPersistenceManager.swift
//  SubsoniciousKit
//
//  Created by Bilal on 18/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation
import KeychainAccess

public final class ServerPersistenceManager {

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let keychain: Keychain

    public init() throws {
        guard let bundleIdentifier = Bundle.kit.bundleIdentifier else { throw Error.nilBundleIdentifier }
        self.keychain = Keychain(service: bundleIdentifier)
    }

    func persist(server: Server) throws {
        guard shouldPersist(server: server) else { return }

        let data = try encoder.encode(server)
        try keychain.set(data, key: Constant.Keychain.Key.server)
    }

    func persistedServer() throws -> Server {
        guard let serverData = try keychain.getData(Constant.Keychain.Key.server) else { throw Error.nilPersistedServer }
        return try decoder.decode(Server.self, from: serverData)
    }
}

private extension ServerPersistenceManager {

    func shouldPersist(server: Server) -> Bool {
        guard let persistedServer = try? self.persistedServer() else { return true }
        return persistedServer != server
    }
}

private extension ServerPersistenceManager {
    enum Error: Swift.Error {
        case nilBundleIdentifier
        case nilPersistedServer
    }
}

extension ServerPersistenceManager.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .nilBundleIdentifier:
            return "ServerPersistenceManager.Error.nilBundleIdentifier \n The SubsoniciousKit bundle identifier used to create a Keychain instance is nil."
        case .nilPersistedServer:
            return "ServerPersistenceManager.Error.nilPersistedServer \n The persisted server  is nil."
        }
    }
}
