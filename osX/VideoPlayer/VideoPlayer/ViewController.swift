//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Sheila Gonzalez on 2019-10-21.
//  Copyright © 2019 Sheila Gonzalez. All rights reserved.
//

import Cocoa
import AVKit

class ViewController: NSViewController {
    @IBOutlet weak var playerView: AVPlayerView!
    
    var player : AVPlayer!
    var playerItem : AVPlayerItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurePlayer()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    func configurePlayer() {
        if let path = Bundle.main.path(forResource: "asl", ofType: "mp4")
        {
            player = AVPlayer(url: URL(fileURLWithPath: path))
            playerView.player = player
        }
    }

}

