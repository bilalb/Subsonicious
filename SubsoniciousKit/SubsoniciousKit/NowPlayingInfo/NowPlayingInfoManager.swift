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

    private let player: CombineAudioController
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

    public init(player: CombineAudioController) {
        self.player = player
        bindPlayerState()
    }
}

private extension NowPlayingInfoManager {

    func bindPlayerState() {
        player.$state
            .sink { [weak self] _ in
                self?.updateDynamicMetadata()
                self?.prepareStaticMetadataUpdate()
            }
            .store(in: &cancellables)
    }

    func updateDynamicMetadata() {
        // FIXME: (player.activeStream?.value(forKey: "_private") as? NSObject)?.value(forKey: "_url")
        dynamicMetadata = NowPlayingMetadata.Dynamic(
            rate: NSNumber(value: Double(1.0)),
            defaultRate: NSNumber(value: Double(1.0)),
            position: NSNumber(value: Double(player.currentTime)))
    }

    func prepareStaticMetadataUpdate() {
        if let item = player.currentPlaylistItem as? SubsonicPlaylistItem {
            do {
                try downloadArtwork(with: item.song.id)
            } catch {
                try? updateStaticMetadata()
                preconditionFailure(error.localizedDescription)
            }
        } else {
            try? updateStaticMetadata()
        }
    }

    func downloadArtwork(with id: String) throws {
        coverArtManager = CoverArtManager(endpoint: .coverArt(id: id))
        try coverArtManager?.fetch()
        bindCoverArtData()
    }

    func bindCoverArtData() {
        coverArtManager?.$data
            .compactMap { $0 }
            .map { UIImage(data: $0) }
            .sink { [weak self] image in
                try? self?.updateStaticMetadata(with: image)
            }
            .store(in: &cancellables)
    }

    func updateStaticMetadata(with artworkImage: UIImage? = nil) throws {
        guard let item = player.currentPlaylistItem as? SubsonicPlaylistItem else { return }
        staticMetadata = try self.staticMetadata(for: item.song, artworkImage: artworkImage)
    }

    func staticMetadata(
        for song: Song,
        artworkSize: CGSize = .init(width: 50, height: 50),
        artworkImage: UIImage? = nil) throws -> NowPlayingMetadata.Static {
        let manager: Manager<Song> = .init(endpoint: .stream(mediaFileId: song.id))

        var artwork: MPMediaItemArtwork?
        if let artworkImage = artworkImage {
            artwork = MPMediaItemArtwork(boundsSize: artworkSize) { _ -> UIImage in
                // TODO: provide image based on size
                artworkImage
            }
        }

        let queueIndex = player.value(forKey: "currentPlaylistItemIndex") as? UInt ?? 0

        return NowPlayingMetadata.Static(
            collectionIdentifier: "",
            assetURL: try manager.url(),
            title: NSString(string: song.title),
            artist: NSString(string: song.artistName),
            artwork: artwork,
            albumArtist: NSString(string: song.artistName),
            albumTitle: NSString(string: song.albumTitle),
            duration: NSNumber(value: TimeInterval(song.duration)),
            queueCount: NSNumber(value: UInt(player.countOfItems())),
            queueIndex: NSNumber(value: queueIndex))
    }
}
