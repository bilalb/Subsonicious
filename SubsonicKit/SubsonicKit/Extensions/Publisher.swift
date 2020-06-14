//
//  Publisher.swift
//  SubsonicKit
//
//  Created by Bilal on 14/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Combine
import Foundation

extension Publisher {
    func eraseToAnyVoidPublisher() -> AnyPublisher<(), Self.Failure> {
        map { _ in () }
            .eraseToAnyPublisher()
    }
}

extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
        sink { [weak root] in
            root?[keyPath: keyPath] = $0
        }
    }
}

public protocol ManagerProviding {

    var player: CombineQueuePlayer! { get }
    var audioSessionManager: AudioSessionManager! { get }
    var playerObserver: PlayerObserver! { get }
    var remoteCommandsManager: MediaPlayerRemoteCommandsManager! { get }
    var nowPlayingInfoManager: NowPlayingInfoManager! { get }
}

public class ManagerProvider: ManagerProviding {

    public static var shared = ManagerProvider()

    public var player: CombineQueuePlayer!
    public var audioSessionManager: AudioSessionManager!
    public var playerObserver: PlayerObserver!
    public var remoteCommandsManager: MediaPlayerRemoteCommandsManager!
    public var nowPlayingInfoManager: NowPlayingInfoManager!

    init() {
        player = CombineQueuePlayer.dummyInstance
        audioSessionManager = AudioSessionManager()
        playerObserver = PlayerObserver(player: player)
        remoteCommandsManager = MediaPlayerRemoteCommandsManager(player: player)
        nowPlayingInfoManager = NowPlayingInfoManager(player: player)
    }
}
