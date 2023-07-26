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
            Image("Squat")
//            KFImage.url(URL(string: "\(video.imageLink)"))
//            //                          .placeholder(Rectangle()
//            //                            .foregroundColor(.gray.opacity(0.3))
//            //                            .frame(width: 50, height: 50))
//            //                          .setProcessor(processor)
//                .loadDiskFileSynchronously()
//                .cacheMemoryOnly()
//                .fade(duration: 0.25)
//            //                          .lowDataModeSource(.network(lowResolutionURL))
//                .onProgress { receivedSize, totalSize in  }
//                .onSuccess { result in  }
//                .onFailure { error in }
                .resizable()
                .aspectRatio(CGSize(width: 1, height: 1 ), contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipped()
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
