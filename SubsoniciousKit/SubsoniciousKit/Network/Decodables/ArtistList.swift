//
//  ArtistList.swift
//  SubsoniciousKit
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public struct ArtistList {
    let ignoredArticles: String
    public let indexes: [Index]
}

extension ArtistList: Decodable {
    enum CodingKeys: String, CodingKey {
        case ignoredArticles
        case indexes = "index"
    }
}

public extension ArtistList {
    static let placeholder = ArtistList(
        ignoredArticles: "",
        indexes: [.placeholder])
}

public extension ArtistList {
    struct Index: Decodable {
        public let name: String
        public let artists: [Artist]

        enum CodingKeys: String, CodingKey {
            case name
            case artists = "artist"
        }
    }
}

extension ArtistList.Index: Identifiable {
    public var id: String { name }
}

public extension ArtistList.Index {
    static let placeholder = ArtistList.Index(
        name: "B",
        artists: [.placeholder])
}
