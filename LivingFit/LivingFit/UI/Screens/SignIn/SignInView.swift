//
//  SignInView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/9/23.
//

import SwiftUI
import Combine
import Foundation

enum AuthState {
    case failure(err: Error)
    case success
    case na
}

class ViewModel: ObservableObject {
    private var service: AuthServiceProtocol
    @Published var state: AuthState = .na
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: AuthServiceProtocol) {
        self.service = service
    }
    
    func signIn(email: String, password: String) {
        service.signIn(email: email, password: password)
            .sink { res in
            switch res {
            case .failure(let err):
                self.state = .failure(err: err)
            default: break
            }
        } receiveValue: { [weak self] in
            self?.state = .success
        }.store(in: &subscriptions)
    }
}

struct SignInView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var showPassword: Bool = false
    @StateObject private var vm = ViewModel(service: AuthServiceImpl(authRepository: FirebaseAuthRepositoryAdapter()))
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 16) {
                Spacer()
                VStack(alignment: .leading) {
                    Text("Email")
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "3A4750"))
                    TextFieldView(input: $email, placeholder: "johnsmith@gmail.com", keyboardType: .emailAddress, isSecure: false)
                }
                VStack(alignment: .leading) {
                    Text("Password")
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "3A4750"))
                    if !showPassword {
                        TextFieldView(input: $password, placeholder: "qYRNmq0f", keyboardType: .default, isSecure: true)
                    } else {
                        TextFieldView(input: $password, placeholder: "qYRNmq0f", keyboardType: .default, isSecure: false)
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Text("Forgot Password?")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    })
                }
                VStack {
                    ButtonView(title: "Sign In") {
                        print("here")
                        vm.signIn(email: email, password: password)
                    }
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
        .navigationTitle("Sign in to your account")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInView()
        }
    }
}
