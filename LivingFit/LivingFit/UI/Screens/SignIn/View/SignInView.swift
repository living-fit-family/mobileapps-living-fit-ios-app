//
//  SignInView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/9/23.
//

import SwiftUI

enum LoginField: Hashable {
    case email
    case password
}

struct SignInView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var isPresentWebView: Bool = false
    
    @State private var showPrivacyPolicy: Bool = false
    @State private var showTermsOfService: Bool = false
    
    var privacyPolicy = "https://app.termly.io/document/privacy-policy/8fda4592-f666-4715-9086-b9985d880dfa"
    
    var termsOfService = "https://app.termly.io/document/terms-of-service/add938b1-59ab-4529-8741-e60383f45ce5"
    
    @StateObject private var vm = SignInViewModelImpl(service: AuthServiceImpl(authRepository: FirebaseAuthRepositoryAdapter()))
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("Email")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(hex: "3A4750"))
                    TextFieldView(input: $email, placeholder: "example@mail.com", keyboardType: .emailAddress, isSecure: false)
                }
                VStack(alignment: .leading) {
                    Text("Password")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(hex: "3A4750"))
                    HStack {
                        if !showPassword {
                            TextFieldView(input: $password, placeholder: "Password", keyboardType: .default, isSecure: true)
                        } else {
                            TextFieldView(input: $password, placeholder: "Password", keyboardType: .default, isSecure: false)
                        }
                    }
                    .overlay(alignment: .trailing) {
                        Image(systemName: showPassword ? "eye" : "eye.slash")
                            .resizable()
                            .frame(width: 18, height: 15)
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
                            .foregroundStyle(.black)
                    }
                }
                VStack(alignment: .center, spacing: 16) {
                    ButtonView(title: "Sign In") {
                        vm.signIn(email: email, password: password)
                    }
                    VStack(alignment: .leading) {
                        HStack(spacing: 4) {
                            Text("By continuing, you agree to our")
                                .font(.caption)
                            
                            Button(action: {
                                showTermsOfService.toggle()
                            }) {
                                Text("Terms of Service (EULA)")
                                    .font(.caption)
                                    .foregroundStyle(Color(hex: "#55C856"))
                                    .underline()
                            }
                            .sheet(isPresented: $showTermsOfService, content: {
                                WebView(url: URL(string: termsOfService)!)
                            })
                        }
                        
                        HStack(spacing: 4) {
                            Text("and")
                                .font(.caption)
                            
                            Button(action: {
                                showPrivacyPolicy.toggle()
                            }) {
                                Text("Privacy Policy.")
                                    .font(.caption)
                                    .foregroundStyle(Color(hex: "#55C856"))
                                    .underline()
                            }
                            .sheet(isPresented: $showPrivacyPolicy, content: {
                                WebView(url: URL(string: privacyPolicy)!)
                            })
                        }
                    }
                }
                .padding(.top)
                Spacer()
            }
            .padding()
            .ignoresSafeArea(.keyboard)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "multiply")
                            .foregroundStyle(.black)
                    }
                }
            }
            .navigationTitle("Sign in to Living Fit")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $vm.hasError) {
                if case .failure(let error) = vm.state {
                    return Alert(title: Text("Error"), message: Text(error.localizedDescription))
                } else {
                    return Alert(title: Text("Error"), message: Text("Something went wrong."))
                }
            }
            .sheet(isPresented: $isPresentWebView, onDismiss: {
                showPrivacyPolicy = false
                showTermsOfService = false
            }) {
                if (showPrivacyPolicy) {
                    WebView(url: URL(string: privacyPolicy)!)
                        .ignoresSafeArea()
                } else {
                    WebView(url: URL(string: termsOfService)!)
                        .ignoresSafeArea()
                }

            }
            .navigationBarBackButtonHidden(true)
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
