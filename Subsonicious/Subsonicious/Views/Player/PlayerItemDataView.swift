//
//  PlayerItemDataView.swift
//  Subsonicious
//
//  Created by Bilal on 14/06/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SwiftUI

struct PlayerItemDataView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Title")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                Text("Artist")
                    .font(.subheadline)
                    .opacity(0.6)
            }

            Spacer()
        }
    }
}

struct PlayerItemDataView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerItemDataView()
    }
}
