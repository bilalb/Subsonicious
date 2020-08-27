//
//  CombineQueuePlayer+MedataChanges.swift
//  SubsoniciousKit
//
//  Created by Bilal on 14/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Combine
import Foundation

extension CombinePlayer {
    var dynamicMetadataChangesPublisher: AnyPublisher<(), Never> {
        Publishers.MergeMany(anyVoidPublisher(for: \.currentItem),
                             anyVoidPublisher(for: \.rate),
                             anyVoidPublisher(for: \.timeControlStatus),
                             anyVoidPublisher(for: \.currentItem?.status),
                             seekingPublisher)
            .eraseToAnyPublisher()
    }

    var staticMetadataChangesPublisher: AnyPublisher<(), Never> {
        anyVoidPublisher(for: \.currentItem)
    }
}

private extension CombinePlayer {

    func anyVoidPublisher<Value>(for keyPath: KeyPath<CombinePlayer, Value>) -> AnyPublisher<(), Never> {
        publisher(for: keyPath)
            .eraseToAnyVoidPublisher()
    }

    var seekingPublisher: AnyPublisher<(), Never> {
        seeking
            .filter { $0 }
            .eraseToAnyVoidPublisher()
    }
}
