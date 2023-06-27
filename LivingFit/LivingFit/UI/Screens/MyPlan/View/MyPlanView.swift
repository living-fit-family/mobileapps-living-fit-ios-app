//
//  HomeView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//

import SwiftUI

private struct Workout: Identifiable {
    let name: String
    let day: String
    var id: String { name }
}

private let workoutSplit: [Workout] = [
    Workout(name: "Back & Shoulders", day: "Monday"),
    Workout(name: "Heavy Legs", day: "Tuesday"),
    Workout(name: "Bodyweight H.I.I.T", day: "Wednesday"),
    Workout(name: "Chest & Arms", day: "Thursday"),
    Workout(name: "Glutes", day: "Friday")
]

struct MyPlanView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Hello, \(sessionService.user?.firstName ?? "Friend")")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Friday, June 24 (Week 1 of 4)")
                        .font(.title3)
                        .foregroundColor(Color(red: 0.66, green: 0.66, blue: 0.66))
                }
            }
            VStack(alignment: .leading, spacing: 16) {
                VStack {
                    Text("Heavy Leg Gains")
                        .font(
                            .system(size: 19)
                            .weight(.semibold)
                        )
                        .foregroundColor(Color(red: 0.09, green: 0.1, blue: 0.17))
                    
                }
                HStack {
                    ProgressView()
                    VStack(spacing: 16) {
                        ForEach(workoutSplit) { workout in
                            NavigationLink(destination: EmptyView()) {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(maxWidth: 350, maxHeight: 80)
                                        .background(.white)
                                        .cornerRadius(10)
                                    HStack {
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 48, height: 48)
                                            .background(.green)
                                            .cornerRadius(10)
                                            .overlay {
                                                Image("military-press")
                                                    .resizable()
                                                    .scaledToFit()
                                            }
                                        
                                        VStack(alignment: .leading) {
                                            Text(workout.day)
                                                .font(
                                                    .system(size: 16)
                                                    .weight(.semibold)
                                                )
                                                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.18))
                                                .frame(width: 162.31305, height: 22, alignment: .topLeading)
                                            Text(workout.name)
                                                .font(
                                                    .system(size: 14)
                                                )
                                                .foregroundColor(Color(red: 0.26, green: 0.33, blue: 0.4))
                                                .frame(width: 153, height: 23, alignment: .topLeading)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .renderingMode(.template)
                                            .foregroundColor(.gray)
                                    }.padding(.horizontal)
                                }
                                .frame(maxWidth: 350, maxHeight: 80)
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.05), radius: 4, x: 0, y: 3)
                            }
                        }
                    }
                }
            }
            Spacer()
        }.padding()
    }
}

struct MyPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MyPlanView()
            .environmentObject(SessionServiceImpl())
    }
}
