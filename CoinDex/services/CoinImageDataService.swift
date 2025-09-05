//
//  CoinImageDataService.swift
//  CoinDex
//
//  Created by Pranav on 05/09/25.
//

import Foundation
import SwiftUI
import Combine

class CoinImageDataService{
    @Published var coinImage:UIImage?
    private var coinImageSubscription:AnyCancellable?
    private let coin:Coin
    private let fileManager = LocalFileManager.instance
    private let imageName:String
    private let folderName = "coin_images"
    
    init(coin:Coin){
        self.coin=coin
        self.imageName = coin.id
        getCoinImages()
    }
    
    private func getCoinImages(){
        if let savedImage = fileManager.getImage(
            imageName: imageName,
            folderName: folderName
        ){
            self.coinImage = savedImage
            return
        }else{
            downloadCoinImages()
        }
        
    }
    
    private func downloadCoinImages(){
        guard let url = URL(string: coin.image) else {return}
        
        coinImageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data in
                UIImage(data: data)
            })
            .sink(
                receiveCompletion: NetworkingManager
                    .handleCompletion(completion:),
                receiveValue: { [weak self] img in
                    guard let self = self, let img else { return }
                    self.coinImage = img
                    self.fileManager.saveImage(image: img, imageName: self.imageName, folderName: self.folderName)
                    self.coinImageSubscription?.cancel()
                }
            )
    }
}
