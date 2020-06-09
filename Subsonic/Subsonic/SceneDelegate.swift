//
//  SceneDelegate.swift
//  Subsonic
//
//  Created by Bilal on 31/05/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import AVFoundation
import SubsonicKit
import SwiftUI
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var playerObserver: PlayerObserver!
    private var remoteCommandsManager: MediaPlayerRemoteCommandsManager!
    private var nowPlayingInfoManager: NowPlayingInfoManager!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let player = CombineQueuePlayer.dummyInstance

        playerObserver = PlayerObserver(player: player)
        playerObserver.listenToPlayerChanges()

        remoteCommandsManager = MediaPlayerRemoteCommandsManager(player: player)
        remoteCommandsManager.configureRemoteCommands()

        nowPlayingInfoManager = NowPlayingInfoManager(player: player)
        nowPlayingInfoManager.listenToNowPlayingInfoChanges()

        let contentView = ContentView()
            .environmentObject(player)
            .environmentObject(playerObserver)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
