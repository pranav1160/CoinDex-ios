//
//  SearchBarView.swift
//  CoinDex
//
//  Created by Pranav on 06/09/25.
//

/*
 bind it to homeview
 make the keyboard disappear when xbutton is clicked
 */

import SwiftUI

struct SearchBarView: View {
    @Binding  var searchText:String
    @FocusState private var isFocused: Bool
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchText.isEmpty ? Color.theme.secondaryText :Color.theme.accent
                )
            TextField("Search by name or symbol...", text: $searchText)
                .focused($isFocused)
                .foregroundColor(Color.theme.accent)
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(Color.theme.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            isFocused=false
                            searchText = ""
                        }
                    
                    ,alignment: .trailing
                )
            
        }
        .font(.headline)
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.backGround)
                .shadow(color: Color.theme.accent.opacity(0.4), radius: 10)
                
                       
        }
        .padding()
    }
}

#Preview {
    Group{
        SearchBarView(searchText: .constant(""))
            .colorScheme(.light)
    
        SearchBarView(searchText: .constant(""))
            .colorScheme(.dark)
        
    }
}
