//
//  HomeView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//

import SwiftUI
import Kingfisher
import StreamChatSwiftUI

struct CurrentSplitListView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var splitSessionService: SplitSessionServiceImpl
    
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
    
    var body: some View {
        NavigationStack {
            if let segments = splitSessionService.split?.segments {
                List {
                    Section {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Hello, \(sessionService.user?.firstName ?? "Friend")")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                    .fontWeight(.light)
                                Text("Today is \(date)")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                            ProfileImageView(showingOptions: .constant(false), imageUrl: URL(string: sessionService.user?.photoURL ?? ""), enableEditMode: false)
                            
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
                    Section {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Split Focus")
                                .font(.title2)
                                .fontWeight(.semibold)
                            HStack {
                                Text("\(splitSessionService.split?.name ?? "")")
                                    .font(.subheadline)
                                    .foregroundColor(.colorPrimary)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("Week 1 / 4")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }
                        ForEach(segments, id: \.self) { segment in
                            NavigationLink(value: segment) {
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
                                            .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.18))
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
                .navigationDestination(for: Split.Segment.self) { segment in
                    if workoutExists(segment: segment) {
                        WorkoutView(name: segment.name, day: segment.day)
                    } else {
                        WorkoutEditView(split: segment)
                    }
                }
                .navigationTitle("Workout Plan")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 40)
                        
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: ChatChannelListView(viewFactory: CustomFactory.shared, title: "Family Chat", handleTabBarVisibility: false, embedInNavigationView: false)){
                            Image(systemName: "message")
                                .resizable()
                                .frame(width: 22, height: 22)
                                .fontWeight(.light)
                                .foregroundColor(.black)
                        }
                        
                    }
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
                .environmentObject(AppState())
                .environmentObject(SessionServiceImpl())
                .environmentObject(SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter()))
        }
    }
}
