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

    private let authenticationService: Service<SubsonicResponse>
    private let serverPersistenceManager: ServerPersistenceManager
    private var server: Server?
    private var cancellables: Set<AnyCancellable> = []

    @Published public private(set) var status: AuthenticationStatus = .notAuthenticated(.haveNotTriedYet)

    public init(authenticationService: Service<SubsonicResponse>,
                serverPerstistenceManager: ServerPersistenceManager) {
        self.authenticationService = authenticationService
        self.serverPersistenceManager = serverPerstistenceManager

        bindStatus()
    }

    public func authenticate(_ mode: AuthenticationMode) throws {
        switch mode {
        case .automatic:
            do {
                self.server = try serverPersistenceManager.persistedServer()
            } catch {
                status = .notAuthenticated(.noPersistedServer)
                throw error
            }
        case .manual(let server):
            self.server = server
        }

        status = .authenticating(mode)

        let url = try authenticationURL()
        authenticate(url: url)
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

    func authenticate(url: URL) {
        authenticationService.fetch(url)
            .map { _ in AuthenticationStatus.authenticated }
            .catch { Just(AuthenticationStatus.notAuthenticated(.failure($0))).eraseToAnyPublisher() }
            .receive(on: DispatchQueue.main)
            .assign(to: \.status, on: self)
            .store(in: &cancellables)
    }

    func authenticationURL() throws -> URL {
        guard let server = server else { throw Error.nilServer }
        let authentication = Authentication(server: server)
        let urlBuilder = try URLBuilder(authentication: authentication, endpoint: .authentication)
        return try urlBuilder.url()
    }
}

extension AuthenticationManager {
    enum Error: Swift.Error {
        case nilServer
    }
}
