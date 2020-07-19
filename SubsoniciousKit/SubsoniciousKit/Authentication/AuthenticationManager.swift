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
    @Published public private(set) var result: Result<SubsonicResponse, Error>?
    private var cancellables: Set<AnyCancellable> = []

    public init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }

    public func authenticate(with server: Server) {
        authenticationService.fetchAuthentication(with: server)
            .map { Result<SubsonicResponse, Error>.success($0) }
            .catch { Just(Result<SubsonicResponse, Error>.failure($0)).eraseToAnyPublisher() }
            .receive(on: DispatchQueue.main)
            .assign(to: \.result, on: self)
            .store(in: &cancellables)
    }
}
