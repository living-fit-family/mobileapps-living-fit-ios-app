//
//  WorkoutRepository.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/8/23.
//

import Combine
import Foundation

protocol WorkoutRepository {
    func fetchCurrentSplit() -> AnyPublisher<Workout, Error>
}
