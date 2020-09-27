//
//  SceneDelegate.swift
//  Subsonicious
//
//  Created by Bilal on 31/05/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SubsoniciousKit
import SwiftUI
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var remoteCommandsManager: MediaPlayerRemoteCommandsManager!
    private var nowPlayingInfoManager: NowPlayingInfoManager!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let player = CombineAudioController()

        remoteCommandsManager = MediaPlayerRemoteCommandsManager(player: player)

        nowPlayingInfoManager = NowPlayingInfoManager(player: player)

        var serverPerstistenceManager: ServerPersistenceManager!
        do {
            serverPerstistenceManager = try ServerPersistenceManager()
        } catch {
            preconditionFailure(error.localizedDescription)
        }

        let authenticationManager = AuthenticationManager(
            endpoint: .authentication,
            serverPerstistenceManager: serverPerstistenceManager)

        let rootContainerView = RootContainerView()
            .environmentObject(authenticationManager)
            .environmentObject(player)
            .environmentObject(nowPlayingInfoManager)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: rootContainerView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
