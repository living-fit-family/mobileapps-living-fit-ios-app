//
//  WorkoutView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/20/23.
//

import SwiftUI

struct WorkoutView: View {
    var day: String? = ""
    var workout: [Video] = []
    var categories: [String] = []

    
    var body: some View {
        NavigationStack {
            List(categories, id: \.self) { category in
                Section(header: Text(category)) {
                    ForEach(workout.filter {$0.category == category}) { video in
                        NavigationLink {
                            VideoView(addedExercises: .constant([]), video: video, dismissAction: {}, showButton: false)
                        } label: {
                            WorkoutRow(video: video)
                        }
                    }
                }
            }
            .navigationTitle(day ?? "")
            ButtonView(title: "Finish Workout") {
//                addedExercises.append(video)
//                dismissAction()
            }.padding()
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WorkoutView()
        }
    }
}
