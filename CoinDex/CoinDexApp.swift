//
//  CoinDexApp.swift
//  CoinDex
//
//  Created by Pranav on 31/08/25.
//

import SwiftUI

@main
struct CoinDexApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                HomeView()
            }
            .toolbar(.hidden)
        }
    }
}
