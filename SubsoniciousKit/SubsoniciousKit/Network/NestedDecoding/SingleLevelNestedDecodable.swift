//
//  SingleLevelNestedDecodable.swift
//  SubsoniciousKit
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

/// To use to decode a single level of nested information.
///
/// For example, used with the following json, the `content` of `SingleLevelNestedDecodable<ADecodable, ASingleCodingKey>` returns an `ADecodable`.
/// ```json
/// {
///     "ASingleCodingKey.key": {
///         "somePropropertyKey": "somePropertyValue"
///     }
/// }
/// ```
public struct SingleLevelNestedDecodable<T: Decodable, NestedCodingKeys: SingleCodingKey> {
    public let content: T
}

extension SingleLevelNestedDecodable: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NestedCodingKeys.self)
        content = try container.decode(T.self, forKey: NestedCodingKeys.key)
    }
}
