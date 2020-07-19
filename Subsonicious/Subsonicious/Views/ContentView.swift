//
//  ContentView.swift
//  Subsonicious
//
//  Created by Bilal on 31/05/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection) {
            LibraryView()
                .tabItem {
                    VStack {
                        Image("first")
                        Text("library")
                    }
                }
                .tag(0)
            PlayerView()
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Player")
                    }
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
