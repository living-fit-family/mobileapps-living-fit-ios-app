//
//  VideoListViewModel.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/1/23.
//

import Combine
import Foundation

enum Query: String, Encodable, CaseIterable {
    case back, shoulders, glutes
}

enum VideoState {
    case failure(err: Error)
    case success
    case na
}

class VideoListViewModel: ObservableObject {
    @Published private(set) var videos: [Video] = []
    @Published var selectedQuery: Query = Query.glutes {
        didSet {
            Task.init {
                service.fetchVideos()
            }
        }
    }
    @Published var state: VideoState = .na
    private var subscriptions = Set<AnyCancellable>()
    
    private var service: VideoService
    
    private static var instance: VideoListViewModel? = nil
    
    private init() {
        service = VideoServiceImpl(videoRespository: FirebaseVideoRespositoryAdapter())
        Task.init {
            await fetchVideos()
        }
    }
    
    public static func getInstance() -> VideoListViewModel? {
        if (instance == nil) {
            instance = VideoListViewModel()
        }
        return instance
    }
    
    func fetchVideos() async {
        if (videos.isEmpty) {
            service.fetchVideos()
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
