//
//  LaunchScreenView.swift
//  CoinDex
//
//  Created by Pranav on 01/09/25.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var titleOpacity: Double = 0.0
    @State private var buttonOpacity: Double = 0.0
    @State private var navigateToContent = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Clean dark background
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                // Subtle dark gradient overlay
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.gray.opacity(0.1),
                        Color.black
                    ]),
                    center: .center,
                    startRadius: 100,
                    endRadius: 400
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Logo section
                    VStack(spacing: 25) {
                        Image(.logoTransparent)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .scaleEffect(logoScale)
                            .opacity(logoOpacity)
                        
                        // App title
                        VStack(spacing: 8) {
                            Text("CoinDex")
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .opacity(titleOpacity)
                            
                            Text("Your Crypto Companion")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                                .opacity(titleOpacity)
                        }
                    }
                    
                    Spacer()
                    
                    // Navigation button
                    VStack(spacing: 20) {
                        NavigationLink{
                            ContentView()
                        }label:{
                                HStack(spacing: 12) {
                                    Text("Get Started")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                )
                            
                        }
                        .padding(.horizontal, 40)
                        .opacity(buttonOpacity)
                        
                        Text("Tap to continue")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.gray.opacity(0.7))
                            .opacity(buttonOpacity)
                    }
                    .padding(.bottom, 80)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Logo animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Title animation
        withAnimation(.easeOut(duration: 0.6).delay(0.8)) {
            titleOpacity = 1.0
        }
        
        // Button animation
        withAnimation(.easeOut(duration: 0.6).delay(1.3)) {
            buttonOpacity = 1.0
        }
    }
}



struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
