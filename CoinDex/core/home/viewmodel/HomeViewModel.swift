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
        dataService.$allCoins
            .sink {[weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
    }

}
