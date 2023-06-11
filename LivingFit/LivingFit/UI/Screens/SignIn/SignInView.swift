//
//  SignInView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/9/23.
//

import SwiftUI

struct SignInView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var showPassword: Bool = false
    @StateObject private var vm = SignInViewModel(service: AuthServiceImpl(authRepository: FirebaseAuthRepositoryAdapter()))
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Hi, Welcome Back! 👋")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("Please log in to your account")
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
                VStack(alignment: .leading) {
                    Text("Password")
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "3A4750"))
                    HStack {
                        if !showPassword {
                            TextFieldView(input: $password, placeholder: "Password", keyboardType: .asciiCapable, isSecure: true)
                        } else {
                            TextFieldView(input: $password, placeholder: "Password", keyboardType: .asciiCapable, isSecure: false)
                        }
                    }.overlay(alignment: .trailing) {
                        Image(showPassword ? "show" : "hide")
                            .resizable()
                            .frame(width: 24, height: 26)
                            .opacity(0.60)
                            .onTapGesture {
                                showPassword.toggle()
                            }.padding(.horizontal)
                    }
                }
                HStack {
                    Spacer()
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot Password?")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                }
                VStack {
                    ButtonView(title: "Sign In") {
                        print("here")
                        vm.signIn(email: email, password: password)
                    }.padding(.vertical)
                }
                Spacer()
                HStack {
                    Text("By signing in you agree to our ") +
                    Text("Terms of Service ")
                        .foregroundColor(.green) +
                    Text("and ") +
                    Text("Privacy Policy")
                        .foregroundColor(.green)
                }
                .font(.subheadline)
                .multilineTextAlignment(.center)
            }
        }
        .padding()
        .ignoresSafeArea(.keyboard)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInView()
        }
    }
}
