//
//  SubsonicPlayerItem.swift
//  SubsoniciousKit
//
//  Created by Bilal on 21/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation
import MediaPlayer

final class SubsonicPlayerItem: AVPlayerItem {
    let subsonicId: String

    init(subsonicId: String, asset: AVAsset, automaticallyLoadedAssetKeys: [String]? = nil) {
        self.subsonicId = subsonicId
        super.init(asset: asset, automaticallyLoadedAssetKeys: automaticallyLoadedAssetKeys)
    }
}
