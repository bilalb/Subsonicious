//
//  Service.swift
//  SubsoniciousKit
//
//  Created by Bilal on 10/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Combine
import Foundation

public class Service<T: Decodable> {

    private let fetcher: Fetcher

    public init(fetcher: Fetcher = Fetcher()) {
        self.fetcher = fetcher
    }

    func fetch(_ url: URL) -> AnyPublisher<T, Error> {
        fetcher.fetch(url)
    }

    func fetchData(_ url: URL) -> AnyPublisher<Data, Error> {
        fetcher.fetchData(url)
    }
}
