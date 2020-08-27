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

    @EnvironmentObject var player: QueuePlayer
    @EnvironmentObject var playerObserver: PlayerObserver

    var body: some View {
        HStack {
            Spacer()

            Button(action: {
                player.skipToPrevious()
            }) {
                PlayerControlImage(systemName: "backward.fill")
            }

            Spacer()

            Button(action: {
                player.togglePlayPause()
            }) {
                PlayerControlImage(systemName: playPauseImageName)
            }

            Spacer()

            Button(action: {
                player.skipToNext()
            }) {
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
        let player = QueuePlayer.placeholder
        let playerObserver = PlayerObserver(player: player)
        let playerControlsView = PlayerControlsView()
            .environmentObject(player)
            .environmentObject(playerObserver)

        return playerControlsView
    }
}
