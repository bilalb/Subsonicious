//
//  ArtistListContainer.swift
//  SubsoniciousKit
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public enum ArtistListContainerCodingKey: String, SingleCodingKey {
    case artistList = "artists"

    public static var key: ArtistListContainerCodingKey { .artistList }
}

public typealias ArtistListContainer<T: Decodable> = SubsonicResponseContainer<T, ArtistListContainerCodingKey>
