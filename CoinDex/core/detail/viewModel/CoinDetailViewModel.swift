//
//  CoinDetailViewModel.swift
//  CoinDex
//
//  Created by Pranav on 15/09/25.
//

import Foundation
import Combine

class CoinDetailViewModel:ObservableObject{
    @Published var coinDetails:CoinDetail?
    private let detailService : CoinDetailDataService
    private var cancellables =  Set<AnyCancellable>()
    init(coin:Coin){
        self.detailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers(){
        detailService.$coinDetails
            .sink { returedDetails in
                print("GOT THE DATA BRO!!!!")
                print(returedDetails)
            }
            .store(in: &cancellables)
    }
    
}
