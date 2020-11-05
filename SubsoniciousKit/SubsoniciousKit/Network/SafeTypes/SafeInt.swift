//
//  SafeInt.swift
//  SubsoniciousKit
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

struct SafeInt: Valuable {
    var value: Int

    init(_ value: Int) {
        self.value = value
    }

    init(_ value: Double) {
        self.value = Int(value)
    }

    init(_ value: String) throws {
        guard let int = Int(value) else { throw Error.nilInt }
        self.value = int
    }
}

extension SafeInt: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self.init(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            self.init(doubleValue)
        } else if let stringValue = try? container.decode(String.self) {
            try self.init(stringValue)
        } else {
            let context = DecodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "Expected to decode Int, Double or String but found another type instead.")
            throw DecodingError.typeMismatch(Self.self, context)
        }
    }
}

extension SafeInt {
    enum Error: Swift.Error {
        case nilInt
    }
}

extension SafeInt.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .nilInt:
            return "SafeInt.Error.nilInt \n The int created from a String is nil."
        }
    }
}
