//
//  WorkoutView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/20/23.
//

import SwiftUI
import Kingfisher

struct WorkoutView: View {
    @EnvironmentObject var splitSessionService: SplitSessionServiceImpl
    var name: String = ""
    var day: String = ""
    
    func getWorkouts() -> [Workout] {
        guard let workouts = splitSessionService.userWorkOuts[day] else { return [] }
        return workouts
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(getWorkouts()) { workout in
                    Section(header: Text(workout.name)) {
                        ForEach(workout.videos, id: \.self) { video in
                            NavigationLink {
                                VideoView(addedExercises: .constant([]), video: video, dismissAction: {}, showButton: false)
                            } label: {
                                VStack(alignment: .leading) {
                                    HStack(spacing: 0) {
                                        KFImage.url(URL(string: video.squareImageLink ?? ""))
                                            .loadDiskFileSynchronously()
                                            .cacheMemoryOnly()
                                            .fade(duration: 0.25)
                                            .onProgress { receivedSize, totalSize in  }
                                            .onSuccess { result in  }
                                            .onFailure { error in }
                                            .resizable()
                                            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fill)
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(8)
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(video.name)
                                                .font(.headline)
                                                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.18))
                                            if video.category == Query.cardio.rawValue {
                                                Text("\(video.duration ?? "")")
                                                    .foregroundColor(Color(hex: "3A4750"))
                                            } else {
                                                Text("\(video.sets ?? "") x \(video.reps ?? "")")
                                                    .font(.subheadline)
                                                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.18))
                                            }
                                        }
                                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                    }
                                }
                            }
                        }.onMove(perform: workout.moveWorkout)
                    }
                }
            }
            .navigationTitle(name)
            .navigationBarTitleDisplayMode(.large)
            .listStyle(GroupedListStyle())
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WorkoutView(name: "Glutes", day: "Friday")
                .environmentObject(SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter()))
        }
    }
}
