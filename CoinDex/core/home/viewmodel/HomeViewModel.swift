//
//  HomeViewModel.swift
//  CoinDex
//
//  Created by Pranav on 04/09/25.
//

import Foundation
import Combine

class HomeViewModel:ObservableObject{
    @Published var allCoins:[Coin] = []
    @Published var portfolioCoins:[Coin] = []
    
    @Published var searchTxt:String = ""
    @Published var statistics:[Statistic] = []
    
    private let dataService = CoinDataService()
    private let statService = MarketDataService()
    private let portfolioService = PortfolioDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init (){
        addSubscriber()
    }
    
    func saveToPortfolio(coin:Coin,amount:Double){
        portfolioService.update(coin: coin, amount: amount)
    }
    
    private func addSubscriber(){
        $searchTxt
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map (filterCoins)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
        
        statService.$data
            .combineLatest($portfolioCoins)
            .map (convertToStatistics)
            .sink { [weak self] stats in
                self?.statistics = stats
            }
            .store(in: &cancellables)
        
        $allCoins
            .combineLatest(portfolioService.$savedPortfolios)
            .map (convertToPortfolio)
            .sink {[weak self] coins in
                self?.portfolioCoins = coins
            }
            .store(in: &cancellables)
            
    }
    
    private func convertToPortfolio(allCoins: Published<[Coin]>.Publisher.Output,portfolios:Published<[PortfolioEntity]>.Publisher.Output)->[Coin]{
        allCoins.compactMap { coin in
            guard let entity = portfolios.first(where: {$0.id == coin.id}) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func convertToStatistics(
        marketData: MarketDataModel?,
        portfolioCoins: [Coin]
    ) -> [Statistic] {
        
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
                return current / (1 + percentChange)
            }
            .reduce(0, +)
        
        let percentageChange = (currentValue - previousValue) / previousValue
        
        let portfolio = Statistic(
            title: "Portfolio",
            value: currentValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange
        )
        
        // ✅ 3. Collect them
        statistics.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        
        return statistics
    }

    private func filterCoins(searchText:String,allCoins:[Coin])->[Coin]{
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

}
