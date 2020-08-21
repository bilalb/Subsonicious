//
//  CoverArtManager.swift
//  SubsoniciousKit
//
//  Created by Bilal on 21/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Combine
import Foundation

final class CoverArtManager: Manager<Data> {

    @Published private(set) var data: Data?

    override init(service: Service<Data> = Service<Data>(), endpoint: Endpoint) {
        super.init(service: service, endpoint: endpoint)
        bindStatus()
    }

    override func fetch() throws {
        let url = try self.url()

        status = .fetching

        service.fetchData(url)
            .map { FetchStatus.fetched(.success($0)) }
            .catch { Just(FetchStatus.fetched(.failure($0))).eraseToAnyPublisher() }
            .receive(on: DispatchQueue.main)
            .assign(to: \.status, on: self)
            .store(in: &cancellables)
    }
}

extension CoverArtManager {
    func bindStatus() {
        $status
            .sink { [weak self] status in
                self?.data = status.decodable as? Data
            }
            .store(in: &cancellables)
    }
}
