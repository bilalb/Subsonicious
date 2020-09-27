//
//  SubsonicPlaylistItem.swift
//  SubsoniciousKit
//
//  Created by Bilal on 18/10/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import FreeStreamer
import Foundation

final class SubsonicPlaylistItem: FSPlaylistItem {
    let song: Song

    init(song: Song, title: String, url: URL) {
        self.song = song
        super.init()
        self.title = title
        self.url = url
    }
}
