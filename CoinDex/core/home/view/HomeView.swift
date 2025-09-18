//
//  HomeView.swift
//  CoinDex
//
//  Created by Pranav on 01/09/25.
//
import Foundation
import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio = false
    @EnvironmentObject private var homeVm: HomeViewModel
    @State private var navigateToPorfolio = false
    @State private var showSortOptions = false
    @State private var showSettings = false
    var body: some View {
        ZStack {
            Color.theme.backGround.ignoresSafeArea()
                .sheet(isPresented: $navigateToPorfolio) {
                    PortfolioView()
                        .environmentObject(homeVm)
                }
            
            VStack {
                
                header
                
                HomeStatsView(showPortfolio: $showPortfolio)
                
                HStack {
                    SearchBarView(searchText: $homeVm.searchTxt)
                    
                    sortingSection
                }
                
                Spacer(minLength: 0)
  
                homeColumns
                
                coinsList
                   
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(DeveloperPreview.instance.homeVM)
}

extension HomeView {
    private var header: some View {
        VStack {
            HStack {
                CircleButtonView(
                    iconName: showPortfolio ? "plus" : "info"
                )
                .transaction { transaction in
                    transaction.animation = nil
                }
                .onTapGesture {
                    if showPortfolio {
                        navigateToPorfolio = true
                    }else{
                        showSettings = true
                    }
                }
                
                Spacer()
                Text(showPortfolio ? "Portfolio" : "Live Prices")
                    .font(.headline)
                    .scaleEffect(1.2)
                    .fontWeight(.bold)
                    .transaction { transaction in
                        transaction.animation = nil
                    }
                
                Spacer()
                CircleButtonView(iconName: "chevron.right")
                    .rotationEffect(
                        showPortfolio ? Angle(degrees: 180) : Angle(degrees: 0)
                    )
                    .onTapGesture {
                        withAnimation {
                            showPortfolio.toggle()
                        }
                    }
            }
            .padding(.horizontal)
        }
    }
 
    private var sortingSection: some View {
        HStack {
            Menu {
                Picker("Sort", selection: showPortfolio ? $homeVm.portfolioSortType : $homeVm.sortType) {
                    ForEach(sortOptions, id: \.self) { option in
                        Text(sortOptionText(for: option))
                            .tag(option)
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down.circle")
                    .font(.title2) // size of the SF Symbol
                    .foregroundColor(Color.theme.accent)
            }
        }
       
    }

    
    private var coinsList: some View {
        VStack {
            if showPortfolio {
                if homeVm.portfolioCoins.isEmpty {
                    // Show empty state when no portfolio coins
                    EmptyPortfolioView {
                        // Action to add coins - you can customize this
                        withAnimation {
                            navigateToPorfolio = true
                        }
                    }
                    .transition(.opacity.combined(with: .scale))
                } else {
                    // Show portfolio coins list
                    List {
                        ForEach(homeVm.portfolioCoins) { coin in
                            NavigationLink {
                                LazyView { DetailView(coin: coin) }
                            } label: {
                                CoinRowView(coin: coin, showPortFolio: true)
                            }
                            .listRowInsets(EdgeInsets())
                        }
                    }
                    .listStyle(.plain)
                    .listRowSpacing(4)
                    .transition(.move(edge: .trailing))
                    .refreshable {
                        await refreshCoins()
                    }
                }
            }
            
            if !showPortfolio {
                List {
                    ForEach(homeVm.allCoins) { coin in
                        NavigationLink {
                            LazyView { DetailView(coin: coin) }
                        } label: {
                            CoinRowView(coin: coin, showPortFolio: false)
                        }
                        .listRowInsets(EdgeInsets())
                        
                    }
                }
                .listStyle(.plain)
                .listRowSpacing(4)
                .transition(.move(edge: .leading))
                .refreshable {
                    await refreshCoins()
                }
            }
        }
    }

    
    @MainActor
    private func refreshCoins() async {
        homeVm.reloadCoins()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
    
    private var homeColumns: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holdings")
                Spacer()
            }
            Text("Price")
        }
        .foregroundStyle(Color.theme.secondaryText)
        .font(.caption)
        .padding(.horizontal)
    }
    
    // MARK: - Helper Properties and Methods
    
    private var sortOptions: [HomeViewModel.SortOptions] {
        if showPortfolio {
            return [.holdings, .holdingsReversed, .rank, .rankReversed, .price, .priceReversed]
        } else {
            return [.rank, .rankReversed, .price, .priceReversed]
        }
    }
    
    private var currentSortText: String {
        let currentSort = showPortfolio ? homeVm.portfolioSortType : homeVm.sortType
        return sortOptionText(for: currentSort)
    }
    
    private func sortOptionText(for option: HomeViewModel.SortOptions) -> String {
        switch option {
        case .rank:
            return "Rank ↓"
        case .rankReversed:
            return "Rank ↑"
        case .holdings:
            return "Holdings ↓"
        case .holdingsReversed:
            return "Holdings ↑"
        case .price:
            return "Price ↓"
        case .priceReversed:
            return "Price ↑"
        }
    }
    
    private func isCurrentSort(_ option: HomeViewModel.SortOptions) -> Bool {
        if showPortfolio {
            return homeVm.portfolioSortType == option
        } else {
            return homeVm.sortType == option
        }
    }
}
