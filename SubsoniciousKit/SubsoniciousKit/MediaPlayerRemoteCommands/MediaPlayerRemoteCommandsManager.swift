//
//  MediaPlayerRemoteCommandsManager.swift
//  SubsoniciousKit
//
//  Created by Bilal on 07/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation
import MediaPlayer

public final class MediaPlayerRemoteCommandsManager {

    private let player: QueuePlayer

    public init(player: QueuePlayer) {
        self.player = player
    }

    public func configureRemoteCommands() {
        configurePlaybackAndNavigationCommands()
        disableUnusedCommands()
    }
}

// MARK: - Private Methods

private extension MediaPlayerRemoteCommandsManager {

    typealias CommandHandler = (command: MPRemoteCommand, handler: (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus)

    func configurePlaybackAndNavigationCommands() {
        let remoteCommandCenter = MPRemoteCommandCenter.shared()

        let playbackCommands: [CommandHandler]
            = [(remoteCommandCenter.pauseCommand, player.pauseCommandHandler),
               (remoteCommandCenter.playCommand, player.playCommandHandler),
               (remoteCommandCenter.stopCommand, player.stopCommandHandler),
               (remoteCommandCenter.togglePlayPauseCommand, player.togglePlayPauseCommandHandler)]

        let betweenTracksNavigationCommands: [CommandHandler]
            = [(remoteCommandCenter.nextTrackCommand, player.nextTrackCommandHandler),
               (remoteCommandCenter.previousTrackCommand, player.previousTrackCommandHandler),
               (remoteCommandCenter.changeRepeatModeCommand, player.changeRepeatModeCommandHandler),
               (remoteCommandCenter.changeShuffleModeCommand, player.changeShuffleModeCommandHandler)]

        let innerTrackNavigationCommands: [CommandHandler]
            = [(remoteCommandCenter.changePlaybackRateCommand, player.changePlaybackRateCommandHandler),
               (remoteCommandCenter.seekBackwardCommand, player.seekBackwardCommandHandler),
               (remoteCommandCenter.seekForwardCommand, player.seekForwardCommandHandler),
               (remoteCommandCenter.skipBackwardCommand, player.skipBackwardCommandHandler),
               (remoteCommandCenter.skipForwardCommand, player.skipForwardCommandHandler),
               (remoteCommandCenter.changePlaybackPositionCommand, player.changePlaybackPositionCommandHandler)]

        let preferredSkipIntervals: [NSNumber] = [10, 20, 30, 40, 50, 60]
        remoteCommandCenter.skipBackwardCommand.preferredIntervals = preferredSkipIntervals
        remoteCommandCenter.skipForwardCommand.preferredIntervals = preferredSkipIntervals

        // Didn't manage to find such feature on Apple Music, Deezer & Spotify
        // useful for podcasts?
        remoteCommandCenter.changePlaybackRateCommand.supportedPlaybackRates = [0.5, 1, 1.5, 2]

        let commands = playbackCommands
            + betweenTracksNavigationCommands
            + innerTrackNavigationCommands

        commands.forEach { (command, handler) in
            command.addTarget(handler: handler)
        }
    }

    func disableUnusedCommands() {
        let remoteCommandCenter = MPRemoteCommandCenter.shared()

        let ratingCommands = [remoteCommandCenter.ratingCommand,
                              remoteCommandCenter.likeCommand,
                              remoteCommandCenter.dislikeCommand]

        let bookmarkCommands = [remoteCommandCenter.bookmarkCommand]

        let languageOptionCommands = [remoteCommandCenter.enableLanguageOptionCommand,
                                      remoteCommandCenter.disableLanguageOptionCommand]

        let commandsToDisable = ratingCommands
            + bookmarkCommands
            + languageOptionCommands

        commandsToDisable.forEach { $0.isEnabled = false }
    }
}
