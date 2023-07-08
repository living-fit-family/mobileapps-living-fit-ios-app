//
//  NutritionView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/2/23.
//

import SwiftUI

struct NutritionView: View {
    var body: some View {
        VStack {
            DonutChart()
            
            Spacer()
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
