//
//  DonutChart.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/2/23.
//

import SwiftUI

struct DonutChart: View {
    @State private var chartModelData = ChartModelData.sample
    @State private var selectedSlice = -1
    var body: some View {
        HStack(spacing : 30) {
            ZStack {
                ForEach(0..<chartModelData.count, id: \.self) { index in
                    Circle()
                        .trim(from: index == 0 ? 0.0 : chartModelData[index-1].slicePercent, to: chartModelData[index].slicePercent)
                        .stroke(chartModelData[index].color, lineWidth: 30)
                        .onTapGesture {
                            selectedSlice = selectedSlice == index ? -1 : index
                        }
                        .scaleEffect(index == selectedSlice ? 1.1 : 1.0)
                        .animation(.spring(), value: selectedSlice)
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
                        Text("1709 kcal")
                            .font(.subheadline)
                    }
                }
            }
            .frame(width: 180, height: 230)
            
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
        .onAppear {
            setUpChartData()
        }
    }
    private func setUpChartData() {
        let total: CGFloat = chartModelData.reduce(0.0) {$0 + $1.value}
        for i in 0..<chartModelData.count {
            let percentage = (chartModelData[i].value / total)
            chartModelData[i].slicePercent = (i == 0 ? 0.0 : chartModelData[i - 1].slicePercent) + percentage
            let calories = chartModelData[i].title == "Fat" ? chartModelData[i].value * 9 : chartModelData[i].value * 4
            chartModelData[i].macroPercent = calories / 3250
        }
    }
}

struct DonutChart_Previews: PreviewProvider {
    static var previews: some View {
        DonutChart()
    }
}
