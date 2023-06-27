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

protocol SignInViewModel {
    func signIn(email: String, password: String)
    var service: AuthService { get }
    var state: AuthState { get }
    var hasError: Bool { get }
    init(service: AuthService)
}

final class SignInViewModelImpl: SignInViewModel, ObservableObject {
    @Published var state: AuthState = .na
    @Published var hasError: Bool = false
    
    let service: AuthService
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: AuthService) {
        self.service = service
        setUpErrorSubscriptions()
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

private extension SignInViewModelImpl {
    func setUpErrorSubscriptions() {
        $state
            .map{ state -> Bool in
                switch state {
                case .success, .na:
                    return false
                case .failure:
                    return true
                }
            }
            .assign(to: &$hasError)
    }
}
