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
    
    
    @IBOutlet weak var equalizerImg: UIImageView!
    
    var redOverlayView: UIView!
    
    var player: AVPlayer?
    
    let stringsArr = [
        "Stress Reduction: Engaging in mindful walking can be an effective way to reduce stress and promote relaxation. By directing your attention to the physical sensations of walking, you create a mental break from everyday stressors. This practice activates the relaxation response in your body, leading to a calmer state of mind",
        "Emotional Regulation: Engaging in mindful walking can help regulate your emotions. By observing your thoughts and emotions as they arise during the practice, you develop a non-judgmental and accepting attitude towards them. This can enhance emotional resilience and provide you with a greater sense of control over your reactions to challenging situations."
    ]
    
    let spanishStringsArr = [
        "Reducción del estrés: Participar en la caminata consciente puede ser una forma efectiva de reducir el estrés y promover la relajación. Al dirigir tu atención a las sensaciones físicas de caminar, creas un descanso mental de los factores estresantes cotidianos. Esta práctica activa la respuesta de relajación en tu cuerpo, lo que lleva a un estado mental más tranquilo.",
        "Regulación emocional: Participar en la caminata consciente puede ayudar a regular tus emociones. Al observar tus pensamientos y emociones a medida que surgen durante la práctica, desarrollas una actitud de no juicio y aceptación hacia ellos. Esto puede mejorar la resiliencia emocional y brindarte un mayor sentido de control sobre tus reacciones ante situaciones desafiantes."
    ]

    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var rewindImg: UIImageView!
    
    @IBOutlet weak var playPauseImg: UIImageView!
    
    @IBOutlet weak var forwardImg: UIImageView!
    
    @IBOutlet weak var playAudioImg: UIImageView!
    
    @IBOutlet weak var backImg: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var languageId : Int = 1
    
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        guard let url = URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3") else {
            print("Invalid URL")
            return
        }
        player = AVPlayer(url: url)
        
        
        descriptionLabel.attributedText = add(stringList: languageId == 1 ? stringsArr : spanishStringsArr, font: descriptionLabel.font, bullet: "•")
        
        
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
    
    
    func setupLanguage() {
        
             languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        titleLabel.text = AppHelper.getLocalizeString(str:"Mindful walking")
        
        subtitleLabel.text = AppHelper.getLocalizeString(str: "What are the benefits of mindful walking?")
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLanguage()
        
        descriptionLabel.attributedText = add(stringList: languageId == 1 ? stringsArr : spanishStringsArr, font: descriptionLabel.font, bullet: "•")
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
