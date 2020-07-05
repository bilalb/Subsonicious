//
//  RootView.swift
//  Subsonicious
//
//  Created by Bilal on 15/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SubsoniciousKit
import SwiftUI

struct RootView: View {

    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var player: CombineQueuePlayer
    @EnvironmentObject var playerObserver: PlayerObserver

    var body: some View {
        Group {
            if case .success(let response) = self.authenticationManager.result, response.status == .success {
                ContentView()
                    .environmentObject(player)
                    .environmentObject(playerObserver)
            } else {
                LoginView()
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
