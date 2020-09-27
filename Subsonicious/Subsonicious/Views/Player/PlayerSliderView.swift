//
//  PlayerSliderView.swift
//  Subsonicious
//
//  Created by Bilal on 14/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import FreeStreamer
import SubsoniciousKit
import SwiftUI

struct PlayerSliderView: View {

    @EnvironmentObject var player: CombineAudioController

    var body: some View {
        VStack {
            Slider(value: $player.currentTime,
                   in: 0...player.duration,
                   onEditingChanged: sliderEditingChanged(editingStarted:))

            HStack {
                Text("\(TimeInterval(player.currentTime), formatter: .minutesSecondsFormatter)")
                    .font(.caption)
                Spacer()
                Text("-\(TimeInterval(player.remainingTime), formatter: .minutesSecondsFormatter)")
                    .font(.caption)
            }
        }
    }
}

private extension PlayerSliderView {
    func sliderEditingChanged(editingStarted: Bool) {
        if !editingStarted {
            let progression = player.currentTime/player.duration
            let position = FSStreamPosition(progression)
            player.activeStream?.seek(to: position)
        }
        player.shouldPauseTimeObserver = editingStarted
    }
}

struct PlayerSliderView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerSliderView()
            .environmentObject(CombineAudioController())
    }
}
