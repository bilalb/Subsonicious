//
//  Bundle.swift
//  SubsoniciousKit
//
//  Created by Bilal on 18/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

extension Bundle {
    static var kit: Bundle {
        Bundle(for: Self.self)
    }
}
