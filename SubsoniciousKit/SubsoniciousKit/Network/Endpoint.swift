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
    case stream(mediaFileId: String)
    case coverArt(id: String, size: Int = 400)

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
        case .stream:
            return Constant.NetworkRequest.Stream.path
        case .coverArt:
            return Constant.NetworkRequest.CoverArt.path
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
        case .stream(let mediaFileId):
            return [URLQueryItem(name: Constant.NetworkRequest.Stream.ParameterName.mediaFileId, value: mediaFileId)]
        case .coverArt(let id, let size):
            return [URLQueryItem(name: Constant.NetworkRequest.CoverArt.ParameterName.id, value: id),
                    URLQueryItem(name: Constant.NetworkRequest.CoverArt.ParameterName.size, value: "\(size)")]
        default:
            return []
        }
    }
}
