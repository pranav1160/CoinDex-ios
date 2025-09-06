//
//  StatisticView.swift
//  CoinDex
//
//  Created by Pranav on 06/09/25.
//

import SwiftUI

struct StatisticView: View {
    let stat:Statistic
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            HStack(spacing:2){
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: stat.percentageChange ?? 0 >= 0 ?  0 : 180)
                    )
                
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
            }
            .opacity(stat.percentageChange == nil ? 0 : 1)
            .foregroundStyle(
                stat.percentageChange ?? 0 >= 0 ? Color.theme.appGreen : Color.theme.appRed
            )
            
        }
    }
}



struct StatisticView_Preview:PreviewProvider{
    static var previews: some View{
        Group{
            HStack{
                StatisticView(stat: dev.stat1)
                Spacer()
                StatisticView(stat: dev.stat2)
                Spacer()
                StatisticView(stat: dev.stat3)
            }
            .padding()
        }
    }
}
