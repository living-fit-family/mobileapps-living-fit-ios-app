//
//  SignInViewModel.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/11/23.
//

import Combine
import Foundation

enum AuthState {
    case failure(err: Error)
    case success
    case na
}

class SignInViewModel: ObservableObject {
    private var service: AuthService
    @Published var state: AuthState = .na
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: AuthService) {
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
