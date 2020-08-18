//
//  ArtistContainer.swift
//  SubsoniciousKit
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public enum ArtistContainerCodingKey: String, SingleCodingKey {
    case artist

    public static var key: ArtistContainerCodingKey { .artist }
}

public typealias ArtistContainer<T: Decodable> = SubsonicResponseContainer<T, ArtistContainerCodingKey>

extension ArtistContainer: Identifiable where T == Artist {
    public var id: Int {
        content.id
    }
}

extension ArtistContainer: Equatable where T == Artist {
    public static func == (lhs: SubsonicResponseContainer<T, NestedCodingKeys>, rhs: SubsonicResponseContainer<T, NestedCodingKeys>) -> Bool {
        lhs.content.id == rhs.content.id
    }
}
