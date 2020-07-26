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

    func fetch(_ url: URL) -> AnyPublisher<SubsonicResponse, Error> {
        fetcher.fetch(url)
    }
}
