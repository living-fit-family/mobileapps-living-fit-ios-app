//
//  VideoView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//
import SwiftUI
import Combine


struct VideoView: View {
    @Binding var addedExercises: [Video]
    var video: Video
    var dismissAction: () -> Void
    var showButton: Bool = false
    
    func isAdded() -> Bool {
        let videos = addedExercises.filter {
            $0.id == video.id
        }
        
        if !videos.isEmpty { return true }
        return false
    }
    
    var body: some View {
        VStack {
            PlayerView(url: video.videoLink)
                .aspectRatio(CGSize(width: 4, height: 5 ), contentMode: .fit)
            HStack {
                VStack(alignment: .leading) {
                    Text(video.name.replacingOccurrences(of: "\\n", with: "\n"))
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
            if (showButton) {
                if (isAdded()) {
                    ButtonView(title: "Remove Exercise", background: .red) {
                        addedExercises = addedExercises.filter {
                            $0.id != video.id
                        }
                        dismissAction()
                    }.padding()
                } else {
                    ButtonView(title: "Add Exercise") {
                        addedExercises.append(video)
                        dismissAction()
                    }.padding()
                }
            }
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(addedExercises: .constant([]), video: Video.sampleVideo, dismissAction: {})
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        
        VideoView(addedExercises: .constant([]), video: Video.sampleVideo, dismissAction: {})
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
    }
}
