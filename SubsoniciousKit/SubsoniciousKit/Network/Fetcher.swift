//
//  Fetcher.swift
//  SubsoniciousKit
//
//  Created by Bilal on 01/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Combine
import Foundation

public final class Fetcher {

    private let session: URLSession
    private let jsonDecoder: JSONDecoder

    public init(sessionConfiguration: URLSessionConfiguration = .default,
                jsonDecoder: JSONDecoder = .subsonicDecoder) {
        self.session = URLSession(configuration: sessionConfiguration)
        self.jsonDecoder = jsonDecoder
    }

    func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        fetchData(url)
            .decode(type: T.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }

    func fetchData(_ url: URL) -> AnyPublisher<Data, Error> {
        session.dataTaskPublisher(for: url)
            .map(\.data)
            .catch { Fail(error: $0) }
            .eraseToAnyPublisher()
    }
}
