//
//  UserRepository.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/10/23.
//

import Combine
import Foundation

protocol UserRepository {
    func signIn(email: String, password: String  ) -> AnyPublisher<Void, Error>
}
