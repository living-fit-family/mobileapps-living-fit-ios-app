//
//  WorkoutView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/20/23.
//

import SwiftUI
import Foundation
import Kingfisher
import PopupView

struct WorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var splitSessionService: SplitSessionServiceImpl
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var bannerService: BannerService
    
    @State private var weight = "0"
    @State private var videoName = ""
    @State private var showingUnitOfMeasureForm = false
    
    @State var editMode: Bool = false
    var split: Split.Segment? = nil
    
    @State private var selectedVideo: Video? = nil
    
    var queries: [String] {
        var queries: [String] = []
        if let split = split {
            split.exercises.forEach {
                queries.append($0.category)
            }
        }
        return queries
    }
    
    private enum CoordinateSpaces {
        case scrollView
    }
    
    func getWorkouts() -> [Workout] {
        guard let workouts = splitSessionService.userWorkOuts[split?.day ?? ""] else { return [] }
        return workouts
    }
    
    func getAddedExercises() -> [Video] {
        let workouts = getWorkouts().flatMap { $0.videos }
        return workouts
    }
    
    func handleDismiss() {
        self.selectedVideo = nil
    }
    
    var body: some View {
        VStack {
            List {
                if split?.day == "Tuesday" {
                    Section {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Perform Each Exercise for 5 rounds")
                                .font(.headline)
                            Text("Work: 40 Seconds")
                                .font(.subheadline)
                            Text("Rest 20 Seconds")
                                .font(.subheadline)
                        }
                    }
                }
                ForEach(getWorkouts()) { workout in
                    Section(header: Text(workout.name.capitalized).foregroundColor(.black).padding(.bottom, 4)) {
                        ForEach(workout.videos, id: \.self) { video in
                            WorkoutCard(video: video, showingUnitOfMeasureForm: $showingUnitOfMeasureForm, weight: video.weight ?? "0") { value in
                                self.videoName = value
                            }
                                .onTapGesture {
                                    self.selectedVideo = video
                                }
                        }
                        .onMove(perform: workout.moveWorkout)
                    }
                }
                
            }
            .sheet(item: self.$selectedVideo, onDismiss: handleDismiss) {
                VideoView(addedExercises: .constant([]), video: $0, dismissAction: handleDismiss, showButton: false)
            }
        }
        .popup(isPresented: $showingUnitOfMeasureForm) {
            UnitOfMeasureForm(feet: .constant(""), inches: .constant(""), weight: $weight, showingUnitOfMeasureForm: $showingUnitOfMeasureForm, measurement: .weight) {
                let index = getAddedExercises().firstIndex(where: { $0.name == videoName })
                var workouts = getAddedExercises()
                
                if let index = index {
                    var newExercise = workouts[index]
                    newExercise.weight = weight
                    workouts[index] = newExercise
                }
                
                if let user = sessionService.user, let day = split?.day {
                    Task {
                        await splitSessionService.addUserWorkout(uid: user.id, day: day, categories: queries, workout: workouts)
                    }
                }
            }
        } customize: {
            $0
                .type(.floater())
                .position(.center)
                .animation(.spring())
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .dragToDismiss(false)
                .backgroundColor(.black.opacity(0.5))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    NavigationLink(destination:  NavigationLazyView(WorkoutEditView(split: split ?? nil, addedExercises: getAddedExercises()))) {
                        Image(systemName: "square.and.pencil")
                        Text("Edit")
                    }
                    Button(action: {
                        if let user = sessionService.user, let day = split?.day {
                            Task {
                                await splitSessionService.deleteUserWorkout(uid: user.id, day: day)
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            bannerService.setBanner(bannerType: .success(message: "Your \(split?.name ?? "") workout has been deleted.", isPersistent: true))
                        }
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .navigationTitle(split?.name ?? "")
        .navigationBarTitleDisplayMode(.large)
    }
}


struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WorkoutView()
                .environmentObject(SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter()))
                .environmentObject(SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter()))
                .environmentObject(BannerService())
        }
    }
}
