//
//  AuthenticationMode.swift
//  SubsoniciousKit
//
//  Created by Bilal on 26/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public enum AuthenticationMode {
    case automatic
    case manual(Server)
}

extension AuthenticationMode: Equatable { }
