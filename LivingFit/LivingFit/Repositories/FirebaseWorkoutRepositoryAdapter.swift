//
//  FirebaseWorkoutRepositoryAdapter.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/8/23.
//

//NNneigzut2SYf12QmCuF

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirebaseWorkoutRespositoryAdapter: WorkoutRepository {
    func fetchCurrentSplit() -> AnyPublisher<Workout, Error> {
        Deferred {
            Future { promise in
                Firestore
                    .firestore()
                    .collection("workouts").document("yC1lT9jrNvPI2UJX9Z25").getDocument { (document, err) in
                        if let error = err as NSError? {
                            print(error)
                            promise(.failure(error))
                        } else {
                            if let document = document {
                                do {
                                    let workout = try document.data(as: Workout.self)
                                    promise(.success(workout))
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
}
