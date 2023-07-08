//
//  ChartModelData.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/2/23.
//

import Foundation
import SwiftUI

struct ChartModelData: Identifiable {
    var id = UUID()
    var color: Color
    var slicePercent: CGFloat = 0.0
    var macroPercent: CGFloat = 0.0
    var value: CGFloat
    var title: String
}

extension ChartModelData {
    static var sample: [ChartModelData] {
        [
            ChartModelData(color: .red, value: 325, title: "Protein"),
            ChartModelData(color: .green, value: 72, title: "Fat"),
            ChartModelData(color: .blue, value: 325, title: "Carbs"),
        ]
    }
}
