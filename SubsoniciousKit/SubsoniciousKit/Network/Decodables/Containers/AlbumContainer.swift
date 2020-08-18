//
//  AlbumContainer.swift
//  SubsoniciousKit
//
//  Created by Bilal on 18/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public enum AlbumContainerCodingKey: String, SingleCodingKey {
    case album

    public static var key: AlbumContainerCodingKey { .album }
}

public typealias AlbumContainer<T: Decodable> = SubsonicResponseContainer<T, AlbumContainerCodingKey>
