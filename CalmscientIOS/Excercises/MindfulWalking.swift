//
//  MindfulWalking.swift
//  sample
//
//  Created by Krishna on 8/6/24.
//

import Foundation

import UIKit
import AVFAudio
import AVFoundation


class MindfulWalking: UIViewController {
    
    
    
    var player: AVPlayer?
    
    let stringsArr = [
        "Stress Reduction: Engaging in mindful walking can be an effective way to reduce stress and promote relaxation. By directing your attention to the physical sensations of walking, you create a mental break from everyday stressors. This practice activates the relaxation response in your body, leading to a calmer state of mind",
        "Emotional Regulation: Engaging in mindful walking can help regulate your emotions. By observing your thoughts and emotions as they arise during the practice, you develop a non-judgmental and accepting attitude towards them. This can enhance emotional resilience and provide you with a greater sense of control over your reactions to challenging situations."
    ]
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var rewindImg: UIImageView!
    
    @IBOutlet weak var playPauseImg: UIImageView!
    
    @IBOutlet weak var forwardImg: UIImageView!
    
    @IBOutlet weak var playAudioImg: UIImageView!
    
    @IBOutlet weak var backImg: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        guard let url = URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3") else {
            print("Invalid URL")
            return
        }
        player = AVPlayer(url: url)
        
        
        descriptionLabel.attributedText = add(stringList: stringsArr, font: descriptionLabel.font, bullet: "•")
        
        
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
        
        self.titleLabel.font = UIFont(name: Fonts().lexendMedium, size: 19)
        self.subtitleLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.descriptionLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        
        
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
    
    
    func add(stringList: [String],
             font: UIFont,
             bullet: String = "\u{2022}",
             indentation: CGFloat = 20,
             lineSpacing: CGFloat = 2,
             paragraphSpacing: CGFloat = 12,
             textColor: UIColor = UIColor(hex: "#424242"),
             bulletColor: UIColor = .black) -> NSAttributedString {

        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: bulletColor]

        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation

        let bulletList = NSMutableAttributedString()
        for (index,string) in stringList.enumerated() {
            let formattedString = "\(index+1). \t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)

            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))

            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))

            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }

        return bulletList
    }
    
    
}
