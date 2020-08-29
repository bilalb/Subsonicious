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

    private let player: QueuePlayer
    private var cancellables: Set<AnyCancellable> = []
    private var timeObserver: Any?

    @Published public var shouldPauseTimeObserver = false
    @Published public var currentTime: Double = .zero
    @Published public private(set) var timeControlStatus: AVPlayer.TimeControlStatus?
    @Published public private(set) var duration: Double = .zero
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
            .map { $0 }
            .assign(to: \.shouldPauseTimeObserver, on: self)
            .store(in: &cancellables)

        $shouldPauseTimeObserver
            .filter { [weak self] _ in self?.player.timeControlStatus == .paused }
            .filter { !$0 }
            .sink { [weak self] _ in self?.currentTime = self?.player.currentTime().seconds ?? 0 }
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

        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard self?.shouldPauseTimeObserver == false else { return }
            self?.currentTime = time.seconds
        }
    }

    func removePeriodicTimeObserver() {
        guard let observer = timeObserver else { return }
        player.removeTimeObserver(observer)
        timeObserver = nil
    }
}
