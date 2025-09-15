//
//  CoinDetailDataService.swift
//  CoinDex
//
//  Created by Pranav on 15/09/25.
//
import Foundation
import Combine

class CoinDetailDataService{
    
    
    @Published var coinDetails:CoinDetail? = nil
    private var coinDetailSubscription:AnyCancellable?
    let coin:Coin
    init(coin:Coin){
        self.coin = coin
        getCoinDetails()
    }
    
    
    
    func getCoinDetails(){
        guard let url = URL(
            string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        )
        else {return}
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetail.self, decoder: JSONDecoder())
            .sink(receiveCompletion:NetworkingManager
                .handleCompletion(completion:),
                  receiveValue: {[weak self] returnedCoin in
                self?.coinDetails = returnedCoin
                self?.coinDetailSubscription?.cancel()
            }
            )
        
    }
}
