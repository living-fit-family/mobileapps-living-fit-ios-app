//
//  ExerciseViewCoordinator.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 4/10/24.
//

import SwiftUI

struct ExerciseViewCoordinator: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var splitSessionService: SplitSessionServiceImpl
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var bannerService: BannerService
    
    @State private var currentItem = 0
    @State private var totalElapsedSeconds: Double = 0
    @State private var elapsedTotalTime: TimeInterval = 0
    @State private var finalTime: Double = 0
    
    @Binding var path: NavigationPath
    
    var split: Split.Segment? = nil
    
    var videos: [Video]
    var day: String
    var queries: [String]
    
    @State private var currentQuery: String = ""
    
    @State private var isHiitCompleted = false
    
    @State private var showCompleteWorkoutView = false
    
    private func getSplitInterval() -> Split.Interval {
        if let split = split {
            if let exercise = split.exercises.first(where: { $0.interval != nil }) {
                return exercise.interval!
            }
        }
        return Split.Interval(rounds: 1, work: 1, rest: 1)
    }
    
    var body: some View {
        VStack {
            if (currentQuery != "hiit") {
                ExerciseView(totalElapsedSeconds: $totalElapsedSeconds,
                             currentItem: $currentItem,
                             videos: videos.filter { $0.category != "hiit"},
                             day: day,
                             queries: queries) { time in
                    self.finalTime = time
                }
            } else {
                TabataExerciseView(videos: videos.filter { $0.category == "hiit"},
                                   day: day,
                                   queries: queries,
                                   interval: getSplitInterval(),
                                   path: $path) {
                    let interval = getSplitInterval()
                    let hiitVideosCount = videos.filter { $0.category == "hiit"}.count
                    self.elapsedTotalTime = Double((interval.work + interval.rest) * hiitVideosCount * interval.rounds)
                    self.totalElapsedSeconds = self.totalElapsedSeconds + elapsedTotalTime
                    self.currentItem = videos.count - hiitVideosCount - self.currentItem
                    self.currentQuery = videos.filter { $0.category != "hiit"}[currentItem].category
                    
                    isHiitCompleted.toggle()
                }
            }
        }
        .fullScreenCover(isPresented: $showCompleteWorkoutView) {
            WorkoutCompleteView(completionTime: finalTime) {
                if let user = sessionService.user, let segments = splitSessionService.split?.segments {
                    if let segment = segments.first(where: { $0.day == day}) {
                        let completedWorkout = CompletedWorkout(day: day, completed: true)
                        Task {
                            await splitSessionService.updateCompletedWorkouts(uid: user.id, completedWorkout: completedWorkout)
                            path.removeLast(path.count)
                        }
                    }
                }
            }
        }
        .onAppear {
            currentQuery = queries[0]
        }
        .onChange(of: self.currentItem, perform: { value in
            // switch to hiit
            if (videos[value].category == "hiit" && !isHiitCompleted) {
                self.currentQuery = videos[value].category
            }
        })
        .onChange(of: self.finalTime, perform: { value in
            // finish workout
            showCompleteWorkoutView.toggle()
        })
    }
}

#Preview {
    ExerciseViewCoordinator(path: .constant(NavigationPath()), split: SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter()).split?.segments[0], videos: [Video.sampleVideo, Video.sampleVideo2], day: "Monday", queries: [""])
        .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
}
