//
//  Constants.swift
//  SubsoniciousKit
//
//  Created by Bilal on 05/07/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

enum Constant {

    enum NetworkRequest {

        enum Parameter {

            enum Name {
                /// The username.
                static let username = "u"

                /// Authentication token computed as md5(password + salt).
                static let authenticationToken = "t"

                /// A random string ("salt") used as input for computing the password hash.
                static let salt = "s"

                /// The protocol version implemented by the client, i.e., the version of the subsonic-rest-api.xsd schema used.
                static let version = "v"

                /// A unique string identifying the client application.
                static let clientApplication = "c"

                /// Request data to be returned in this format. Supported values are "xml", "json" (since 1.4.0) and "jsonp" (since 1.6.0). If using jsonp, specify name of javascript callback function using a callback parameter.
                static let dataFormat = "f"
            }

            enum Value {
                static let version = "1.16.1"
                static let clientApplication = "Subsonicious"
                static let dataFormat = "json"
            }
        }

        enum Authentication {
            static let path = "/rest/ping"
        }

        enum CompleteArtistList {
            static let path = "/rest/getArtists"
        }

        enum AlbumList {
            static let path = "/rest/getArtist"

            enum ParameterName {
                static let artistId = "id"
            }
        }

        enum ArtistDetails {
            static let path = "/rest/getArtistInfo2"

            enum ParameterName {
                /// The artist ID.
                static let id = "id"
            }
        }

        enum SongList {
            static let path = "/rest/getAlbum"

            enum ParameterName {
                static let albumId = "id"
            }
        }

        enum Stream {
            static let path = "/rest/stream"

            enum ParameterName {
                static let mediaFileId = "id"
            }
        }

        enum CoverArt {
            static let path = "/rest/getCoverArt"

            enum ParameterName {
                static let id = "id"
                static let size = "size"
            }
        }
    }

    enum Keychain {

        enum Key {
            static let server = "server"
        }
    }
}
