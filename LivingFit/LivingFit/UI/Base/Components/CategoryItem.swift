//
//  CategoryItem.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/29/23.
//

import SwiftUI
import PopupView

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
                .popup(isPresented: $showSheet) {
                    nutrition.image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                } customize: {
                    $0
                        .type(.floater())
                        .position(.center)
                        .animation(.spring())
                        .closeOnTapOutside(true)
                        .backgroundColor(.black.opacity(0.5))
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
