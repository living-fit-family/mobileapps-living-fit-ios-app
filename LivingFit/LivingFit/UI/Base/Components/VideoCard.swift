//
//  VideoCard.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//

import SwiftUI

struct VideoCard: View {
    var video: Video
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: video.imageLink)) { image in
                    image.resizable()
                        .aspectRatio(CGSize(width: 9, height: 16 ), contentMode: .fill)
                        .frame(width: 165, height: 225)
                        .cornerRadius(20)
                } placeholder: {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .frame(width: 165, height: 225)
                        .cornerRadius(20)
                }
                VStack(alignment: .leading) {
                    Text(video.name)
                        .font(.caption).bold()
                    Text(video.setDuration)
                        .font(.caption).bold()
                }
                .foregroundColor(.white)
                .shadow(radius: 20)
                .padding()
            }
            Image(systemName: "play.fill")
                .foregroundColor(.white)
                .font(.title)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(50)
        }
    }
}

struct VideoCard_Previews: PreviewProvider {
    static var previews: some View {
        VideoCard(video: Video.sampleVideo)
    }
}
