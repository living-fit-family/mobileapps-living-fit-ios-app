//
//  FirebaseWorkoutRepositoryAdapter.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/8/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirebaseSplitSessionRespositoryAdapter: SplitSessionRepository {
    func fetchCurrentSplit() -> AnyPublisher<Split, Error> {
        Deferred {
            Future { promise in
                Firestore
                    .firestore()
                    .collection("splits").document("current").getDocument { (document, err) in
                        if let error = err as NSError? {
                            print(error)
                            promise(.failure(error))
                        } else {
                            if let document = document {
                                do {
                                    let currentSplit = try document.data(as: Split.self)
                                    promise(.success(currentSplit))
                                }
                                catch {
                                    print(error)
                                    promise(.failure(error))
                                }
                            }
                        }
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func addUserWorkout(uid: String, day: String, workout: [Workout]) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                do {
                    try Firestore.firestore()
                        .collection("users").document(uid)
                        .collection("workouts")
                        .document(day).setData(from: WorkoutRoutine(workouts: workout))
                } catch let error {
                    print(error)
                    promise(.failure(error))
                }
                promise(.success(()))
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func deleteUserWorkout(uid: String, day: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Firestore.firestore()
                    .collection("users").document(uid)
                    .collection("workouts")
                    .document(day).delete() {error in
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



