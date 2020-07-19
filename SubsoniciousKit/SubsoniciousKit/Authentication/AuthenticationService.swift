//
//  AuthenticationService.swift
//  SubsoniciousKit
//
//  Created by Bilal on 05/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Combine
import Foundation

public class AuthenticationService: Service {

    private let jsonDecoder = JSONDecoder()

    func fetchAuthentication(with server: Server) -> AnyPublisher<SubsonicResponse, Error> {
        let request = AuthenticationRequest(server: server)

        guard let url = request.url else {
            return Fail(outputType: SubsonicResponse.self, failure: NetworkRequest.Error.nilURL)
                .eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: SubsonicResponse.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
}
