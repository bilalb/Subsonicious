//
//  LibraryView.swift
//  Subsonicious
//
//  Created by Bilal on 19/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SwiftUI

struct LibraryView: View {

    @State private var selection: String?

    var content: some View {
        NavigationView {
            List(selection: $selection) {
                ForEach(LibraryItem.allCases) { item in
                    NavigationLink(
                        destination: item.destination,
                        tag: item.id,
                        selection: $selection) {
                        Text(NSLocalizedString(item.localizedStringKey))
                    }
                    .tag(item)
                }
            }
            .navigationBarTitle(Text("library"))
        }
    }

    @ViewBuilder var body: some View {
        #if os(iOS)
        content
        #else
        content
            .frame(minWidth: 270,
                   idealWidth: 300,
                   maxWidth: 400,
                   maxHeight: .infinity)
            .toolbar { Spacer() }
        #endif
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
