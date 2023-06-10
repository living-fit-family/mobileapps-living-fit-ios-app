//
//  TextFieldView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/9/23.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var input: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    
    var body: some View {
        if isSecure {
            VStack(alignment: .leading) {
                SecureField(placeholder, text: $input)
                    .textFieldStyle(LFTextFieldStyle())
                    .font(.body)
                    .keyboardType(keyboardType)
                    .textContentType(.password)
            }
        } else {
            VStack(alignment: .leading) {
                TextField(placeholder, text: $input)
                    .textFieldStyle(LFTextFieldStyle())
                    .font(.body)
                    .keyboardType(keyboardType)
            }
        }

    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TextFieldView(input: .constant(""), placeholder: "johnsmith@gmail.com" , keyboardType: .emailAddress, isSecure: false)
                .preview(with: "Input Text Field")
        }
    }
}
