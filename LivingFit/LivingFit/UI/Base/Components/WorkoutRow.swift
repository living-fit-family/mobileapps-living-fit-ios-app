//
//  WorkoutRow.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/20/23.
//

import SwiftUI
import Kingfisher

struct WorkoutRow: View {
    var video: Video
        var body: some View {
            HStack {
                KFImage.url(URL(string: "\(video.squareImageLink ?? video.imageLink)"))
//                          .placeholder(Rectangle()
//                            .foregroundColor(.gray.opacity(0.3))
//                            .frame(width: 50, height: 50))
//                          .setProcessor(processor)
                          .loadDiskFileSynchronously()
                          .cacheMemoryOnly()
                          .fade(duration: 0.25)
//                          .lowDataModeSource(.network(lowResolutionURL))
                          .onProgress { receivedSize, totalSize in  }
                          .onSuccess { result in  }
                          .onFailure { error in }
                          .resizable()
                          .frame(width: 50, height: 50)
                Text(video.name)
                Spacer()
            }
        }
}

struct WorkoutRow_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutRow(video: Video.sampleVideo)
    }
}
