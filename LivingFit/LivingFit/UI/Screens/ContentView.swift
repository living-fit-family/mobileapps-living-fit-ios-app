//
//  ContentView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/8/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresented = false
    
    var body: some View {
        GeometryReader{ geo in
            ZStack {
                PlayerView()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .overlay(Color.black.opacity(0.2))
                    .edgesIgnoringSafeArea(.all)
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.0), .black.opacity(1.0)]), startPoint: .top, endPoint: .bottom))
                    .frame(width: geo.size.width, height: geo.size.height)
                VStack {
                    Spacer()
                    Image("full-logo-transparent")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                    Text("Atlanta’s #1 In-Person Training Available Worldwide")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    Spacer()
                    Button(action: {isPresented.toggle()}) {
                        Text("Get Started")
                        Image(systemName: "chevron.right")
                    }
                    .font(.title3)
                    .foregroundColor(.green)
                    .fullScreenCover(isPresented: $isPresented, content: {
                        SignInView()
                    })
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .background(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
