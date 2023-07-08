//
//  VideoListView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/28/23.
//

import SwiftUI

struct VideoListView: View {
    @StateObject private var vm = VideoListViewModel.getInstance()!
    @State private var selectedVideo: Video? = nil
    @State private var selectedQuery: String? = ""
    
    var split: Workout.Split? = nil
    var queries: [String] {
        var queries: [String] = []
        if let split = split {
            split.requiredExercises.forEach {
                queries.append($0.category)
            }
        }
        return queries
    }
    
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    ForEach(queries, id: \.self) { query in
                        QueryTag(query: query, isSelected: self.selectedQuery == query)
                            .onTapGesture {
                                self.selectedQuery = query
                            }
                    }
                }
                Text("Pick 2 Exercises")
                    .font(.headline)
                    .padding(.leading, 15)
                    .padding(.top, 5)
                
                ScrollView {
                    if (vm.videos.isEmpty) {
                        VStack(alignment: .center) {
                            ProgressView()
                        }
                    } else {
                        VStack(alignment: .leading) {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(vm.videos.filter{$0.category == self.selectedQuery}) {video in
                                    VideoCard(video: video)
                                        .onTapGesture {
                                            self.selectedVideo = video
                                        }
                                }
                            }
                        }
                        .sheet(item: self.$selectedVideo) {
                            VideoView(video: $0)
                        }
                    }
                }
                ButtonView(title: "Create Workout") {
                    
                }
                .disabled(true)
            }.padding()
        }
        .navigationTitle(split?.name ?? "")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonTitleHidden()
    }
}

struct VideoListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VideoListView()
        }
    }
}
