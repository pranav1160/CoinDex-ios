//
//  LazyView.swift
//  CoinDex
//
//  Created by Pranav on 12/09/25.
//
import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    var body: some View { build() }
}

