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
    var body: some View {
        ZStack {
            Color.theme.backGround.ignoresSafeArea()
            
            VStack{
                
                header
                
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
                    iconName:  showPortfolio ? "info" : "person"
                )
                .transaction { transaction in
                    transaction.animation = nil
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
                    ForEach(homeVm.allCoins){coin in
                        CoinRowView(coin: coin,showPortFolio: true)
                            .listRowInsets(EdgeInsets())
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
                            .padding(.vertical,6)
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
