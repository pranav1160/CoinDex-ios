//
//  CircleButtonView.swift
//  CoinDex
//
//  Created by Pranav on 01/09/25.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName:String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .fill(.ultraThinMaterial)
                    .shadow(color: Color.theme.accent,radius: 10)
            )
            .padding()
    }
}

#Preview {
    CircleButtonView(iconName: "heart")
}
