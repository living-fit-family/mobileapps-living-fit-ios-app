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
    var setDuration: String
    var imageLink: String
    var squareImageLink: String?
    var videoLink: String
}

extension Video {
    static var sampleVideo = Video(
        id: "1",
        name: "Glute Bridge",
        category: "Glutes",
        setDuration: "4x10",
        imageLink: "https://ik.imagekit.io/z9gymi5p9/dumbell_flat_bench_press.jpg?updatedAt=1689485634307",
        videoLink: "https://livingfitfamily.imgix.net/legs/leg_extension.mp4"
    )
}
