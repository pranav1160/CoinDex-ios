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
    
    private let dataService = CoinDataService()
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
