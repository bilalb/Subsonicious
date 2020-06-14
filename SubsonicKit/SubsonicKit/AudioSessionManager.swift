//
//  AudioSessionManager.swift
//  SubsonicKit
//
//  Created by Bilal on 13/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import AVFoundation
import Foundation

public class AudioSessionManager {

    private let audioSession = AVAudioSession.sharedInstance()

    init() { }

    public func configureAudioSession() {
        do {
            try audioSession.setCategory(.playback)
        } catch {
            preconditionFailure("Failed to set the audio session’s category. \(error), \(error.localizedDescription)")
        }
    }
}
