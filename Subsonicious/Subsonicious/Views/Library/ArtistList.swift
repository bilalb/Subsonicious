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

    @EnvironmentObject var artistListManager: Manager<SubsoniciousKit.ArtistList>
    @State private var artistList: SubsoniciousKit.ArtistList?
    @State private var selection: Artist?

    @ViewBuilder var content: some View {
        LoadableView(status: artistListManager.status) {
            if let artistList = artistList {
                List(selection: $selection) {
                    ForEach(artistList.indexes) { index in
                        Section(header: Text(index.name)) {
                            ForEach(index.artists) { artist in
                                NavigationLink(
                                    destination: AnyView(
                                        ArtistView(artistName: artist.name)
                                            .environmentObject(
                                                Manager<SubsoniciousKit.Artist>(
                                                    endpoint: .albumList(
                                                        artistId: "\(artist.id)")))),
                                    tag: artist,
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

    @ViewBuilder var body: some View {
        content
            .navigationBarTitle(Text("library.artists"))
            .onAppear {
                guard artistList == nil else { return }
                fetchArtistList()
            }
            .onReceive(artistListManager.$status) { status in
                switch status {
                case .fetched(let result):
                    switch result {
                    case .success(let artistList):
                        self.artistList = artistList as? SubsoniciousKit.ArtistList
                    default:
                        break
                    }
                default:
                    break
                }
            }
    }
}

private extension ArtistList {
    func fetchArtistList() {
        do {
            try artistListManager.fetch()
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }

    var errorDescription: String? {
        artistListManager.status.errorDescription
    }
}

struct ArtistList_Previews: PreviewProvider {
    static var previews: some View {
        ArtistList()
            .environmentObject(
                Manager<SubsoniciousKit.ArtistList>(
                    endpoint: .artistList))
    }
}
