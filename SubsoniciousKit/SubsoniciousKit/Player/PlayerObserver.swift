//
//  PlayerObserver.swift
//  SubsoniciousKit
//
//  Created by Bilal on 06/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import AVFoundation
import Combine
import Foundation

public final class PlayerObserver: ObservableObject {

    public var shouldPauseTimeObserver = false

    private let player: QueuePlayer
    private var cancellables: Set<AnyCancellable> = []
    private var timeObserverToken: Any?

    @Published public private(set) var timeControlStatus: AVPlayer.TimeControlStatus?
    @Published public private(set) var duration: Double = .zero
    @Published public var currentTime: Double = .zero
    public var remainingTime: Double {
         abs(currentTime - duration)
    }

    public init(player: QueuePlayer) {
        self.player = player
    }

    public func listenToPlayerChanges() {
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
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
}
