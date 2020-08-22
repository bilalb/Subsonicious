//
//  AuthenticationManager.swift
//  SubsoniciousKit
//
//  Created by Bilal on 05/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Combine
import Foundation

public final class AuthenticationManager: Manager<SubsonicResponse> {

    private let serverPersistenceManager: ServerPersistenceManager
    private var server: Server?
    @Published public private(set) var authenticationStatus: AuthenticationStatus = .notAuthenticated(.haveNotTriedYet) {
        // As described in https://stackoverflow.com/a/57620669
        // "Using @Published doesn't work on a subclass.
        // But if you update the value you want to maintain state
        // of using the objectWillChange.send() method provided by the
        // baseclass the state gets updated properly"
        willSet {
            self.objectWillChange.send()
        }
    }

    public init(service: Service<SubsonicResponse> = Service<SubsonicResponse>(),
                endpoint: Endpoint,
                serverPerstistenceManager: ServerPersistenceManager) {
        self.serverPersistenceManager = serverPerstistenceManager
        super.init(service: service, endpoint: endpoint)

        bindAuthenticationStatus()
    }

    public func authenticate(_ mode: AuthenticationMode) throws {
        switch mode {
        case .automatic:
            do {
                self.server = try serverPersistenceManager.persistedServer()
            } catch {
                authenticationStatus = .notAuthenticated(.noPersistedServer)
                throw error
            }
        case .manual(let server):
            self.server = server
        }

        authenticationStatus = .authenticating(mode)

        try fetch()
    }

    public override func fetch() throws {
        let url = try self.url()

        service.fetch(url)
            .map { _ in AuthenticationStatus.authenticated }
            .catch { Just(AuthenticationStatus.notAuthenticated(.failure($0))).eraseToAnyPublisher() }
            .receive(on: DispatchQueue.main)
            .assign(to: \.authenticationStatus, on: self)
            .store(in: &cancellables)
    }

    override func url() throws -> URL {
        guard let server = server else { throw Error.nilServer }
        let authentication = Authentication(server: server)
        let urlBuilder = try URLBuilder(authentication: authentication, endpoint: .authentication)
        return try urlBuilder.url()
    }
}

private extension AuthenticationManager {

    func bindAuthenticationStatus() {
        $authenticationStatus
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
}

extension AuthenticationManager {
    enum Error: Swift.Error {
        case nilServer
    }
}
