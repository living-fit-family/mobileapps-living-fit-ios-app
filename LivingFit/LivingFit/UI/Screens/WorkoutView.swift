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
import AVKit

enum WorkoutType {
    case regular
    case hiit
    case abs
}

struct WorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var splitSessionService: SplitSessionServiceImpl
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var bannerService: BannerService
    
    @State private var weight = "0"
    @State private var videoName = ""
    @State private var showingUnitOfMeasureForm = false
    
    @State private var workouts: [Video] = []
    @State private var draggedItem : Video?
    
    @State private var showSheet = false
    @State private var showSelection = false
    
    var split: Split.Segment? = nil
    
    @Binding var path: NavigationPath
    
    private var queries: [String] {
        var queries: [String] = []
        if let split = split {
            split.exercises.forEach {
                queries.append($0.category)
            }
        }
        return queries
    }
    
    private var rounds: Int {
        return split?.exercises.first(where: { $0.category == "hiit"})?.interval?.rounds ?? 0
    }
    
    private var work: Int {
        return split?.exercises.first(where: { $0.category == "hiit"})?.interval?.work ?? 0
    }
    
    private var rest: Int {
        return split?.exercises.first(where: { $0.category == "hiit"})?.interval?.rest ?? 0
    }
    
    private func getWorkouts() -> [Workout] {
        guard let workouts = splitSessionService.userWorkOuts[split?.day ?? ""] else { return [] }
        return workouts
    }
    
    private func getAddedExercises() -> [Video] {
        let workouts = getWorkouts().flatMap { $0.videos }
        return workouts
    }
    
    private func isHIIT() -> Bool {
        let isHitt = getAddedExercises().contains(where: {$0.category == "hiit" })
        return isHitt
    }
    
