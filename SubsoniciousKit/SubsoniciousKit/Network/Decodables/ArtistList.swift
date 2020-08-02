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

    public init(from decoder: Decoder) throws {
        _ = try SubsonicResponse(from: decoder)
        let container = try decoder.container(keyedBy: SubsonicResponse.CodingKeys.self)
        let responseContainer = try container.nestedContainer(keyedBy: SubsonicResponse.ResponseCodingKeys.self, forKey: .responseContainer)
        let artistContainer = try responseContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .artists)

        ignoredArticles = try artistContainer.decode(String.self, forKey: .ignoredArticles)
        indexes = try artistContainer.decode([Index].self, forKey: .indexes)
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
