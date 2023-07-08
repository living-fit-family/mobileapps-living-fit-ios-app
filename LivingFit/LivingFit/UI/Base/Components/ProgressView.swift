//
//  ProgressView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/24/23.
//

import SwiftUI

struct LFProgressView: View {
    var body: some View {
        VStack(spacing: 1) {
            ForEach(1..<6) { num in
                Circle()
                    .fill(.green)
//                    .strokeBorder(.green, lineWidth: 1)
                    .frame(width: 20, height: 20)
                    .overlay {
                        Image(systemName: "checkmark")
                            .resizable()
                            .foregroundColor(.white)
                            .fontWeight(.bold)
//                            .scaledToFit()
                            .padding(7)
                    }
                if (num < 5) {
                    Divider()
                        .frame(width: 2, height: 83)
                        .background(.green)
                }
            }
        }
    }
}

struct LFProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
