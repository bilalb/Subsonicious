//
//  Service.swift
//  SubsoniciousKit
//
//  Created by Bilal on 10/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public class Service {

    let session: URLSession

    public init(sessionConfiguration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: sessionConfiguration)
    }
}
