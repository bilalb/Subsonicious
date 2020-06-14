//
//  Publisher.swift
//  SubsonicKit
//
//  Created by Bilal on 14/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Combine
import Foundation

extension Publisher {
    func eraseToAnyVoidPublisher() -> AnyPublisher<(), Self.Failure> {
        map { _ in () }
            .eraseToAnyPublisher()
    }
}

extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
        sink { [weak root] in
            root?[keyPath: keyPath] = $0
        }
    }
}
