//
//  RadioButton.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/4/23.
//

import SwiftUI

struct RadioButton: View {
    let id: String
    let label: String
    let symbol: String?
    let width: CGFloat
    let height: CGFloat
    let isSelected: Bool;
    let callback: (String) -> ()
    
    init(id: String, label: String, symbol: String? = nil, width: CGFloat = 150, height: CGFloat = 150, isSelected: Bool = false, callback: @escaping (String) -> Void) {
        self.id = id
        self.label = label
        self.width = width
        self.height = height
        self.isSelected = isSelected
        self.symbol = symbol
        self.callback = callback
    }
    
    @ViewBuilder func getRadioButtonType() -> some View {
        switch self.isSelected {
        case true:
            Circle()
                .fill(Color(hex: "55C856"))
                .frame(width: self.width, height: self.height)
                .shadow(color: .green, radius: 20, x: 0, y: 10)
        case false:
            Circle()
                .fill(Color(hex: "B9B9B9"))
                .frame(width: self.width, height: self.height)
        }
    }
    
    var body: some View {
        Button(action: {
            self.callback(self.id)
        }) {
            ZStack {
                getRadioButtonType()
                VStack {
                    if let symbol {
                        Image(symbol)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                    }
                    Text(label.capitalized)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
        }
//        .buttonStyle(LFPrimitiveButtonStyle())
        .disabled(self.isSelected ? true : false)
    }
}

struct RadioButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RadioButton(id: "0", label: "male", symbol: "male") { id in
                print("id \(id)")
            }.preview(with: "Radio Button Male")
            
            RadioButton(id: "1", label: "female", symbol: "female") { id in
                print("id \(id)")
            }.preview(with: "Radio Button Female")
        }
    }
}

