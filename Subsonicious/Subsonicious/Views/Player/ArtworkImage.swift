//
//  ArtworkImage.swift
//  Subsonicious
//
//  Created by Bilal on 14/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SubsoniciousKit
import SwiftUI

struct ArtworkImage: View {
    @EnvironmentObject var nowPlayingInfoManager: NowPlayingInfoManager

    var body: some View {
        GeometryReader { containerView in
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: containerView.size.width,
                       maxHeight: containerView.size.width)
                .clipped()
                .cornerRadius(Constant.View.CornerRadius.default)
                .shadow(radius: 10)
        }
        .aspectRatio(contentMode: .fit)
    }
}

private extension ArtworkImage {
    var image: UIImage {
        nowPlayingInfoManager.staticMetadata?.artwork?.image(at: .zero) ?? UIImage()
    }
}

struct ArtworkImage_Previews: PreviewProvider {
    static var previews: some View {
        ArtworkImage()
    }
}
