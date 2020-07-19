//
//  ErrorView.swift
//  Subsonicious
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
    private let errorDescription: String
    private let action: () -> Void

    init(errorDescription: String,
         action: @escaping () -> Void) {
        self.errorDescription = errorDescription
        self.action = action
    }

    var body: some View {
        VStack {
            Text(errorDescription)
                .multilineTextAlignment(.center)
                .padding()

            Button(action: action) {
                Text("retry")
            }
            .padding()
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(
            errorDescription: "error",
            action: {})
    }
}
