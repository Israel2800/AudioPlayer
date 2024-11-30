//
//  Reproductor.swift
//  AudioPlayer
//
//  Created by Paola Delgadillo on 11/29/24.
//

import Foundation
import AVKit
import AVFoundation

class Reproductor : AVPlayerViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let laURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") {
            self.player = AVPlayer(url: laURL)
        }
    }
}
