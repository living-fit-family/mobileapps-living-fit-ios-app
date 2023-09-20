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
    
    func blackListed(video: Video) -> Bool {
        return video.category == "abs" ||
        video.category == "cardio" ||
        video.category == "hiit" ||
        video.category == "resistance band" ||
        video.name == "Plate Walk Up" ||
        video.name == "Ladder Push Up" ||
        video.name == "Push Up" ||
        video.name == "Release Push Up" ||
        video.name == "Australian Pull Up"
    }
    
    var body: some View {
        HStack(spacing: 8) {
            KFImage.url(URL(string: video.squareImageLink ?? ""))
                .loadDiskFileSynchronously()
                .cacheMemoryOnly()
                .fade(duration: 0.25)
                .onProgress { receivedSize, totalSize in  }
                .onSuccess { result in  }
                .onFailure { error in }
                .resizable()
                .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                .frame(height: 55)
                .cornerRadius(4)
            VStack(alignment: .leading, spacing: 4) {
                Text(video.name)
                    .font(.subheadline)
                if video.category == Query.cardio.rawValue {
                    Text("\(video.duration ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else if video.category == Query.hiit.rawValue {
                    Text("Included in HIIT Interval")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    Text("\(video.sets ?? "") x \(video.reps ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                return 0
            }
            Spacer()
            if !blackListed(video: video) {
                HStack(alignment: .lastTextBaseline) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.ultraThickMaterial)
                            .frame( width: 60, height: 30)
                        Text(weight)
                            .font(.subheadline)
                    }
                    Text("lbs")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    setVideoName(video.name)
                    self.showingUnitOfMeasureForm.toggle()
                }
            }
        }
    }
}

struct WorkoutCard_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCard(video: Video.sampleVideo, showingUnitOfMeasureForm: .constant(false), weight: "25") { _ in
            
        }
    }
}
