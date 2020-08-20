//
//  MPNowPlayingInfoCenter.swift
//  SubsoniciousKit
//
//  Created by Bilal on 20/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation
import MediaPlayer

extension MPNowPlayingInfoCenter {
    func setStaticMetadata(_ metadata: NowPlayingMetadata.Static) {
        var nowPlayingInfo = self.nowPlayingInfo ?? [String: Any]()

        //        MPNowPlayingInfoPropertyCurrentPlaybackDate
        //        MPNowPlayingInfoPropertyExternalContentIdentifier
        //        MPNowPlayingInfoPropertyExternalUserProfileIdentifier
        //        MPNowPlayingInfoPropertyPlaybackProgress
        //        MPNowPlayingInfoPropertyServiceIdentifier
        nowPlayingInfo[MPNowPlayingInfoCollectionIdentifier] = metadata.collectionIdentifier
        nowPlayingInfo[MPNowPlayingInfoPropertyAssetURL] = metadata.assetURL
        nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = metadata.mediaType.rawValue
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = metadata.isLiveStream
        nowPlayingInfo[MPMediaItemPropertyTitle] = metadata.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = metadata.artist
        nowPlayingInfo[MPMediaItemPropertyArtwork] = metadata.artwork
        nowPlayingInfo[MPMediaItemPropertyAlbumArtist] = metadata.albumArtist
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = metadata.albumTitle
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = metadata.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackQueueCount] = metadata.queueCount
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackQueueIndex] = metadata.queueIndex

        self.nowPlayingInfo = nowPlayingInfo
    }

    func setDynamicMetadata(_ metadata: NowPlayingMetadata.Dynamic) {
        var nowPlayingInfo = self.nowPlayingInfo ?? [String: Any]()

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = metadata.position
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = metadata.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = metadata.defaultRate
        nowPlayingInfo[MPNowPlayingInfoPropertyCurrentLanguageOptions] = metadata.currentLanguageOptions
        nowPlayingInfo[MPNowPlayingInfoPropertyAvailableLanguageOptions] = metadata.availableLanguageOptionGroups

        self.nowPlayingInfo = nowPlayingInfo
    }
}
