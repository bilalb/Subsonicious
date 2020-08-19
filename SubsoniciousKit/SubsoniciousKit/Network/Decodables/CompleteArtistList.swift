//
//  CompleteArtistList.swift
//  SubsoniciousKit
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public struct CompleteArtistList {
    let ignoredArticles: String
    public let indexes: [Index]
}

extension CompleteArtistList: Decodable {
    enum CodingKeys: String, CodingKey {
        case ignoredArticles
        case indexes = "index"
    }
}

public extension CompleteArtistList {
    static let placeholder = CompleteArtistList(
        ignoredArticles: "",
        indexes: [.placeholder])
}

public extension CompleteArtistList {
    struct Index: Decodable {
        public let name: String
        public let artists: [Artist]

        enum CodingKeys: String, CodingKey {
            case name
            case artists = "artist"
        }
    }
}

extension CompleteArtistList.Index: Identifiable {
    public var id: String { name }
}

public extension CompleteArtistList.Index {
    static let placeholder = CompleteArtistList.Index(
        name: "B",
        artists: [.placeholder])
}
