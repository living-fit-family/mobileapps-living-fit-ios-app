//
//  Workout.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/20/23.
//

import Foundation


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct WorkoutRoutine: Codable {
    var workouts: [Workout]
}

class Workout: Codable, Identifiable {
    let name: String
    var videos: [Video]
    
    init(name: String, videos: [Video]) {
        self.name = name
        self.videos = videos
    }
    
    func moveWorkout(from source: IndexSet, to destination: Int) {
        videos.move(fromOffsets: source, toOffset: destination)
    }
}
