//
//  SubsonicPlayerItem.swift
//  SubsoniciousKit
//
//  Created by Bilal on 21/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation
import MediaPlayer

public final class SubsonicPlayerItem: AVPlayerItem {
    let id: String

    init(id: String, asset: AVAsset, automaticallyLoadedAssetKeys: [String]? = nil) {
        self.id = id
        super.init(asset: asset, automaticallyLoadedAssetKeys: automaticallyLoadedAssetKeys)
    }
}

extension SubsonicPlayerItem {
    static var placeholder: SubsonicPlayerItem {
        let path = Bundle.main.path(forResource: "example.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        let asset = AVURLAsset(url: url)
        return .init(id: Song.placeholder.id, asset: asset)
    }
}
