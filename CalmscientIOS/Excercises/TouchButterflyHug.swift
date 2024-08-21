//
//  TouchButterflyHug.swift
//  sample
//
//  Created by Krishna on 8/4/24.
//

import Foundation
import UIKit


class TouchButterflyHug: UIViewController {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var circle1: UIView!
    @IBOutlet weak var circle2: UIView!
    @IBOutlet weak var circle3: UIView!
    
    @IBOutlet weak var backImg: UIImageView!
    
    @IBOutlet weak var leftIcon: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var view2title: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var view1Title: UILabel!
    
    
    @IBOutlet weak var verticalBar: UIView!
    
    override func viewDidLoad() {
        
        titleLabel.font = UIFont(name: Fonts().lexendMedium, size: 19)
        
        subTitleLabel.font = UIFont(name: Fonts().lexendRegular, size: 19)
        
        view1Title.font  = UIFont(name: Fonts().lexendLight, size: 15)
        
        view2title.font = UIFont(name: Fonts().lexendLight, size: 15)
        
        descriptionLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        view1.applyShadow()
        view2.applyShadow()
        view3.applyShadow()
        
        verticalBar.backgroundColor = UIColor(hex: "#6E6BB3")
        
        circle1.layer.cornerRadius = circle1.frame.size.width / 2
        circle1.backgroundColor = UIColor(hex: "#6E6BB3")
        circle1.layer.masksToBounds = true
        
        circle2.layer.cornerRadius = circle2.frame.size.width / 2
        circle2.backgroundColor = UIColor(hex: "#6E6BB3")
        circle2.layer.masksToBounds = true
        
        circle3.layer.cornerRadius = circle3.frame.size.width / 2
        circle3.backgroundColor = UIColor(hex: "#6E6BB3")
        circle3.layer.masksToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            backImg.isUserInteractionEnabled = true
            backImg.addGestureRecognizer(tapGestureRecognizer)
        
        let backIconRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        leftIcon.isUserInteractionEnabled = true
        leftIcon.addGestureRecognizer(backIconRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLanguage()
    }
    
    func setupLanguage() {
        
            let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        titleLabel.text = AppHelper.getLocalizeString(str:"Touch and the butterfly hug")
        
        subTitleLabel.text = AppHelper.getLocalizeString(str: "HOW TO DO IT")
        
        view1Title.text = AppHelper.getLocalizeString(str: "Interlock your thumbs to form a butterfly shape")
        
        view2title.text = AppHelper.getLocalizeString(str: "Place both hands over your chest, and alternate tapping your middle finger just below your collarbone")
        
        descriptionLabel.text = AppHelper.getLocalizeString(str: "Breathe slowly and deeply (abdominal breathing) while you mentally observe what is going through your mind and body thoughts, images, sounds, odors, feelings, and physical sensation.")
        
        }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.navigationController?.popViewController(animated: true)
        // Your action
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func leftAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
