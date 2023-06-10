//
//  UserService.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/10/23.
//

import Combine
import Foundation

protocol SignInServiceProtocol {
    func signIn(email: String, password: String) -> AnyPublisher<Void, Error>
}

final class SignInServiceImpl: SignInServiceProtocol {
    private var userRepository: UserRepository
    
    func signIn(email: String, password: String) -> AnyPublisher<Void, Error> {
        userRepository.signIn(email: email, password: password)
    }
    
    internal init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
}
