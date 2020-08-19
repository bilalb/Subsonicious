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

    let manager: Manager<AlbumContainer<SubsoniciousKit.Album>>
    let albumName: String
    @EnvironmentObject var player: CombineQueuePlayer
    @State private var album: SubsoniciousKit.Album?
    @State private var selectedSong: Song?

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
            List(selection: selection) {
                ForEach(songs) { song in
                    NavigationLink(
                        destination: PlayerView(),
                        tag: song,
                        selection: selection) {
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

    var selection: Binding<Song?> {
        Binding<Song?>(
            get: {
                selectedSong
            },
            set: {
                selectedSong = $0
                if let selectedSong = self.selectedSong {
                    replaceCurrentSong(with: selectedSong)
                }
            })
    }

    func fetchSongList() {
        do {
            try manager.fetch()
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }

    func replaceCurrentSong(with song: Song) {
        do {
            try player.replaceCurrentSong(with: song)
            player.play()
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
}

struct SongList_Previews: PreviewProvider {
    static var previews: some View {
        SongList(
            manager: .init(
                endpoint: .songList(
                    albumId: Song.placeholder.id)),
            albumName: Album.placeholder.name)
    }
}
