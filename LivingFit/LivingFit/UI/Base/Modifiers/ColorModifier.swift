//
//  ColorModifier.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/9/23.
//

import SwiftUI

extension Color {
    static let colorPrimary: Color = Color(hex: "55C855")
    
    init(hex: String, alpha: Double = 1) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r = (int & 0xff0000) >> 16
        let g = (int & 0xff00) >> 8
        let b = int & 0xff
        
        self.init(
            .sRGB,
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff,
            opacity: alpha
        )
    }
}
