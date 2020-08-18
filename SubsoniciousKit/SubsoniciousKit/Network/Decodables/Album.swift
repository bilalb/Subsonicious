//
//  Album.swift
//  SubsoniciousKit
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public struct Album {
    public let id: String
    public let name: String
    let coverArt: String?
    let songCount: Int
    let creationDate: Date
    let duration: Int
    let artistName: String
    let artistId: String
    let playCount: Int
    let year: Int?
    let genre: String?
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
}

extension Album {
    static let placeholder = Album(
        id: "772",
        name: "Legend",
        coverArt: "al-772",
        songCount: 26,
        creationDate: Date(),
        duration: 6986,
        artistName: "Bob Marley",
        artistId: "460",
        playCount: 42,
        year: 1984,
        genre: "Reggae")
}

extension Album: Hashable { }

extension Album: Identifiable { }
