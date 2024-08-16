//
//  DiagraphicBreathe.swift
//  sample
//
//  Created by Krishna on 8/6/24.
//


import Foundation
import UIKit


class DiagraphicBreathe: UIViewController {

    
    @IBOutlet weak var backImg: UIImageView!
    
    
    @IBOutlet weak var playPauseButton: UIButton!
    
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
    
    
    @IBOutlet weak var maximiseButton: UIButton!
    
    
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
    
    
    override func viewDidLoad() {
        
        playPauseButton.titleLabel?.text = ""
        maximiseButton.titleLabel?.text = ""
        
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
        
        setFonts()
    }
    
    func setFonts(){
        self.titleLabel.font = UIFont(name: Fonts().lexendMedium, size: 19)
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
    
    
    @IBAction func playPauseAction(_ sender: Any) {
    }
    
    
    @IBAction func maximiseAction(_ sender: Any) {
    }
    
    
}
