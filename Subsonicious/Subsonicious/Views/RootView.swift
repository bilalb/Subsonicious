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
        RootView(status: .authenticating(.automatic),
                 authenticate: {})
    }
}

extension RootView: Equatable {
    static func == (lhs: RootView, rhs: RootView) -> Bool {
        let statusDidNotChange = lhs.status == rhs.status
        var changedManually: Bool {
            switch rhs.status {
            case .authenticating(let mode):
                return mode != AuthenticationMode.automatic
            default:
                return false
            }
        }
        return statusDidNotChange || changedManually
    }
}
