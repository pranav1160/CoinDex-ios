//
//  Color.swift
//  CoinDex
//
//  Created by Pranav on 01/09/25.
//


import Foundation
import SwiftUI

extension Color{
    static let theme = ColorTheme()
}

struct ColorTheme{
    let appRed = Color("AppRedColor")
    let appGreen = Color("AppGreenColor")
    let accent = Color("AppAccentColor")
    let backGround = Color("AddBackgroundColor")
    let secondaryText = Color("SecondaryTextColor")
}
