//
//  QueuePlayer+RemoteCommand.swift
//  SubsoniciousKit
//
//  Created by Bilal on 07/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation
import MediaPlayer

// swiftlint:disable opening_brace

// MARK: - Playback Commands Handlers

extension QueuePlayer {

    var pauseCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { [weak self] _ in
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
        { [weak self] _ in
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
        { [weak self] _ in
            self?.stop()
            return .success
        }
    }

    var togglePlayPauseCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }
    }
}

// MARK: - Between Tracks Navigation Commands Handlers

extension QueuePlayer {

    var nextTrackCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { [weak self] _ in
            self?.skipToNext()
            return .success
        }
    }

    var previousTrackCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { [weak self] _ in
            self?.skipToPrevious()
            return .success
        }
    }

    var changeRepeatModeCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { [weak self] event in
            guard let event = event as? MPChangeRepeatModeCommandEvent else { return .commandFailed }
            self?.repeatType = event.repeatType
            return .success
        }
    }

    var changeShuffleModeCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { [weak self] event in
            guard let event = event as? MPChangeShuffleModeCommandEvent else { return .commandFailed }
            self?.shuffleType = event.shuffleType
            return .success
        }
    }
}

// MARK: - Inner Track Navigation Commands Handlers

extension QueuePlayer {

    var changePlaybackRateCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { [weak self] event in
            guard let event = event as? MPChangePlaybackRateCommandEvent else { return .commandFailed }
            self?.rate = event.playbackRate
            return .success
        }
    }

    var seekBackwardCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { _ in
            // TODO: to implement (see: MPSeekCommandEvent)
            return .commandFailed
        }
    }

    var seekForwardCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { _ in
            // TODO: to implement (see: MPSeekCommandEvent)
            return .commandFailed
        }
    }

    var skipBackwardCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { [weak self] event in
            guard let event = event as? MPSkipIntervalCommandEvent else { return .commandFailed }
            self?.skip(.backward, interval: event.interval)
            return .success
        }
    }

    var skipForwardCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { [weak self] event in
            guard let event = event as? MPSkipIntervalCommandEvent else { return .commandFailed }
            self?.skip(.forward, interval: event.interval)
            return .success
        }
    }

    var changePlaybackPositionCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { [weak self] event in
            guard let event = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            let time = CMTime(seconds: event.positionTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            self?.seek(to: time)
            return .success
        }
    }
}

extension QueuePlayer {
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
