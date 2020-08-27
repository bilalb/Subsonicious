//
//  QueuePlayer.swift
//  SubsoniciousKit
//
//  Created by Bilal on 27/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation
import MediaPlayer

public final class QueuePlayer: CombinePlayer {

    var items: [SubsonicPlayerItem] = []

    var currentItemIndex: Int? {
        didSet {
            guard let index = currentItemIndex else { return }
            let item = items[safe: index]
            let timeControlStatus = self.timeControlStatus
            replaceCurrentItem(with: item)
            if timeControlStatus == .playing {
                play()
            }
        }
    }

    var repeatType: MPRepeatType = .off {
        didSet {
            switch repeatType {
            case .off, .all:
                itemDidPlayToEndTimeSelector = #selector(skipToNext)
            case .one:
                itemDidPlayToEndTimeSelector = #selector(skipToTheStart)
            @unknown default:
                assertionFailure("Unknown MPRepeatType")
            }
        }
    }

    var shuffleType: MPShuffleType = .off

    var itemDidPlayToEndTimeSelector = #selector(skipToNext)

    public override init() {
        super.init()
    }

    public init(items: [SubsonicPlayerItem]) {
        self.items = items
        super.init(playerItem: items.first)
    }

    /// Skip to the previous song.
    /// When the current time is more than 4 seconds, skips to the start of the song.
    public func skipToPrevious() {
        let skipToPreviousDurationThreshold: Double = 4
        guard CMTimeGetSeconds(currentTime()) < skipToPreviousDurationThreshold,
              let previousItemIndex = previousItemIndex else {
            skipToTheStart()
            return
        }
        currentItemIndex = previousItemIndex
    }

    @objc public func skipToNext() {
        guard let nextItemIndex = nextItemIndex else {
            stop()
            return
        }
        currentItemIndex = nextItemIndex
    }

    func stop() {
        currentItemIndex = 0
        pause()
    }

    public override func replaceCurrentItem(with item: AVPlayerItem?) {
        super.replaceCurrentItem(with: item)
        resetObservers()
        skipToTheStart()
    }

    public func replaceCurrentSongs(with songs: [Song]) throws {
        items = try songs.map { song -> SubsonicPlayerItem in
            let manager: Manager<Song> = .init(endpoint: .stream(mediaFileId: song.id))
            let url = try manager.url()
            let asset = AVURLAsset(url: url)
            return SubsonicPlayerItem(id: song.id, asset: asset)
        }
    }

    public func playSong(with id: String) {
        currentItemIndex = items.firstIndex { $0.id == id }
        if timeControlStatus != .playing {
            play()
        }
    }
}

// MARK: - Miscellaneous Private Methods
private extension QueuePlayer {
    @objc func skipToTheStart() {
        let time = CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        seek(to: time)
    }
}

// MARK: - Item Indexes
private extension QueuePlayer {
    var previousItemIndex: Int? {
        if let currentItemIndex = currentItemIndex {
            return currentItemIndex - 1
        }
        return nil
    }

    var nextItemIndex: Int? {
        switch shuffleType {
        case .off:
            let isLastItem = currentItemIndex == items.indices.last
            if repeatType == .all, isLastItem {
                return 0
            } else if let currentItemIndex = currentItemIndex {
                return currentItemIndex + 1
            } else {
                return nil
            }
        case .items, .collections:
            // TODO: implement something else for .collections
            return .random(in: 0 ..< items.count)
        @unknown default:
            assertionFailure("Unknown MPShuffleType")
            return nil
        }
    }
}

// MARK: - Observers
private extension QueuePlayer {
    func resetObservers() {
        removeObservers()
        addObservers()
    }

    func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: itemDidPlayToEndTimeSelector,
            name: .AVPlayerItemDidPlayToEndTime,
            object: currentItem)
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: currentItem)
    }
}

// MARK: -
public extension QueuePlayer {
    static var placeholder: QueuePlayer = .init(items: [.placeholder])
}
