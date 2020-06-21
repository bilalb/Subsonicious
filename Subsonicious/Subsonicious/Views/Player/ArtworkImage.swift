//
//  ArtworkImage.swift
//  Subsonicious
//
//  Created by Bilal on 14/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SwiftUI

struct ArtworkImage: View {
    var body: some View {
        GeometryReader { containerView in
            Image(systemName: "music.note")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: containerView.size.width,
                       maxHeight: containerView.size.width)
                .clipped()
                .background(Color.blue)
                .cornerRadius(6)
                .shadow(radius: 10)
        }
        .aspectRatio(contentMode: .fit)
    }
}

struct ArtworkImage_Previews: PreviewProvider {
    static var previews: some View {
        ArtworkImage()
    }
}
