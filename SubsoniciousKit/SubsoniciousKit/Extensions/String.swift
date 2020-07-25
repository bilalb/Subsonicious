//
//  String.swift
//  SubsoniciousKit
//
//  Created by Bilal on 25/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

extension String {
    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}
