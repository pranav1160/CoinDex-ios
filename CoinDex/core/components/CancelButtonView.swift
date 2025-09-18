//
//  CancelButtonView.swift
//  CoinDex
//
//  Created by Pranav on 07/09/25.
//


import SwiftUI

struct CancelButtonView: View {
    // Used to dismiss the current view
    @Environment(\.dismiss) private var dismiss
    var action: (() -> Void)? = nil
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                    action?()      
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .imageScale(.large)
                        .padding()
                }
                
                Spacer()
            }
            
            Spacer()
        }
    }
}

#Preview {
    CancelButtonView {
        print("crazy xyx")
    }
}
