//
//  Player.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/28.
//

import SwiftUI
import AVKit

struct PlayerView: UIViewControllerRepresentable {
    @Binding var player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController,
                                context: Context) {
        uiViewController.player = player
    }
}
