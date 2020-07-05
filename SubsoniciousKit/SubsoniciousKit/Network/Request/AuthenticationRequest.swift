//
//  AuthenticationRequest.swift
//  SubsoniciousKit
//
//  Created by Bilal on 05/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

class AuthenticationRequest: NetworkRequest {

    override var path: String {
        Constant.NetworkRequest.Authentication.path
    }
}
