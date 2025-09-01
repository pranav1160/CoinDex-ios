//
//  CryptoLoadingView.swift
//  CoinDex
//
//  Created by Pranav on 01/09/25.
//


import SwiftUI

struct CryptoLoadingView: View {
    @State private var isAnimating = false
    
    // Customizable properties
    var message: String = "Loading..."
    var circleSize: CGFloat = 120
    var gradientColors: [Color] = [Color.pink.opacity(0.8), Color.purple.opacity(0.8)]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea() // Sleek dark background
            
            VStack(spacing: 24) {
                ZStack {
                    // Outer pulsing ring
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 3)
                        .scaleEffect(isAnimating ? 1.2 : 0.2)
                        .opacity(isAnimating ? 0 : 1)
                        .animation(
                            .easeOut(duration: 1.5)
                            .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                    
                    // Main rotating gradient circle
                    rotatingRing(
                        size: circleSize,
                        lineWidth: 6,
                        colors: gradientColors,
                        duration: 1.5
                    )
                    
                    // Smaller inner ring (different speed + color)
                    rotatingRing(
                        size: circleSize * 0.7,
                        lineWidth: 4,
                        colors: [Color.green, Color.cyan],
                        duration: 1.2,
                        reverse: true
                    )
                    
                    // Tiny center ring
                    rotatingRing(
                        size: circleSize * 0.4,
                        lineWidth: 3,
                        colors: [Color.orange, Color.red],
                        duration: 1.8
                    )
                }
                .frame(width: circleSize * 1.6, height: circleSize * 1.6)
                .onAppear {
                    isAnimating = true
                }
                   
            }
        }
        .accessibilityLabel("Loading, please wait")
        
    }
    
    // MARK: - Reusable rotating ring view
    private func rotatingRing(size: CGFloat,
                              lineWidth: CGFloat,
                              colors: [Color],
                              duration: Double,
                              reverse: Bool = false) -> some View {
        Circle()
            .trim(from: 0, to: 0.8)
            .stroke(
                AngularGradient(
                    gradient: Gradient(colors: colors),
                    center: .center
                ),
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            )
            .frame(width: size, height: size)
            .rotationEffect(Angle(degrees: isAnimating ? (reverse ? -360 : 360) : 0))
            .animation(
                .linear(duration: duration)
                .repeatForever(autoreverses: false),
                value: isAnimating
            )
    }
}

#Preview {
    CryptoLoadingView()
}
