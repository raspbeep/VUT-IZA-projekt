//
//  ColorExtension.swift
//  iza
//
//  Created by Pavel Kratochvil on 26.04.2022.
//

import SwiftUI

extension Color {
    public init(decimalRed red: Double, green: Double, blue: Double) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255)
    }
    
    public static var flatDarkCardBackground: Color {
        return Color(decimalRed: 46, green: 46, blue: 46)
    }
    
    public static var lightRedCard: Color {
        return Color(decimalRed: 255, green: 204, blue: 203)
    }
    
    public static var lightGreenCard: Color {
        return Color(decimalRed: 210, green: 248, blue: 208)
    }
    
    public static var lightRedError: Color {
        return Color(decimalRed: 255, green: 114, blue: 118)
    }
}
