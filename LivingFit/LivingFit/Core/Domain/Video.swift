//
//  Video.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/8/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct Video: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var name: String
    var category: String
    var subCategory: String?
    var sets: String?
    var reps: String?
    var rest: String?
    var duration: String?
    var imageLink: String
    var squareImageLink: String?
    var videoLink: String
    var editWeightEnabled: Bool?
    var weight: String?
    var completed: Bool?
    var currentSet: Int?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Video {
    static var sampleVideo = Video(
        id: "1",
        name: "Burpee",
        category: "hiit",
        sets: "4",
        reps: "10",
        rest: "60",
        imageLink: "https://ik.imagekit.io/z9gymi5p9/leg_press-min.jpg?updatedAt=1689981732525",
        squareImageLink: "https://ik.imagekit.io/z9gymi5p9/square/standing_cable_row.jpg?updatedAt=1707103427310",
        videoLink: "https://storage.googleapis.com/living-fit-family-videos/hiit/burpees.mp4"
    )
    
    static var sampleVideo2 = Video(
        id: "2",
        name: "Playe Raise",
        category: "shoulders",
        sets: "4",
        reps: "10",
        rest: "45",
        imageLink: "https://ik.imagekit.io/z9gymi5p9/leg_press-min.jpg?updatedAt=1689981732525",
        squareImageLink: "https://ik.imagekit.io/z9gymi5p9/square/seated_dumbbell_snatch.jpg?updatedAt=1707431248308",
        videoLink: "https://storage.googleapis.com/living-fit-family-videos/shoulders/plate_raise.mp4"
    )
}
