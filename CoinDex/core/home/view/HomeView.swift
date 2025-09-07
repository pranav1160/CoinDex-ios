//
//  HomeView.swift
//  CoinDex
//
//  Created by Pranav on 01/09/25.
//

import Foundation
import SwiftUI

struct HomeView:View {
    
    @State private var showPortfolio = false
    @EnvironmentObject private var homeVm:HomeViewModel
    @State private var navigateToPorfolio = false
    
    var body: some View {
        ZStack {
            Color.theme.backGround.ignoresSafeArea()
                .sheet(isPresented: $navigateToPorfolio) {
                    PortfolioView()
                        .environmentObject(homeVm)
                }
            
            VStack{
                
                header
                
                HomeStatsView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchText: $homeVm.searchTxt)
                
                Spacer(minLength: 0)
                
                homeColumns

                coinsList
                
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(DeveloperPreview.instance.homeVM)
}


extension HomeView{
    private var header : some View{
        VStack{
            HStack{
                CircleButtonView(
                    iconName:  showPortfolio ? "plus" : "info"
                )
                .transaction { transaction in
                    transaction.animation = nil
                }
                .onTapGesture {
                    if showPortfolio{
                        navigateToPorfolio = true
                    }
                }
                
                Spacer()
                Text( showPortfolio ? "Portfolio" : "Live Prices" )
                    .font(.headline)
                    .scaleEffect(1.2)
                    .fontWeight(.bold)
                    .transaction { transaction in
                        transaction.animation = nil
                    }
                
                Spacer()
                CircleButtonView(iconName: "chevron.right")
                    .rotationEffect(
                        showPortfolio ? Angle(degrees: 180) : Angle(degrees: 0)
                    )
                    .onTapGesture {
                        withAnimation {
                            showPortfolio.toggle()
                        }
                    }
            }
            .padding(.horizontal)
        }
    }
    
    private var coinsList:some View{
        VStack{
            if showPortfolio{
                List{
                    ForEach(homeVm.portfolioCoins){coin in
                        CoinRowView(coin: coin,showPortFolio: true)
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical,10)
                    }
                }
                .listStyle(.plain)
                .transition(.move(edge: .trailing))
            }
            
            if !showPortfolio{
                List{
                    ForEach(homeVm.allCoins){coin in
                        
                            CoinRowView(coin: coin,showPortFolio: false)
                                .listRowInsets(EdgeInsets())
                                .padding(.vertical,10)
                    }
                }
                .listStyle(.plain)
                .transition(.move(edge: .leading))
            }
        }
    }
    
    private var homeColumns:some View{
        HStack{
            Text("Coin")
            Spacer()
            if showPortfolio{
                Text("Holdings")
                Spacer()
            }
            Text("Price")
        }
        .foregroundStyle(Color.theme.secondaryText)
        .font(.caption)
        .padding(.horizontal)
    }
    
}
