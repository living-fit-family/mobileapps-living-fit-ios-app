//
//  PlayerView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/7/23.
//

//
//  VideoPlayer.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/4/23.
//

import SwiftUI

import SwiftUI
import AVFoundation

struct PlayerView: UIViewRepresentable {
    private var url: String = ""

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

        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        // Setup the player
        let player = AVQueuePlayer()
        playerLayer.player = player;
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        // Create a new player looper with the queue player and template items
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        //Mute the audio
        player.isMuted = true
        // Start the video
        player.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
