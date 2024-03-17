//
//  SplitSessionService.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/19/23.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
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
    @Published var userWorkOuts: [String: [Workout]] = [:]
    @Published var completedWorkouts: Int = 0
    
    private var splitSessionRepository: SplitSessionRepository
    private var subscriptions = Set<AnyCancellable>()
    
    init(splitSessionRepository: SplitSessionRepository) {
        self.splitSessionRepository = splitSessionRepository
        Task.init {
            await fetchCurrentSplit()
            self.handleRefresh()
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
    
    func updateCompletedWorkouts(uid: String, completedWorkout: CompletedWorkout, totalExercises: Int) async {
        splitSessionRepository.updateCompletedWorkouts(uid: uid, completedWorkout: completedWorkout, totalExercises: totalExercises)
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
    
    func addUserWorkout(uid: String, day: String, categories: [String], workout: [Video]) async {
        var workouts: [Workout] = [];
        categories.forEach { category in
            let outerData = Workout(name: String(category), videos: workout.filter { $0.category.components(separatedBy: ",").first(where: { $0 == category}) != nil })
            workouts.append(outerData)
        }
        self.userWorkOuts.updateValue(workouts, forKey: day )
        splitSessionRepository.addUserWorkout(uid: uid, day: day, workout: self.userWorkOuts[day, default: []])
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
    
    func deleteUserWorkout(uid: String, day: String) async {
        self.userWorkOuts.removeValue(forKey: day)
        splitSessionRepository.deleteUserWorkout(uid: uid, day: day)
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
    
    func handleRefresh() {
        if let user = Auth.auth().currentUser {
            let docRef = Firestore.firestore().collection("users").document(user.uid).collection("workouts")
            docRef
                .addSnapshotListener { [weak self] querySnapshot, error in
                    guard let querySnapshot = querySnapshot else {
//                                            print("Error retreiving collection: \(error)")
                        return
                    }
                    querySnapshot.documents.forEach { document in
                        if document.documentID == "completed" {
                            guard let self = self,
                                  let completed: Completed = try? document.data(as: Completed.self) else {
                                return
                            }
                            DispatchQueue.main.async {
                                self.completedWorkouts = completed.total
                            }
                        }
                        guard let self = self,
                              let workouts: WorkoutRoutine = try? document.data(as: WorkoutRoutine.self) else {
                            return
                        }
                        DispatchQueue.main.async {
                            self.userWorkOuts.updateValue(workouts.workouts, forKey: document.documentID )
                        }
                    }
                }
        }
    }
    
}

