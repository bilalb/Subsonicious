//
//  LibraryItem.swift
//  Subsonicious
//
//  Created by Bilal on 19/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation
import SwiftUI

enum LibraryItem {
    case playlists
    case artists
    case albums
    case songs
    case recentlyAdded
    case favorites
}

extension LibraryItem {
    var localizedStringKey: String {
        switch self {
        case .playlists:
            return "library.playlists"
        case .artists:
            return "library.artists"
        case .albums:
            return "library.albums"
        case .songs:
            return "library.songs"
        case .recentlyAdded:
            return "library.recentlyAdded"
        case .favorites:
            return "library.favorites"
        }
    }

    var destination: AnyView {
        switch self {
        case .playlists:
            return AnyView(PlayerView())
        case .artists:
            return AnyView(PlayerView())
        case .albums:
            return AnyView(PlayerView())
        case .songs:
            return AnyView(LoginView())
        case .recentlyAdded:
            return AnyView(LoginView())
        case .favorites:
            return AnyView(LoginView())
        }
    }
}

extension LibraryItem: CaseIterable { }

extension LibraryItem: Identifiable {
    // swiftlint:disable identifier_name
    var id: String { localizedStringKey }
}

extension LibraryItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension LibraryItem: Equatable {
    static func == (lhs: LibraryItem, rhs: LibraryItem) -> Bool {
        lhs.id == rhs.id
    }
}
