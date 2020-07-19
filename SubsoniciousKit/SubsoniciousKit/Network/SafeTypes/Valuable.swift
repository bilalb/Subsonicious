//
//  Valuable.swift
//  SubsoniciousKit
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

protocol Valuable: Equatable {
    associatedtype ValueType: Equatable
    var value: ValueType { get set }
}
