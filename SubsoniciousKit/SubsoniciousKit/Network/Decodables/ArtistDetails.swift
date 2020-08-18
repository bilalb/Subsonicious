//
//  ArtistDetails.swift
//  SubsoniciousKit
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public struct ArtistDetails {
    let biography: String
    let musicBrainzId: String?
    let lastFmURL: URL
    let smallImageURL: URL?
    let mediumImageURL: URL?
    let largeImageURL: URL?
    let similarArtists: [Artist]?
}

extension ArtistDetails: Decodable {
    enum CodingKeys: String, CodingKey {
        case biography
        case musicBrainzId
        case lastFmURL = "lastFmUrl"
        case smallImageURL = "smallImageUrl"
        case mediumImageURL = "mediumImageUrl"
        case largeImageURL = "largeImageUrl"
        case similarArtists = "similarArtist"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        biography = try container.decode(String.self, forKey: .biography)
        musicBrainzId = try container.decodeIfPresent(String.self, forKey: .musicBrainzId)
        lastFmURL = try container.decode(SafeURL.self, forKey: .lastFmURL).value
        smallImageURL = try container.decodeIfPresent(SafeURL.self, forKey: .smallImageURL)?.value
        mediumImageURL = try container.decodeIfPresent(SafeURL.self, forKey: .mediumImageURL)?.value
        largeImageURL = try container.decodeIfPresent(SafeURL.self, forKey: .largeImageURL)?.value
        similarArtists = try container.decodeIfPresent([Artist].self, forKey: .similarArtists)
    }
}

extension ArtistDetails {
    static let placeholder = ArtistDetails(
        biography: "Bob Marley (February 6, 1945 – May 11, 1981), born Nesta Robert Marley which was later to be changed by passport officials to Robert Nesta Marley, was a Jamaican singer-songwriter, guitarist, and activist. He was the most widely known writer and performer of Reggae, and more specifically Roots Reggae.  He is famous for popularising the genre outside of Jamaica and the Caribbean. Much of his music dealt with the struggles of the spiritually wealthy rasta and/or spiritually powerful Jah Rastafari. &lt;a target='_blank' href=\"https://www.last.fm/music/Bob+Marley\";&gt;Read more on Last.fm&lt;/a&gt;",
        musicBrainzId: "ed2ac1e9-d51d-4eff-a2c2-85e81abd6360",
        lastFmURL: URL(string: "https://www.last.fm/music/Bob+Marley")!,
        smallImageURL: URL(string: "https://assets.fanart.tv/preview/music/ed2ac1e9-d51d-4eff-a2c2-85e81abd6360/artistbackground/marley-bob-50976093292ea.jpg")!,
        mediumImageURL: URL(string: "https://assets.fanart.tv/fanart/music/ed2ac1e9-d51d-4eff-a2c2-85e81abd6360/artistthumb/marley-bob-509763da01576.jpg")!,
        largeImageURL: URL(string: "https://assets.fanart.tv/fanart/music/ed2ac1e9-d51d-4eff-a2c2-85e81abd6360/artistbackground/marley-bob-50976093292ea.jpg")!,
        similarArtists: [.placeholder])
}
