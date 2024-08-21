//
//  MindfulBodyMovement.swift
//  sample
//
//  Created by Krishna on 8/6/24.
//

import Foundation
import UIKit

class MindfulBodyMovement : UIViewController {

    
    
    @IBOutlet weak var backImg: UIImageView!
    
    
    @IBOutlet weak var titleLbl: UILabel!
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    var languageId : Int = 1
    
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            backImg.isUserInteractionEnabled = true
            backImg.addGestureRecognizer(tapGestureRecognizer)
        
        self.titleLbl.font = UIFont(name: Fonts().lexendMedium, size: 19)
        
        self.descriptionLabel.font = UIFont(name: Fonts().lexendLight, size: 15)
        
        
        
        
        
    }
    
    
    func setupLanguage() {
        
             languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        titleLbl.text = AppHelper.getLocalizeString(str:"Mindful body movement")
        
        descriptionLabel.text = AppHelper.getLocalizeString(str: "There are many movement routines that invite you to reconnect with your body. Pilates, yoga and other similar stretching exercises incorporate mindful awareness of movements and postures. Additionally, coordinating body movement and breath further potentiates your ability to shift your state.")
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLanguage()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.navigationController?.popViewController(animated: true)
        // Your action
    }
    
}
