//
//  CombineAudioController.swift
//  SubsoniciousKit
//
//  Created by Bilal on 18/10/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Combine
import Foundation
import FreeStreamer

public final class CombineAudioController: FSAudioController, ObservableObject {

    @Published public private(set) var state: FSAudioStreamState = .fsAudioStreamStopped

    @Published public private(set) var duration: Float = .zero
    @Published public var currentTime: Float = .zero
    public var remainingTime: Float { abs(currentTime - duration) }
    public var shouldPauseTimeObserver = false

    private var cancellables: Set<AnyCancellable> = []
    private var timer: Timer?

    public override init() {
        super.init()

        #if DEBUG
        enableDebugOutput = true
        #endif

        addPeriodicTimeObserver()

        bindState()
    }

    deinit {
        removePeriodicTimeObserver()
    }

    public func replaceCurrentSongs(with songs: [Song]) throws {
        removeAllItems()

        try songs.forEach {
            let manager: Manager<Song> = .init(endpoint: .stream(mediaFileId: $0.id))
            let item = SubsonicPlaylistItem(song: $0, title: $0.title, url: try manager.url())
            add(item)
        }
    }

    /// Plays the previous item of multiple-item playlist.
    /// When the current time is more than 4 seconds, skips to the start of the song.
    public override func playPreviousItem() {
        let skipToPreviousDurationThreshold: Float = 4
        if currentTime < skipToPreviousDurationThreshold && hasPreviousItem() {
            super.playPreviousItem()
        } else {
            skipToTheStart()
        }
    }
}

private extension CombineAudioController {
    func bindState() {
        $state
            .sink { [weak self] _ in
                self?.updateDuration()
                self?.updateCurrentTime()
            }
            .store(in: &cancellables)

        onStateChange = { [weak self] state in
            self?.state = state
        }
    }

    func removeAllItems() {
        stop()

        while countOfItems() > 0 {
            removeItem(at: 0)
        }
    }

    func updateDuration() {
        duration = activeStream?.duration.playbackTimeInSeconds ?? 0
    }

    func skipToTheStart() {
        let position = FSStreamPosition(0)
        activeStream?.seek(to: position) // cannot seek to the start when the state is not playing
    }
}

private extension CombineAudioController {
    func addPeriodicTimeObserver() {
        timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(updateCurrentTime),
            userInfo: nil,
            repeats: true)
    }

    @objc func updateCurrentTime() {
        guard !shouldPauseTimeObserver else { return }
        currentTime = activeStream?.currentTimePlayed.playbackTimeInSeconds ?? 0
    }

    func removePeriodicTimeObserver() {
        timer?.invalidate()
        timer = nil
    }
}
