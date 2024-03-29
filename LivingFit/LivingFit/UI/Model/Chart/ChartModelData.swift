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
    var slicePercent: Double = 0.0
    var macroPercent: Double = 0.0
    var value: Double
    var title: String
}

extension ChartModelData {
    static var sample: [ChartModelData] {
        [
            ChartModelData(color: .red, value: 104, title: "Protein"),
            ChartModelData(color: .green, value: 49, title: "Fat"),
            ChartModelData(color: .blue, value: 228, title: "Carbs"),
        ]
    }
}
