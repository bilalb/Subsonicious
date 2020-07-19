//
//  LoadableView.swift
//  Subsonicious
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SubsoniciousKit
import SwiftUI

struct LoadableView<Content: View>: View {
    private var status: FetchStatus
    private let content: Content

    init(status: FetchStatus,
         @ViewBuilder content: () -> Content) {
        self.status = status
        self.content = content()
    }

    @ViewBuilder var body: some View {
        switch status {
        case .notFetchedYet, .fetching:
            ProgressView()
        case .fetched:
            content
        }
    }
}

struct LoadableView_Previews: PreviewProvider {
    static var previews: some View {
        LoadableView(
            status: .notFetchedYet,
            content: {
                EmptyView()
            })
    }
}
