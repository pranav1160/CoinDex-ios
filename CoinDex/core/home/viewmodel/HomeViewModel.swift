//
//  HomeViewModel.swift
//  CoinDex
//
//  Created by Pranav on 04/09/25.
//

import Foundation


class HomeViewModel:ObservableObject{
    @Published var allCoins:[Coin] = []
    @Published var portfolioCoins:[Coin] = []
    
    init (){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            self.allCoins.append(DeveloperPreview.instance.coin)
            self.portfolioCoins.append(DeveloperPreview.instance.coin)
        }
    }

}
