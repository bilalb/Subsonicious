//
//  Manager.swift
//  SubsoniciousKit
//
//  Created by Bilal on 05/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Combine
import Foundation

public class Manager<T: Decodable>: ObservableObject {
    private let service: Service<T>
    private let endpoint: Endpoint
    @Published public private(set) var status: FetchStatus = .notFetchedYet
    private var cancellables: Set<AnyCancellable> = []

    public init(service: Service<T>, endpoint: Endpoint) {
        self.service = service
        self.endpoint = endpoint
    }

    public func fetch() throws {
        let url = try self.url()

        status = .fetching
        
        service.fetch(url)
            .map { FetchStatus.fetched(.success($0)) }
            .catch { Just(FetchStatus.fetched(.failure($0))).eraseToAnyPublisher() }
            .receive(on: DispatchQueue.main)
            .assign(to: \.status, on: self)
            .store(in: &cancellables)
    }
}

private extension Manager {
    func url() throws -> URL {
        let urlBuilder = try URLBuilder(endpoint: endpoint)
        return try urlBuilder.url()
    }
}
