//
//  WorkoutSplitService.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/8/23.
//

import Combine
import Foundation

protocol WorkoutService {
    func fetchCurrentSplit() -> AnyPublisher<Workout, Error>
}

final class WorkoutServiceImpl: WorkoutService {
    private var workoutRepository: WorkoutRepository
    
    init(workoutRepository: WorkoutRepository) {
        self.workoutRepository = workoutRepository
    }
    
    func fetchCurrentSplit() -> AnyPublisher<Workout, Error> {
        workoutRepository.fetchCurrentSplit()
    }
}
