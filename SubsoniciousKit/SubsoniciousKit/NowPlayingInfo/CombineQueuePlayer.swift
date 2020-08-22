//
//  CombineQueuePlayer.swift
//  SubsoniciousKit
//
//  Created by Bilal on 10/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Combine
import Foundation
import MediaPlayer

public final class CombineQueuePlayer: AVQueuePlayer, ObservableObject {

    /// When the player starts seeking it sends `true`.
    /// When the player finishes seeking it sends `false`.
    let seeking = PassthroughSubject<Bool, Never>()

    public override func seek(to time: CMTime) {
        seek(to: time) { _ in }
    }

    public override func seek(to date: Date) {
        seek(to: date) { _ in }
    }

    public override func seek(to time: CMTime, completionHandler: @escaping (Bool) -> Void) {
        seeking.send(false)
        super.seek(to: time) { [weak self] finished in
            completionHandler(finished)
            if finished {
                self?.seeking.send(true)
            }
        }
    }

    public override func seek(to date: Date, completionHandler: @escaping (Bool) -> Void) {
        seeking.send(false)
        super.seek(to: date) { [weak self] finished in
            completionHandler(finished)
            if finished {
                self?.seeking.send(true)
            }
        }
    }

    public override func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime) {
        seek(to: time,
             toleranceBefore: toleranceBefore,
             toleranceAfter: toleranceAfter) { _ in }
    }

    public override func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void) {
        seeking.send(false)
        super.seek(to: time,
                   toleranceBefore: toleranceBefore,
                   toleranceAfter: toleranceAfter) { [weak self] finished in
                    completionHandler(finished)
                    if finished {
                        self?.seeking.send(true)
                    }
        }
    }
}

public extension CombineQueuePlayer {
    static var dummyInstance: CombineQueuePlayer {
        let path = Bundle.main.path(forResource: "example.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        let playerItem = AVPlayerItem(url: url)
        let player = CombineQueuePlayer(items: [playerItem])
        player.actionAtItemEnd = .advance

        return player
    }
}
