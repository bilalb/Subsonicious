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
    @State private var isLoggedIn = false

    var body: some View {
        Group {
            if isLoggedIn {
                ContentView()
                    .environmentObject(player)
                    .environmentObject(playerObserver)
            } else {
                LoginView()
            }
        }
        .onAppear {
            do {
                isLoggedIn = try authenticationManager.authenticateWithPersistedServer()
            } catch {
                debugPrint(error)
            }
        }
        .onReceive(authenticationManager.$result) { result in
            if case .success(let response) = result, response.status == .success {
                withAnimation {
                    isLoggedIn = true
                }
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
