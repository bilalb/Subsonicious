//
//  PlayerObserver.swift
//  SubsonicKit
//
//  Created by Bilal on 06/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import AVFoundation
import Combine
import Foundation

public final class PlayerObserver: ObservableObject {

    public let player: AVQueuePlayer!
    public var shouldPauseTimeObserver = false

    private var cancellables = [AnyCancellable]()
    private var timeObserverToken: Any?

    @Published public var timeControlStatus: AVPlayer.TimeControlStatus?
    @Published public var duration: Double = .zero
    @Published public var currentTime: Double = .zero

    init(player: AVQueuePlayer) {
        self.player = player

        player.publisher(for: \.timeControlStatus)
            .map { $0 }
            .assign(to: \.timeControlStatus, on: self)
            .store(in: &cancellables)

        player.publisher(for: \.currentItem?.duration)
            .filter { $0?.isNumeric == true }
            .compactMap { $0?.seconds }
            .assign(to: \.duration, on: self)
            .store(in: &cancellables)

        player.seeking
            .map { !$0 }
            .assign(to: \.shouldPauseTimeObserver, on: self)
            .store(in: &cancellables)

        addPeriodicTimeObserver()
    }

    deinit {
        removePeriodicTimeObserver()
    }
}

public extension PlayerObserver {

    static var dummyInstance: PlayerObserver {
        let path = Bundle.main.path(forResource: "example.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        let playerItem = AVPlayerItem(url: url)
        let player = AVQueuePlayer(items: [playerItem])
        player.actionAtItemEnd = .advance
        return PlayerObserver(player: player)
    }
}

// MARK: - Private Methods

private extension PlayerObserver {

    func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 0.5,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))

        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard self?.shouldPauseTimeObserver == false else { return }
            self?.currentTime = time.seconds
        }
    }

    func removePeriodicTimeObserver() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
}
