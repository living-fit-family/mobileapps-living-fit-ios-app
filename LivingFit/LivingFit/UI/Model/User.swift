//
//  User.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/4/23.
//

import Foundation

enum Gender: String, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    
    case male
    case female
}

typealias User = (gender: Gender, age: Int, weightInKg: Double, heightInCm: Int, bodyfat: Int?)
