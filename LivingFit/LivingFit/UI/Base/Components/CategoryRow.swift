//
//  CategoryRow.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/29/23.
//

import SwiftUI

struct CategoryRow: View {
    var categoryName: String
    var items: [Nutrition]


    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)


            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { nutrition in
                        CategoryItem(nutrition: nutrition)
                    }
                }
            }
            .frame(height: 185)
        }
    }
}


struct CategoryRow_Previews: PreviewProvider {
    static var nutritions = ModelData().nutritions


    static var previews: some View {
        CategoryRow(
            categoryName: nutritions[0].category.rawValue,
            items: Array(nutritions.prefix(4))
        )
    }
}
