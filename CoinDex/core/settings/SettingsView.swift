//
//  SettingsView.swift
//  CoinDex
//
//  Created by Pranav on 18/09/25.
//



import SwiftUI

struct SettingsView: View {
    
    @State private var showingAlert = false
    @State private var selectedTab = 0
    @Environment(\.dismiss) private var dismiss
    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com/@theconsistentman")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    let personalURL = URL(string: "https://github.com/pranav1160")!
    
    var body: some View {
        NavigationView {
            ZStack {
                // Enhanced gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.theme.backGround,
                        Color.theme.backGround.opacity(0.8),
                        Color.theme.accent.opacity(0.1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Content
                ScrollView {
                    LazyVStack(spacing: 24) {
                        youtubeSection
                        coinGeckoSection
                        developerSection
                        applicationSection
                        footerSection
                    }
                    
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                            .imageScale(.large)
                            .padding()
                    }
                }
            

                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAlert = true
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                }
            }
            .alert("App Info", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text("This app showcases modern SwiftUI development with MVVM architecture, Combine framework, and CoreData persistence.")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}

extension SettingsView {
    
    private var youtubeSection: some View {
        SettingsCard(
            title: "The Consistent Man",
            icon: "play.rectangle.fill",
            iconColor: .red
        ) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    AsyncImage(url: URL(string: "https://via.placeholder.com/80x80/FF0000/FFFFFF?text=TCM")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.red)
                            .overlay(
                                Text("TCM")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("The Consistent Man")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text("YouTube Channel")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "play.fill")
                                .foregroundColor(.red)
                            Text("Educational Content")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                }
                
                Text("This app was inspired by educational content and tutorials. It demonstrates MVVM Architecture, Combine framework, and CoreData for data persistence!")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                EnhancedLinkButton(
                    title: "Subscribe on YouTube",
                    icon: "play.rectangle.fill",
                    color: .red,
                    destination: youtubeURL
                )
            }
        }
    }
    
    private var coinGeckoSection: some View {
        SettingsCard(
            title: "CoinGecko API",
            icon: "chart.line.uptrend.xyaxis",
            iconColor: .green
        ) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(.coingecko)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("CoinGecko")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text("Crypto Data Provider")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "wifi")
                                .foregroundColor(.green)
                            Text("Free API")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                }
                
                Text("Real-time cryptocurrency data is provided by CoinGecko's comprehensive API. Market prices and statistics are updated regularly with minimal delays.")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                EnhancedLinkButton(
                    title: "Visit CoinGecko",
                    icon: "safari",
                    color: .green,
                    destination: coingeckoURL
                )
            }
        }
    }
    
    private var developerSection: some View {
        SettingsCard(
            title: "Developer",
            icon: "hammer.fill",
            iconColor: .blue
        ) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    AsyncImage(url: URL(string: "https://via.placeholder.com/80x80/0000FF/FFFFFF?text=DEV")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                Text("👨‍💻")
                                    .font(.largeTitle)
                            )
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Pranav")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text("iOS Developer")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "swift")
                                .foregroundColor(.orange)
                            Text("SwiftUI Expert")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                }
                
                Text("This application showcases modern iOS development using SwiftUI, implementing clean architecture patterns with multi-threading, reactive programming, and persistent data storage.")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                EnhancedLinkButton(
                    title: "View GitHub Profile",
                    icon: "laptopcomputer",
                    color: .blue,
                    destination: personalURL
                )
            }
        }
    }
    
    private var applicationSection: some View {
        SettingsCard(
            title: "Application",
            icon: "app.badge",
            iconColor: .orange
        ) {
            VStack(spacing: 12) {
                SettingsRow(title: "Terms of Service", icon: "doc.text", destination: defaultURL)
                Divider()
                SettingsRow(title: "Privacy Policy", icon: "hand.raised.fill", destination: defaultURL)
                Divider()
                SettingsRow(title: "Company Website", icon: "globe", destination: defaultURL)
                Divider()
                SettingsRow(title: "Learn More", icon: "info.circle", destination: defaultURL)
            }
        }
    }
    
    private var footerSection: some View {
        VStack(spacing: 8) {
            Text("Made with ❤️ using SwiftUI")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("Version 1.0.0")
                .font(.caption2)
                .foregroundColor(.secondary.opacity(0.7))
        }
        .padding(.bottom, 20)
    }
}

// MARK: - Custom Components

struct SettingsCard<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    let content: Content
    
    init(title: String, icon: String, iconColor: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.title2)
                    .frame(width: 30)
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(iconColor.opacity(0.1))
            
            // Content
            content
                .padding(20)
        }
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.theme.backGround.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.theme.accent.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct EnhancedLinkButton: View {
    let title: String
    let icon: String
    let color: Color
    let destination: URL
    
    var body: some View {
        Link(destination: destination) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let destination: URL
    
    var body: some View {
        Link(destination: destination) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.system(size: 16))
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
