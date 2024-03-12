//
//  WorkoutCompleteView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 3/6/24.
//

import SwiftUI

struct FireworkParticlesGeometryEffect : GeometryEffect {
    var time : Double
    var speed = Double.random(in: 20 ... 200)
    var direction = Double.random(in: -Double.pi ...  Double.pi)
    
    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let xTranslation = speed * cos(direction) * time
        let yTranslation = speed * sin(direction) * time
        let affineTranslation =  CGAffineTransform(translationX: xTranslation, y: yTranslation)
        return ProjectionTransform(affineTranslation)
    }
}


struct ParticlesModifier: ViewModifier {
    @State var time = 0.0
    @State var scale = 0.1
    let duration = 5.0
    
    func body(content: Content) -> some View {
        ZStack {
            ForEach(0..<80, id: \.self) { index in
                content
                    .hueRotation(Angle(degrees: time * 80))
                    .scaleEffect(scale)
                    .modifier(FireworkParticlesGeometryEffect(time: time))
                    .opacity(((duration-time) / duration))
            }
        }
        .onAppear {
            withAnimation (.easeOut(duration: duration)) {
                self.time = duration
                self.scale = 1.0
            }
        }
    }
}

struct WorkoutCompleteView:View {
    var completionTime: Double?
    var callback: () -> ()
    var body: some View {
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 12, height: 12)
                    .modifier(ParticlesModifier())
                    .offset(x: -100, y : -50)
                VStack(spacing: 12) {
                    Text("Congratulations!".uppercased())
                        .font(.custom("Avenir", size: 28))
                        .fontWeight(.bold)
                    Text("You have completed your workout!".uppercased())
                        .font(.custom("Avenir", size: 17))
                        .fontWeight(.semibold)
                    Text(completionTime?.format(using: [.hour, .minute, .second]) ?? "")
                        .font(.custom("Avenir", size: 36))
                        .foregroundStyle(Color.colorPrimary)
                        .bold()
                        .padding(.bottom)
                    ButtonView(title: "Return to Dashboard".uppercased(), font: .custom("Avenir", size: 16)) {
                        callback()
                    }
                    .padding(.horizontal)
                }
                Circle()
                    .fill(Color.red)
                    .frame(width: 12, height: 12)
                    .modifier(ParticlesModifier())
                    .offset(x: 60, y : 70)
            }
        }
}

#Preview {
    WorkoutCompleteView(completionTime: 4029.0) {
        print("Callback")
    }
}
