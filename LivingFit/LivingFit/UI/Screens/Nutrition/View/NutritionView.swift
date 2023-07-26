//
//  NutritionView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/2/23.
//

import SwiftUI

struct NutritionView: View {
    var body: some View {
        NavigationStack {
            VStack {
                DonutChart()
                Spacer()
            }
            .navigationTitle("Nutrition")
        }
        .tabItem {
            Label("Nutrition", systemImage: "chart.pie")
        }
    }
}

struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NutritionView()
        }
    }
}
