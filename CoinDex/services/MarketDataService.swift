//
//  MarketDataService.swift
//  CoinDex
//
//  Created by Pranav on 06/09/25.
//

import Foundation
import Combine

class MarketDataService{
    
    @Published var data:MarketDataModel? = nil
    private var marketDataSubscription:AnyCancellable?
    
    init(){
        getMarketData()
    }
    

    func getMarketData(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global")
        else {return}
        
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion:NetworkingManager
                .handleCompletion(completion:),
                  receiveValue: {[weak self] globalData in
                self?.data = globalData.data
                self?.marketDataSubscription?.cancel()
            }
            )
        
    }
}
