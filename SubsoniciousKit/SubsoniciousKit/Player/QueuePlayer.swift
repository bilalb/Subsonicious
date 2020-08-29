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
              let previousItemIndex = previousItemIndex,
              currentItemIndex != previousItemIndex else {
            skipToTheStart()
            return
        }
        currentItemIndex = previousItemIndex
    }

    public func skipToNext() {
        guard let nextItemIndex = nextItemIndex,
              currentItemIndex != nextItemIndex else {
            stop()
            return
        }
        currentItemIndex = nextItemIndex
    }

    func stop() {
        pause()
        if currentItemIndex != 0 {
            currentItemIndex = 0
        }
        skipToTheStart()
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
    func skipToTheStart() {
        seek(to: .zero)
    }
}

// MARK: - Item Indexes
private extension QueuePlayer {
    var previousItemIndex: Int? {
        if let currentItemIndex = currentItemIndex {
            return max(0, currentItemIndex - 1)
        }
        return nil
    }

    var nextItemIndex: Int? {
        if let currentItemIndex = currentItemIndex {
            return min(currentItemIndex + 1, items.count - 1)
        }
        return nil
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
            selector: #selector(itemDidPlayToEndTime),
            name: .AVPlayerItemDidPlayToEndTime,
            object: currentItem)
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: currentItem)
    }

    @objc func itemDidPlayToEndTime() {
        skipToNext()
    }
}

// MARK: -
public extension QueuePlayer {
    static var placeholder: QueuePlayer = .init(items: [.placeholder])
}
