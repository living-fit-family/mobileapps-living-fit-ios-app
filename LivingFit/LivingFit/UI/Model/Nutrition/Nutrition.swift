//
//  Nutrition.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/29/23.
//
import Foundation
import SwiftUI


struct Nutrition: Hashable, Codable, Identifiable {
    var id: Int
    
    var category: Category
    enum Category: String, CaseIterable, Codable {
        case generic = "Nutrition Made Simple"
        case goals = "Eat Towards Your Goals"
        case macros = "Reach Your Macros"
    }


    private var imageName: String
    var image: Image {
        Image(imageName)
    }
}
