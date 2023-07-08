//
//  MyPlanViewModel.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/8/23.
//

import Combine
import Foundation

enum WorkoutState {
    case failure(err: Error)
    case success
    case na
}

class MyPlanViewModel: ObservableObject {
    @Published private(set) var workout: Workout? = nil
    @Published var state: WorkoutState = .na
    private var subscriptions = Set<AnyCancellable>()
    
    private var service: WorkoutService
    
    private static var instance: MyPlanViewModel? = nil
    
    private init() {
        service = WorkoutServiceImpl(workoutRepository: FirebaseWorkoutRespositoryAdapter())
        Task.init {
            await fetchCurrentSplit()
        }
    }
    
    public static func getInstance() -> MyPlanViewModel? {
        if (instance == nil) {
            instance = MyPlanViewModel()
        }
        return instance
    }
    
    func fetchCurrentSplit() async {
        if (workout == nil) {
            service.fetchCurrentSplit()
                .sink { res in
                    switch res {
                    case .failure(let err):
                        self.state = .failure(err: err)
                    default: break
                    }
                } receiveValue: { value in
                    self.state = .success
                    self.workout = value
                }.store(in: &subscriptions)
        }
    }
}

