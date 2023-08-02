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
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var splitSessionService: SplitSessionServiceImpl
    
    @State private var isPresented = false
    @State private var path: [Int] = []
    
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
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 20) {
                    Image(uiImage: sessionService.image)
                        .resizable()
                        .scaledToFill()
                        .background(
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color(UIColor.systemGray5)))
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text("Hi, \(sessionService.user?.firstName ?? "Friend")")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#313131"))
                        Text("Today is \(date)")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .fontWeight(.light)
                    }
                }
                .padding(.horizontal)
                
                
                
                if let segments = splitSessionService.split?.segments {
                    List {
                        Section {
                            VStack(alignment: .leading) {
                                Text("Current Split Focus (Week 1 of 4)")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text(splitSessionService.split?.name ?? "")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.colorPrimary)
                            }
                        }
                        ForEach(segments, id: \.self) { segment in
                            NavigationLink {
                                if workoutExists(segment: segment) {
                                    WorkoutView(name: segment.name, day: segment.day)
                                } else {
                                    WorkoutEditView(split: segment)
                                }
                            } label: {
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
                    .listStyle(.plain)
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink(destination: ChatChannelListView(viewFactory: CustomFactory.shared, title: "Family Chat")){
                        Image(systemName: "message")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .fontWeight(.light)
                            .foregroundColor(Color(hex: "#313131"))
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
                .environmentObject(SessionServiceImpl())
                .environmentObject(SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter()))
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        }
        NavigationStack {
            CurrentSplitListView()
                .environmentObject(SessionServiceImpl())
                .environmentObject(SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter()))
                .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        }
    }
}
