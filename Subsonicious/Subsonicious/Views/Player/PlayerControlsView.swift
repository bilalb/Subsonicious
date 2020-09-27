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

    @EnvironmentObject var player: CombineAudioController

    var body: some View {
        HStack {
            Spacer()

            Button(action: {
                player.playPreviousItem()
            }) {
                PlayerControlImage(systemName: "backward.fill")
            }

            Spacer()

            Button(action: {
                player.pause()
            }) {
                PlayerControlImage(systemName: playPauseImageName)
            }

            Spacer()

            Button(action: {
                player.playNextItem()
            }) {
                PlayerControlImage(systemName: "forward.fill")
            }

            Spacer()
        }
    }
}

private extension PlayerControlsView {
    var playPauseImageName: String {
        player.state == .fsAudioStreamPlaying ? "pause.fill" : "play.fill"
    }
}

struct PlayerControlsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControlsView()
            .environmentObject(CombineAudioController())
    }
}
