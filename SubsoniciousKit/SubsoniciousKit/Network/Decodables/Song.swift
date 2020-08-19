//
//  Song.swift
//  SubsoniciousKit
//
//  Created by Bilal on 18/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public struct Song {
    public let id: String
    let parent: String
    let isDirectory: Bool
    public let title: String
    let albumTitle: String
    let artistName: String
    let track: Int?
    let year: Int?
    let genre: String?
    let coverArtId: String?
    let size: Int
    let contentType: String
    let suffix: String
    let duration: Int
    let bitRate: Int
    let path: String
    let playCount: Int
    let discNumber: Int?
    let creationDate: Date
    let albumId: String
    let artistId: String?
    let type: String
}

extension Song: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case parent
        case isDirectory = "isDir"
        case title
        case albumTitle = "album"
        case artistName = "artist"
        case track
        case year
        case genre
        case coverArtId = "coverArt"
        case size
        case contentType
        case suffix
        case duration
        case bitRate
        case path
        case playCount
        case discNumber
        case creationDate = "created"
        case albumId
        case artistId
        case type
    }
}

extension Song: Hashable { }

extension Song: Identifiable { }

public extension Song {
    static let placeholder = Song(
        id: "9070",
        parent: "8957",
        isDirectory: false,
        title: "I Shot The Sheriff",
        albumTitle: "Legend",
        artistName: "Bob Marley",
        track: 7,
        year: 1970,
        genre: "Reggae",
        coverArtId: "something",
        size: 4530176,
        contentType: "audio/mpeg",
        suffix: "mp3",
        duration: 283,
        bitRate: 128,
        path: "Bob Marley - Integrale 1967-2002/Bob Marley - 1994 - Legend/07 - I Shot The Sheriff.mp3",
        playCount: 42,
        discNumber: 7,
        creationDate: Date(),
        albumId: "772",
        artistId: "460",
        type: "music")
}
