//
//  Progressive.swift
//  sample
//
//  Created by Krishna on 8/6/24.
//

import UIKit
import AVFAudio
import AVFoundation


class Progressive: UIViewController {
    
    
    
    @IBOutlet weak var backImg: UIImageView!
    var player: AVPlayer?
    
    @IBOutlet weak var playAudioImg: UIImageView!
    
    @IBOutlet weak var rewindImg: UIImageView!
    @IBOutlet weak var forwardImg: UIImageView!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        self.titleLabel.font = UIFont(name: Fonts().lexendMedium, size: 19)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        guard let url = URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3") else {
            print("Invalid URL")
            return
        }
        
        player = AVPlayer(url: url)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            backImg.isUserInteractionEnabled = true
            backImg.addGestureRecognizer(tapGestureRecognizer)
        
        let rewindGesture = UITapGestureRecognizer(target: self, action: #selector(rewindTapped(tapGestureRecognizer:)))
            rewindImg.isUserInteractionEnabled = true
        rewindImg.addGestureRecognizer(rewindGesture)
        
        let forwardGesture = UITapGestureRecognizer(target: self, action: #selector(forwardTapped(tapGestureRecognizer:)))
            forwardImg.isUserInteractionEnabled = true
        forwardImg.addGestureRecognizer(forwardGesture)
        
        
        let playPauseGesture = UITapGestureRecognizer(target: self, action: #selector(playPauseTapped(tapGestureRecognizer:)))
            playAudioImg.isUserInteractionEnabled = true
            playAudioImg.addGestureRecognizer(playPauseGesture)
        
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated: true)
        // Your action
    }
    
    @objc func rewindTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        guard let player = player else { return }
                let currentTime = player.currentTime()
                let newTime = CMTimeSubtract(currentTime, CMTimeMakeWithSeconds(10, preferredTimescale: currentTime.timescale))
                player.seek(to: newTime)
        
    }
    
    @objc func forwardTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        guard let player = player else { return }
                let currentTime = player.currentTime()
                let newTime = CMTimeAdd(currentTime, CMTimeMakeWithSeconds(10, preferredTimescale: currentTime.timescale))
                player.seek(to: newTime)
        
    }
    
    @objc func playPauseTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        player?.timeControlStatus == .playing ? player?.pause() : player?.play()
        playAudioImg.image = player?.timeControlStatus == .playing ? UIImage(named: "fav") : UIImage(named: "playAudio")
        
    }
    
    
}

