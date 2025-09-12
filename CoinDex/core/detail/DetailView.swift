//
//  DetailView.swift
//  CoinDex
//
//  Created by Pranav on 12/09/25.
//

import SwiftUI

struct DetailView: View {
    let coin:Coin
    init(coin: Coin) {
        self.coin = coin
        print("loaded view for \(coin.id)")
    }
    var body: some View {
        VStack{
            Text("\(coin.name)")
        }
    }
}

struct DetailView_Preview:PreviewProvider{
    static var previews: some View{
        DetailView(coin: dev.coin)
    }
}
