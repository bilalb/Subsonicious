//
//  SongList.swift
//  Subsonicious
//
//  Created by Bilal on 18/08/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SubsoniciousKit
import SwiftUI

struct SongList: View {

    @EnvironmentObject var manager: Manager<AlbumContainer<SubsoniciousKit.Album>>
    var albumName: String
    @State private var album: SubsoniciousKit.Album?
    @State private var selection: Song?

    @ViewBuilder var body: some View {
        content
            .navigationBarTitle(Text(albumName))
            .onAppear {
                guard album == nil else { return }
                fetchSongList()
            }
            .onReceive(manager.$status) { status in
                album = status.content(for: AlbumContainerCodingKey.key)
            }
    }
}

private extension SongList {
    @ViewBuilder var content: some View {
        if let songs = album?.songs {
            List(selection: $selection) {
                ForEach(songs) { song in
                    NavigationLink(
                        destination: PlayerView(),
                        tag: song,
                        selection: $selection) {
                        Text(song.title)
                    }
                    .tag(song)
                }
            }
        } else if let errorDescription = manager.status.errorDescription {
            ErrorView(
                errorDescription: errorDescription,
                action: fetchSongList)
        }
    }

    func fetchSongList() {
        do {
            try manager.fetch()
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
}

struct SongList_Previews: PreviewProvider {
    static var previews: some View {
        SongList(albumName: Album.placeholder.name)
    }
}
