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

                Text(artist)
                    .font(.subheadline)
                    .opacity(0.6)
            }

            Spacer()
        }
    }
}

private extension PlayerItemDataView {
    var title: String {
        nowPlayingInfoManager.staticMetadata?.title ?? ""
    }

    var artist: String {
        nowPlayingInfoManager.staticMetadata?.artist ?? ""
    }
}

struct PlayerItemDataView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerItemDataView()
    }
}
