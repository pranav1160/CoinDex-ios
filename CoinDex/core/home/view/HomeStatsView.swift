//
//  HomeStatsView.swift
//  CoinDex
//
//  Created by Pranav on 06/09/25.
//

import SwiftUI

struct HomeStatsView: View {
    
    @Binding var showPortfolio:Bool
    @EnvironmentObject var homeVM:HomeViewModel
    
    var body: some View {
        HStack{
            ForEach(homeVM.statistics) { statistic in
                StatisticView(stat: statistic)
                    .frame(width: UIScreen.main.bounds.width/3)
            }
        }
        .frame(
            width: UIScreen.main.bounds.width,
            alignment: showPortfolio ? .trailing : .leading
        )
    }
}

struct HomeStats_Preview:PreviewProvider {
    static var previews: some View{
        HomeStatsView(showPortfolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}
