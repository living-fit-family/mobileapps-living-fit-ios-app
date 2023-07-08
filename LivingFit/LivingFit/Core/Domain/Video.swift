//
//  Video.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/8/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Video: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var category: String
    var setDuration: String
    var imageLink: String
    var videoLink: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case setDuration = "set_duration"
        case imageLink = "image_link"
        case videoLink = "video_link"
    }
}

extension Video {
    static var sampleVideo = Video(
        id: "1",
        name: "Glute Bridge",
        category: "Glutes",
        setDuration: "4x10",
        imageLink: "https://livingfitfamily.imgix.net/barbell_glute_bridge.jpg",
        videoLink: "https://livingfitfamily.imgix.net/barbell_glute_bridge.mp4"
    )
}