//    private func getSplitInterval() -> Split.Interval {
//        if let split = split {
//            if let exercise = split.exercises.first(where: { $0.interval != nil }) {
//                return exercise.interval!
//            }
//        }
//        return Split.Interval(rounds: 4, work: 10, rest: 5)
//    }
    
    @ViewBuilder private func MenuView(progress: CGFloat) -> some View {
        Menu {
            NavigationLink(destination:  NavigationLazyView(WorkoutEditView(split: split ?? nil, addedExercises: getAddedExercises(), path: $path))) {
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
            Circle()
                .fill(-progress > 1 ? Color.gray.opacity(0.2) : Color(uiColor: .black).opacity(0.7))
                .frame(width: 30, height: 30)
                .overlay {
                    Image(systemName: "ellipsis")
                        .imageScale(.medium)
                        .foregroundStyle(-progress > 1 ? Color.colorPrimary : Color.white)
                }
        }
    }
    
    @ViewBuilder
    func HeaderView(safeArea: EdgeInsets, size: CGSize)->some View{
        GeometryReader{ proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let height = size.height * 0.45
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            let titleProgress = minY / height
            
            HStack(spacing: 15){
                Circle()
                    .fill(-progress > 1 ? Color.white : Color(uiColor: .black).opacity(0.7))
                    .frame(width: 30, height: 30)
                    .overlay {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .imageScale(.medium)
                                .fontWeight(.semibold)
                                .foregroundStyle(-progress > 1 ? .black : .white)
                        }
                    }
                Spacer(minLength: 0)
                MenuView(progress: progress)
                
            }
            .overlay(content: {
                Text(split?.day ?? "")
                    .fontWeight(.medium)
                // Your Choice Where to display the title
                    .offset(y: -titleProgress > 0.75 ? 0 : 45)
                    .clipped()
                    .animation(.easeInOut(duration: 0.25), value: -titleProgress > 0.75)
            })
            .padding(.top,safeArea.top + 10)
            .padding([.horizontal,.bottom],15)
            .background(content: {
                Color.white
                    .opacity(-progress > 1 ? 1 : 0)
                    .shadow(radius: 3.0)
            })
            .offset(y: -minY)
        }
        .frame(height: 35)
    }
    
    @ViewBuilder
    func ArtWork(safeArea: EdgeInsets, size: CGSize)->some View{
        let height = size.height * 0.45
        GeometryReader{proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            
            KFImage(URL(string: split?.placeholder ?? "")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0))
                .clipped()
                .offset(y: (minY > 0 ? -minY : 0))
        }
        .frame(height: height + safeArea.top)
    }
    
    @ViewBuilder
    func StartWorkoutButton()-> some View {
        Text("Start Workout")
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.colorPrimary.gradient)
            }
    }
    
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let size = $0.size
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack{
                        // MARK: Artwork
                        ArtWork(safeArea: safeArea, size: size)
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(split?.day ?? "")
                                    .font(.largeTitle)
                                    .fontWeight(.black)
                                Text(split?.name ?? "")
                                    .font(.headline)
                                    .fontWeight(.regular)
                            }
                            .padding(.bottom)
                            
                            // MARK: Album View
                            ForEach(queries, id: \.self) { query in
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack(alignment: .lastTextBaseline, spacing: 18) {
                                        Text(query == "hiit" ? query.uppercased() : query.capitalized)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                        if (query == "hiit") {
                                            Text("40 sec work • 20 sec rest • 4 round")
                                                .fontWeight(.medium)
                                                .foregroundStyle(.gray)
                                        }
                                    }
                                    .padding(.top)
                                    .padding(.bottom, 4)
                                    ForEach(workouts.filter { $0.category == query }, id: \.self) { video in
                                        WorkoutCard(video: video, showingUnitOfMeasureForm: $showingUnitOfMeasureForm, weight: video.weight ?? "0") { value in
                                            self.videoName = value
                                        }
                                        .onDrag({
                                            self.draggedItem = video
                                            return NSItemProvider()
                                        })
                                        .onDrop(of: [.text],
                                                delegate: DropViewDelegate(destinationItem: video, videos: $workouts, draggedItem: $draggedItem)
                                        )
                                        Divider()
                                    }
                                }
                                .padding(.bottom)
                                
                                
                            }
                        }
                        .padding()
                        .zIndex(0)
                        .background(.white)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 20,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 20
                            )
                        )
                        .offset(y: -35)
                    }
                    .overlay(alignment: .top) {
                        HeaderView(safeArea: safeArea, size: size)
                    }
                }
                VStack {
                    Spacer()
//                    if isHIIT() {
//                        StartWorkoutButton()
//                            .onTapGesture {
//                                showSelection.toggle()
//                            }
//                    } else {
                        NavigationLink(value: WorkoutType.regular) {
                            StartWorkoutButton()
                        }
//                    }
                }
                .navigationDestination(for: WorkoutType.self) { type in
//                    switch type {
//                    case .regular:
                    AnyView(NavigationLazyView(ExerciseViewCoordinator(path: $path, split: split, videos: getAddedExercises(), day: split?.day ?? "", queries: queries)
                            .toolbar(.hidden, for: .navigationBar)))
//                        AnyView(NavigationLazyView(ExerciseView(path: $path, videos: getAddedExercises(), day: split?.day ?? "", queries: queries)
//                            .toolbar(.hidden, for: .navigationBar)))
//                    case .hiit:
//                        AnyView(NavigationLazyView(
//                            TabataExerciseView(videos: getAddedExercises().filter { $0.category == "hiit"},
//                                               day: split?.day ?? "",
//                                               queries: queries,
//                                               interval: getSplitInterval(),
//                                               path: $path)                                            .toolbar(.hidden, for: .navigationBar)))
//                    case .abs:
//                        AnyView(NavigationLazyView(ExerciseView(videos: getAddedExercises().filter { $0.category != "hiit"}, day: split?.day ?? "", queries: queries)
//                            .toolbar(.hidden, for: .navigationBar)))
//                    }
                    
                }
                .padding(.horizontal)
            }
            .confirmationDialog("Which part would you like to do?", isPresented: $showSelection, titleVisibility: .visible) {
                NavigationLink(value: WorkoutType.hiit) {
                    Text("Part One (HIIT)")
                }
                NavigationLink(value: WorkoutType.abs) {
                    Text("Part Two (Abs)")
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
                        
                        self.workouts[index].weight = weight
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
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
            .onAppear {
                self.workouts = getAddedExercises()
            }
            .onChange(of: workouts, perform: { value in
                if let user = sessionService.user, let day = split?.day {
                    Task {
                        await splitSessionService.addUserWorkout(uid: user.id, day: day, categories: queries, workout: workouts)
                    }
                }
            })
            .ignoresSafeArea(.container, edges: .top)
            .ignoresSafeArea(.keyboard)
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static let splitSessionService = SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter())
    
    static var previews: some View {
        NavigationStack {
            WorkoutView(split: splitSessionService.split?.segments[0], path: .constant(NavigationPath()))
                .environmentObject(BannerService())
                .environmentObject(SessionServiceImpl())
                .environmentObject(splitSessionService)
        }
    }
}
