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

    @EnvironmentObject var player: CombineQueuePlayer
    @EnvironmentObject var playerObserver: PlayerObserver
    var status: AuthenticationStatus
    var authenticate: () -> Void

    var body: some View {
        Group {
            switch status {
            case .authenticated:
                ContentView()
                    .environmentObject(player)
                    .environmentObject(playerObserver)
            case .authenticating:
                ProgressView("authenticating")
            case .notAuthenticated:
                LoginView()
                    .animation(nil)
            }
        }
        .onAppear(perform: authenticate)
        .animation(.default)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(status: .authenticating(withPersistedServer: false),
                 authenticate: {})
    }
}

extension RootView: Equatable {
    static func == (lhs: RootView, rhs: RootView) -> Bool {
        let statusDidNotChange = lhs.status == rhs.status
        var changedByUser: Bool {
            switch rhs.status {
            case .authenticating(let persistedServerExists):
                return !persistedServerExists
            default:
                return false
            }
        }
        return statusDidNotChange || changedByUser
    }
}
