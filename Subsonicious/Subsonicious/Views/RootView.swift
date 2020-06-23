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

    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var player: CombineQueuePlayer
    @EnvironmentObject var playerObserver: PlayerObserver

    var body: some View {
        Group {
            if authentication.isConnected {
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

class Authentication: ObservableObject {
    @Published var isConnected = false
}
