//
//  PlayerSliderView.swift
//  Subsonicious
//
//  Created by Bilal on 14/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import AVFoundation
import SubsoniciousKit
import SwiftUI

struct PlayerSliderView: View {

    @EnvironmentObject var player: QueuePlayer
    @EnvironmentObject var playerObserver: PlayerObserver

    var body: some View {
        VStack {
            Slider(value: $playerObserver.currentTime,
                   in: 0...playerObserver.duration,
                   onEditingChanged: sliderEditingChanged(editingStarted:))

            HStack {
                Text("\(playerObserver.currentTime, formatter: .minutesSecondsFormatter)")
                    .font(.caption)
                Spacer()
                Text("-\(playerObserver.remainingTime, formatter: .minutesSecondsFormatter)")
                    .font(.caption)
            }
        }
    }
}

private extension PlayerSliderView {
    func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            playerObserver.shouldPauseTimeObserver = true
        } else {
            let targetTime = CMTime(seconds: playerObserver.currentTime,
                                    preferredTimescale: CMTimeScale(NSEC_PER_SEC))

            player.seek(to: targetTime)
        }
    }
}

struct PlayerSliderView_Previews: PreviewProvider {
    static var previews: some View {
        let player = QueuePlayer.placeholder
        let playerObserver = PlayerObserver(player: player)
        let playerSliderView = PlayerSliderView()
            .environmentObject(player)
            .environmentObject(playerObserver)

        return playerSliderView
    }
}
