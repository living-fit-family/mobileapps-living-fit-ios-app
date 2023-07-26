//
//  HomeView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//

import SwiftUI

struct CurrentSplitListView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var splitSessionService: SplitSessionServiceImpl
    
    @State private var isPresented = false
    
    var date: Text {
        return Text(Date(), style: .date)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 20) {
                    Image("profile")
                        .resizable()
                        .frame(width: 70, height: 70)
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
                }.padding(.horizontal)
                VStack(alignment: .leading) {
                    Text("Current Split Focus (Week 1 of 4)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(splitSessionService.split?.name ?? "")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.colorPrimary)
                }.padding(.horizontal)
                ScrollView {
                    HStack {
                        VStack(spacing: 16) {
                            if let segments = splitSessionService.split?.segments {
                                ForEach(segments) { segment in
                                    NavigationLink(destination: WorkoutEditView(split: segment)) {
                                        ZStack {
                                            Rectangle()
                                                .foregroundColor(.clear)
                                                .frame(maxWidth: .infinity, maxHeight: 90)
                                                .background(.white)
                                                .cornerRadius(10)
                                            HStack(spacing: 10) {
                                                Rectangle()
                                                    .foregroundColor(.clear)
                                                    .frame(width: 70, height: 70)
                                                    .foregroundColor(.gray.opacity(0.3))
                                                    .cornerRadius(10)
                                                    .overlay {
                                                        AsyncImage(url: URL(string: segment.placeholder)) { image in
                                                            image
                                                            
                                                                .resizable()
                                                                .aspectRatio(CGSize(width: 4, height: 4 ), contentMode: .fit)
                                                                .cornerRadius(10)
                                                        }
                                                    placeholder: {
                                                        Rectangle()
                                                            .aspectRatio(CGSize(width: 4, height: 4 ), contentMode: .fit)
                                                            .foregroundColor(.gray.opacity(0.3))
                                                            .cornerRadius(10)
                                                    }
                                                        
                                                    }
                                                
                                                VStack(alignment: .leading) {
                                                    Text(segment.day)
                                                        .font(.headline)
                                                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.18))
                                                        .frame(width: 162, height: 20, alignment: .topLeading)
                                                    Text(segment.name)
                                                        .font(.subheadline)
                                                        .foregroundColor(.gray)
                                                        .frame(width: 153, height: 23, alignment: .topLeading)
                                                }
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .renderingMode(.template)
                                                    .foregroundColor(.gray)
                                            }
                                            .padding()
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: 90)
                                        .padding(.horizontal)
                                        .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.10), radius: 4, x: 0, y: 3)
                                    }
                                }
                            }
                        }
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {}) {
                        Image(systemName: "bell")
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
