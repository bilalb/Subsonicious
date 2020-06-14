//
//  PlayerControlsView.swift
//  Subsonicious
//
//  Created by Bilal on 14/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SubsoniciousKit
import SwiftUI

struct PlayerControlsView: View {

    @EnvironmentObject var player: CombineQueuePlayer
    @EnvironmentObject var playerObserver: PlayerObserver

    var body: some View {
        HStack {
            Spacer()

            Button(action: {}) {
                PlayerControlImage(systemName: "backward.fill")
            }

            Spacer()

            Button(action: {
                self.player.togglePlayPause()
            }) {
                PlayerControlImage(systemName: self.playPauseImageName)
            }

            Spacer()

            Button(action: {}) {
                PlayerControlImage(systemName: "forward.fill")
            }

            Spacer()
        }
    }
}

private extension PlayerControlsView {
    var playPauseImageName: String {
        playerObserver.timeControlStatus == .playing ? "pause.fill" : "play.fill"
    }
}

struct PlayerControlsView_Previews: PreviewProvider {
    static var previews: some View {
        let player = CombineQueuePlayer.dummyInstance
        let playerObserver = PlayerObserver(player: player)
        let playerControlsView = PlayerControlsView()
            .environmentObject(player)
            .environmentObject(playerObserver)

        return playerControlsView
    }
}
