//
//  SplitSessionService.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/19/23.
//
import Foundation
import Combine

enum SplitSessionState {
    case failure(err: Error)
    case success
    case na
}

protocol SplitSessionService {
    func fetchCurrentSplit() async
}

@MainActor
final class SplitSessionServiceImpl: ObservableObject, SplitSessionService {
    @Published private(set) var split: Split? = nil
    @Published var state: SplitSessionState = .na
    @Published var hasError: Bool = false
    
    private var splitSessionRepository: SplitSessionRepository
    private var subscriptions = Set<AnyCancellable>()
        
    init(splitSessionRepository: SplitSessionRepository) {
        self.splitSessionRepository = splitSessionRepository
        Task.init {
            await fetchCurrentSplit()
        }
    }
    
    func fetchCurrentSplit() async {
        splitSessionRepository.fetchCurrentSplit()
            .sink { res in
                switch res {
                case .failure(let err):
                    self.state = .failure(err: err)
                default: break
                }
            } receiveValue: { value in
                self.split = value
                self.state = .success
            }.store(in: &subscriptions)
    }
    
    func addUserWorkout(uid: String, day: String, workout: [Video]) async {
        splitSessionRepository.addUserWorkout(uid: uid, day: day, workout: workout)
            .sink { res in
                switch res {
                case .failure(let err):
                    self.state = .failure(err: err)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .success
            }.store(in: &subscriptions)
    }
    
}
