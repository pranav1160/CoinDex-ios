//
//  PortfolioView.swift
//  CoinDex
//
//  Created by Pranav on 07/09/25.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @State private var selectedCoin:Coin? = nil
    @State private var amountSelected = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $homeVM.searchTxt)
                    
                    coinsRow
                    
                    if let coin = selectedCoin {
                        CoinFormView(
                            coin: coin,
                            amountSelected: $amountSelected
                        )
                    }
                }
                
                .padding(.vertical, 8)
            }
            .overlay(  // Wide Save Button
                saveButton
                ,alignment: .bottom)
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    CancelButtonView(action: {
                        removeSelectedCoin()
                    })
                    .offset(x:30)
                }
            }
        }
        .onChange(of: homeVM.searchTxt) { _, newValue in
            if newValue==""{
                removeSelectedCoin()
            }
        }
    }
}

struct Portfolio_Preview: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}


extension PortfolioView{
    
    private func getAmountValue(for coin: Coin) -> Double {
        return coin.currentPrice * (Double(amountSelected) ?? 0)
    }
    
    private func removeSelectedCoin(){
        withAnimation {
            homeVM.searchTxt = ""
            selectedCoin = nil
            amountSelected = ""
        }
    }
    
    private func updateSelectedCoin(coin: Coin) {
        selectedCoin = coin
        if let portfolioCoin = homeVM.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            amountSelected = amount.asNumberString()
        } else {
            amountSelected = ""
        }
    }

    
    private func saveToPortfolio() {
        guard let coin = selectedCoin,
              let amount = Double(amountSelected),
              amount >= 0 else { return }
        
        homeVM.saveToPortfolio(coin: coin, amount: amount)
        
        withAnimation(.easeIn) {
            removeSelectedCoin()
        }
    }

    

    
    
    private var coinsRow:some View{
        ScrollView(
            .horizontal,
            showsIndicators: false,
            content: {
                LazyHStack(spacing: 10) {
                    ForEach(
                        homeVM.searchTxt.isEmpty ? homeVM.portfolioCoins : homeVM.allCoins
                    ) { coin in
                        CoinImageRowView(coin: coin)
                            .frame(width: 65)
                            .padding()
                            .onTapGesture {
                                updateSelectedCoin(coin: coin)
                            }
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        Color.theme.appRed,
                                        lineWidth: 2
                                    )
                                    .opacity(
                                        (selectedCoin?.id == coin.id) ? 1 : 0
                                    )
                            }
                    }
                }
            })
    }
    
    private var saveButton: some View {
        VStack {
            Button {
                saveToPortfolio()
            } label: {
                Text("Save".uppercased())
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.theme.appRed)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding()
            }
        }
    }

    
    private struct CoinFormView: View {
        let coin: Coin
        @Binding var amountSelected: String
        
        var body: some View {
            VStack(spacing: 20) {
                HStack {
                    Text("Price of : \(coin.symbol.uppercased())")
                    Spacer()
                    Text("\(coin.currentPrice.asCurrencyWith2Decimals())")
                }
                
                Divider()
                
                HStack {
                    Text("Portfolio Amount:")
                    Spacer()
                    TextField("Ex: 1.4", text: $amountSelected)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                
                Divider()
                
                HStack {
                    Text("Current Value")
                    Spacer()
                    Text("\(getAmountValue().asCurrencyWith2Decimals())")
                }
                
            }
            .padding()
            .font(.headline)
        }
        private func getAmountValue() -> Double {
            return coin.currentPrice * (Double(amountSelected) ?? 0)
        }
    }
    
}
