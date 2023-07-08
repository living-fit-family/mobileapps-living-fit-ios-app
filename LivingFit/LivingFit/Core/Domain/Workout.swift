//
//  Workout.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/8/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Workout: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var startDate: String
    var endDate: String
    var split: [Split]
}


extension Workout {
    struct Split: Codable, Identifiable {
        let id: String
        let name: String
        let day: String
        let requiredExercises: [RequiredExercise]
        let placeholder: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case day
            case requiredExercises = "required_exercises"
            case placeholder
        }
    }
}

extension Workout {
    struct RequiredExercise: Codable {
        var category: String
        var number: Int
        var type: String?
        var interval: Interval?
    }
}

extension Workout {
    struct Interval: Codable {
        var rounds: Int
        var work: Int
        var rest: Int
    }
}
