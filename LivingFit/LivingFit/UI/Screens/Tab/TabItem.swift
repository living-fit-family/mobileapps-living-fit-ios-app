//
//  TabItem.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/10/23.
//

import SwiftUI

struct TabItemView: View {
    @Binding var selected: Tab
    let tab: Tab
    let width, height: CGFloat
    
    var body: some View {
        VStack {
            Image(tab.image)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
                .padding(.top, 10)
            Text(tab.rawValue)
                .font(.footnote)
            Spacer()
        }
        .padding(.horizontal, -4)
        .onTapGesture {
            selected = tab
        }
        .foregroundColor(selected == tab ? .green: .gray)
    }
}

struct TabItemView_Previews: PreviewProvider {
    static var previews: some View {
        TabItemView(selected: .constant(.home), tab: .home, width: 80, height: 80)
    }
}
