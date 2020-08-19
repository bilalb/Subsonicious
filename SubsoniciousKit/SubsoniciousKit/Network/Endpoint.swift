//
//  Endpoint.swift
//  SubsoniciousKit
//
//  Created by Bilal on 25/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

public enum Endpoint {
    case authentication
    /// Indexed structure of all artists.
    case completeArtistList
    /// Details for an artist, including a list of albums.
    case albumList(artistId: String)
    /// Artist info with biography, image URLs and similar artists.
    case artistDetails(id: String)
    /// Details for an album, including a list of songs.
    case songList(albumId: String)

    var path: String {
        switch self {
        case .authentication:
            return Constant.NetworkRequest.Authentication.path
        case .completeArtistList:
            return Constant.NetworkRequest.CompleteArtistList.path
        case .albumList:
            return Constant.NetworkRequest.AlbumList.path
        case .artistDetails:
            return Constant.NetworkRequest.ArtistDetails.path
        case .songList:
            return Constant.NetworkRequest.SongList.path
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .albumList(let artistId):
            return [URLQueryItem(name: Constant.NetworkRequest.AlbumList.ParameterName.artistId, value: artistId)]
        case .artistDetails(let id):
            return [URLQueryItem(name: Constant.NetworkRequest.ArtistDetails.ParameterName.id, value: id)]
        case .songList(let albumId):
            return [URLQueryItem(name: Constant.NetworkRequest.SongList.ParameterName.albumId, value: albumId)]
        default:
            return []
        }
    }
}
