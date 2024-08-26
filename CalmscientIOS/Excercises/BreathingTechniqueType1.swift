//
//  BreathingTechniqueType1.swift
//  sample
//
//  Created by Krishna on 8/7/24.
//



import UIKit

import Foundation
import UIKit
import AVKit
import AVFoundation


class BreathingTechniqueType1: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
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
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var playPauseImage: UIImageView!
    @IBOutlet weak var maximiseImg: UIImageView!
    @IBOutlet weak var favImg: UIImageView!
    @IBOutlet weak var bottomDescriptionLbl: UILabel!
    @IBOutlet weak var preparationDescLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var step1TitleLabel: UILabel!
    @IBOutlet weak var step1DescLabel: UILabel!
    @IBOutlet weak var step2TitleLabel: UILabel!
    @IBOutlet weak var step2DescLabel: UILabel!
    @IBOutlet weak var step3TitleLabel: UILabel!
    @IBOutlet weak var step3DescLabel: UILabel!
    @IBOutlet weak var step4TitleLabel: UILabel!
    @IBOutlet weak var step4DescLabel: UILabel!
    @IBOutlet weak var step5TitleLabel: UILabel!
    @IBOutlet weak var step5DescLabel: UILabel!
    @IBOutlet weak var videoDescLbl: UILabel!
    @IBOutlet weak var bottomDescLabel: UILabel!
    
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isMaximized: Bool = false
    var isPlaying = false
    var isFavorite = false
    var isFullScreen = false
    let avController = AVPlayerViewController()
    var autoHideTimer: Timer?
    
    
    @IBOutlet weak var backImg: UIImageView!
    
    @IBOutlet weak var preparationLabel: UILabel!
    
    var languageId : Int = 1
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = .white
        super.viewDidLoad()
        setupPlayer()
        setupProgressBar()
        
        progressBar.setThumbImage(UIImage(), for: .normal)
        progressBar.tintColor = UIColor.white
        preparationView.applyShadow()
        preparationView.backgroundColor = UIColor(named: "AppViewBorderColor")
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        step1View.applyShadow()
        step1View.backgroundColor = UIColor(named: "AppViewBorderColor")
        step2View.applyShadow()
        step2View.backgroundColor = UIColor(named: "AppViewBorderColor")
        step3View.applyShadow()
        step3View.backgroundColor = UIColor(named: "AppViewBorderColor")
        step4View.applyShadow()
        step4View.backgroundColor = UIColor(named: "AppViewBorderColor")
        step5View.applyShadow()
        step5View.backgroundColor = UIColor(named: "AppViewBorderColor")
        
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
        
        dot5View.layer.cornerRadius = dot5View.frame.size.width / 2
        dot5View.backgroundColor = UIColor(hex: "#6E6BB3")
        dot5View.layer.masksToBounds = true
        
        verticalBar.backgroundColor = UIColor(hex: "#6E6BB3")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        backImg.isUserInteractionEnabled = true
        backImg.addGestureRecognizer(tapGestureRecognizer)
        
        let playPauseGesture = UITapGestureRecognizer(target: self, action: #selector(playPauseTapped(tapGestureRecognizer:)))
        playPauseImage.isUserInteractionEnabled = true
        playPauseImage.addGestureRecognizer(playPauseGesture)
    
        let maximiseGesture = UITapGestureRecognizer(target: self, action: #selector(maximiseTapped(tapGestureRecognizer:)))
        maximiseImg.isUserInteractionEnabled = true
        maximiseImg.addGestureRecognizer(maximiseGesture)
        
        
        
    }
    
    func uiLabelsSetup(){
        
        titleLabel.font = UIFont(name: Fonts().lexendMedium, size: 19)
        titleLabel.textColor = UIColor(named: "lineChartLabelColor")
        preparationLabel.font = UIFont(name: Fonts().lexendRegular, size: 15)
        preparationLabel.textColor = UIColor(named: "lineChartLabelColor")
        preparationDescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        preparationDescLabel.textColor = UIColor(named: "lineChartLabelColor")
        subtitleLabel.font = UIFont(name: Fonts().lexendRegular, size: 15)
        subtitleLabel.textColor = UIColor(named: "lineChartLabelColor")
        step1TitleLabel.font = UIFont(name: Fonts().lexendRegular, size: 15)
        step1TitleLabel.textColor = UIColor(named: "lineChartLabelColor")
        step1DescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        step1DescLabel.textColor = UIColor(named: "lineChartLabelColor")
        step2TitleLabel.font = UIFont(name: Fonts().lexendRegular, size: 15)
        step2DescLabel.textColor = UIColor(named: "lineChartLabelColor")
        step2DescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        step2TitleLabel.textColor = UIColor(named: "lineChartLabelColor")
        
        step3TitleLabel.font = UIFont(name: Fonts().lexendRegular, size: 15)
        step3TitleLabel.textColor = UIColor(named: "lineChartLabelColor")
        step3DescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        step3DescLabel.textColor = UIColor(named: "lineChartLabelColor")
        step4TitleLabel.font = UIFont(name: Fonts().lexendRegular, size: 15)
        step4TitleLabel.textColor = UIColor(named: "lineChartLabelColor")
        step4DescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        step4DescLabel.textColor = UIColor(named: "lineChartLabelColor")
        step5TitleLabel.font = UIFont(name: Fonts().lexendRegular, size: 15)
        step5TitleLabel.textColor = UIColor(named: "lineChartLabelColor")
        step5DescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        step5DescLabel.textColor = UIColor(named: "lineChartLabelColor")
        videoDescLbl.font = UIFont(name: Fonts().lexendLight, size: 15)
        videoDescLbl.textColor = UIColor(named: "lineChartLabelColor")
        bottomDescLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        bottomDescLabel.textColor = UIColor(named: "lineChartLabelColor")
        
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
                playPauseImage.image = UIImage(named: "pause")
                
            } else {
                player.play()
                playPauseImage.image = UIImage(named: "Play")

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
        self.view.bringSubviewToFront(playPauseImage)
            self.view.bringSubviewToFront(favImg)
            
            self.view.bringSubviewToFront(progressBar)
            self.view.bringSubviewToFront(playPauseImage)
        self.view.bringSubviewToFront(maximiseImg)
        }
    
    override func viewDidAppear(_ animated: Bool) {
        bringControlsToFront()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
        bringControlsToFront()
    }
    
    
    func setupLanguage() {
        
             languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        titleLabel.text = AppHelper.getLocalizeString(str:"4-7-8 Breathing excercise")
        
        preparationLabel.text = AppHelper.getLocalizeString(str: "Preparation")
        preparationDescLabel.text = AppHelper.getLocalizeString(str: "First find a comfortable seated position. Ensure that you are at ease before beginning the rhythmic breathing pattern.\n\nPlace the tip of your tongue gently against the tissue just behind your top front teeth")
        
        subtitleLabel.text = AppHelper.getLocalizeString(str: "Let’s learn how to do the 4-7-8 breathing exercise.")
        
        step1TitleLabel.text =  AppHelper.getLocalizeString(str: "Step 1: Emptying the lungs")
        step1DescLabel.text = AppHelper.getLocalizeString(str: "Begin by completely emptying your lungs of air. Allow yourself a moment to release any tension.")
        
        step2TitleLabel.text =  AppHelper.getLocalizeString(str: "Step 2: Inhaling quietly")
        step2DescLabel.text = AppHelper.getLocalizeString(str: "Inhale quietly through your nose, counting to 4 seconds. Fell the breath entering your body, bringing calmness.")
        
        step3TitleLabel.text =  AppHelper.getLocalizeString(str: "Step 3: Hold the breath")
        step3DescLabel.text = AppHelper.getLocalizeString(str: "Hold your breath for  a steady count of 7 seconds. Embrace the stillness within, allowing the breath to settle.")
        
        step4TitleLabel.text =  AppHelper.getLocalizeString(str: "Step 4: Force exhalation")
        step4DescLabel.text = AppHelper.getLocalizeString(str: "Exhale forcefully through your mouth, pursing your lips, and create a distinct “whoosh” sound for 8 seconds. Feel the release of tension as you expel the breath.")
        
        step5TitleLabel.text =  AppHelper.getLocalizeString(str: "Step 5: Repeat the process")
        step5DescLabel.text = AppHelper.getLocalizeString(str: "Repeat this entire cycle up to 4 times. Each repetition contributes to a deepening sense of relaxation.")
        
        videoDescLbl.text = AppHelper.getLocalizeString(str: "Now, let’s dive into it.\nPay careful attention to the following video.")
        
        bottomDescLabel.text = AppHelper.getLocalizeString(str:"Engage in this practice regularly, allowing the 4-7-8 technique to guide you towards a state of tranquility and mindful breathing.")
        
        
        
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLanguage()
        bringControlsToFront()
        uiLabelsSetup()
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


}



extension UIView {
//    func applyShadow(
//        color: UIColor = UIColor.black, //UIColor(hex: "#323247"),
//        opacity: Float = 1,
//        offset: CGSize = CGSize(width: 2, height: 8),
//        radius: CGFloat = 5) {
//            
//            
//            self.backgroundColor = .white
//            self.layer.borderColor = UIColor(hex: "#E8E7F4").cgColor
//            self.layer.borderWidth = 1
//            self.layer.shadowColor = color.cgColor.copy(alpha: 0.08)
//        self.layer.shadowOpacity = opacity
//        self.layer.shadowOffset = offset
//        self.layer.shadowRadius = radius
//        self.layer.masksToBounds = false
//        self.layer.cornerRadius = 15
//    }
    
    func applyShadow(cornerRadius: CGFloat = 10.0, shadowColor: UIColor = .black, shadowOpacity: Float = 0.2, shadowOffset: CGSize = CGSize(width: 0, height: 2), shadowRadius: CGFloat = 5.0) {
       // self.backgroundColor = .white
            self.layer.cornerRadius = cornerRadius
            self.layer.shadowColor = shadowColor.cgColor
            self.layer.shadowOpacity = shadowOpacity
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowRadius = shadowRadius
            self.layer.masksToBounds = false
        }
    
    func addShadowView() {
        //Remove previous shadow views
        superview?.viewWithTag(119900)?.removeFromSuperview()

        //Create new shadow view with frame
        let shadowView = UIView(frame: frame)
        shadowView.tag = 119900
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        shadowView.layer.masksToBounds = false

        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        shadowView.layer.shouldRasterize = true

        superview?.insertSubview(shadowView, belowSubview: self)
    }
    
    
    func applyShadowWithCornerRadius(cornerRadius: CGFloat,
                                         shadowColor: UIColor = .darkGray,
                                         shadowOffset: CGSize = .zero,
                                         shadowRadius: CGFloat = 20,
                                         shadowOpacity: Float = 1) {
            self.layer.cornerRadius = cornerRadius
            self.layer.shadowColor = shadowColor.cgColor
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOpacity = shadowOpacity
            
            // Set shadow path for performance optimization
            let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius)
            self.layer.shadowPath = shadowPath.cgPath
        }
}

extension UIColor {
    convenience init(hex: String) {
        var hexFormatted: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
