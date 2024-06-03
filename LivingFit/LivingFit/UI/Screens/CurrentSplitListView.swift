//
//  HomeView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//

import SwiftUI
import Kingfisher
import StreamChat
import StreamChatSwiftUI

enum Destination {
    case workout
    case editWorkout
}

struct CurrentSplitListView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var splitSessionService: SplitSessionServiceImpl
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var unreadChannelCount = 0
    
    @State private var path = NavigationPath()
    
    var date: Text {
        return Text(Date(), style: .date)
    }
    
    var partOfDay: String {
        let components = Calendar.current.dateComponents([.hour], from: Date())
        let hour = components.hour ?? 0
        var partOfDay = ""
        if (hour >= 0 && hour < 12) {
            partOfDay = "Morning"
        } else if (hour >= 12 && hour < 17) {
            partOfDay = "Afternoon"
        } else if (hour >= 17 && hour != 0) {
            partOfDay = "Evening"
        }
        return String(partOfDay)
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
    
    func totalQuantity(segment: Split.Segment) -> Int {
        // Using reduce to calculate the total quantity
        let sum = segment.exercises.reduce(0) { (result, currentStruct) -> Int in
            return result + currentStruct.number
        }
        return sum
    }
    
    func getCompletedWorkouts() -> Int {
        return splitSessionService.completedWorkouts
    }
    
    
    var body: some View {
        NavigationStack(path: $path) {
            
            VStack(alignment: .leading) {
                HStack {
                    ProfileImageView(showingOptions: .constant(false), imageUrl: URL(string: sessionService.user?.photoUrl ?? ""), enableEditMode: false)
                    
                    VStack(alignment: .leading) {
                        Text("Good \(partOfDay)")
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundStyle(.gray)
                        
                        Text("\(sessionService.user?.username ?? "Living Fit User")")
                            .font(.title)
                            .fontWeight(.bold)
                        
                    }
                    Spacer()
                    NavigationLink {
                        AnyView(NavigationLazyView(ChatChannelListView(viewFactory: CustomViewFactory.shared, title: "Channels", embedInNavigationView: false)))
                    } label: {
                        // existing contents…
                        Image(systemName: "text.bubble")
                            .imageScale(.large)
                            .fontWeight(.medium)
                            .foregroundStyle(.black)
                            .overlay {
                                NotificationCountView(value: $unreadChannelCount)
                            }
                            .padding(.bottom)
                    }
                }
                .padding([.horizontal, .bottom])
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.gradient)
                    .frame(height: 100)
                    .overlay {
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Workout Progress")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text("\(getCompletedWorkouts())/20 total workouts completed")
                                    .font(.subheadline)
                                    .foregroundStyle(Color(.systemGray3))
                            }
                            
                            Spacer()
                            VStack {
                                ZStack {
                                    Circle()
                                        .stroke(lineWidth: 8)
                                        .foregroundColor(Color(.systemGray3))
                                        .frame(width: 65, height: 65)
                                    Circle()
                                        .trim(from: 0.0, to: CGFloat(getCompletedWorkouts()) / 20)
                                        .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                                        .foregroundStyle(Color.colorPrimary)
                                        .rotationEffect(.degrees(270.0))
                                        .foregroundColor(.black)
                                        .frame(width: 65, height: 65)
                                    
                                    Text("\(getCompletedWorkouts() * 100 / 20)%")
                                        .foregroundStyle(.white)
                                        .font(.subheadline)
                                        .bold()
                                }
                            }
                        }
                        .padding()
                    }
                    .padding([.bottom, .horizontal])
                Text("\(splitSessionService.split?.name ?? "") • Week \(splitSessionService.split?.startDate ?? "")/\(splitSessionService.split?.endDate ?? "" )")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding([.horizontal])
                Divider()
                    .padding(.leading)
            }
            if let segments = splitSessionService.split?.segments {
                VStack {
                    List {
                        ForEach(segments, id: \.self) { segment in
                            NavigationLink(value: segment) {
                                HStack {
                                    KFImage.url(URL(string: segment.placeholder))
                                        .resizable()
                                        .frame(width: 110, height: 110)
                                        .cornerRadius(8)
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(segment.day)
                                            .bold()
                                            .font(.headline)
                                            .lineLimit(1)
                                        Text(segment.name)
                                            .font(.subheadline)
                                            .foregroundStyle(Color.gray)
                                        HStack {
                                            Text("\(totalQuantity(segment: segment)) Total Exercises")
                                                .foregroundStyle(Color.colorPrimary)
                                                .font(.system(size: 10))
                                                .padding(4)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.colorPrimary, lineWidth: 0.5)
                                                )
                                        }
                                    }
                                }
                                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                                    return 0
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .listStyle(PlainListStyle())
                }
                .navigationDestination(for: Split.Segment.self) { segment in
                    getDestination(segment: segment) == .workout ?
                    AnyView(NavigationLazyView(WorkoutView(split: segment, path: $path).toolbar(.hidden, for: .tabBar))) :
                    AnyView(NavigationLazyView(WorkoutEditView(split: segment, path: $path).toolbar(.hidden, for: .tabBar)))
                }
            }
        }
        .tabItem {
            Label("Home", systemImage: "house.fill")
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
