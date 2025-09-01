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
    
    var body: some View {
        ZStack {
            Color.theme.backGround.ignoresSafeArea()
            VStack{
                header
                Spacer(minLength: 0)
                
            }
           
            
        }
    }
    
    
    
    
}

#Preview {
    HomeView()
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
}
