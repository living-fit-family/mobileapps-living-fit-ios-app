//
//  ForgotPasswordView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var didSend = false
    @StateObject private var vm = ResetPasswordViewModelImpl(service: AuthServiceImpl(authRepository: FirebaseAuthRepositoryAdapter()))
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Please enter your email below to receive your password reset code.")
                        .font(.body)
                        .foregroundColor(Color(hex: "3A4750"))
                }
            }
            Spacer()
            VStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("Email")
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "3A4750"))
                    TextFieldView(input: $vm.email, placeholder: "example@mail.com", keyboardType: .emailAddress, isSecure: false)
                }

                VStack {
                    ButtonView(title: "Send Reset Link") {
                        vm.sendPasswordReset()
                        didSend.toggle()
                    }
                    .alert("Success", isPresented: $didSend) {
                        NavigationLink(destination: SignInView()) {
                            Text("Continue")
                        }
                    } message: {
                        Text("Password reset link sent to \(vm.email)  ")
                    }
                }.padding(.vertical)
                Spacer()
            }
        }
        .padding()
        .navigationTitle("Forgot Password")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ResetPasswordView()
        }
    }
}
