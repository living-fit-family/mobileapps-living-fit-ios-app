//
//  FirebaseUserRepository.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/8/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine

class FirebaseUserRepository {
    func updateName(uid: String, username: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Firestore.firestore()
                    .collection("users").document(uid)
                    .updateData(
                        [
                            "username": username,
                        ]
                    ) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                            promise(.failure(err))
                        } else {
                            print("Document successfully written!")
                            promise(.success(()))
                        }
                        
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func updateMacroNutrientInfo(uid: String, userDetails: UserDetail) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Firestore.firestore()
                    .collection("users").document(uid)
                    .updateData(
                        [
                            "gender": userDetails.gender.rawValue,
                            "birthDate": userDetails.birthDate,
                            "height": userDetails.height,
                            "weight": userDetails.weight,
                            "goal": userDetails.goal.rawValue,
                            "totalCalories": userDetails.totalCalories,
                        ]
                    ) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                            promise(.failure(err))
                        } else {
                            print("Document successfully written!")
                            promise(.success(()))
                        }
                        
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
