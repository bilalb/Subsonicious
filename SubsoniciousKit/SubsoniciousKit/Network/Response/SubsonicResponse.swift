//
//  SubsonicResponse.swift
//  SubsoniciousKit
//
//  Created by Bilal on 05/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public struct SubsonicResponse: Decodable {
    public let status: Status
    public let error: Error?

    enum CodingKeys: String, CodingKey {
        case responseContainer = "subsonic-response"
    }

    enum ResponseCodingKeys: String, CodingKey {
        case status
        case error
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let responseContainer = try container.nestedContainer(keyedBy: ResponseCodingKeys.self, forKey: .responseContainer)
        status = try responseContainer.decode(Status.self, forKey: .status)
        error = try responseContainer.decodeIfPresent(Error.self, forKey: .error)
    }
}

extension SubsonicResponse {
    public enum Status: Decodable {
        case success
        case failure

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let status = try container.decode(String.self)
            try self.init(status: status)
        }

        init(status: String) throws {
            switch status {
            case "ok":
                self = .success
            case "failed":
                self = .failure
            default:
                throw Error.invalidStatus(status)
            }
        }
    }
}

extension SubsonicResponse.Status {
    enum Error: Swift.Error {
        case invalidStatus(String)
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
