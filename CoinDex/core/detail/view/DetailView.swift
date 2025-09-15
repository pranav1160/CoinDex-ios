//
//  DetailView.swift
//  CoinDex
//
//  Created by Pranav on 12/09/25.
//


import SwiftUI

struct DetailView: View {
    @StateObject var vm: CoinDetailViewModel
    let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Coin Image
                AsyncImage(url: URL(string: coin.image)) { img in
                    img.resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                // Coin Name + Symbol
                VStack(alignment: .leading, spacing: 8) {
                    Text(coin.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(coin.symbol.uppercased())
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                
            }
            .padding()
        }
        .navigationTitle(coin.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}
