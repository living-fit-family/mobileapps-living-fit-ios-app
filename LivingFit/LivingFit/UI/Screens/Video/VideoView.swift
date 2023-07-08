//
//  VideoView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//
import SwiftUI
import Combine


struct VideoView: View {
    var video: Video
    
    var body: some View {
        VStack {
//            VideoPlayer(player: AVPlayer(url: URL(string: video.videoLink)!))
                

            VideoPlayer(url: video.videoLink)
                .aspectRatio(CGSize(width: 4, height: 5 ), contentMode: .fit)
            HStack {
                VStack(alignment: .leading) {
                    Text(video.name)
                        .font(.largeTitle)
                        .bold()
                    Text(video.setDuration)
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 0.66, green: 0.66, blue: 0.66))
                }
                Spacer()
            }.padding(.horizontal)
            Spacer()
            ButtonView(title: "Add Exercise") {
                
            }.padding()
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(video: Video.sampleVideo)
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        VideoView(video: Video.sampleVideo)
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
    }
}
