//
//  SparklineView.swift
//  CoinDex
//
//  Created by Pranav on 18/09/25.
//


import SwiftUI

struct SparklineView: View {
    let prices: [Double]
    @State private var animate: Bool = false
    
    // Normalize data between 0 and 1
    var normalized: [CGFloat] {
        guard let min = prices.min(), let max = prices.max(), max != min else {
            return prices.map { _ in 0.5 }
        }
        return prices.map { CGFloat(($0 - min) / (max - min)) }
    }
    
    // Dynamic line color depending on price movement
    var lineColor: Color {
        guard let first = prices.first, let last = prices.last else { return .gray }
        return last >= first ? Color.theme.appGreen : Color.theme.appRed
    }
    
    // Reference values for dividers
    var minPrice: Double { prices.min() ?? 0 }
    var maxPrice: Double { prices.max() ?? 0 }
    var midPrice: Double { (minPrice + maxPrice) / 2 }
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let stepX = width / CGFloat(max(prices.count - 1, 1)) // avoid /0
            
            // Build path
            let sparklinePath = Path { path in
                guard !normalized.isEmpty else { return }
                path.move(to: CGPoint(x: 0, y: (1 - normalized[0]) * height))
                for i in 1..<normalized.count {
                    path.addLine(to: CGPoint(
                        x: CGFloat(i) * stepX,
                        y: (1 - normalized[i]) * height
                    ))
                }
            }
            
            ZStack(alignment: .leading) {
                // Background grid lines
                VStack {
                    Divider().background(Color.gray.opacity(0.4))
                    Spacer()
                    Divider().background(Color.gray.opacity(0.4))
                    Spacer()
                    Divider().background(Color.gray.opacity(0.4))
                }
                
                // Gradient fill under line
                sparklinePath
                    .trim(from: 0, to: animate ? 1 : 0)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                lineColor.opacity(0.3),
                                .clear
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                // Line stroke
                sparklinePath
                    .trim(from: 0, to: animate ? 1 : 0)
                    .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
                
                // Price labels (left aligned)
                VStack {
                    Text(String(format: "%.2f", maxPrice))
                        .font(.caption2).foregroundColor(.secondary)
                    Spacer()
                    Text(String(format: "%.2f", midPrice))
                        .font(.caption2).foregroundColor(.secondary)
                    Spacer()
                    Text(String(format: "%.2f", minPrice))
                        .font(.caption2).foregroundColor(.secondary)
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 1.8)) {
                    animate = true
                }
            }
        }
    }
}

struct Spark_Previews: PreviewProvider {
    static var previews: some View {
        SparklineView(prices: dev.coin.sparklineIn7D?.price ?? [])
            .frame(height: 120)
            .padding()
    }
}
