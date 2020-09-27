//
//  FSStreamPosition.swift
//  SubsoniciousKit
//
//  Created by Bilal on 18/10/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import FreeStreamer
import Foundation

public extension FSStreamPosition {
    /// The audio stream playback position.
    /// - Parameter position: Position within the stream, where 0 is the beginning and 1.0 is the end.
    init(_ position: Float) {
        self.init()
        self.position = position
    }
}
