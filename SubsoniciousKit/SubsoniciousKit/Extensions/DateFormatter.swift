//
//  DateFormatter.swift
//  SubsoniciousKit
//
//  Created by Bilal on 17/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let subsonicFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
}
