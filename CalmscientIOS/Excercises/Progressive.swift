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
    
    @IBOutlet weak var equalizerImg: UIImageView!
    @IBOutlet weak var backImg: UIImageView!
    var player: AVPlayer?
    
    @IBOutlet weak var playAudioImg: UIImageView!
    @IBOutlet weak var rewindImg: UIImageView!
    @IBOutlet weak var forwardImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var redOverlayView: UIView!
    var languageId : Int = 1
    
    
    override func viewDidLoad() {
        self.titleLabel.font = UIFont(name: Fonts().lexendMedium, size: 18)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        guard let url = URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3") else {
            print("Invalid URL")
            return
        }
        
        player = AVPlayer(url: url)
        
        // Adding gesture recognizers
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLanguage()
    }
    
    
    func setupLanguage() {
        
             languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        titleLabel.text = AppHelper.getLocalizeString(str:"Progressive muscle relaxation")
        
        }
    
    func addGestureRecognizers() {
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
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rewindTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let player = player else { return }
        let currentTime = player.currentTime()
        let newTime = CMTimeSubtract(currentTime, CMTimeMakeWithSeconds(10, preferredTimescale: currentTime.timescale))
        player.seek(to: newTime)
    }
    
    @objc func forwardTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let player = player else { return }
        let currentTime = player.currentTime()
        let newTime = CMTimeAdd(currentTime, CMTimeMakeWithSeconds(10, preferredTimescale: currentTime.timescale))
        player.seek(to: newTime)
    }
    
    @objc func updateOverlayView() {
        guard let player = player else { return }
        let totalDuration = player.currentItem?.duration.seconds ?? 1.0
        let currentTime = player.currentTime().seconds
        let progress = CGFloat(currentTime / totalDuration)
        
        let newWidth = equalizerImg.frame.width * progress
        redOverlayView.frame = CGRect(x: 0, y: 0, width: newWidth, height: equalizerImg.frame.height)
        
        // Stop the timer if the audio has finished playing
        if progress >= 1.0 {
            redOverlayView.frame = CGRect(x: 0, y: 0, width: equalizerImg.frame.width, height: equalizerImg.frame.height)
        }
    }
    
    @objc func playPauseTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        equalizerImg.contentMode = .scaleToFill
        
        // Create the red overlay view
        redOverlayView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: equalizerImg.frame.height))
        redOverlayView.backgroundColor = UIColor(hex: "#F48383")
        equalizerImg.addSubview(redOverlayView)
        
        // Create the mask layer
        let maskLayer = CAShapeLayer()
        maskLayer.frame = equalizerImg.bounds
        
        // Use the image as the mask
        maskLayer.contents = equalizerImg.image?.cgImage
        redOverlayView.layer.mask = maskLayer
        
        // Play or pause audio
        if player?.timeControlStatus == .playing {
            playAudioImg.image = UIImage(named: "playAudio")
            player?.pause()
            
        } else {
            playAudioImg.image = UIImage(named: "pause")
            player?.play()
        }
        
        // Start a timer to update the red overlay view based on the audio progress
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateOverlayView), userInfo: nil, repeats: true)
        
        // Update the play/pause icon
//        playAudioImg.image = player?.timeControlStatus == .playing ? UIImage(named: "pause") : UIImage(named: "playAudio")
    }
}

