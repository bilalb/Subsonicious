//
//  ArtistView.swift
//  Subsonicious
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SubsoniciousKit
import SwiftUI

struct ArtistView: View {

    @EnvironmentObject var manager: Manager<ArtistContainer<SubsoniciousKit.Artist>>
    var artistName: String
    @State private var artist: SubsoniciousKit.Artist?
    @State private var selection: Album?

    @ViewBuilder var content: some View {
        if let albums = artist?.albums {
            List(selection: $selection) {
                ForEach(albums) { album in
                    NavigationLink(
                        destination: AnyView(PlayerView()),
                        tag: album,
                        selection: $selection) {
                        Text(album.name)
                    }
                    .tag(album)
                }
            }
        } else if let errorDescription = manager.status.errorDescription {
            ErrorView(
                errorDescription: errorDescription,
                action: fetchArtist)
        }
    }

    @ViewBuilder var body: some View {
        content
            .navigationBarTitle(Text(artistName))
            .onAppear {
                guard artist == nil else { return }
                fetchArtist()
            }
            .onReceive(manager.$status) { status in
                artist = status.content(for: ArtistContainerCodingKey.key)
            }
    }
}

private extension ArtistView {
    func fetchArtist() {
        do {
            try manager.fetch()
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
}

struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistView(artistName: Artist.placeholder.name)
    }
}
