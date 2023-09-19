//
//  LFTextFieldStyle.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/9/23.
//

import SwiftUI

struct LFTextFieldStyle: TextFieldStyle {    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(maxWidth: .infinity, maxHeight: 48)
            .padding(.leading, 16)
            .cornerRadius(5)
            .overlay(RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(Color(uiColor: .systemGray5), lineWidth: 1))
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
    }
}
