//
//  ArtistDetailsContainer.swift
//  SubsoniciousKit
//
//  Created by Bilal on 18/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public enum ArtistDetailsContainerCodingKey: String, SingleCodingKey {
    case artistDetails = "artistInfo2"

    public static var key: ArtistDetailsContainerCodingKey { .artistDetails }
}

public typealias ArtistDetailsContainer<T: Decodable> = SubsonicResponseContainer<T, ArtistDetailsContainerCodingKey>
