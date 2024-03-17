//
//  VideoView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//
import SwiftUI
import Combine
import VideoPlayer
import CoreMedia
import AVKit


struct VideoView: View {
    @State var player = AVPlayer()
    @State private var time: CMTime = .zero
    @Binding var addedExercises: [Video]
    var video: Video
    var dismissAction: () -> Void
    var showButton: Bool = false
    
    
    func isAdded() -> Bool {
        let videos = addedExercises.filter {
            $0.name == video.name
        }
        
        if !videos.isEmpty { return true }
        return false
    }
    
    var body: some View {
        VStack {
            ZStack {
                VideoPlayerView(urls: [URL(string: video.videoLink)!], currentIndex: .constant(0), isPlaying: .constant(true))
                VStack(alignment: .center) {
                    Spacer()
                    HStack {
                        Text(video.name.replacingOccurrences(of: "\\n", with: "\n").uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 24)
                            .background(.thickMaterial)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 8,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: 8
                                )
                            )
                    }
                    
                }
            }
            HStack {
                VStack(alignment: .center) {
                    VStack {
                        if video.category == Query.cardio.rawValue {
                            HStack {
                                Spacer()
                                VStack {
                                    Text("DURATION")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                    Text("\(video.duration ?? "N/A")")
                                        .font(.largeTitle)
                                        .fontWeight(.semibold)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                Spacer()
                                Divider()
                                    .frame(height: 50)
                                Spacer()
                                VStack {
                                    Text("REST")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                    Text("\(video.rest ?? "N/A") sec")
                                        .font(.largeTitle)
                                        .fontWeight(.semibold)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                Spacer()
                            }
                            .padding(.vertical)
                        } else if video.category == Query.hiit.rawValue {
                            VStack(alignment: .center) {
                                Text("Included in HIIT Interval")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .padding()
                            }
                        } else {
                            HStack {
                                Spacer()
                                VStack {
                                    Text("SETS")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                    Text("\(video.sets ?? "N/A")")
                                        .font(.largeTitle)
                                        .fontWeight(.semibold)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                Spacer()
                                Divider()
                                    .frame(height: 50)
                                Spacer()
                                VStack {
                                    Text("REPS")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                    Text("\(video.reps ?? "N/A")")
                                        .font(.largeTitle)
                                        .fontWeight(.semibold)
                                    
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                Spacer()
                                Divider()
                                    .frame(height: 50)
                                Spacer()
                                VStack {
                                    Text("REST")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                    Text("\(video.rest ?? "N/A") sec")
                                        .font(.largeTitle)
                                        .fontWeight(.semibold)
                                    
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                Spacer()
                            }.padding(.vertical)
                        }
                    }
                }
            }
            if (showButton) {
                if (isAdded()) {
                    ButtonView(title: "Remove Exercise", background: .red) {
                        addedExercises = addedExercises.filter {
                            $0.name != video.name
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
