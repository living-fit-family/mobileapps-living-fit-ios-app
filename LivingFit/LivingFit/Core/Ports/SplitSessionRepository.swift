//
//  SplitSessionRespository.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/19/23.
//

import Combine
import Foundation

struct CompletedWorkout {
    var day: String
    var categoriesCompleted: [String: Int]
}

protocol SplitSessionRepository {
    func fetchCurrentSplit() -> AnyPublisher<Split, Error>
    func addUserWorkout(uid: String, day: String, workout: [Workout]) -> AnyPublisher<Void, Error>
    func deleteUserWorkout(uid: String, day: String) -> AnyPublisher<Void, Error>
    func updateCompletedWorkouts(uid: String, completedWorkout: CompletedWorkout) -> AnyPublisher<Void, Error>
}
