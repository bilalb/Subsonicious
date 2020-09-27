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
        let mediaType = NSNumber(value: MPNowPlayingInfoMediaType.audio.rawValue)
        let isLiveStream = NSNumber(value: false)

        public let title: NSString
        public let artist: NSString?
        public let artwork: MPMediaItemArtwork?

        let albumArtist: NSString?
        let albumTitle: NSString?

        let duration: NSNumber
        let queueCount: NSNumber
        let queueIndex: NSNumber
    }
}

extension NowPlayingMetadata {
    struct Dynamic {
        let rate: NSNumber
        let defaultRate: NSNumber
        let position: NSNumber

        let currentLanguageOptions = [MPNowPlayingInfoLanguageOption]()
        let availableLanguageOptionGroups = [MPNowPlayingInfoLanguageOptionGroup]()
    }
}

extension NowPlayingMetadata.Static {
    static var dummyInstance: NowPlayingMetadata.Static {
        let path = Bundle.main.path(forResource: "example.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)

        return .init(collectionIdentifier: "",
                     assetURL: url,
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
