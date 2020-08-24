//
//  MockedSuccessService.swift
//  SubsoniciousKit
//
//  Created by Bilal on 24/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Combine
import Foundation

public final class MockedSuccessService<T: PlaceholderProtocol>: Service<T> {
    override func fetch(_ url: URL) -> AnyPublisher<T, Error> {
        guard let placeholder = T.placeholder as? T else {
            preconditionFailure("Failed to cast placeholder")
        }
        return Just(placeholder)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
