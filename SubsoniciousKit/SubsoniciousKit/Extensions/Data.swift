//
//  Data.swift
//  SubsoniciousKit
//
//  Created by Bilal on 25/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import CryptoKit
import Foundation

extension Data {
    func md5() -> String {
        return Insecure.MD5
            .hash(data: self)
            .map { String(format: "%02hhx", $0) }
            .joined()
    }
}
