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
    private var server: Server?
    private var cancellables: Set<AnyCancellable> = []

    @Published public private(set) var status: AuthenticationStatus = .notAuthenticated(.haveNotTriedYet)

    public init(authenticationService: AuthenticationService,
                serverPerstistenceManager: ServerPersistenceManager) {
        self.authenticationService = authenticationService
        self.serverPersistenceManager = serverPerstistenceManager

        bindStatus()
    }

    public func authenticate(with server: Server) throws {
        self.server = server
        status = .authenticating(withPersistedServer: false)
        try authenticate()
    }

    public func authenticateWithPersistedServer() throws {
        do {
            self.server = try serverPersistenceManager.persistedServer()
            status = .authenticating(withPersistedServer: true)
            try authenticate()
        } catch {
            status = .notAuthenticated(.noPersistedServer)
            throw error
        }
    }
}

private extension AuthenticationManager {

    func bindStatus() {
        $status
            .filter { $0 == .authenticated }
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

    func authenticate() throws {
        guard let server = server else { throw Error.nilServer }

        authenticationService.fetchAuthentication(with: server)
            .map { _ in AuthenticationStatus.authenticated }
            .catch { Just(AuthenticationStatus.notAuthenticated(.failure($0))).eraseToAnyPublisher() }
            .receive(on: DispatchQueue.main)
            .assign(to: \.status, on: self)
            .store(in: &cancellables)
    }
}

extension AuthenticationManager {
    enum Error: Swift.Error {
        case nilServer
    }
}
