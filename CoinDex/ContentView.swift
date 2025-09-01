//
//  ContentView.swift
//  CoinDex
//
//  Created by Pranav on 31/08/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.pink.ignoresSafeArea()
            VStack{
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, Coindex!")
            }
        }
    }
}

#Preview {
    ContentView()
}
