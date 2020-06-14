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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        ManagerProvider.shared.playerObserver.listenToPlayerChanges()
        ManagerProvider.shared.remoteCommandsManager.configureRemoteCommands()
        ManagerProvider.shared.nowPlayingInfoManager.listenToNowPlayingInfoChanges()

        let contentView = ContentView()
            .environmentObject(ManagerProvider.shared.player)
            .environmentObject(ManagerProvider.shared.playerObserver)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
