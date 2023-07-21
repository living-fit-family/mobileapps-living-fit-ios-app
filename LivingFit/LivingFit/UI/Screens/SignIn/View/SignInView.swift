//
//  SignInView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/9/23.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var email: String = ""
    @State var password: String = ""
    @State var showPassword: Bool = false
    @StateObject private var vm = SignInViewModelImpl(service: AuthServiceImpl(authRepository: FirebaseAuthRepositoryAdapter()))
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("Email")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "3A4750"))
                        TextFieldView(input: $email, placeholder: "example@mail.com", keyboardType: .emailAddress, isSecure: false)
                    }
                    VStack(alignment: .leading) {
                        Text("Password")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "3A4750"))
                        HStack {
                            if !showPassword {
                                TextFieldView(input: $password, placeholder: "Password", keyboardType: .default, isSecure: true)
                            } else {
                                TextFieldView(input: $password, placeholder: "Password", keyboardType: .default, isSecure: false)
                            }
                        }
                        .overlay(alignment: .trailing) {
                            Image(showPassword ? "show" : "hide")
                                .resizable()
                                .frame(width: 24, height: 26)
                                .opacity(0.60)
                                .onTapGesture {
                                    showPassword.toggle()
                                }
                                .padding()
                        }
                    }
                    HStack {
                        Spacer()
                        NavigationLink(destination: ResetPasswordView()) {
                            Text("Forgot Password?")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        ButtonView(title: "Sign In") {
                            vm.signIn(email: email, password: password)
                        }
                        HStack {
                            Text("By signing in you agree to our ") +
                            Text("Terms of Service ")
                                .underline()
                                .foregroundColor(.green) +
                            Text("and ") +
                            Text("Privacy Policy")
                                .underline()
                                .foregroundColor(.green)
                        }
                        .font(.subheadline)
                        .padding(.horizontal)
                        .multilineTextAlignment(.leading)
                    }
                    .padding(.top)
                }
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "multiply")
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationTitle("Sign in to Living Fit")
            .alert(isPresented: $vm.hasError) {
                if case .failure(let error) = vm.state {
                    return Alert(title: Text("Error"), message: Text(error.localizedDescription))
                } else {
                    return Alert(title: Text("Error"), message: Text("Something went wrong."))
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .padding()
        }

    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            SignInView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        }
    }
}
