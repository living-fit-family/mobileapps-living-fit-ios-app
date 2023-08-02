//
//  CategoryItem.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/29/23.
//

import SwiftUI

struct CategoryItem: View {
    @State private var selected: Bool = false
    @State var showSheet = false

    var nutrition: Nutrition
    
    
    var body: some View {
        VStack(alignment: .leading) {
            nutrition.image
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
                .onTapGesture {
                    showSheet.toggle()
                }
                .sheet(isPresented: $showSheet) {
                    nutrition.image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
//                        .presentationDetents([.medium, .large])
//                        .presentationDragIndicator(.automatic)
                }
        }
        .padding(.leading, 15)
    }
}


struct CategoryItem_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItem(nutrition: ModelData().nutritions[0])
    }
}
