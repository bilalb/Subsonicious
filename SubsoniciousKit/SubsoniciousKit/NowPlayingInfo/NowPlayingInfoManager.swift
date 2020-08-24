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
    private var coverArtManager: CoverArtManager?
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
                self?.prepareStaticMetadataUpdate()
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

    func prepareStaticMetadataUpdate() {
        if let item = player.currentItem as? SubsonicPlayerItem {
            do {
                try downloadArtwork(with: item.subsonicId)
            } catch {
                updateStaticMetadata()
                preconditionFailure(error.localizedDescription)
            }
        } else {
            updateStaticMetadata()
        }
    }

    func downloadArtwork(with id: String) throws {
        let coverArtManager = CoverArtManager(endpoint: .coverArt(id: id))
        self.coverArtManager = coverArtManager
        try coverArtManager.fetch()
        bindCoverArtData()
    }

    func bindCoverArtData() {
        coverArtManager?.$data
            .compactMap { $0 }
            .map { UIImage(data: $0) }
            .sink { [weak self] image in
                self?.updateStaticMetadata(with: image)
            }
            .store(in: &cancellables)
    }

    func updateStaticMetadata(with artworkImage: UIImage? = nil) {
        guard let currentItem = player.currentItem else { return }
        let commonMetadata = currentItem.asset.commonMetadata
        staticMetadata = self.staticMetadata(
            for: commonMetadata,
            playerItem: currentItem,
            artworkImage: artworkImage)
    }

    func staticMetadata(
        for metadata: [AVMetadataItem],
        playerItem: AVPlayerItem,
        artworkSize: CGSize = .init(width: 50, height: 50),
        artworkImage: UIImage? = nil) -> NowPlayingMetadata.Static {

        func firstMetadataItem(filteredByIdentifier identifier: AVMetadataIdentifier) -> AVMetadataItem? {
            AVMetadataItem.metadataItems(
                from: metadata,
                filteredByIdentifier: identifier)
                .first
        }

        let mediaType = MPNowPlayingInfoMediaType(
            rawValue: UInt(
                truncating: firstMetadataItem(filteredByIdentifier: .id3MetadataMediaType)?
                    .numberValue ?? 0)) ?? .audio

        let title = firstMetadataItem(filteredByIdentifier: .commonIdentifierTitle)?.stringValue ?? ""

        let artist = firstMetadataItem(filteredByIdentifier: .commonIdentifierArtist)?.stringValue

        var artwork: MPMediaItemArtwork?
        if let artworkImage = artworkImage {
            artwork = MPMediaItemArtwork(boundsSize: artworkSize) { _ -> UIImage in
                // TODO: provide image based on size
                artworkImage
            }
        }

        let albumArtist = firstMetadataItem(filteredByIdentifier: .iTunesMetadataAlbumArtist)?.stringValue

        let albumName = firstMetadataItem(filteredByIdentifier: .commonIdentifierAlbumName)?.stringValue

        return NowPlayingMetadata.Static(
            collectionIdentifier: "",
            assetURL: (playerItem.asset as? AVURLAsset)?.url,
            mediaType: mediaType,
            isLiveStream: false,
            title: title,
            artist: artist,
            artwork: artwork,
            albumArtist: albumArtist,
            albumTitle: albumName,
            duration: playerItem.duration.seconds,
            queueCount: player.items().count ,
            queueIndex: player.items().firstIndex { $0 == playerItem } ?? 0)
    }
}
