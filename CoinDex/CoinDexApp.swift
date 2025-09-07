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
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        
        // 🔴 Change title text color
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

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
