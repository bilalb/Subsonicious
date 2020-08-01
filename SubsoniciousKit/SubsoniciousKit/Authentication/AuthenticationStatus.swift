//
//  AuthenticationStatus.swift
//  SubsoniciousKit
//
//  Created by Bilal on 25/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public enum AuthenticationStatus {
    case authenticated
    case authenticating(AuthenticationMode)
    case notAuthenticated(NotAuthenticatedReason)
}

extension AuthenticationStatus: Equatable {
    public static func == (lhs: AuthenticationStatus, rhs: AuthenticationStatus) -> Bool {
        switch (lhs, rhs) {
        case (.authenticated, .authenticated):
            return true
        case (.authenticating, .authenticating):
            return true
        case (.notAuthenticated, .notAuthenticated):
            return true
        default:
            return false
        }
    }
}

public extension AuthenticationStatus {
    enum NotAuthenticatedReason {
        case haveNotTriedYet
        case noPersistedServer
        case failure(Error?)
    }
}
