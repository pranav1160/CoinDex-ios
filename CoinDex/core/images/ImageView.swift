//
//  ImageView.swift
//  CoinDex
//
//  Created by Pranav on 05/09/25.
//

import SwiftUI

struct ImageView: View {
    @StateObject var imageVM:CoinImageViewModel
    
    init(coin:Coin){
        _imageVM = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack{
            if let image = imageVM.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if imageVM.isLoading{
                ProgressView()
            }else{
                Image(systemName: "questionmark")
                    .foregroundStyle(Color.theme.secondaryText)
            }
        }
    }
}

struct ImageView_Preview:PreviewProvider{
    static var previews: some View{
        ImageView(coin: dev.coin)
    }
}
