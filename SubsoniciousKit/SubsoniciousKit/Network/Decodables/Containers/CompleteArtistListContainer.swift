//
//  CompleteArtistListContainer.swift
//  SubsoniciousKit
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public enum CompleteArtistListContainerCodingKey: String, SingleCodingKey {
    case artistList = "artists"

    public static var key: CompleteArtistListContainerCodingKey { .artistList }
}

public typealias CompleteArtistListContainer<T: Decodable> = SubsonicResponseContainer<T, CompleteArtistListContainerCodingKey>

extension CompleteArtistListContainer: PlaceholderProtocol {
    public static var placeholder: CompleteArtistListContainer<CompleteArtistList> {
        .init(.placeholder)
    }
}
