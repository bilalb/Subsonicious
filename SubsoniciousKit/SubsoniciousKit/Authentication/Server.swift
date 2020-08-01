//
//  Server.swift
//  SubsoniciousKit
//
//  Created by Bilal on 23/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public struct Server {
    public var baseURL: String
    public var username: String
    public var password: String

    public init(baseURL: String = "", username: String = "", password: String = "") {
        self.baseURL = baseURL
        self.username = username
        self.password = password
    }
}

extension Server: Codable { }

extension Server: Equatable { }
