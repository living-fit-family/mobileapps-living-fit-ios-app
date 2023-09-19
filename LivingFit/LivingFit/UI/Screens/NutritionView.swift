//
//  NutritionView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/2/23.
//

import SwiftUI

struct NutritionView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var bannerService: BannerService
    @State private var isShowingPopover = false
    @State private var isShowingChart = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text("My Nutrition")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Image(systemName: "info.circle")
                        .resizable()
                        .scaledToFit()
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            bannerService.setBanner(bannerType: .info(message: "Adjust your profile to get personalized macro info", isPersistent: false))
                        }
                }
                .padding()
                VStack(alignment: .leading) {
                    
                    DonutChart(chartModelData: sessionService.chartModelData, totalCalories: sessionService.macros?.totalCalories ?? "2000")
                        .padding()
                    
                }
                .padding(.horizontal)
                List {
                    ForEach(modelData.categories.keys.sorted(), id: \.self) { key in
                        CategoryRow(categoryName: key, items: modelData.categories[key]!)
                    }
                }
                .listStyle(PlainListStyle())
            }
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
                .environmentObject(SessionServiceImpl())
                .environmentObject(BannerService())
        }
    }
}
