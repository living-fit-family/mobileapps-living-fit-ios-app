//
//  HomeView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/11/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .strokeBorder(.green, lineWidth: 3)
                    .frame(width: 85, height: 85)
                    .overlay {
                        Image("Profile")
                            .resizable()
                            .scaledToFit()
                            .padding(5)
                    }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Good Morning ☀️")
                        .font(.headline)
                    Text("Alexander Cleoni")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Tuesday, February 14th")
                        .font(.title3)
                        .foregroundColor(Color(hex: "707070"))
                }
                Spacer()
            }
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.green)
                    .frame(maxHeight: 72)
                    .overlay {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Today is Back and Legs")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                Text("Do you want to start the workout?")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                            }
                            VStack {
                                Button(action: {}) {
                                    Text("Start")
                                        .foregroundColor(.green)
                                        .fontWeight(.semibold)
                                }
                                .frame(width: 82, height: 32)
                                .background(.white)
                                .cornerRadius(99)
                            }.padding(.leading)
                        }
                    }
            }
            HStack {
                Text("My Exercises")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("(Week 1 of 8)")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
            }.padding([.top, .bottom])
            VStack {
               RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(maxHeight: 120)
                    .shadow(radius: 10)
                    .overlay {
                        HStack {
                            Image("military-press")
                                .resizable()
                                .frame(width: 100, height: 100)
                            VStack(alignment: .leading) {
                                Text("Back and Shoulders")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                Text("3 Back / 2 Shoulders / 2 abs")
                                    .font(.body)
                                    .foregroundColor(Color(hex: "192126", alpha: 0.50))
                                HStack {
                                    Text("Edit")
                                        .padding(.zero)
                                    //                                    Image(systemName: "chevron.right")
                                    //                                        .padding(.zero)
                                }
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .padding(.top)
                            }
                            Spacer()
                        }
        
                    }
            }
            Spacer()
        }
//        .background(Color(hex: "F7F6FA"))
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
