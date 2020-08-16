//
//  SubsonicResponseContainer.swift
//  SubsoniciousKit
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

/// To use to decode objects returned by the Subsonic API.
/// The objects themselves are nested inside a container which is itself nested in another container.
///
/// The objects have the following format:
/// ```json
/// {
///     "subsonic-response": {
///         "status": "ok",
///         "version": "1.16.1",
///         "someObjectKey": {
///             "somePropropertyKey": "somePropertyValue"
///         }
///     }
/// }
/// ```
public struct SubsonicResponseContainer<T: Decodable, NestedCodingKeys: SingleCodingKey> {
    public let content: T

    public init(_ content: T) {
        self.content = content
    }
}

extension SubsonicResponseContainer: Decodable {
    enum CodingKeys: String, CodingKey {
        case responseContainer = "subsonic-response"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        _ = try SubsonicResponse(from: decoder)

        content = try container.decode(SingleLevelNestedDecodable<T, NestedCodingKeys>.self, forKey: .responseContainer).content
    }
}

public protocol SingleCodingKey: CodingKey {
    static var key: Self { get }
}

extension ArtistContainer: Hashable where T == Artist { }
