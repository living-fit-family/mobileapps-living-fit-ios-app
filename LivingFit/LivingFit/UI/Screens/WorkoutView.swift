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
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var splitSessionService: SplitSessionServiceImpl
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var bannerService: BannerService
    
    @State var editMode: Bool = false
    var split: Split.Segment? = nil
    
    @State private var selectedVideo: Video? = nil
    
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
                                    } else if video.category == Query.hiit.rawValue {
                                        Text("Included in HIIT Interval")
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
                                Spacer()
                            }.contentShape(Rectangle())
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
