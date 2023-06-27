//
//  ContentView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/8/23.
//

import SwiftUI
import AVKit
import AVFoundation

struct PlayerView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }
    
    func makeUIView(context: Context) -> UIView {
        return LoopingPlayerUIView(frame: .zero)
    }
}

class LoopingPlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Load the resource -> h
        let url = URL(string: "https://ik.imagekit.io/z9gymi5p9/main.mp4?updatedAt=1680125548332")!
        //        let fileUrl = Bundle.main.url(forResource: "onboarding", withExtension: "mov")!
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        // Setup the player
        let player = AVQueuePlayer()
        playerLayer.player = player;
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        // Create a new player looper with the queue player and template items
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        // Start the movie
        player.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}

struct ContentView: View {
    @State private var isPresented = false

    var body: some View {
//        NavigationView {
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
                        Image("Full Logo")
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
            }.background(.black)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        NavigationStack {
            ContentView()
//        }
    }
}
