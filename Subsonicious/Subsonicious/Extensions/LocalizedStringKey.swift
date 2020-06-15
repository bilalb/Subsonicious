//
//  LocalizedStringKey.swift
//  Subsonicious
//
//  Created by Bilal on 14/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation
import SwiftUI

extension LocalizedStringKey.StringInterpolation {

    mutating func appendInterpolation(_ seconds: TimeInterval, formatter: DateComponentsFormatter) {
        appendInterpolation(formatter.string(from: seconds) ?? "--:--")
    }
}
