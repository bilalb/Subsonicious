//
//  SafeURL.swift
//  SubsoniciousKit
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

struct SafeURL: Valuable {
    var value: URL

    init(_ value: URL) {
        self.value = value
    }

    init(_ value: String) throws {
        guard let url = URL(string: value) else { throw Error.urlRepresentationInvalid }
        self.value = url
    }
}

extension SafeURL: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let urlValue = try? container.decode(URL.self) {
            self.init(urlValue)
        } else if let stringValue = try? container.decode(String.self) {
            try self.init(stringValue)
        } else {
            let context = DecodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "Expected to decode URL or String but found another type instead.")
            throw DecodingError.typeMismatch(Self.self, context)
        }
    }
}

extension SafeURL {
    enum Error: Swift.Error {
        case urlRepresentationInvalid
    }
}

extension SafeURL.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .urlRepresentationInvalid:
            return "SafeURL.Error.urlRepresentationInvalid \n The url created from a String is nil. The string doesn’t represent a valid URL. For example, an empty string or one containing characters that are illegal in a URL produces nil."
        }
    }
}
