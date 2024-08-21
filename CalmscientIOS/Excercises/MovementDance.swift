//
//  MovementDance.swift
//  sample
//
//  Created by Krishna on 8/6/24.
//

import Foundation
import UIKit


class MovementDance: UIViewController {
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var backImg: UIImageView!
    var languageId : Int = 1
    
    override func viewDidLoad() {
        
        self.titleLbl.font = UIFont(name: Fonts().lexendMedium, size: 19)
        
        self.descriptionLbl.font = UIFont(name: Fonts().lexendLight, size: 15)
        

        self.navigationController?.navigationBar.tintColor = UIColor.white
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            backImg.isUserInteractionEnabled = true
            backImg.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    func setupLanguage() {
        
             languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        titleLbl.text = AppHelper.getLocalizeString(str:"Movement: dance")
        
        descriptionLbl.text = AppHelper.getLocalizeString(str: "Moving your body to music can be a fun and fast way to shift your state and reconnect with your body, rhythm and expression.")
        
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
