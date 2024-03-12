//
//  VideoPlayerView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 3/3/24.
//
import SwiftUI
import AVKit
import AVFoundation

class VideoPlayerCoordinator: NSObject {
    var player: AVQueuePlayer
    var urls: [URL]
    
    init(urls: [URL]) {
        self.urls = urls
        self.player = AVQueuePlayer(items: urls.map { AVPlayerItem(url: $0) })
        self.player.actionAtItemEnd = .none
        
        super.init()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    
    @objc func playerItemDidReachEnd() {
        // Loop the current video when it reaches the end
        player.seek(to: CMTime.zero)
        player.play()
    }
}

struct VideoPlayerView: UIViewControllerRepresentable {
    var urls: [URL]
    @Binding var currentIndex: Int
    @Binding var isPlaying: Bool
    
    
    class Coordinator: VideoPlayerCoordinator {
        var parent: VideoPlayerView
        
        init(parent: VideoPlayerView) {
            self.parent = parent
            super.init(urls: parent.urls)
        }
        
        override func playerItemDidReachEnd() {
            // Loop the current video when it reaches the end
            player.seek(to: CMTime.zero)
            player.play()
            
            super.playerItemDidReachEnd()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = context.coordinator.player
        playerViewController.showsPlaybackControls = false
        playerViewController.videoGravity = .resizeAspectFill
        // Disable Picture-in-Picture
        playerViewController.allowsPictureInPicturePlayback = false
        // Create an overlay view to disable text selection
        let overlayView = UIView()
        overlayView.backgroundColor = .clear
        overlayView.isUserInteractionEnabled = false
        
        // Add the overlay view on top of the AVPlayerViewController's view
        playerViewController.contentOverlayView?.addSubview(overlayView)
        
        // Mute audio
        context.coordinator.player.isMuted = true
        // Automatically play the AVQueuePlayer
        context.coordinator.player.play()
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update player items based on the current index
        if let currentItem = context.coordinator.player.currentItem,
           let currentIndex = urls.firstIndex(where: { (($0 as NSURL) as URL) == (currentItem.asset as! AVURLAsset).url }) {
            
            if currentIndex != self.currentIndex {
                let newItem = AVPlayerItem(url: urls[self.currentIndex])
                context.coordinator.player.replaceCurrentItem(with: newItem)
            }
        }
        
        // Check the play/pause state and adjust playback accordingly
        if isPlaying {
            context.coordinator.player.play()
        } else {
            context.coordinator.player.pause()
        }
    }
}


