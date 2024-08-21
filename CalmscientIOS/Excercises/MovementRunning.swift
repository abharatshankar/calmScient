//
//  MovementRunning.swift
//  sample
//
//  Created by Krishna on 8/6/24.
//

import Foundation
import UIKit


class MovementRunning: UIViewController {
    
    
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    var languageId : Int = 1
    
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            backImg.isUserInteractionEnabled = true
            backImg.addGestureRecognizer(tapGestureRecognizer)
        descriptionLbl.font = UIFont(name: Fonts().lexendLight, size: 15)
        
        titleLbl.font = UIFont(name: Fonts().lexendMedium, size: 19)
        
        
    }
    
    
    func setupLanguage() {
        
             languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        titleLbl.text = AppHelper.getLocalizeString(str:"Movement: running")
        
        descriptionLbl.text = AppHelper.getLocalizeString(str: "It’s not easy to move when you have a shutdown or are feeling numb. Running can quickly shift you out of the shutdown state and re-energize you.")
        
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
