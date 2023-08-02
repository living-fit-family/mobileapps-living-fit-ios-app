//
//  NutritionView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/2/23.
//

import SwiftUI

struct NutritionView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        NavigationStack {
            DonutChart()
            List {
                ForEach(modelData.categories.keys.sorted(), id: \.self) { key in
                    CategoryRow(categoryName: key, items: modelData.categories[key]!)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("My Nutrition")
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
                .environmentObject(ModelData())
        }
    }
}
