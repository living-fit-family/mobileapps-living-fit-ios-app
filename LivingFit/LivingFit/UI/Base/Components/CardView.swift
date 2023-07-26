//
//  CardView.swift
//  LivingFit
//
//  Created by ALEXANDER CLEONI on 3/31/23.
//

import SwiftUI

struct CardData: Identifiable {
    let id: UUID
    let title: String
    let description: String?
    
    internal init(id: UUID = UUID(), title: String, description: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
    }
}

struct CardView: View {
    @Binding var selected: UUID
    var cardData: CardData
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("\(cardData.title)")
                        .font(.headline)
                    if let description = cardData.description {
                        Text("\(description)")
                            .font(.subheadline)
                            .opacity(0.70)
                    }
                }
                Spacer()
                Circle()
                    .stroke(selected == cardData.id ? .green : Color(hex: "D8DADC"), lineWidth: 1)
                    .frame(width: 20, height: 20)
                    .overlay {
                        if (selected == cardData.id) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 11))
                                .fontWeight(.medium)
                                .foregroundColor(.green)
                        }
                    }
            }
            .contentShape(RoundedRectangle(cornerRadius: 16))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 84)
            .onTapGesture {
                if selected != cardData.id {
//                    HapticsManager.shared.selectionVibrate()
                    selected = cardData.id;
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selected == cardData.id ? .green : Color(hex: "D8DADC"), lineWidth: 1)
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let cardData = CardData(title: "One Month", description: "$39.99 / mo")
        CardView(selected: .constant(UUID()), cardData: cardData).padding()
    }
}
