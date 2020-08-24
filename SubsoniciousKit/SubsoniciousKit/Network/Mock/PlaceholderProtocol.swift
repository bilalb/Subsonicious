//
//  PlaceholderProtocol.swift
//  SubsoniciousKit
//
//  Created by Bilal on 24/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public protocol PlaceholderProtocol: Decodable {
    associatedtype Placeholder: Decodable
    static var placeholder: Placeholder { get }
}
