//
//  SubsonicResponse.swift
//  SubsoniciousKit
//
//  Created by Bilal on 05/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public struct SubsonicResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case responseContainer = "subsonic-response"
    }

    enum ResponseCodingKeys: String, CodingKey {
        case error
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let responseContainer = try container.nestedContainer(keyedBy: ResponseCodingKeys.self, forKey: .responseContainer)

        if let error = try responseContainer.decodeIfPresent(Error.self, forKey: .error) {
            throw DecodingError.Subsonic.error(error)
        }
    }
}

extension DecodingError {
    public enum Subsonic: Error {
        case error(SubsonicResponse.Error)
    }
}

extension SubsonicResponse {
    public struct Error: Decodable {
        let code: Int
        public let message: String

        enum CodingKeys: String, CodingKey {
            case code
            case message
        }
    }
}
