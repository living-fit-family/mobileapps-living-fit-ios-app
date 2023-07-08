//
//  VideoService.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/1/23.
//

import Combine
import Foundation

protocol VideoService {
   func fetchVideos() -> AnyPublisher<[Video], Error>
}

final class VideoServiceImpl: VideoService {
    private var videoRespository: VideoRepository
    
    init(videoRespository: VideoRepository) {
        self.videoRespository = videoRespository
    }
    
    func fetchVideos() -> AnyPublisher<[Video], Error> {
        videoRespository.fetchVideos()
    }
}
