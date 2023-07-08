//
//  HomeView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//

import SwiftUI

struct MyPlanView: View {
    @State private var isPresented = false
    @StateObject private var vm = MyPlanViewModel.getInstance()!
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                Text("Current Split Focus")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(vm.workout?.name ?? "")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.colorPrimary)
            }
            ScrollView {
                HStack {
                    VStack(spacing: 16) {
                        if let workout = vm.workout {
                            ForEach(workout.split) { split in
                                NavigationLink(destination: VideoListView(split: split)) {
                                    ZStack {
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(maxWidth: .infinity, maxHeight: 90)
                                            .background(.white)
                                            .cornerRadius(10)
                                        HStack(spacing: 20) {
                                            Rectangle()
                                                .foregroundColor(.clear)
                                                .frame(width: 70, height: 70)
                                                .foregroundColor(.gray.opacity(0.3))
                                                .cornerRadius(10)
                                                .overlay {
                                                    AsyncImage(url: URL(string: split.placeholder)) { image in
                                                        image.resizable()
                                                            .aspectRatio(CGSize(width: 4, height: 4 ), contentMode: .fit)
                                                            .cornerRadius(10)
                                                    } placeholder: {
                                                        Rectangle()
                                                            .aspectRatio(CGSize(width: 4, height: 4 ), contentMode: .fit)
                                                            .foregroundColor(.gray.opacity(0.3))
                                                            .cornerRadius(10)
                                                    }
                                                    
                                                }
                                            
                                            VStack(alignment: .leading) {
                                                Text(split.day)
                                                    .font(.headline)
                                                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.18))
                                                    .frame(width: 162, height: 20, alignment: .topLeading)
                                                Text(split.name)
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                                    .frame(width: 153, height: 23, alignment: .topLeading)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .renderingMode(.template)
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: 90)
                                    .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.05), radius: 4, x: 0, y: 3)
                                }
                            }
                        } else {
                            ProgressView()
                        }
                    }
                }
            }
        }.padding()
    }
}

struct MyPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MyPlanView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        
        MyPlanView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        
    }
}
