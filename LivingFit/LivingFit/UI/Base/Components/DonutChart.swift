//
//  DonutChart.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/2/23.
//

import SwiftUI



struct DonutChart: View {
    @State private var selectedSlice = -1
    var chartModelData: [ChartModelData] = []
    var totalCalories: String = ""
    
    var body: some View {
        HStack(spacing : 30) {
            ZStack {
                ForEach(0..<chartModelData.count, id: \.self) { index in
                    Circle()
                        .trim(from: index == 0 ? 0.0 : chartModelData[index-1].slicePercent, to: chartModelData[index].slicePercent)
                        .stroke(chartModelData[index].color, lineWidth: 30)
                }
                if selectedSlice != -1 {
                    VStack {
                        Text(chartModelData[selectedSlice].title)
                            .font(.headline)
                        Text(String(format: "%.0fg", Double(chartModelData[selectedSlice].value))+"")
                            .font(.subheadline)
                    }
                } else {
                    VStack {
                        Text("Total Calories")
                            .font(.headline)
                        Text("\(totalCalories) kcal")
                            .font(.subheadline)
                    }
                }
            }
            
            VStack(alignment: .leading) {
                ForEach(chartModelData) { datum in
                    HStack {
                        Circle()
                            .foregroundStyle(datum.color.gradient)
                            .frame(width: 20, height: 20)
                        Text(datum.title)
                        Text("\(Int(round(datum.value)))g")
                    }
                }
            }
        }
    }
}

struct DonutChart_Previews: PreviewProvider {
    static var previews: some View {
        DonutChart(chartModelData: [], totalCalories: "2000")
    }
}
