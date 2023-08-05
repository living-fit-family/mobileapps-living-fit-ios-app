//
//  ActivityViewModel.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/3/23.
//

import Foundation
import HealthKit

class ActivityViewModel: ObservableObject {
    let healthStore = HKHealthStore()
    
    @Published var activities: [String:Activity] = [:]
    
    
    init() {
        let steps = HKQuantityType(.stepCount)
        let caloriesBurned = HKQuantityType(.activeEnergyBurned)
        let healthTypes: Set = [steps, caloriesBurned]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCaloriesBurned()
            } catch {
                print("error fetching health data.")
            }
        }
    }
    
    func fetchTodaySteps() {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, err in
            guard let quantity = result?.sumQuantity(), err == nil else {
                print("error fetching todays step data")
                return
            }
            let stepCount = quantity.doubleValue(for: .count()).formatString()
            let activity = Activity(id: 0, title: "Daily Steps", subtitle: "Goal: 10,000", image: "figure.walk", amount: stepCount, color: .blue)
            DispatchQueue.main.async {
                self.activities["steps"] = activity
            }
        }
        healthStore.execute(query)
    }
    
    func fetchTodayCaloriesBurned() {
        let steps = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, err in
            guard let quantity = result?.sumQuantity(), err == nil else {
                print("error fetching todays calories burned data")
                return
            }
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie()).formatString()
            let activity = Activity(id: 1, title: "Calories Burned", subtitle: "3000", image: "flame", amount: caloriesBurned, color: .orange)
            DispatchQueue.main.async {
                self.activities["caloriesBurned"] = activity
            }
        }
        healthStore.execute(query)
    }
}

extension Double {
    func formatString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self))!
    }
}
