//
//  RootContainerView.swift
//  Subsonicious
//
//  Created by Bilal on 25/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SubsoniciousKit
import SwiftUI

struct RootContainerView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager

    var body: some View {
        RootView(status: authenticationManager.authenticationStatus,
                 authenticate: {
                    do {
                        try authenticationManager.authenticate(.automatic)
                    } catch {
                        debugPrint(error)
                    }
                 })
            .equatable()
    }
}

struct RootContainerView_Previews: PreviewProvider {
    static var previews: some View {
        RootContainerView()
    }
}
