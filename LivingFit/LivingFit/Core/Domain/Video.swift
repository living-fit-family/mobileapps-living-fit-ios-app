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

struct Video: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var category: String
    var subCategory: String?
    var sets: String?
    var reps: String?
    var rest: String?
    var duration: String?
    var imageLink: String
    var videoLink: String
}

extension Video {
    static var sampleVideo = Video(
        id: "1",
        name: "Glute Bridge",
        category: "glutes",
        sets: "4",
        reps: "10",
        rest: "1 minute",
        imageLink: "https://ik.imagekit.io/z9gymi5p9/jump_rope.jpg?updatedAt=1689275393337",
        videoLink: "https://livingfitfamily.imgix.net/legs/leg_extension.mp4"
    )
}
