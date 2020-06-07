//
//  AVQueuePlayer+RemoteCommand.swift
//  SubsonicKit
//
//  Created by Bilal on 07/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation
import MediaPlayer

// MARK: - Playback Commands Handlers

extension AVQueuePlayer {

    var pauseCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { [weak self] _ in
            switch self?.timeControlStatus {
            case .paused:
                break
            case .playing:
                self?.pause()
                return .success
            case .waitingToPlayAtSpecifiedRate:
                print("reasonForWaitingToPlay: \(String(describing: self?.reasonForWaitingToPlay))")
            default:
                preconditionFailure("Unknown AVPlayer.TimeControlStatus")
            }
            return .commandFailed
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
                    print("error: \(String(describing: self?.error?.localizedDescription))")
                default:
                    print("status: \(String(describing: self?.status))")
                }
            case .playing:
                break
            case .waitingToPlayAtSpecifiedRate:
                print("reasonForWaitingToPlay: \(String(describing: self?.reasonForWaitingToPlay))")
            default:
                preconditionFailure("Unknown AVPlayer.TimeControlStatus")
            }
            return .commandFailed
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
        return { [weak self] event in
            switch self?.timeControlStatus {
            case .paused:
                switch self?.status {
                case .readyToPlay:
                    self?.play()
                    return .success
                case .failed:
                    print("error: \(String(describing: self?.error?.localizedDescription))")
                default:
                    print("status: \(String(describing: self?.status))")
                }
            case .playing:
                self?.pause()
                return .success
            case .waitingToPlayAtSpecifiedRate:
                print("reasonForWaitingToPlay: \(String(describing: self?.reasonForWaitingToPlay))")
            default:
                preconditionFailure("Unknown AVPlayer.TimeControlStatus")
            }
            return .commandFailed
        }
    }
}

// MARK: - Between Tracks Navigation Commands Handlers

extension AVQueuePlayer {

    var nextTrackCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { [weak self] _ in
            self?.advanceToNextItem()
            return .success
        }
    }

    var previousTrackCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { _ in
            // TODO: to implement
            return .success
        }
    }

    var changeRepeatModeCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { _ in
            // TODO: to implement
            return .success
        }
    }

    var changeShuffleModeCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return { _ in
            // TODO: to implement
            return .success
        }
    }
}

// MARK: - Inner Track Navigation Commands Handlers

extension AVQueuePlayer {

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
