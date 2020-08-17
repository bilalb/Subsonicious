//
//  Fetcher.swift
//  SubsoniciousKit
//
//  Created by Bilal on 01/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Combine
import Foundation

public class Fetcher {

    let session: URLSession
    let jsonDecoder: JSONDecoder

    public init(sessionConfiguration: URLSessionConfiguration = .default,
                jsonDecoder: JSONDecoder = .subsonicDecoder) {
        self.session = URLSession(configuration: sessionConfiguration)
        self.jsonDecoder = jsonDecoder
    }

    func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
}
