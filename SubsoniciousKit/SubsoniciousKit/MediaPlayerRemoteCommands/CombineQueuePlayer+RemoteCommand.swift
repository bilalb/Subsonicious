//
//  CombineQueuePlayer+RemoteCommand.swift
//  SubsoniciousKit
//
//  Created by Bilal on 07/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation
import MediaPlayer

// MARK: - Playback Commands Handlers

extension CombineQueuePlayer {

    var pauseCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { [weak self] _ in
            switch self?.timeControlStatus {
            case .paused:
                preconditionFailure("Tried to pause the player which is already paused")
            case .playing:
                self?.pause()
                return .success
            case .waitingToPlayAtSpecifiedRate:
                preconditionFailure("reasonForWaitingToPlay: \(String(describing: self?.reasonForWaitingToPlay))")
            default:
                preconditionFailure("Unknown AVPlayer.TimeControlStatus: \(String(describing: self?.timeControlStatus))")
            }
        }
    }

    var playCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { [weak self] _ in
            switch self?.timeControlStatus {
            case .paused:
                switch self?.status {
                case .readyToPlay:
                    self?.play()
                    return .success
                case .failed:
                    preconditionFailure("error: \(String(describing: self?.error?.localizedDescription))")
                default:
                    preconditionFailure("status: \(String(describing: self?.status))")
                }
            case .playing:
                preconditionFailure("Tried to play the player which is already playing")
            case .waitingToPlayAtSpecifiedRate:
                preconditionFailure("reasonForWaitingToPlay: \(String(describing: self?.reasonForWaitingToPlay))")
            default:
                preconditionFailure("Unknown AVPlayer.TimeControlStatus: \(String(describing: self?.timeControlStatus))")
            }
        }
    }

    var stopCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { [weak self] _ in
            self?.pause()
            self?.removeAllItems()
            return .success
        }
    }

    var togglePlayPauseCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }
    }
}

// MARK: - Between Tracks Navigation Commands Handlers

extension CombineQueuePlayer {

    var nextTrackCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { [weak self] _ in
            self?.advanceToNextItem()
            return .success
        }
    }

    var previousTrackCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { _ in
            // TODO: to implement when the player will have more than one track
            return .commandFailed
        }
    }

    var changeRepeatModeCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { _ in
            // TODO: to implement when the player will have more than one track
            // set remoteCommandCenter.changeRepeatModeCommand.currentRepeatType
            return .commandFailed
        }
    }

    var changeShuffleModeCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { _ in
            // TODO: to implement when the player will have more than one track
            // Set remoteCommandCenter.changeShuffleModeCommand.currentShuffleType
            return .commandFailed
        }
    }
}

// MARK: - Inner Track Navigation Commands Handlers

extension CombineQueuePlayer {

    var changePlaybackRateCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { [weak self] event in
            guard let event = event as? MPChangePlaybackRateCommandEvent else { return .commandFailed }
            self?.rate = event.playbackRate
            return .success
        }
    }

    var seekBackwardCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { _ in
            // TODO: to implement
            return .commandFailed
        }
    }

    var seekForwardCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { _ in
            // TODO: to implement
            return .commandFailed
        }
    }

    var skipBackwardCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { [weak self] event in
            guard let event = event as? MPSkipIntervalCommandEvent else { return .commandFailed }
            self?.skip(.backward, interval: event.interval)
            return .success
        }
    }

    var skipForwardCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { [weak self] event in
            guard let event = event as? MPSkipIntervalCommandEvent else { return .commandFailed }
            self?.skip(.forward, interval: event.interval)
            return .success
        }
    }

    var changePlaybackPositionCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { [weak self] event in
            guard let event = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            let time = CMTime(seconds: event.positionTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            self?.seek(to: time)
            return .success
        }
    }
}

extension CombineQueuePlayer {

    enum SkipType {
        case backward
        case forward
    }

    func skip(_ type: SkipType, interval: TimeInterval) {
        let interval = CMTime(seconds: interval, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let time: CMTime = {
            switch type {
            case .backward:
                return CMTimeSubtract(currentTime(), interval)
            case .forward:
                return CMTimeAdd(currentTime(), interval)
            }
        }()
        seek(to: time)
    }
}
