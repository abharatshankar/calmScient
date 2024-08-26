//
//  MindfulBreathing.swift
//  sample
//
//  Created by Krishna on 8/6/24.
//

import Foundation
import UIKit
import AVFoundation
import AVKit


class MindfulBreathing: UIViewController {

    
    @IBOutlet weak var backImg: UIImageView!
    
    @IBOutlet weak var preparationView: UIView!
    @IBOutlet weak var step1View: UIView!
    @IBOutlet weak var step2View: UIView!
    @IBOutlet weak var step3View: UIView!
    @IBOutlet weak var step4View: UIView!
    
    @IBOutlet weak var step6View: UIView!
    
    @IBOutlet weak var step5: UIView!
    
    @IBOutlet weak var verticalBarView: UIView!
    @IBOutlet weak var dot1View: UIView!
    @IBOutlet weak var dot2View: UIView!
    @IBOutlet weak var dot3View: UIView!
    @IBOutlet weak var dot4View: UIView!
    
    @IBOutlet weak var dot6View: UIView!
    
    @IBOutlet weak var dot5: UIView!
    
    
    @IBOutlet weak var favImg: UIImageView!
    
    @IBOutlet weak var playPauseImage: UIImageView!
    
    @IBOutlet weak var maximiseImg: UIImageView!
    
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var progressBar: UISlider!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var preparationTitle: UILabel!
    
    @IBOutlet weak var preparationDesLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
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
    
    @IBOutlet weak var step6Label: UILabel!
    
    @IBOutlet weak var step6DescLabel: UILabel!
    
    @IBOutlet weak var videoLabel: UILabel!
    
    @IBOutlet weak var bottomDescLabel: UILabel!
    
  
    
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isMaximized: Bool = false
    var isPlaying = false
    var isFavorite = false
    var isFullScreen = false
    let avController = AVPlayerViewController()
    var autoHideTimer: Timer?

