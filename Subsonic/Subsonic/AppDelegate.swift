//
//  AppDelegate.swift
//  Subsonic
//
//  Created by Bilal on 31/05/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SubsonicKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let audioSessionManager = AudioSessionManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        audioSessionManager.configureAudioSession()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
