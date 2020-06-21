//
//  PlayerControlImage.swift
//  Subsonicious
//
//  Created by Bilal on 14/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SwiftUI

struct PlayerControlImage: View {

    let systemName: String

    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 32, height: 32)
    }
}

struct PlayerControlImage_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControlImage(systemName: "play.fill")
    }
}
