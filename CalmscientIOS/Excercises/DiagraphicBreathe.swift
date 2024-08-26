//
//  DiagraphicBreathe.swift
//  sample
//
//  Created by Krishna on 8/6/24.
//


import Foundation
import UIKit
import AVFoundation
import AVKit


class DiagraphicBreathe: UIViewController {

    
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var preparationView: UIView!
    @IBOutlet weak var step1View: UIView!
    @IBOutlet weak var step2View: UIView!
    @IBOutlet weak var step3View: UIView!
    @IBOutlet weak var step4View: UIView!
    @IBOutlet weak var step5View: UIView!
    @IBOutlet weak var dot1View: UIView!
    @IBOutlet weak var dot2View: UIView!
    @IBOutlet weak var dot3View: UIView!
    @IBOutlet weak var dot4View: UIView!
    @IBOutlet weak var dot5View: UIView!
    @IBOutlet weak var verticalBar: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topDescriptionLabel: UILabel!
    @IBOutlet weak var preparationLabel: UILabel!
    @IBOutlet weak var preparationDescLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var step1DescLabel: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var step2DescLabel: UILabel!
    @IBOutlet weak var step3Label: UILabel!
    @IBOutlet weak var step3DescLabel: UILabel!
    @IBOutlet weak var step4Label: UILabel!
    @IBOutlet weak var step4DescLabel: UILabel!
    @IBOutlet weak var step5Label: UILabel!
    @IBOutlet weak var step5DescLabel: UILabel!
    @IBOutlet weak var videoDesc: UILabel!
    @IBOutlet weak var bottomDescLabel: UILabel!
    @IBOutlet weak var playPauseImg: UIImageView!
    @IBOutlet weak var maximiseImg: UIImageView!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var videoView: UIView!
    
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isMaximized: Bool = false
    var isPlaying = false
    var isFavorite = false
    var isFullScreen = false
    let avController = AVPlayerViewController()
    var autoHideTimer: Timer?
    var languageId :Int = 1
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = .white
        super.viewDidLoad()
        setupPlayer()
        setupProgressBar()
        bringControlsToFront()
        progressBar.setThumbImage(UIImage(), for: .normal)
        progressBar.tintColor = UIColor.white
        preparationView.applyShadow()
        step1View.applyShadow()
        step2View.applyShadow()
        step3View.applyShadow()
        step4View.applyShadow()
        step5View.applyShadow()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        dot2View.layer.cornerRadius = dot2View.frame.size.width / 2
        dot2View.backgroundColor = UIColor(hex: "#6E6BB3")
        dot2View.layer.masksToBounds = true
        
        
        dot3View.layer.cornerRadius = dot3View.frame.size.width / 2
        dot3View.backgroundColor = UIColor(hex: "#6E6BB3")
        dot3View.layer.masksToBounds = true
        
        
        dot4View.layer.cornerRadius = dot4View.frame.size.width / 2
        dot4View.backgroundColor = UIColor(hex: "#6E6BB3")
        dot4View.layer.masksToBounds = true
        
        
        dot5View.layer.cornerRadius = dot5View.frame.size.width / 2
        dot5View.backgroundColor = UIColor(hex: "#6E6BB3")
        dot5View.layer.masksToBounds = true
        
        
        dot1View.layer.cornerRadius = dot1View.frame.size.width / 2
        dot1View.backgroundColor = UIColor(hex: "#6E6BB3")
        dot1View.layer.masksToBounds = true
        
        
        verticalBar.backgroundColor = UIColor(hex: "#6E6BB3")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            backImg.isUserInteractionEnabled = true
            backImg.addGestureRecognizer(tapGestureRecognizer)
        
