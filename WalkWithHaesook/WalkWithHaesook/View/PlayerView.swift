//
//  Player.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/28.
//

import SwiftUI
import AVKit

struct PlayerView: UIViewControllerRepresentable {
    let player: AVPlayer?
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.player = player
        repeatPlayer(controller)
        return controller
    }
    
    private func repeatPlayer(_ controller: AVPlayerViewController) {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil, queue: nil) { _ in
            controller.player?.seek(to: .zero)
            controller.player?.play()
        }
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController,
                                context: Context) {}
}
