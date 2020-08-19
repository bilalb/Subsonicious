//
//  ArtistList.swift
//  Subsonicious
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SubsoniciousKit
import SwiftUI

struct ArtistList: View {

    let manager: Manager<ArtistListContainer<SubsoniciousKit.ArtistList>>
    @State private var artistList: SubsoniciousKit.ArtistList?
    @State private var selection: ArtistContainer<SubsoniciousKit.Artist>?

    @ViewBuilder var body: some View {
        content
            .navigationBarTitle(Text("library.artists"))
            .onAppear {
                guard artistList == nil else { return }
                fetchArtistList()
            }
            .onReceive(manager.$status) { status in
                artistList = status.content(for: ArtistListContainerCodingKey.key)
            }
    }
}

private extension ArtistList {
    @ViewBuilder var content: some View {
        LoadableView(status: manager.status) {
            if let artistList = artistList {
                List(selection: $selection) {
                    ForEach(artistList.indexes) { index in
                        Section(header: Text(index.name)) {
                            ForEach(index.artists) { artist in
                                NavigationLink(
                                    destination: AlbumList(
                                        manager: .init(
                                            endpoint: .albumList(
                                                artistId: artist.id)),
                                        artistName: artist.name),
                                    tag: ArtistContainer<SubsoniciousKit.Artist>(artist),
                                    selection: $selection) {
                                    Text(artist.name)
                                }
                                .tag(artist)
                            }
                        }
                    }
                }
            } else if let errorDescription = errorDescription {
                ErrorView(
                    errorDescription: errorDescription,
                    action: fetchArtistList)
            }
        }
    }

    func fetchArtistList() {
        do {
            try manager.fetch()
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }

    var errorDescription: String? {
        manager.status.errorDescription
    }
}

struct ArtistList_Previews: PreviewProvider {
    static var previews: some View {
        ArtistList(manager: .init(endpoint: .artistList))
    }
}
