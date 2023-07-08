//
//  FirebaseFirestoreRepositoryAdapter.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/1/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirebaseVideoRespositoryAdapter: VideoRepository {
    func fetchVideos() -> AnyPublisher<[Video], Error> {
        Deferred {
            Future { promise in
                Firestore
                    .firestore()
                    .collection("videos").getDocuments() { (querySnapshot, err) in
                        if let error = err {
                            print(error)
                            promise(.failure(error))
                        } else if let snapshot = querySnapshot {
                            let video: [Video] = snapshot.documents.compactMap {
                                return try? $0.data(as: Video.self)
                            }
                            promise(.success(video))
                        }
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
