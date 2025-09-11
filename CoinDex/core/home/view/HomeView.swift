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
                
                SearchBarView(searchText: $homeVm.searchTxt)
                
                Spacer(minLength: 0)
                
                sortingSection
                    .padding(.bottom,4)
                
                homeColumns
                
                coinsList
                
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
        VStack(spacing: 8) {
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.arrow.down")
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Text(currentSortText)
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color.theme.secondaryText)
                        .rotationEffect(showSortOptions ? Angle(degrees: 180) : Angle(degrees: 0))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.theme.backGround)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.theme.secondaryText.opacity(0.3), lineWidth: 1)
                        )
                )
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showSortOptions.toggle()
                    }
                }
                
                Spacer()
            }
           
            
            // Sort Options Dropdown
            if showSortOptions {
                VStack(spacing: 0) {
                    ForEach(sortOptions, id: \.self) { option in
                        HStack {
                            Text(sortOptionText(for: option))
                                .font(.caption)
                            Spacer()
                            if isCurrentSort(option) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.theme.accent)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.theme.backGround)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if showPortfolio {
                                    homeVm.portfolioSortType = option
                                } else {
                                    homeVm.sortType = option
                                }
                                showSortOptions = false
                            }
                        }
                        
                        if option != sortOptions.last {
                            Divider()
                                .background(Color.theme.secondaryText.opacity(0.2))
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.theme.backGround)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.theme.secondaryText.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal)
                .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .top)))
            }
        }
    }
    
    private var coinsList: some View {
        VStack {
            if showPortfolio {
                List {
                    ForEach(homeVm.portfolioCoins) { coin in
                        CoinRowView(coin: coin, showPortFolio: true)
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, 10)
                    }
                }
                .listStyle(.plain)
                .transition(.move(edge: .trailing))
                .refreshable {
                    await refreshCoins()
                }
            }
            
            if !showPortfolio {
                List {
                    ForEach(homeVm.allCoins) { coin in
                        CoinRowView(coin: coin, showPortFolio: false)
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, 10)
                    }
                }
                .listStyle(.plain)
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
