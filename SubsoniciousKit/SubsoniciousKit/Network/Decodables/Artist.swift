//
//  Artist.swift
//  SubsoniciousKit
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public struct Artist {
    public let id: Int
    public let name: String
    let albumCount: Int
    let coverArt: String?
    let artistImageUrl: URL?
}

extension Artist: Decodable {

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case albumCount
        case coverArt
        case artistImageUrl
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(SafeInt.self, forKey: .id).value
        name = try container.decode(String.self, forKey: .name)
        albumCount = try container.decode(SafeInt.self, forKey: .albumCount).value

        coverArt = try container.decodeIfPresent(String.self, forKey: .coverArt)
        artistImageUrl = try container.decodeIfPresent(SafeURL.self, forKey: .artistImageUrl)?.value
    }
}

public extension Artist {
    static let placeholder = Artist(
        id: 0,
        name: "Bob Marley",
        albumCount: 42,
        coverArt: "",
        artistImageUrl: URL(string: "https://www.artist.image.url"))
}

extension Artist: Identifiable { }

extension Artist: Hashable { }

extension Artist: Equatable { }