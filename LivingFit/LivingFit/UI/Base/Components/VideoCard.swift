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
    @State var isLoaded: Bool = false
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottomLeading) {
                KFImage.url(URL(string: video.imageLink))
                    .loadDiskFileSynchronously()
                    .cacheMemoryOnly()
                    .fade(duration: 0.10)
                    .onProgress { receivedSize, totalSize in  }
                    .onSuccess {
                        result in
                        self.isLoaded = true
                    }
                    .onFailure { error in }
                    .resizable()
                    .aspectRatio(CGSize(width: 9, height: 16 ), contentMode: .fill)
                    .frame(width: 165, height: 225)
                    .cornerRadius(8)
            }
            if isLoaded {
                Image(systemName: "play.fill")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(50)
            } else {
                ProgressView()
            }
        }
        .overlay {
            if isLoaded {
                ZStack(alignment: .bottom) {
                    if isAdded  {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.green, lineWidth: 4)
                    }
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.black)
                        .opacity(0.15)
                    HStack() {
                        Text(video.name)
                            .font(.caption).bold()
                            .foregroundColor(.white)
                            .shadow(radius: 20)
                            .padding([.bottom, .leading])
                        Spacer()
                    }
                    
                }
            }
        }
    }
}

struct VideoCard_Previews: PreviewProvider {
    static var previews: some View {
        VideoCard(video: Video.sampleVideo, isAdded: true)
    }
}
