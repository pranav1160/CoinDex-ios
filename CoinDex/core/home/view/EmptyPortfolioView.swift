
//
//  EmptyPortfolioView.swift
//  CoinDex
//
//  Created by Pranav on 01/09/25.
//

import SwiftUI

struct EmptyPortfolioView: View {
    
    @State private var animateGradient = false
    @State private var animateScale = false
    @State private var animateOpacity = false
    
    let onAddCoinsPressed: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            
            Spacer()
            
            // Icon Section
            ZStack {
                // Background circles for depth
                Circle()
                    .fill(Color.theme.accent.opacity(0.1))
                    .frame(width: 180, height: 180)
                    .scaleEffect(animateScale ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                        value: animateScale
                    )
                
                Circle()
                    .fill(Color.theme.accent.opacity(0.05))
                    .frame(width: 140, height: 140)
                    .scaleEffect(animateScale ? 1.2 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.3),
                        value: animateScale
                    )
                
                // Main icon
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.theme.accent.opacity(0.8),
                                    Color.theme.accent.opacity(0.6)
                                ],
                                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                                endPoint: animateGradient ? .bottomTrailing : .topLeading
                            )
                        )
                        .frame(width: 100, height: 100)
                        .shadow(color: Color.theme.accent.opacity(0.3), radius: 20, x: 0, y: 10)
                        .animation(
                            Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true),
                            value: animateGradient
                        )
                    
                    VStack(spacing: 4) {
                        Image(systemName: "folder")
                            .font(.system(size: 30, weight: .medium))
                            .foregroundColor(.white)
                        
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .opacity(animateOpacity ? 1.0 : 0.7)
            .animation(
                Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                value: animateOpacity
            )
            
            // Text Section
            VStack(spacing: 16) {
                Text("Your Portfolio is Empty")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                VStack(spacing: 8) {
                    Text("Start building your crypto portfolio")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("Track your favorite coins and monitor your investments")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 40)
            }
            
            // Action Button
            Button(action: onAddCoinsPressed) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text("Add Your First Coin")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                colors: [Color.theme.accent, Color.theme.accent.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: Color.theme.accent.opacity(0.4), radius: 8, x: 0, y: 4)
                )
            }
            .buttonStyle(EmptyPortfolioButtonStyle())
            
            // Tips Section
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "lightbulb.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    
                    Text("Tip: You can add coins from the main list")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Text("Track performance and manage holdings")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 40)
            .padding(.top, 16)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.backGround)
        .onAppear {
            animateGradient = true
            animateScale = true
            animateOpacity = true
        }
    }
}

// MARK: - Custom Button Style

struct EmptyPortfolioButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}


// MARK: - Preview

#Preview {
    ZStack {
        Color.theme.backGround.ignoresSafeArea()
        
        EmptyPortfolioView {
            print("Add coins pressed")
        }
    }
}
