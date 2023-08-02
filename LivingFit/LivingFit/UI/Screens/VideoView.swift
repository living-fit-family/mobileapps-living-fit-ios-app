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
                VStack(alignment: .leading, spacing: 12) {
                    Text(video.name.replacingOccurrences(of: "\\n", with: "\n"))
                        .font(.title)
                        .fontWeight(.semibold)
                    VStack(alignment: .leading, spacing: 16) {
                        if video.category == Query.cardio.rawValue {
                            Text("Duration: \(video.duration ?? "N/A")")
                                .foregroundColor(Color(hex: "3A4750"))
                            
                            Text("Rest: \(video.rest ?? "N/A")")
                                .foregroundColor(Color(hex: "3A4750"))
                        } else {
                            Text("Sets: \(video.sets ?? "N/A")")
                                .foregroundColor(Color(hex: "3A4750"))
                            Text("Reps: \(video.reps ?? "N/A")")
                                .foregroundColor(Color(hex: "3A4750"))
                            Text("Rest: \(video.rest ?? "N/A")")
                                .foregroundColor(Color(hex: "3A4750"))
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
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
