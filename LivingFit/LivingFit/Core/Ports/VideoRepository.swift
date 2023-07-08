//
//  VideoRepository.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/1/23.
//

import Combine
import Foundation

protocol VideoRepository {
    func fetchVideos() -> AnyPublisher<[Video], Error>
}