        let playPauseRecognizer = UITapGestureRecognizer(target: self, action: #selector(playPauseTapped(tapGestureRecognizer:)))
        playPauseImg.isUserInteractionEnabled = true
        playPauseImg.addGestureRecognizer(playPauseRecognizer)
        
        
            let maximiseGesture = UITapGestureRecognizer(target: self, action: #selector(maximiseTapped(tapGestureRecognizer:)))
            maximiseImg.isUserInteractionEnabled = true
            maximiseImg.addGestureRecognizer(maximiseGesture)
        
        
        
        setFonts()
    }
    
    
    func setupLanguage() {
        
             languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        titleLabel.text = AppHelper.getLocalizeString(str:"Diaphragmatic breathing exercise")
        
        topDescriptionLabel.text = AppHelper.getLocalizeString(str: "Doctors usually recommend diaphragmatic breathing to people with a lung condition called chronic obstructive pulmonary disease. A 2017 study found that it could also help reduce anxiety.")
        preparationLabel.text = AppHelper.getLocalizeString(str:"Preparation")
        preparationDescLabel.text = AppHelper.getLocalizeString(str: "First find a comfortable to either sit down or lay down.")
        
        subtitleLabel.text = AppHelper.getLocalizeString(str: "Let’s learn how to do the diaphragmatic breathing exercise.")
        
        step1Label.text =  AppHelper.getLocalizeString(str: "Step 1: Inhale")
        step1DescLabel.text = AppHelper.getLocalizeString(str: "Inhale through your nose until the tummy expands.")
        
        step2Label.text =  AppHelper.getLocalizeString(str: "Step 2: Exhale slowly and repeat it")
        step2DescLabel.text = AppHelper.getLocalizeString(str: "Inhale through your nose about 4 seconds,\nFocusing on the tummy rising.")
        
        step3Label.text =  AppHelper.getLocalizeString(str: "Step 3: Focus on the breath")
        step3DescLabel.text = AppHelper.getLocalizeString(str: "Once settled into the pattern, focus on the breath coming in through the nose and out through the mouth")
        
        step4Label.text =  AppHelper.getLocalizeString(str: "Step 4: Focus on the tummy")
        step4DescLabel.text = AppHelper.getLocalizeString(str: "Notice the rise and fall of the tummy as the breath come in and out")
        
        step5Label.text =  AppHelper.getLocalizeString(str: "Step 5: Focus on the mind")
        step5DescLabel.text = AppHelper.getLocalizeString(str: "As thoughts come into the head, notice that they are there without judgment, then let them go and bring the attention back to the breathing.")
        
        videoDesc.text = AppHelper.getLocalizeString(str: "Now, let’s dive into it.\nPay careful attention to the following video.")
        
        bottomDescLabel.text = AppHelper.getLocalizeString(str:"Engage in this practice regularly, allowing the diaphragmatic breathing technique to guide you towards a state of tranquility and mindful breathing.")
        
        self.preparationView.backgroundColor = UIColor(named: "AppViewBorderColor")
        self.step1View.backgroundColor = UIColor(named: "AppViewBorderColor")
        self.step2View.backgroundColor = UIColor(named: "AppViewBorderColor")
        self.step3View.backgroundColor = UIColor(named: "AppViewBorderColor")
        self.step4View.backgroundColor = UIColor(named: "AppViewBorderColor")
        self.step5View.backgroundColor = UIColor(named: "AppViewBorderColor")
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLanguage()
        bringControlsToFront()
    }
    
    
    @objc func playPauseTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {

            if isPlaying {
                player.pause()
                playPauseImg.image = UIImage(named: "pause")
                
            } else {
                player.play()
                playPauseImg.image = UIImage(named: "Play")
                

            }
        bringControlsToFront()
            isPlaying.toggle()
    }
    
    
    @objc func maximiseTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        guard let player = player else { return }
        avController.modalPresentationStyle = .fullScreen
        avController.player = player
        present(avController, animated: true) {
            player.play()
            
        }
        bringControlsToFront()
    }
    
    
    func bringControlsToFront() {
        self.view.bringSubviewToFront(playPauseImg)
            self.view.bringSubviewToFront(maximiseImg)
            self.view.bringSubviewToFront(progressBar)
        }
    
    override func viewDidAppear(_ animated: Bool) {
        bringControlsToFront()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
        bringControlsToFront()
    }
    
    func setupPlayer() {
        
        guard let url = URL(string: "https://calmscient.blob.core.windows.net/exercises-videos/Mindful%20breathing.mp4") else { return }
        player = AVPlayer(url: url)
               playerLayer = AVPlayerLayer(player: player)
               playerLayer.frame = videoView.bounds
               playerLayer.videoGravity = .resizeAspect
               videoView.layer.addSublayer(playerLayer)
               videoView.bringSubviewToFront(playPauseImg)
               player.pause()
               addPeriodicTimeObserver()
        bringControlsToFront()
    }

    func setupProgressBar() {
        progressBar.value = 0
        progressBar.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    
        @objc func sliderValueChanged(_ sender: UISlider) {
            let seconds = Double(progressBar.value) * player.currentItem!.duration.seconds
            let targetTime = CMTime(seconds: seconds, preferredTimescale: 600)
            player.seek(to: targetTime)
        }
    
    
    func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: 600)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.updateProgressBar()
        }
    }

    func updateProgressBar() {
        guard let currentItem = player.currentItem else { return }
        let currentTime = player.currentTime().seconds
        let duration = currentItem.duration.seconds
        progressBar.value = Float(currentTime / duration)

    }
    
    
    func setFonts(){
        self.titleLabel.font = UIFont(name: Fonts().lexendMedium, size: 15)
        self.topDescriptionLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.preparationLabel.font = UIFont(name: Fonts().lexendRegular, size: 15)
        self.preparationDescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.subtitleLabel.font = UIFont(name: Fonts().lexendRegular, size: 15)
        self.preparationLabel.font = UIFont(name: Fonts().lexendRegular, size: 15)
        self.preparationDescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.subtitleLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.step1Label.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.step1DescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        
        self.step2Label.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.step2DescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        
        self.step3Label.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.step3DescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        
        self.step4Label.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.step4DescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        
        self.step5Label.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.step5DescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        
        self.videoDesc.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.bottomDescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.navigationController?.popViewController(animated: true)
        // Your action
    }
    
    
    
    
}
