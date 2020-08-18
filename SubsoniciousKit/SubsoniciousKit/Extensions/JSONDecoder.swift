//
//  JSONDecoder.swift
//  SubsoniciousKit
//
//  Created by Bilal on 17/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public extension JSONDecoder {
    static let subsonicDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.subsonicFormatter)
        return jsonDecoder
    }()
}
