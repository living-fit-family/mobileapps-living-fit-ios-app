//
//  SplitSessionRespository.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/19/23.
//

import Combine
import Foundation

protocol SplitSessionRepository {
    func fetchCurrentSplit() -> AnyPublisher<Split, Error>
    func addUserWorkout(uid: String, day: String, workout: [Workout]) -> AnyPublisher<Void, Error>
}
