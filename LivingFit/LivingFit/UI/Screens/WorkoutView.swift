//
//  WorkoutView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/20/23.
//

import SwiftUI
import Foundation
import Kingfisher

enum Selection: String, CaseIterable {
    case edit
    case delete
}

struct WorkoutView: View {
    @EnvironmentObject var splitSessionService: SplitSessionServiceImpl
    @State private var selection: Selection = .edit
    var name: String = ""
    var day: String = ""
    
    private enum CoordinateSpaces {
        case scrollView
    }
    
    func getWorkouts() -> [Workout] {
        guard let workouts = splitSessionService.userWorkOuts[day] else { return [] }
        return workouts
    }
    
    var customLabel: some View {
        HStack {
            Image(systemName: "paperplane")
            Text(String("selectedNumber"))
            Spacer()
            Text("⌵")
                .offset(y: -4)
        }
        .foregroundColor(.white)
        .font(.title)
        .padding()
        .frame(height: 32)
        .background(Color.blue)
        .cornerRadius(16)
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
                                
                            }
                        }
                        .onMove(perform: workout.moveWorkout)
                    }
                }
                
            }
        }
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.inset)
        .scrollContentBackground(.hidden)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Picker("Edit", selection: $selection) {
                        ForEach(Selection.allCases, id: \.self) { selection in // 4
                            Text(selection.rawValue.capitalized + " " + "workout")
                                .foregroundColor(selection == .delete ? .red : .black)
                        }
                    }
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
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
