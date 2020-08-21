//
//  NowPlayingMetadata.swift
//  SubsoniciousKit
//
//  Created by Bilal on 06/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation
import MediaPlayer
import UIKit

public enum NowPlayingMetadata { }

public extension NowPlayingMetadata {
    struct Static {
        let collectionIdentifier: String
        let assetURL: URL?
        let mediaType: MPNowPlayingInfoMediaType
        let isLiveStream: Bool

        public let title: String
        public let artist: String?
        public let artwork: MPMediaItemArtwork?

        let albumArtist: String?
        let albumTitle: String?

        let duration: TimeInterval
        let queueCount: Int
        let queueIndex: Int
    }
}

extension NowPlayingMetadata {
    struct Dynamic {
        let rate: Float
        let defaultRate: Float
        let position: NSNumber

        let currentLanguageOptions: [MPNowPlayingInfoLanguageOption]
        let availableLanguageOptionGroups: [MPNowPlayingInfoLanguageOptionGroup]
    }
}

extension NowPlayingMetadata.Static {
    static var dummyInstance: NowPlayingMetadata.Static {
        let path = Bundle.main.path(forResource: "example.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)

        return .init(collectionIdentifier: "",
                     assetURL: url,
                     mediaType: .audio,
                     isLiveStream: false,
                     title: "Corovon",
                     artist: "Metropolitan Jazz Affair",
                     artwork: nil,
                     albumArtist: "Metropolitan Jazz Affair",
                     albumTitle: "Mja",
                     duration: 272,
                     queueCount: 1,
                     queueIndex: 0)
    }
}
