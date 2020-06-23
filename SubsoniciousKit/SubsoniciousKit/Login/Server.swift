//
//  Server.swift
//  SubsoniciousKit
//
//  Created by Bilal on 23/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public struct Server {
    public var address: String
    public var username: String
    public var password: String

    public init(address: String = "", username: String = "", password: String = "") {
        self.address = address
        self.username = username
        self.password = password
    }
}
