//
//  PlayerView.swift
//  Subsonicious
//
//  Created by Bilal on 31/05/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import AVFoundation
import SubsoniciousKit
import SwiftUI

struct PlayerView: View {

    var body: some View {
        VStack {

            Spacer()

            ArtworkImage()

            Spacer()

            VStack(alignment: .leading) {
                Text("Title")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                Text("Artist")
                    .font(.subheadline)
                    .opacity(0.6)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)

            Spacer()

            PlayerSliderView()

            Spacer()

            PlayerControlsView()

            Spacer()
        }
        .padding()
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
