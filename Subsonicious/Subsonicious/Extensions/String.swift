//
//  String.swift
//  Subsonicious
//
//  Created by Bilal on 23/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

extension String {
    var isValid: Bool {
        !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
