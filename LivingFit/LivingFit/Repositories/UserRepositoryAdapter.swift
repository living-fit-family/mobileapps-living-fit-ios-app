//
//  UserRepositoryAdapter.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/10/23.
//

import Foundation


import Combine
import Foundation
import FirebaseAuth

final class UserRepositoryAdapter: UserRepository {
    func signIn(email: String, password: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth
                    .auth()
                    .signIn(withEmail: email, password: password) { res, error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
