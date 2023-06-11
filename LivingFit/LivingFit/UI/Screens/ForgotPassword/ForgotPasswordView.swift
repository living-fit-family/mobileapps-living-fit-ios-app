//
//  ForgotPasswordView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/10/23.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State var email: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Forgot Password")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("Please enter your email below to receive your password reset code.")
                        .font(.body)
                        .foregroundColor(Color(hex: "3A4750"))
                }
                Spacer()
            }
            Spacer()
            VStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("Email")
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "3A4750"))
                    TextFieldView(input: $email, placeholder: "example@mail.com", keyboardType: .emailAddress, isSecure: false)
                }

                VStack(spacing: 16) {
                    ButtonView(title: "Send Code") {
                        
//                        vm.signIn(email: email, password: password)
                    }
                    ButtonView(title: "Go Back", background: .clear, foreground: Color(hex: "55C856"), border: .green) {
                        
                    }
                }.padding(.vertical)
                Spacer()
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.keyboard)
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
