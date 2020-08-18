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
    case artistList
    /// Details for an artist, including a list of albums.
    case albumList(artistId: String)
    /// Artist info with biography, image URLs and similar artists.
    case artistDetails(id: String)

    var path: String {
        switch self {
        case .authentication:
            return Constant.NetworkRequest.Authentication.path
        case .artistList:
            return Constant.NetworkRequest.ArtistList.path
        case .albumList:
            return Constant.NetworkRequest.Artist.path
        case .artistDetails:
            return Constant.NetworkRequest.ArtistDetails.path
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .albumList(let artistId):
            return [URLQueryItem(name: Constant.NetworkRequest.Artist.ParameterName.artistId, value: artistId)]
        case .artistDetails(let id):
            return [URLQueryItem(name: Constant.NetworkRequest.ArtistDetails.ParameterName.id, value: id)]
        default:
            return []
        }
    }
}
