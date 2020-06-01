//
//  DateComponentsFormatter.swift
//  Subsonic
//
//  Created by Bilal on 01/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

extension DateComponentsFormatter {

    static let minutesSecondsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
}
