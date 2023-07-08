//
//  VideoPlayer.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/4/23.
//

import SwiftUI

import SwiftUI
import AVFoundation

struct VideoPlayer: UIViewRepresentable {
    private var url: String = ""
    init(url: String) {
        self.url = url
    }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<VideoPlayer>) {
    }
    
    func makeUIView(context: Context) -> UIView {
        return LoopingPlayerUIView(url: url, frame: .zero)
    }
}

class LoopingPlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    init(url: String, frame: CGRect) {
        super.init(frame: frame)
        // Load the resource -> h
        let url = URL(string: url)!

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

