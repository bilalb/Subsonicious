//
//  PlayerView.swift
//  Subsonicious
//
//  Created by Bilal on 31/05/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import AVFoundation
import SubsoniciousKit
import SwiftUI

struct PlayerView: View {

    @EnvironmentObject var player: CombineQueuePlayer
    @EnvironmentObject var playerObserver: PlayerObserver

    var body: some View {
        VStack {

            Spacer()

            ArtworkImage()

            Spacer()

            VStack(alignment: .leading) {
                Text("Title")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                Text("Artist")
                    .font(.subheadline)
                    .opacity(0.6)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)

            Spacer()

            VStack {
                Slider(value: self.$playerObserver.currentTime,
                       in: 0...self.playerObserver.duration,
                       onEditingChanged: self.sliderEditingChanged(editingStarted:))

                HStack {
                    Text("\(self.playerObserver.currentTime, formatter: .minutesSecondsFormatter)")
                        .font(.caption)
                    Spacer()
                    Text(self.remainingTimeRepresentation)
                        .font(.caption)
                }
            }

            Spacer()

            HStack {
                Spacer()
                Button(action: {}) {
                    Image(systemName: "backward.fill")
                        .asPlayerControl()
                }
                Spacer()
                Button(action: {
                    self.player.togglePlayPause()
                }) {
                    Image(systemName: self.playPauseImageName)
                        .asPlayerControl()
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "forward.fill")
                        .asPlayerControl()
                }
                Spacer()
            }

            Spacer()
        }
        .padding()
    }

    var remainingTimeRepresentation: LocalizedStringKey {
        let seconds = abs(self.playerObserver.currentTime - self.playerObserver.duration)
        return "-\(seconds, formatter: .minutesSecondsFormatter)"
    }

    var playPauseImageName: String {
        playerObserver.timeControlStatus == .playing ? "pause.fill" : "play.fill"
    }
}

// MARK: - Private Methods

private extension PlayerView {

    func minutesSecondsRepresentation(for seconds: TimeInterval) -> String {
        DateComponentsFormatter.minutesSecondsFormatter.string(from: seconds) ?? "--:--"
    }

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

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let player = CombineQueuePlayer.dummyInstance
        let playerObserver = PlayerObserver(player: player)
        let playerView = PlayerView()
            .environmentObject(player)
            .environmentObject(playerObserver)

        return playerView
    }
}

extension Image {

    func asPlayerControl() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 32, height: 32)
    }
}
