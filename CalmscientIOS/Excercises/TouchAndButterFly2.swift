//
//  TouchAndButterFly2.swift
//  sample
//
//  Created by Krishna on 8/6/24.
//

import Foundation
import UIKit




class TouchAndButterFly2: UIViewController {
    
    
    @IBOutlet weak var text1: UILabel!
    
    @IBOutlet weak var backImg: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nextIcon: UIImageView!
    
    
    
    
    
    override func viewDidLoad() {
        
        titleLabel.font = UIFont(name: Fonts().lexendMedium, size: 18)
        
        descriptionLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            backImg.isUserInteractionEnabled = true
            backImg.addGestureRecognizer(tapGestureRecognizer)
        
        let nextPageRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextTapped(tapGestureRecognizer:)))
        nextIcon.isUserInteractionEnabled = true
        nextIcon.addGestureRecognizer(nextPageRecognizer)
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
        
        descriptionLabel.text = AppHelper.getLocalizeString(str: "Humans respond powerfully to touch. Gentle, affectionate touch helps calm the nervous system and can trigger the release of oxytocin, the attachment hormone. Interestingly, when it comes to releasing oxytocin, our bodies don’t differentiate between the touch of a loved one or our own touch as we hold ourselves.\nWhen you are feeling upset, ungrounded, agitated or irritable, try giving yourself a hug or a gentle stroke on the cheek and see how it impacts the way you feel.")
        
        }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.navigationController?.popViewController(animated: true)
        // Your action
    }
    
    @objc func nextTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let storyboard = UIStoryboard(name: "Excercises", bundle: nil)
                let destinationVC = storyboard.instantiateViewController(withIdentifier: "TouchButterflyHug") as! TouchButterflyHug
                
                // Push to the destination view controller
                self.navigationController?.pushViewController(destinationVC, animated: true)
        // Your action
    }
}
    
