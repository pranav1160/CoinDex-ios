//
//  CoinRowView.swift
//  CoinDex
//
//  Created by Pranav on 04/09/25.
//

import SwiftUI

struct CoinRowView: View {
    let coin: Coin

    var body: some View {
        HStack(spacing: 12) {
            leftColumn
            
            Spacer()
            
            centreColumn
            
            Spacer()
            
            // Price + Change
            rightColumn
       
        }
        .padding(.vertical, 6)
    }
}


struct CoinRowView_Previews:PreviewProvider{
    static var previews: some View{
        CoinRowView(coin: dev.coin)
    }
}



extension CoinRowView{
    private var leftColumn :some View{
        // Rank
        HStack(spacing: 0){
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            
            // Placeholder for logo
            Circle()
                .frame(width: 30, height: 30)
            
            // Symbol
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .frame(minWidth: 50, alignment: .leading)
        }
    }
    
    
    private var centreColumn:some View{
        HStack{
            // Holdings
            VStack(alignment: .trailing, spacing: 2) {
                Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                    .bold()
                    .foregroundColor(Color.theme.accent)
                Text((coin.currentHoldings ?? 0).asNumberString())
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
    
    private var rightColumn:some View{
        VStack(alignment: .trailing, spacing: 2) {
            Text(coin.currentPrice.asCurrencyWith2to6Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .font(.caption)
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0
                    ? Color.theme.appGreen
                    : Color.theme.appRed
                )
        }
    }
}
