//
//  Split.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/19/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Split: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var startDate: String
    var endDate: String
    var segments: [Segment]
}


extension Split {
    struct Segment: Codable, Identifiable, Hashable, Equatable {
        let id: String
        let name: String
        let day: String
        let exercises: [Exercise]
        let placeholder: String
        
        static func ==(lhs: Segment, rhs: Segment) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}

extension Split {
    struct Exercise: Codable {
        var category: String
        var subCategory: String?
        var number: Int
        var interval: Interval?
    }
}

extension Split {
    struct Interval: Codable {
        var rounds: Int
        var work: Int
        var rest: Int
    }
}
