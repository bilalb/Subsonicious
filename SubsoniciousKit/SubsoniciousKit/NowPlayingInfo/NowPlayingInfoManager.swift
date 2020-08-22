//
//  NowPlayingInfoManager.swift
//  SubsoniciousKit
//
//  Created by Bilal on 06/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Combine
import Foundation
import MediaPlayer

public final class NowPlayingInfoManager: ObservableObject {

    private let player: CombineQueuePlayer
    private let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
    private var cancellables: Set<AnyCancellable> = []
    private var dynamicMetadata: NowPlayingMetadata.Dynamic? {
        didSet {
            guard let dynamicMetadata = dynamicMetadata else { return }
            nowPlayingInfoCenter.setDynamicMetadata(dynamicMetadata)
        }
    }
    @Published public private(set) var staticMetadata: NowPlayingMetadata.Static? {
        didSet {
            guard let staticMetadata = staticMetadata else { return }
            nowPlayingInfoCenter.setStaticMetadata(staticMetadata)
        }
    }

    public init(player: CombineQueuePlayer) {
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
                self?.updateStaticMetadata()
            }
            .store(in: &cancellables)
    }
}

private extension NowPlayingInfoManager {

    func updateDynamicMetadata() {
        dynamicMetadata = NowPlayingMetadata.Dynamic(
            rate: player.rate,
            defaultRate: 1.0,
            position: NSNumber(value: CMTimeGetSeconds(player.currentTime())),
            currentLanguageOptions: [],
            availableLanguageOptionGroups: [])
    }

    func updateStaticMetadata() {
        guard let currentItem = player.currentItem else { return }
        let asset = currentItem.asset
        let commonMetadata = asset.commonMetadata

        let mediaType = MPNowPlayingInfoMediaType(
            rawValue: UInt(
                truncating: AVMetadataItem.metadataItems(
                    from: commonMetadata,
                    filteredByIdentifier: .id3MetadataMediaType)
                    .first?
                    .numberValue ?? 0)) ?? .audio

        let title = AVMetadataItem.metadataItems(
            from: commonMetadata,
            filteredByIdentifier: .commonIdentifierTitle)
            .first?.stringValue ?? ""

        let artist = AVMetadataItem.metadataItems(
            from: commonMetadata,
            filteredByIdentifier: .commonIdentifierArtist)
            .first?.stringValue

        let albumArtist = AVMetadataItem.metadataItems(
            from: commonMetadata,
            filteredByIdentifier: .iTunesMetadataAlbumArtist)
            .first?.stringValue

        let albumName = AVMetadataItem.metadataItems(
            from: commonMetadata,
            filteredByIdentifier: .commonIdentifierAlbumName)
            .first?.stringValue

        staticMetadata = NowPlayingMetadata.Static(
            collectionIdentifier: "",
            assetURL: (asset as? AVURLAsset)?.url,
            mediaType: mediaType,
            isLiveStream: false,
            title: title,
            artist: artist,
            artwork: nil,
            albumArtist: albumArtist,
            albumTitle: albumName,
            duration: currentItem.duration.seconds,
            queueCount: player.items().count ,
            queueIndex: player.items().firstIndex { $0 == currentItem } ?? 0)
    }
}
