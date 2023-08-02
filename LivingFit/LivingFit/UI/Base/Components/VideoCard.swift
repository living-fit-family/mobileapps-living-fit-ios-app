//
//  VideoCard.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//

import SwiftUI
import Kingfisher

struct VideoCard: View {
    var video: Video
    var isAdded: Bool
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottomLeading) {
                KFImage.url(URL(string: video.imageLink))
//                    .placeholder(Rectangle()
//                        .foregroundColor(.gray.opacity(0.3))
//                        .frame(width: 50, height: 50))
//                    .setProcessor(processor)
                    .loadDiskFileSynchronously()
                    .cacheMemoryOnly()
                    .fade(duration: 0.25)
//                    .lowDataModeSource(.network(lowResolutionURL))
                    .onProgress { receivedSize, totalSize in  }
                    .onSuccess { result in  }
                    .onFailure { error in }
                    .resizable()
                    .aspectRatio(CGSize(width: 9, height: 16 ), contentMode: .fill)
                    .frame(width: 165, height: 225)
                    .cornerRadius(8)
                VStack(alignment: .leading) {
                    Text(video.name.replacingOccurrences(of: "\\n", with: "\n"))
                        .lineLimit(2)
                        .font(.caption).bold()
                }
                .foregroundColor(.white)
                .shadow(radius: 20)
                .padding()
            }
            .padding(4)
            Image(systemName: "play.fill")
                .foregroundColor(.white)
                .font(.title)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(50)
        }
        .overlay {
            if isAdded {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.green, lineWidth: 2)
            }
        }
    }
}

struct VideoCard_Previews: PreviewProvider {
    static var previews: some View {
        VideoCard(video: Video.sampleVideo, isAdded: false)
    }
}
