//
//  Album.swift
//  SubsoniciousKit
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public struct Album {
    public let id: Int
    public let name: String
    let coverArt: String?
    let songCount: Int
    let creationDate: Date //="2004-11-08T23:33:11" // decoder.dateDecodingStrategy = .iso8601
    let duration: Int
    let artistName: String
    let artistId: Int
    let playCount: Int
    let year: Int?
    let genre: Genre?
}

enum Genre: String, Decodable {
    case reggae
    case rock

    //    init?(rawValue: String) {
    //        self = Genre(rawValue: rawValue.lowercased())
    //    }
}

extension Album: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case coverArt
        case songCount
        case creationDate = "created"
        case duration
        case artistName = "artist"
        case artistId
        case playCount
        case year
        case genre
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(SafeInt.self, forKey: .id).value
        name = try container.decode(String.self, forKey: .name)
        coverArt = try container.decodeIfPresent(String.self, forKey: .coverArt)
        songCount = try container.decode(Int.self, forKey: .songCount)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        duration = try container.decode(Int.self, forKey: .duration)
        artistName = try container.decode(String.self, forKey: .artistName)
        artistId = try container.decode(SafeInt.self, forKey: .artistId).value
        playCount = try container.decode(Int.self, forKey: .playCount)
        year = try container.decodeIfPresent(Int.self, forKey: .year)
        genre = try container.decodeIfPresent(Genre.self, forKey: .genre)
    }
}

extension Album {
    static let placeholder = Album(
        id: 772,
        name: "Legend",
        coverArt: "al-772",
        songCount: 26,
        creationDate: Date(), // "2020-02-23T12:38:44.000Z"
        duration: 6986,
        artistName: "Bob Marley",
        artistId: 460,
        playCount: 42,
        year: 1984,
        genre: .reggae)
}

extension Album: Hashable { }

extension Album: Identifiable { }
