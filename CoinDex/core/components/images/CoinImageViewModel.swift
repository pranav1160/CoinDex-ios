//
//  CoinImageViewModel.swift
//  CoinDex
//
//  Created by Pranav on 05/09/25.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel:ObservableObject{
    
    @Published var image:UIImage?
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let imageService:CoinImageDataService
    
    init(coin:Coin){
        self.imageService = CoinImageDataService(coin: coin)
        addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers(){
        imageService.$coinImage
            .sink { [weak self] image in
                self?.isLoading = false
                self?.image = image
            }
            .store(in: &cancellables)
    }
    
}
