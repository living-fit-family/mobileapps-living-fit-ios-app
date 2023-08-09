//
//  ProfileViewModel.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/8/23.
//

import Foundation
import Combine
import SwiftUI
import FirebaseStorage
import FirebaseFirestore


enum Gender: String, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    case male
    case female
}

enum Goal: String, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    case lose
    case gain
    case maintain
}

enum ActivityFactor: Double {
    case Sedentary = 1.2 // Little or no exercise and desk job
    case LightlyActive = 1.375 // Light exercise or sports 1-3 days a week
    case ModeratelyActive = 1.55 // Moderate exercise or sports 3-5 days a week
    case VeryActive = 1.725 // Hard exercise or sports 6-7 days a week4
    case ExtremelyActive = 1.9 // Hard daily exercise or sports and physical job
}

class ProfileViewModel: ObservableObject {
    @Published var id: String
    @Published var firstName: String
    @Published var lastName: String
    
    @Published var gender: Gender {
        didSet(newGender) {
            if (newGender != gender) {
                recalculateMacros()
            }
        }
    }
    @Published var birthDate: Date {
        didSet(newBirthDate) {
            if newBirthDate != birthDate {
                recalculateMacros()
            }
        }
    }
    @Published var height: String{
        didSet(newHeight) {
            if newHeight != height {
                recalculateMacros()
            }
        }
    }
    @Published var weight: String{
        didSet(newWeight) {
            if newWeight != weight {
                recalculateMacros()
            }
        }
    }
    @Published var goal: Goal{
        didSet(newGoal) {
            if newGoal != goal {
                recalculateMacros()
            }
        }
    }
    @Published var dailyCalories: String
        
    private var subscriptions = Set<AnyCancellable>()
    
    private var repository = FirebaseUserRepository()
    
    init(id: String = "", firstName: String = "", lastName: String = "", gender: Gender = .female, birthDate: Date = Date(), height: String = "157.48", weight: String = "54", goal: Goal = .maintain, dailyCalories: String = "2000") {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.birthDate = birthDate
        self.height = height
        self.weight = weight
        self.goal = goal
        self.dailyCalories = dailyCalories
    }
    
    func updateName(userId: String, firstName: String, lastName: String) {
        repository.updateName(uid: id, firstName: firstName, lastName: lastName)
            .sink { res in
                switch res {
                case .failure(let err):
                    print("Failure")
                    //                    self.state = .failure(err: err)
                default: break
                }
            } receiveValue: { _ in
                print("success")
                //                self.state = .success
            }.store(in: &subscriptions)
    }
    
    func updatePhotoUrl(userId: String, image: UIImage, onComplete: @escaping () -> (Void)?, onFailure: @escaping (Error) -> (Void)?) {
        let storageRef = storage.reference()
        
        // Create a reference to 'images/mountains.jpg'
        let userIdImagesRef = storageRef.child("\(userId)/profileImage.png")
        
        // Data in memory
        let data = image.pngData()
        
        // Upload the file to the path "images/rivers.jpg"
        if let data = data {
            userIdImagesRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    if let error = error {
                        onFailure(error)
                    }
                    return
                }
                // You can also access to download URL after upload.
                userIdImagesRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        if let error = error {
                            onFailure(error)
                        }
                        return
                    }
                    
                    Firestore.firestore()
                        .collection("users").document(userId).updateData(["photoURL": downloadURL.absoluteString]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                                onFailure(err)
                            } else {
                                print("Document successfully written!")
                                onComplete()
                            }
                        }
                }
            }
        }
    }

    
    private func commitMacroChanges() {
        let detail = UserDetail(gender: gender, birthDate: birthDate, height: height, weight: weight, goal: goal, totalCalories: dailyCalories)
        repository.updateMacroNutrientInfo(uid: id, userDetails: detail)
            .sink { res in
                switch res {
                case .failure(let err):
                    print("Failure")
                    //                    self.state = .failure(err: err)
                default: break
                }
            } receiveValue: { _ in
                print("success")
                //                self.state = .success
            }.store(in: &subscriptions)
    }
    
    private func recalculateMacros() {
        if goal == .maintain {
            dailyCalories = String(Int(round(TDEE(activityFactor: ActivityFactor.ModeratelyActive))))
        }
        
        if goal == .gain {
            let tdee = TDEE(activityFactor: ActivityFactor.ModeratelyActive)
            dailyCalories = String(Int(round(tdee + (tdee * 0.20))))
        }
        
        if goal == .lose {
            let tdee = TDEE(activityFactor: ActivityFactor.ModeratelyActive)
            dailyCalories = String(Int(round(tdee - (tdee * 0.20))))
        }
        
        commitMacroChanges()
    }
    
    private func calculateAge() -> Int {
        let now = Date()
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        return ageComponents.year!
    }
    
    public func weightInKg(pounds: Double) -> Double {
        return pounds / 2.2
    }
    
    public func heightInCm(feet: Double, inches: Double) -> Double {
        return feet * 30.48 + inches * 2.54
    }
    
    private func TDEE(activityFactor: ActivityFactor) -> Double {
        return mifflinCalculator() * activityFactor.rawValue
    }
    
    func mifflinCalculator() -> Double {
        let genderAdjustment = gender == .male ? 5.0 : -161.0
        let age = calculateAge()
        print(genderAdjustment)
        return (10.0 * Double(weight)!) + (6.25 * Double(height)!) - (5.0 * Double(age)) + genderAdjustment
    }
}
