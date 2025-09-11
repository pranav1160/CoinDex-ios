//
//  HomeViewModel.swift
//  CoinDex
//
//  Created by Pranav on 04/09/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    @Published var searchTxt: String = ""
    @Published var statistics: [Statistic] = []
    @Published var sortType: SortOptions = .priceReversed
    @Published var portfolioSortType: SortOptions = .holdings // New property for portfolio sorting
    
    private let dataService = CoinDataService()
    private let statService = MarketDataService()
    private let portfolioService = PortfolioDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOptions {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscriber()
    }
    
    func saveToPortfolio(coin: Coin, amount: Double) {
        portfolioService.update(coin: coin, amount: amount)
    }
    
    func reloadCoins() {
        dataService.getCoins()
        statService.getMarketData()
    }
    
    // MARK: - Subscribers
    private func addSubscriber() {
        
        // All Coins subscriber (existing)
        $searchTxt
            .combineLatest(dataService.$allCoins, $sortType)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
        
        // Statistics subscriber (existing)
        statService.$data
            .combineLatest($portfolioCoins)
            .map(convertToStatistics)
            .sink { [weak self] stats in
                self?.statistics = stats
            }
            .store(in: &cancellables)
        
        // Portfolio Coins subscriber (enhanced with sorting)
        $allCoins
            .combineLatest(portfolioService.$savedPortfolios, $portfolioSortType)
            .map(convertToPortfolioWithSorting)
            .sink { [weak self] coins in
                self?.portfolioCoins = coins
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Portfolio Conversion with Sorting
    private func convertToPortfolioWithSorting(
        allCoins: [Coin],
        portfolios: [PortfolioEntity],
        sortType: SortOptions
    ) -> [Coin] {
        
        // Convert to portfolio coins
        var portfolioCoins: [Coin] = allCoins.compactMap { coin in
            guard let entity = portfolios.first(where: { $0.id == coin.id }) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
        
        // Sort portfolio coins
        sortPortfolioCoins(coins: &portfolioCoins, sortType: sortType)
        return portfolioCoins
    }
    
    // Original method (kept for backward compatibility)
    private func convertToPortfolio(
        allCoins: [Coin],
        portfolios: [PortfolioEntity]
    ) -> [Coin] {
        return allCoins.compactMap { coin in
            guard let entity = portfolios.first(where: { $0.id == coin.id }) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    // MARK: - Statistics Conversion
    private func convertToStatistics(marketData: MarketDataModel?, portfolioCoins: [Coin]) -> [Statistic] {
        
        var statistics: [Statistic] = []
        
        // ✅ 1. Market stats
        guard let marketData = marketData else { return statistics }
        
        let marketCap = Statistic(
            title: "Market Cap",
            value: marketData.marketCap,
            percentageChange: marketData.marketCapChangePercentage24HUsd
        )
        
        let volume = Statistic(
            title: "24H Volume",
            value: marketData.volume
        )
        
        let btcDominance = Statistic(
            title: "BTC Dominance",
            value: marketData.btcDominance
        )
        
        // ✅ 2. Portfolio stats
        let currentValue = portfolioCoins
            .map { $0.currentHoldingsValue }
            .reduce(0, +)
        
        let previousValue = portfolioCoins
            .map { coin -> Double in
                let current = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                return percentChange == -1 ? current : current / (1 + percentChange)
            }
            .reduce(0, +)
        
        let percentageChange = previousValue == 0 ? 0 :
        (currentValue - previousValue) / previousValue
        
        let portfolio = Statistic(
            title: "Portfolio",
            value: currentValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange
        )
        
        // ✅ 3. Collect them
        statistics.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        
        return statistics
    }
    
    // MARK: - Filtering
    private func filterCoins(searchText: String, allCoins: [Coin]) -> [Coin] {
        guard !searchText.isEmpty else {
            return allCoins
        }
        let lowerCasedTxt = searchText.lowercased()
        return allCoins.filter { coin in
            coin.name.lowercased().contains(lowerCasedTxt) ||
            coin.id.lowercased().contains(lowerCasedTxt) ||
            coin.symbol.lowercased().contains(lowerCasedTxt)
        }
    }
    
    // MARK: - Sorting Methods
    private func sortCoins(coins: inout [Coin], sortType: SortOptions) {
        switch sortType {
        case .rank, .holdings:
            coins.sort { $0.rank < $1.rank }
        case .rankReversed, .holdingsReversed:
            coins.sort { $0.rank > $1.rank }
        case .price:
            coins.sort { $0.currentPrice > $1.currentPrice }
        case .priceReversed:
            coins.sort { $0.currentPrice < $1.currentPrice }
        }
    }
    
    private func sortPortfolioCoins(coins: inout [Coin], sortType: SortOptions) {
        switch sortType {
        case .rank:
            coins.sort { $0.rank < $1.rank }
        case .rankReversed:
            coins.sort { $0.rank > $1.rank }
        case .holdings:
            coins.sort { $0.currentHoldingsValue > $1.currentHoldingsValue }
        case .holdingsReversed:
            coins.sort { $0.currentHoldingsValue < $1.currentHoldingsValue }
        case .price:
            coins.sort { $0.currentPrice > $1.currentPrice }
        case .priceReversed:
            coins.sort { $0.currentPrice < $1.currentPrice }
        }
    }
    
    private func filterAndSortCoins(
        searchText: String,
        allCoins: [Coin],
        sortType: SortOptions
    ) -> [Coin] {
        
        // 1. Filter
        var updatedCoins = filterCoins(
            searchText: searchText,
            allCoins: allCoins
        )
        
        // 2. Sort
        sortCoins(coins: &updatedCoins, sortType: sortType)
        return updatedCoins
    }
}
