//
//  WorkoutCard.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 9/17/23.
//

import SwiftUI
import Kingfisher

enum Flavor: String, CaseIterable, Identifiable {
    case chocolate, vanilla, strawberry
    var id: Self { self }
}

struct WorkoutCard: View {
    var video: Video
    @State private var selectedFlavor: Flavor = .chocolate
    @State private var showWeightPicker: Bool = false
    @State private var weightValue = "0"
    
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
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThickMaterial)
//                    Picker("lbs", selection: $selectedFlavor) {
//                        ForEach(Array(stride(from: 5, to: 105, by: 5)), id: \.self) { index in
//                            // ...
//                            Text(index.description)
//                        }
//                    }
                    TextFieldView(input: $weightValue, placeholder: "20", keyboardType: .decimalPad, isSecure: false)
                }
                .frame( width: 120, height: 35)
                Image(systemName: "play.fill")
                    .foregroundColor(.white)
                    .font(.caption)
                    .padding()
                    .background(.green)
                    .cornerRadius(50)
            }
            Spacer()
            
        }
        .contentShape(Rectangle())
//        .sheet(isPresented: $showWeightPicker) {
//            VStack {
//                HStack {
//                    Button(action: {
//                        self.showWeightPicker.toggle()
//                    }) {
//                        Text("CANCEL")
//                    }
//                    Spacer()
//                    Button(action: {
////                        vm.goal = self.newGoal
//                        self.showWeightPicker.toggle()
//                    }) {
//                        Text("SET")
//                    }
//                }.padding([.top, .horizontal])
//
//                .presentationDetents([.fraction(0.30)])
//                .interactiveDismissDisabled()
//            }
//        }
    }
}

struct WorkoutCard_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCard(video: Video.sampleVideo)
    }
}
