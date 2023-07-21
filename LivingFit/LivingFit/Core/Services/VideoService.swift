//
//  VideoService.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/1/23.
//

import Combine
import Foundation

enum Query: String, Encodable, CaseIterable {
    case chest
    case shoulders
    case back
    case legs
    case glutes
    case band
    case triceps
    case biceps
    case hiit
    case abs
    case cardio
}

enum VideoState {
    case failure(err: Error)
    case success
    case na
}

class VideoService: ObservableObject {
    @Published private(set) var videos: [Video] = []
    @Published var selectedQuery: Query = Query.chest
    @Published var state: VideoState = .na
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var videoRepository: VideoRepository
    
    init(videoRepository: VideoRepository) {
        self.videoRepository = videoRepository
        Task.init {
            await fetchVideos()
        }
    }
    
    func fetchVideos() async {
        if (videos.isEmpty) {
            videoRepository.fetchVideos()
                .sink { res in
                    switch res {
                    case .failure(let err):
                        self.state = .failure(err: err)
                    default: break
                    }
                } receiveValue: { value in
                    self.state = .success
                    self.videos = value
                }.store(in: &subscriptions)
        }
    }
}
