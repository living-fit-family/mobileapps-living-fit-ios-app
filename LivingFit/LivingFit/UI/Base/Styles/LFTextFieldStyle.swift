//
//  LFTextFieldStyle.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/9/23.
//

import SwiftUI

struct LFTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(maxWidth: .infinity, maxHeight: 54)
            .padding(.leading, 16)
            .background(Color(hex: "F5F5F5"))
            .cornerRadius(5)
            .overlay(RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(Color(hex: "696969", alpha: 0.25)))
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .focused($isFocused)
            .onTapGesture {
                isFocused = true;
            }
    }
}
