//
//  PlayerItemDataView.swift
//  Subsonicious
//
//  Created by Bilal on 14/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SubsoniciousKit
import SwiftUI

struct PlayerItemDataView: View {
    @EnvironmentObject var nowPlayingInfoManager: NowPlayingInfoManager

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text(artist)
                    .font(.subheadline)
                    .opacity(0.6)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .animation(nil)

            Spacer()
        }
    }
}

private extension PlayerItemDataView {
    var title: String {
        nowPlayingInfoManager.staticMetadata?.title as String? ?? ""
    }

    var artist: String {
        nowPlayingInfoManager.staticMetadata?.artist as String? ?? ""
    }
}

struct PlayerItemDataView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerItemDataView()
    }
}
