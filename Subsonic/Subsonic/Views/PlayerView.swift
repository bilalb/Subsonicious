//
//  PlayerView.swift
//  Subsonic
//
//  Created by Bilal on 31/05/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SwiftUI

struct PlayerView: View {

    @State private var currentTime: TimeInterval = 0
    @State private var duration: TimeInterval = 0

    var body: some View {
        GeometryReader { containerView in
            VStack {

                Spacer()

                Image(systemName: "music.note")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: containerView.size.width - 48, maxHeight: containerView.size.width - 48)
                    .clipped()
                    .background(Color.blue)
                    .cornerRadius(6)
                    .shadow(radius: 10)

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

                VStack {
                    Slider(value: self.$currentTime, in: 0...self.duration)

                    HStack {
                        Text("--:--")
                            .font(.caption)
                        Spacer()
                        Text("--:--")
                            .font(.caption)
                    }
                }

                Spacer()

                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "backward.fill")
                            .asPlayerControl()
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "play.fill")
                            .asPlayerControl()
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "forward.fill")
                            .asPlayerControl()
                    }
                    Spacer()
                }

                Spacer()
            }
            .padding()
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}

extension Image {

    func asPlayerControl() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 32, height: 32)
    }
}
