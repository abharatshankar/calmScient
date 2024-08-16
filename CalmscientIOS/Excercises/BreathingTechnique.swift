//
//  BreathingTechnique.swift
//  sample
//
//  Created by Krishna on 8/6/24.
//

import Foundation
import UIKit


class BreathingTechnique: UIViewController {
        
    @IBOutlet weak var breathingExcercise478: UIView!
    @IBOutlet weak var mindfulBreathingExcercise478: UIView!
    @IBOutlet weak var diaphragmaticBreathing: UIView!
    
    @IBOutlet weak var backImg: UIImageView!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var excersice1Label: UILabel!
    
    @IBOutlet weak var excersice2Label: UILabel!
    
    @IBOutlet weak var excersice3Label: UILabel!
    
    
    override func viewDidLoad() {
        //        backBtn.titleLabel?.text = ""
        breathingExcercise478.applyShadow()
        mindfulBreathingExcercise478.applyShadow()
        diaphragmaticBreathing.applyShadow()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let breathe = UITapGestureRecognizer(target: self, action: #selector(bottomBackTapped(tapGestureRecognizer:)))
        
        let mindfulBreathe = UITapGestureRecognizer(target: self, action: #selector(mindfulTapped(tapGestureRecognizer:)))
        
        let diagraphicBreathe = UITapGestureRecognizer(target: self, action: #selector(diaphragmaticTapped(tapGestureRecognizer:)))
        
        breathingExcercise478.isUserInteractionEnabled = true
        breathingExcercise478.addGestureRecognizer(breathe)
        
        mindfulBreathingExcercise478.isUserInteractionEnabled = true
        mindfulBreathingExcercise478.addGestureRecognizer(mindfulBreathe)
        
        
        diaphragmaticBreathing.isUserInteractionEnabled = true
        diaphragmaticBreathing.addGestureRecognizer(diagraphicBreathe)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        backImg.isUserInteractionEnabled = true
        backImg.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func setFonts(){
        self.titleLabel.font = UIFont(name: Fonts().lexendMedium, size: 19)
        self.subTitleLabel.font = UIFont(name: Fonts().lexendMedium, size: 18)
        self.excersice1Label.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.excersice2Label.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.excersice3Label.font = UIFont(name: Fonts().lexendLight, size: 15)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.navigationController?.popViewController(animated: true)
        // Your action
    }
    
    @objc func bottomBackTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let storyboard = UIStoryboard(name: "Excercises", bundle: nil)
                let destinationVC = storyboard.instantiateViewController(withIdentifier: "BreathingTechniqueType1") as! BreathingTechniqueType1
                
                // Push to the destination view controller
                self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    @objc func mindfulTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let storyboard = UIStoryboard(name: "Excercises", bundle: nil)
                let destinationVC = storyboard.instantiateViewController(withIdentifier: "MindfulBreathing") as! MindfulBreathing
                
                // Push to the destination view controller
                self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    @objc func diaphragmaticTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let storyboard = UIStoryboard(name: "Excercises", bundle: nil)
                let destinationVC = storyboard.instantiateViewController(withIdentifier: "DiagraphicBreathe") as! DiagraphicBreathe
                
                // Push to the destination view controller
                self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}
