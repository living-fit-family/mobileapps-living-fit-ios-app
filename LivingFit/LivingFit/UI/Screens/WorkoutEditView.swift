//
//  VideoListView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/28/23.
//

import SwiftUI

struct Exercise {
    var category: String
    var count: Int
    var required: Int
}

struct WorkoutEditView: View {
    @EnvironmentObject var bannerService: BannerService
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var splitSesstionService: SplitSessionServiceImpl
    
    @StateObject private var service = VideoService(videoRepository: FirebaseVideoRespositoryAdapter())
    
    @State private var addedExercises: [Video] = []
    @State private var selectedVideo: Video? = nil
    @State private var selectedQuery: String
    @State private var showError: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorDescription: String = ""
    @State private var willMoveToNextScreen: Bool = false
    
    var split: Split.Segment? = nil
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    
    var queries: [String] {
        var queries: [String] = []
        if let split = split {
            split.exercises.forEach {
                queries.append($0.category)
            }
        }
        return queries
    }
    
    var requiredExercises: Int {
        var requiredExercises = 0
        if let split = split {
            let exercise = split.exercises.filter {
                $0.category == selectedQuery
            }
            if let found = exercise.first {
                requiredExercises = found.number
            }
        }
        return requiredExercises
    }
    
    init(split: Split.Segment? = nil) {
        self.split = split
        self.selectedQuery = split?.exercises[0].category ?? ""
    }
    
    func handleDismiss() {
        self.selectedVideo = nil
    }
    
    func getRequiredExerciseText() -> some View {
        var formattedQuery = selectedQuery
        if (formattedQuery.last == "s") {
            formattedQuery.removeLast()
        }
        
        if formattedQuery == Query.hiit.rawValue {
            formattedQuery = formattedQuery.uppercased()
        } else {
            formattedQuery = formattedQuery.capitalized
        }
        
        return Text("Pick \(requiredExercises) \(formattedQuery) Exercise\(requiredExercises > 1 || requiredExercises == 0 ? "s" : "")")
    }
    
    func handleCreateWorkout() {
        let errorString = "Add the following exercises:"
        errorTitle.append(errorString)
        
        var count: [Exercise] = []
        split?.exercises.forEach { split in
            count.append(
                Exercise(category: split.category,
                         count: addedExercises.filter{ $0.category.components(separatedBy: ",").first(where: { $0 == split.category}) != nil }.count,
                         required: split.number))
        }
        
        count.forEach {
            if $0.count < $0.required {
                let string = $0.required - $0.count
                errorDescription.append("\(string) \($0.category.capitalized)\n")
                showError = true
            }
        }
        
        if showError != true {
            if let userId = sessionService.user?.id, let day = split?.day {
                Task {
                    await splitSesstionService.addUserWorkout(uid: userId, day: day, categories: queries, workout: addedExercises)
                }
                bannerService.setBanner(bannerType: .success(message: "Your \(split?.name ?? "new") workout is ready.", isPersistent: true))
                willMoveToNextScreen = true
            }
        }
    }
    
    func filter() -> [Video] {
        var videos = service.videos.filter{
            return $0.category.components(separatedBy: ",").first(where: {$0 == self.selectedQuery}) != nil
        }
        
        if let category = split?.exercises.first(where: { $0.category == self.selectedQuery }) {
            if (category.subCategory != nil) {
                videos = videos.filter{$0.subCategory == category.subCategory}
            }
        }
        return videos
    }
    
    func isAdded(video: Video) -> Bool {
        let videos = addedExercises.filter {
            $0.id == video.id
        }
        if !videos.isEmpty {
            return true
        }
        return false
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                Section(header: VStack(alignment: .leading, spacing: 10) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            
                            ForEach(queries, id: \.self) { query in
                                QueryTag(query: query, isSelected: self.selectedQuery == query)
                                    .onTapGesture {
                                        self.selectedQuery = query
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 50,  alignment: .leading)
                    }
                    
                }
                .padding(.horizontal)
                .padding([.vertical], 5)
                .background(.white)) {
                    getRequiredExerciseText()
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding([.vertical], 5)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(filter()) { video in
                            let added = isAdded(video: video)
                            VideoCard(video: video, isAdded: added)
                                .onTapGesture {
                                    self.selectedVideo = video
                                }
                        }
                    }
                }
            }
            .sheet(item: self.$selectedVideo, onDismiss: handleDismiss) {
                VideoView(addedExercises: $addedExercises, video: $0, dismissAction: handleDismiss, showButton: true)
            }
            .alert(isPresented: $showError) {
                Alert(
                    title: Text(errorTitle),
                    message: Text(errorDescription),
                    dismissButton: Alert.Button.default(
                        Text("Ok"), action: {
                            errorTitle = ""
                            errorDescription = ""
                        }
                    )
                )
            }
        }
        .navigationTitle(split?.name ?? "Upper Body Volume")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    handleCreateWorkout()
                }) {
                    Text("Create")
                    Image(systemName: "square.and.pencil").foregroundColor(.colorPrimary)
                }
                .navigationDestination(isPresented: $willMoveToNextScreen) {
                    WorkoutView(name: split?.name ?? "", day: split?.day ?? "")
                }
                
            }
        }.tint(.colorPrimary)
    }
}

struct WorkoutEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WorkoutEditView()
                .environmentObject(BannerService())
                .environmentObject(SessionServiceImpl())
                .environmentObject(SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter()))
        }
    }
}