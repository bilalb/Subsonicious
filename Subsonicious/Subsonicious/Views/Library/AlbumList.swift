//
//  AlbumList.swift
//  Subsonicious
//
//  Created by Bilal on 16/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SubsoniciousKit
import SwiftUI

struct AlbumList: View {

    let manager: Manager<ArtistContainer<SubsoniciousKit.Artist>>
    let artistName: String
    @State private var artist: SubsoniciousKit.Artist?
    @State private var selection: Album?

    @ViewBuilder var body: some View {
        content
            .navigationBarTitle(Text(artistName))
            .onAppear {
                guard artist == nil else { return }
                fetchArtist()
            }
            .onReceive(manager.$status) { status in
                artist = status.decodable(for: ArtistContainerCodingKey.key)
            }
    }
}

private extension AlbumList {
    @ViewBuilder var content: some View {
        if let albums = artist?.albums {
            List(selection: $selection) {
                ForEach(albums) { album in
                    NavigationLink(
                        destination: SongList(
                            manager: .init(
                                endpoint: .songList(
                                    albumId: album.id)),
                            albumName: album.name),
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

    func fetchArtist() {
        do {
            try manager.fetch()
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
}

struct AlbumList_Previews: PreviewProvider {
    static var previews: some View {
        AlbumList(
            manager: .init(
                endpoint: .albumList(
                    artistId: Artist.placeholder.id)),
            artistName: Artist.placeholder.name)
    }
}
