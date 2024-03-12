//
//  WorkoutCard.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 9/17/23.
//

import SwiftUI
import Kingfisher


struct WorkoutCard: View {
    var video: Video
    @Binding var showingUnitOfMeasureForm: Bool
    var weight: String
    var setVideoName: (String) -> ()
    
    var body: some View {
        HStack(spacing: 12) {
            KFImage.url(URL(string: video.squareImageLink ?? ""))
                .loadDiskFileSynchronously()
                .cacheMemoryOnly()
                .fade(duration: 0.25)
                .onProgress { receivedSize, totalSize in  }
                .onSuccess { result in  }
                .onFailure { error in }
                .resizable()
                .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                .frame(height: 110)
                .cornerRadius(8)
            
            VStack(spacing: 10) {
                HStack(alignment: .center) {
                    Text(video.name)
                        .lineLimit(nil)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    if (video.category != "hiit") {
                        Text("\(weight) lbs")
                            .frame(width: 45)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.black)
                            .padding(8)
                            .background(.ultraThickMaterial)
                            .cornerRadius(8)
                            .onTapGesture {
                                setVideoName(video.name)
                                showingUnitOfMeasureForm.toggle()
                            }
                    }
                }
                HStack {
                    if video.category == Query.cardio.rawValue {
                        VStack {
                            Text("Duration")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text(video.duration ?? "")
                                .font(.footnote)
                                .fontWeight(.medium)
                        }
                    } else if video.category == Query.hiit.rawValue {
                        Text("Included in HIIT Interval")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    } else {
                        HStack {
                            VStack {
                                Text("Sets")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text(video.sets ?? "")
                                    .font(.footnote)
                                    .fontWeight(.medium)
                            }
                            Divider()
                                .frame(height: 16)
                                .padding(.horizontal, 4)
                            VStack {
                                Text("Reps")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text(video.reps ?? "")
                                    .font(.footnote)
                                    .fontWeight(.medium)
                            }
                            Divider()
                                .frame(height: 16)
                                .padding(.horizontal, 4)
                            VStack {
                                Text("Rest")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("\(video.rest ?? "") sec")
                                    .font(.footnote)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    Spacer()
                    Image("swap")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray)
                        .padding(.trailing)
                }
            }
        }
    }
}


struct WorkoutCard_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCard(video: Video.sampleVideo, showingUnitOfMeasureForm: .constant(false), weight: "25") { _ in
            
        }
        .padding()
    }
}
