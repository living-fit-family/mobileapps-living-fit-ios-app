//
//  ButtonView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/9/23.
//

import SwiftUI

struct ButtonView: View {
    typealias ActionHandler = () -> Void
    
    let title: String
    let background: Color
    let foreground: Color
    let border: Color
    let handler: ActionHandler
    
    private let cornerRadius: CGFloat = 5
    
    internal init(title: String, background: Color = Color(hex: "#55C856"), foreground: Color = .white, border: Color = .clear, handler: @escaping ButtonView.ActionHandler) {
        self.title = title
        self.background = background
        self.foreground = foreground
        self.border = border
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler, label: {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(background)
                .foregroundColor(foreground)
                .font(.title3)
                .cornerRadius(cornerRadius)
                .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(border, lineWidth: 2))
                .shadow(color: background.opacity(0.25), radius: 8, x: 0, y: 4)
        })
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ButtonView(title: "Primary Button") {
                
            }
            .preview(with: "Primary Button View")
            
            ButtonView(title: "Secondary Button", background: .clear, foreground: Color(hex: "55C856"), border: .green) {
                
            }
            .preview(with: "Secondary Button View")
        }
    }
}