    var languageId : Int = 1

    
    override func viewDidLoad() {
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        setupPlayer()
        setupProgressBar()
        progressBar.setThumbImage(UIImage(), for: .normal)
        progressBar.tintColor = UIColor.white
        designWidgetsSetup()
        bringControlsToFront()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            backImg.isUserInteractionEnabled = true
            backImg.addGestureRecognizer(tapGestureRecognizer)
        
        let playPauseRecognizer = UITapGestureRecognizer(target: self, action: #selector(playPauseTapped(tapGestureRecognizer:)))
            playPauseImage.isUserInteractionEnabled = true
            playPauseImage.addGestureRecognizer(playPauseRecognizer)
        
        let maximiseRecognizer = UITapGestureRecognizer(target: self, action: #selector(maximiseTapped(tapGestureRecognizer:)))
            maximiseImg.isUserInteractionEnabled = true
            maximiseImg.addGestureRecognizer(maximiseRecognizer)
        
        self.titleLabel.font = UIFont(name: Fonts().lexendMedium, size: 18)
        
        self.preparationTitle.font = UIFont(name: Fonts().lexendRegular, size: 15)
        
        self.preparationDesLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        
        self.subTitleLabel.font = UIFont(name: Fonts().lexendRegular, size: 15)
        self.step1Label.font = UIFont(name: Fonts().lexendRegular, size: 15)
        self.step1DescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.step2Label.font = UIFont(name: Fonts().lexendRegular, size: 15)
        self.step2DescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.step3Label.font = UIFont(name: Fonts().lexendRegular, size: 15)
        self.step3DescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.step4Label.font = UIFont(name: Fonts().lexendRegular, size: 15)
        self.step4DescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.step5Label.font = UIFont(name: Fonts().lexendRegular, size: 15)
        self.step5DescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        
        self.step6Label.font = UIFont(name: Fonts().lexendRegular, size: 15)
        self.step6DescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.videoLabel.font = UIFont(name: Fonts().lexendRegular, size: 15)
        self.bottomDescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        
        
        
    }
    
    
    func setupLanguage() {
        
             languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        titleLabel.text = AppHelper.getLocalizeString(str:"Mindful breathing exercise")
        
        preparationTitle.text = AppHelper.getLocalizeString(str: "Preparation")
        preparationDesLabel.text = AppHelper.getLocalizeString(str: "First find a comfortable to either sit down or lay down. You can close your eyes if you want to.")
        
        
        subTitleLabel.text = AppHelper.getLocalizeString(str: "Let’s learn how to do the mindful breathing exercise.")
        
        step1Label.text =  AppHelper.getLocalizeString(str: "Step 1: Inhale")
        step1DescLabel.text = AppHelper.getLocalizeString(str: "Inhale through your nose until the tummy expands.")
        
        step2Label.text =  AppHelper.getLocalizeString(str: "Step 2: Exhale slowly and repeat it")
        step2DescLabel.text = AppHelper.getLocalizeString(str: "Exhale slowly through your mouse. And repeat the process.")
        
        step3Label.text =  AppHelper.getLocalizeString(str: "Step 3: Focus on the breath")
        step3DescLabel.text = AppHelper.getLocalizeString(str: "Once settled into the pattern, focus on the breath coming in through the nose and out through the mouth")
        
        step4Label.text =  AppHelper.getLocalizeString(str: "Step 4: Focus on the tummy")
        step4DescLabel.text = AppHelper.getLocalizeString(str: "Notice the rise and fall of the tummy as the breath come in and out")
        
        step5Label.text =  AppHelper.getLocalizeString(str: "Step 5: Focus on the mind")
        step5DescLabel.text = AppHelper.getLocalizeString(str: "As thoughts come into the head, notice that they are there without judgment, then let them go and bring the attention back to the breathing.")
        
        step6Label.text =  AppHelper.getLocalizeString(str: "Step 6: Focus on the connection between mind and body.")
        step6DescLabel.text = AppHelper.getLocalizeString(str: "Carry on until feeling calm, then start to be aware of how the body and mind feel.")
        
        videoLabel.text = AppHelper.getLocalizeString(str: "Now, let’s dive into it.\nPay careful attention to the following video.")
        
        bottomDescLabel.text = AppHelper.getLocalizeString(str:"Engage in this practice regularly, allowing the diaphragmatic breathing technique to guide you towards a state of tranquility and mindful breathing.")
        
        
        self.preparationView.backgroundColor = UIColor(named: "AppViewBorderColor")
        self.step1View.backgroundColor = UIColor(named: "AppViewBorderColor")
        self.step2View.backgroundColor = UIColor(named: "AppViewBorderColor")
        self.step3View.backgroundColor = UIColor(named: "AppViewBorderColor")
        self.step4View.backgroundColor = UIColor(named: "AppViewBorderColor")
        self.step5.backgroundColor = UIColor(named: "AppViewBorderColor")
        self.step6View.backgroundColor = UIColor(named: "AppViewBorderColor")
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLanguage()
        bringControlsToFront()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.navigationController?.popViewController(animated: true)
        // Your action
    }
    
    
    @objc func playPauseTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {

            if isPlaying {
                
                player.pause()
                bringControlsToFront()
                playPauseImage.image = UIImage(named: "pause")
            } else {
                playPauseImage.image = UIImage(named: "Play")
                
                guard let player = player else { return }
                avController.modalPresentationStyle = .fullScreen
                avController.player = player
                player.play()
                bringControlsToFront()

            }
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
    }
    
    func designWidgetsSetup(){
       
        preparationView.applyShadow()
        step1View.applyShadow()
        step2View.applyShadow()
        step3View.applyShadow()
        step4View.applyShadow()
        step5.applyShadow()
        step6View.applyShadow()
        
        
        dot1View.layer.cornerRadius = dot1View.frame.size.width / 2
        dot1View.backgroundColor = UIColor(hex: "#6E6BB3")
        dot1View.layer.masksToBounds = true
        
        dot2View.layer.cornerRadius = dot2View.frame.size.width / 2
        dot2View.backgroundColor = UIColor(hex: "#6E6BB3")
        dot2View.layer.masksToBounds = true
        
        
        dot3View.layer.cornerRadius = dot3View.frame.size.width / 2
        dot3View.backgroundColor = UIColor(hex: "#6E6BB3")
        dot3View.layer.masksToBounds = true
        
        
        dot4View.layer.cornerRadius = dot4View.frame.size.width / 2
        dot4View.backgroundColor = UIColor(hex: "#6E6BB3")
        dot4View.layer.masksToBounds = true
        
        dot5.layer.cornerRadius = dot5.frame.size.width / 2
        dot5.backgroundColor = UIColor(hex: "#6E6BB3")
        dot5.layer.masksToBounds = true
        
        
        dot6View.layer.cornerRadius = dot6View.frame.size.width / 2
        dot6View.backgroundColor = UIColor(hex: "#6E6BB3")
        dot6View.layer.masksToBounds = true
        
        
        verticalBarView.backgroundColor = UIColor(hex: "#6E6BB3")
    }
    
    
    func bringControlsToFront() {
        
        self.view.bringSubviewToFront(maximiseImg)
            self.view.bringSubviewToFront(progressBar)
        self.view.bringSubviewToFront(playPauseImage)
        self.view.bringSubviewToFront(videoView)
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
        videoView.bringSubviewToFront(playPauseImage)
               player.pause()
               addPeriodicTimeObserver()
        bringControlsToFront()
    }

    func setupProgressBar() {
        progressBar.value = 0
        progressBar.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    
//    @IBAction func playPauseTapped(_ sender: UIButton) {
//
//            if isPlaying {
//                player.pause()
//                playPauseImage.image = UIImage(named: "Play")
//   
//                
//            } else {
//                playPauseImage.image = UIImage(named: "pause")
//                guard let player = player else { return }
//                avController.modalPresentationStyle = .fullScreen
//                avController.player = player
//                present(avController, animated: true) {
//                    player.play()
//                }
//                
//                bringControlsToFront()
//
//            }
//            isPlaying.toggle()
//        }
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
    
    
    
    
    
    @IBAction func maximiseButtonAction(_ sender: Any) {

        guard let player = player else { return }
        avController.modalPresentationStyle = .fullScreen
        avController.player = player
        present(avController, animated: true) {
            player.play()
        }
    }
    
}
