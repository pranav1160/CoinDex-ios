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
    private var cancellables = Set<AnyCancellable>()
    
    init (){
        addSubscriber()
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
            .map (convertToStatistics)
            .sink { [weak self] stats in
                self?.statistics = stats
            }
            .store(in: &cancellables)
    }
    
    private func convertToStatistics(marketData:MarketDataModel?)->[Statistic]{
        var statistics:[Statistic] = []
        
        guard let marketData = marketData else {return statistics}
        
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
        
        let portfolio = Statistic(title: "Portfolio", value: "$0.00", percentageChange: 0.00)
        
        statistics
            .append(
                contentsOf: [marketCap,volume,btcDominance,portfolio]
            )
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
