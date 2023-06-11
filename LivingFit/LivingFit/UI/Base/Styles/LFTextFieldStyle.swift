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
            .frame(maxWidth: .infinity, maxHeight: 48)
            .padding(.leading, 16)
            .background(Color(hex: "F5F5F5"))
            .cornerRadius(5)
            .overlay(RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(Color(hex: "E1E1E1")))
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .focused($isFocused)
            .onTapGesture {
                isFocused = true;
            }
    }
}
