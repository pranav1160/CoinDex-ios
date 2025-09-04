//
//  CoinDexApp.swift
//  CoinDex
//
//  Created by Pranav on 31/08/25.
//

import SwiftUI

@main
struct CoinDexApp: App {
    @StateObject private var homeVm = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                HomeView()
            }
            .environmentObject(homeVm)
            .toolbar(.hidden)
        }
    }
}
