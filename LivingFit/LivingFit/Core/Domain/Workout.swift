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

struct Workout: Codable, Identifiable {
    @DocumentID var id: String?
    var videos: [Video]
}
