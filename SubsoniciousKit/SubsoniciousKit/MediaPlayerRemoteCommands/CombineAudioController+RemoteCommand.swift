//
//  CombineAudioController+RemoteCommand.swift
//  SubsoniciousKit
//
//  Created by Bilal on 07/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import FreeStreamer
import Foundation
import MediaPlayer

// swiftlint:disable opening_brace

// MARK: - Playback Commands Handlers

extension CombineAudioController {

    var pauseCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { [weak self] _ in
            self?.pause()
            return .success
        }
    }

    var playCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { [weak self] _ in
            self?.pause()
            return .success
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
            self?.pause()
            return .success
        }
    }
}

// MARK: - Between Tracks Navigation Commands Handlers

extension CombineAudioController {

    var nextTrackCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { [weak self] _ in
            self?.playNextItem()
            return .success
        }
    }

    var previousTrackCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { [weak self] _ in
            self?.playPreviousItem()
            return .success
        }
    }

    var changeRepeatModeCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { _ in
            // TODO: set remoteCommandCenter.changeRepeatModeCommand.currentRepeatType
            return .commandFailed
        }
    }

    var changeShuffleModeCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { _ in
            // TODO: set remoteCommandCenter.changeShuffleModeCommand.currentShuffleType
            return .commandFailed
        }
    }
}

// MARK: - Inner Track Navigation Commands Handlers

extension CombineAudioController {

    var changePlaybackRateCommandHandler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        { [weak self] event in
            guard let event = event as? MPChangePlaybackRateCommandEvent else { return .commandFailed }
            self?.activeStream.setPlayRate(event.playbackRate)
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
            guard let strongSelf = self,
                  let event = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }

            let progression = Float(event.positionTime)/strongSelf.duration
            let position = FSStreamPosition(progression)
            strongSelf.activeStream.seek(to: position)
            return .success
        }
    }
}

extension CombineAudioController {

    enum SkipType {
        case backward
        case forward
    }

    func skip(_ type: SkipType, interval: TimeInterval) {
        let time: Float = {
            switch type {
            case .backward:
                return currentTime - Float(interval)
            case .forward:
                return currentTime + Float(interval)
            }
        }()

        let progression = time/duration
        let position = FSStreamPosition(progression)
        activeStream.seek(to: position)
    }
}
