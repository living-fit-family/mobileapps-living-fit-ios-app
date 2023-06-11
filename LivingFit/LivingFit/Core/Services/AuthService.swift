//
//  AuthService.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/10/23.
//

import Combine
import Foundation

protocol AuthServiceProtocol {
    func signIn(email: String, password: String) -> AnyPublisher<Void, Error>
}

final class AuthServiceImpl: AuthServiceProtocol {
    private var authRepository: AuthRepository
    
    internal init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<Void, Error> {
        authRepository.signIn(email: email, password: password)
    }
    
    func signOut() {
        authRepository.signOut()
    }
}
