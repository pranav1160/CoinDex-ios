//
//  CoinImageRowView.swift
//  CoinDex
//
//  Created by Pranav on 07/09/25.
//

import SwiftUI

struct CoinImageRowView: View {
    let coin:Coin
    var body: some View {
        VStack( alignment: .center,spacing: 4){
            ImageView(coin: coin)
                .frame(width: 60,height: 60)
            
            Text(coin.symbol.uppercased())
            
            Text(coin.name)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
             
                
        }
        .font(.headline)
    }
}

struct CoinRow_Preview:PreviewProvider {
    static var previews: some View{
        
        
        CoinImageRowView(coin: dev.coin)
            
    }
}
