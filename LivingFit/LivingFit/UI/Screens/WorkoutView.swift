//
//  WorkoutView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/20/23.
//

import SwiftUI
import Foundation
import Kingfisher

struct WorkoutView: View {
    @EnvironmentObject var splitSessionService: SplitSessionServiceImpl
    var name: String = ""
    var day: String = ""
    
    private enum CoordinateSpaces {
        case scrollView
    }
    
    func getWorkouts() -> [Workout] {
        guard let workouts = splitSessionService.userWorkOuts[day] else { return [] }
        return workouts
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(getWorkouts()) { workout in
                    Section(header: Text(workout.name.capitalized).foregroundColor(.black).padding(.bottom, 4)) {
                        ForEach(workout.videos, id: \.self) { video in
                            HStack(spacing: 8) {
                                KFImage.url(URL(string: video.squareImageLink ?? ""))
                                    .loadDiskFileSynchronously()
                                    .cacheMemoryOnly()
                                    .fade(duration: 0.25)
                                    .onProgress { receivedSize, totalSize in  }
                                    .onSuccess { result in  }
                                    .onFailure { error in }
                                    .resizable()
                                    .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                                    .frame(height: 55)
                                    .cornerRadius(4)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(video.name)
                                        .font(.subheadline)
                                    if video.category == Query.cardio.rawValue {
                                        Text("\(video.duration ?? "")")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    } else {
                                        Text("\(video.sets ?? "") x \(video.reps ?? "")")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                                    return 0
                                }
//                                Spacer()
//                                Image(systemName: "line.horizontal.3")
                                
                            }
                        }
                        .onMove(perform: workout.moveWorkout)
                    }
                }
                
            }
//            .toolbar {
//                EditButton()
//            }
        }
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.inset)
        .scrollContentBackground(.hidden)
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
