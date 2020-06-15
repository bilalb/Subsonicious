//
//  AVPlayer+Extensions.swift
//  SubsoniciousKit
//
//  Created by Bilal on 12/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation
import MediaPlayer

extension AVPlayer {

    public func togglePlayPause() {
        switch timeControlStatus {
        case .paused:
            switch status {
            case .readyToPlay:
                play()
            case .failed:
                preconditionFailure("error: \(String(describing: error?.localizedDescription))")
            default:
                preconditionFailure("status: \(String(describing: status))")
            }
        case .playing:
            pause()
        case .waitingToPlayAtSpecifiedRate:
            preconditionFailure("reasonForWaitingToPlay: \(String(describing: reasonForWaitingToPlay))")
        default:
            preconditionFailure("Unknown AVPlayer.TimeControlStatus")
        }
    }
}
