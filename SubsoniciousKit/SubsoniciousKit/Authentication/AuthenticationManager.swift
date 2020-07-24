//
//  AuthenticationManager.swift
//  SubsoniciousKit
//
//  Created by Bilal on 05/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Combine
import Foundation

public class AuthenticationManager: ObservableObject {

    private let authenticationService: AuthenticationService
    private let serverPersistenceManager: ServerPersistenceManager
    @Published public private(set) var result: Result<SubsonicResponse, Error>?
    private var server: Server?
    private var cancellables: Set<AnyCancellable> = []

    public init(authenticationService: AuthenticationService,
                serverPerstistenceManager: ServerPersistenceManager) {
        self.authenticationService = authenticationService
        self.serverPersistenceManager = serverPerstistenceManager

        bindResult()
    }

    private func bindResult() {
        $result
            .filter {
                switch $0 {
                case .success:
                    return true
                default:
                    return false
                }
            }
            .sink { [weak self] _ in
                guard let server = self?.server else { return }
                do {
                    try self?.serverPersistenceManager.persist(server: server)
                } catch {
                    debugPrint(error)
                }
            }
            .store(in: &cancellables)
    }

    public func authenticate(with server: Server) {
        self.server = server

        authenticationService.fetchAuthentication(with: server)
            .map { Result<SubsonicResponse, Error>.success($0) }
            .catch { Just(Result<SubsonicResponse, Error>.failure($0)).eraseToAnyPublisher() }
            .receive(on: DispatchQueue.main)
            .assign(to: \.result, on: self)
            .store(in: &cancellables)
    }

    /// Authenticate with the persisted server if exists.
    /// - Throws: Error while trying to get the persisted server.
    /// - Returns: `true` if the persisted server exists; otherwise `false`.
    public func authenticateWithPersistedServer() throws -> Bool {
        if let persistedServer = try serverPersistenceManager.persistedServer() {
            authenticate(with: persistedServer)
            return true
        }
        return false
    }
}
