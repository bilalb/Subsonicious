//
//  NowPlayingInfoManager.swift
//  SubsonicKit
//
//  Created by Bilal on 06/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Combine
import Foundation
import MediaPlayer

public final class NowPlayingInfoManager {

    private let player: CombineQueuePlayer!
    private let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
    private var cancellables = [AnyCancellable]()

    init(player: CombineQueuePlayer) {
        self.player = player
    }

    public func listenToNowPlayingInfoChanges() {
        player.dynamicMetadataChangesPublisher
            .sink { [weak self] _ in
                self?.updateDynamicMetadata()
        }
        .store(in: &cancellables)

        player.staticMetadataChangesPublisher
            .sink { [weak self] _ in
                self?.nowPlayingInfoCenter.setStaticMetadata(.dummyInstance)
        }
        .store(in: &cancellables)
    }
}

private extension NowPlayingInfoManager {

    func updateDynamicMetadata() {
        let metadata = NowPlayingMetadata.Dynamic(rate: player.rate,
                                                  defaultRate: 1.0,
                                                  position: NSNumber(value: CMTimeGetSeconds(player.currentTime())),
                                                  currentLanguageOptions: [],
                                                  availableLanguageOptionGroups: [])

        nowPlayingInfoCenter.setDynamicMetadata(metadata)
    }
}

extension MPNowPlayingInfoCenter {

    func setStaticMetadata(_ metadata: NowPlayingMetadata.Static) {
        var nowPlayingInfo = [String: Any]()

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
