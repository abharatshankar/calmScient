//
//  MovementDance.swift
//  sample
//
//  Created by Krishna on 8/6/24.
//

import Foundation
import UIKit


class MovementDance: UIViewController {
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var titleLbl: UILabel!
    
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    
    @IBOutlet weak var backImg: UIImageView!
    
    override func viewDidLoad() {
        
        self.titleLbl.font = UIFont(name: Fonts().lexendMedium, size: 19)
        
        self.descriptionLbl.font = UIFont(name: Fonts().lexendLight, size: 15)
        

        self.navigationController?.navigationBar.tintColor = UIColor.white
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            backImg.isUserInteractionEnabled = true
            backImg.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.navigationController?.popViewController(animated: true)
        // Your action
    }
}
