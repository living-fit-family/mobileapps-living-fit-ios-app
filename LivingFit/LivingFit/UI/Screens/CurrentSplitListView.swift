//
//  HomeView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//

import SwiftUI
import Kingfisher
import PopupView
import SendbirdUIKit

enum Destination {
    case workout
    case editWorkout
}

struct CurrentSplitListView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var splitSessionService: SplitSessionServiceImpl
    @State var showProfile = false
    @State var showChat = false
    
    var date: Text {
        return Text(Date(), style: .date)
    }
    
    func workoutExists(segment: Split.Segment) -> Bool {
        let workouts = (splitSessionService.userWorkOuts[segment.day] ?? [])
        if !workouts.isEmpty {return true}
        return false
    }
    
    func getCategories(segment: Split.Segment) -> [String] {
        var queries: [String] = []
        segment.exercises.forEach {
            queries.append($0.category)
        }
        return queries
    }
    
    func getDestination(segment: Split.Segment) -> Destination {
        if workoutExists(segment: segment) {
            return .workout
        } else {
            return .editWorkout
        }
    }
    
    var body: some View {
        NavigationStack {
            if let segments = splitSessionService.split?.segments {
                List {
                    Section {
                        ZStack {
                            VStack {
                                HStack(spacing: 0) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Hello, \(sessionService.user?.username ?? "Friend")")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                            .fontWeight(.light)
                                        Text("Today is \(date)")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                    }
                                    Spacer()
                                    ProfileImageView(showingOptions: .constant(false), imageUrl: URL(string: sessionService.user?.photoUrl ?? ""), enableEditMode: false)
                                }
                            }
                        }
                    }
                    
                    Section {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Current Split")
                                .font(.headline)
                                .fontWeight(.semibold)
                            HStack {
                                Text("\(splitSessionService.split?.name ?? "")")
                                    .font(.subheadline)
                                    .foregroundColor(.colorPrimary)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("Week \(splitSessionService.split?.startDate ?? "") / \(splitSessionService.split?.endDate ?? "")")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }
                        ForEach(segments, id: \.self) { segment in
                            NavigationLink(destination: getDestination(segment: segment) == .workout ? AnyView(NavigationLazyView(WorkoutView(split: segment))) :  AnyView(NavigationLazyView(WorkoutEditView(split: segment)))
                            ){
                                HStack(spacing: 10) {
                                    KFImage.url(URL(string: segment.placeholder))
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
                                        Text(segment.day)
                                            .font(.headline)
                                        Text(segment.name)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                }
                                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                                    return 0
                                }
                                
                            }
                            
                        }
                    }
                }
                .navigationTitle("Workout Plan")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image("full-logo-transparent-white")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 40)
                        
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action:{
                            SendbirdUI.connect { (user, error) in
                                // user object will be an instance of SBDUser
                                guard let _ = user else {
                                    print("ContentView: init: Sendbird connect: ERROR: \(String(describing: error)). Check applicationId")
                                    return
                                }
                            }
                            showChat = true
                        }) {
                            Image(systemName: "message")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20)
                        }
                        
                    }
                    
                }
            }
        }
        .popup(isPresented: $showChat) {
            ChannelListViewContainer()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showChat = false
                    }
                }
        }
        .tabItem {
            Label("Plan", systemImage: "calendar")
        }
    }
}

struct CurrentSplitListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CurrentSplitListView()
                .environmentObject(SessionServiceImpl())
                .environmentObject(SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter()))
        }
    }
}

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

