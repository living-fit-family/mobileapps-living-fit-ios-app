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
    
    func updateCompletedWorkouts(uid: String, completedWorkout: CompletedWorkout) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                
                var newTotal = 0
                
                let docRef = Firestore
                    .firestore()
                    .collection("users").document(uid)
                    .collection("workouts")
                    .document("completed")
                
                docRef
                    .getDocument { snapshot, err in
                        if let snapshot = snapshot {
                            guard let data = snapshot.data() else {
                                print("Document data was empty.")
                                docRef
                                    .setData([
                                        completedWorkout.day: completedWorkout.completed,
                                        "total": completedWorkout.completed == true ? newTotal + 1 : newTotal
                                    ]) { err in
                                        if let err = err {
                                            print("Error writing document: \(err)")
                                            //                                            promise(.failure(err))
                                        } else {
                                            print("Document successfully written!")
                                            //                                            promise(.success(()))
                                        }
                                        
                                    }
                                return
                            }
                            
                            if let total = data["total"] as? Int {
                                newTotal = total
                                if let completed = data[completedWorkout.day] as? Bool {
                                    // Don't exceed total exercises
                                    if (completed == false) {
                                        docRef
                                            .updateData([
                                                completedWorkout.day: completedWorkout.completed,
                                                "total": newTotal + 1
                                            ]) { err in
                                                if let err = err {
                                                    print("Error writing document: \(err)")
                                                } else {
                                                    print("Document successfully written!")
                                                }
                                                
                                            }
                                    }
                                } else {
                                    docRef
                                        .updateData([
                                            completedWorkout.day: completedWorkout.completed,
                                            "total": completedWorkout.completed == true ? newTotal + 1 : newTotal
                                        ]) { err in
                                            if let err = err {
                                                print("Error writing document: \(err)")
                                            } else {
                                                print("Document successfully written!")
                                            }
                                            
                                        }
                                }
                            }
                        } else {
                            docRef
                                .setData([
                                    completedWorkout.day: completedWorkout.completed,
                                    "total": completedWorkout.completed == true ? newTotal + 1 : newTotal
                                ]) { err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                    } else {
                                        print("Document successfully written!")
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



