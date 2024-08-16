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
    
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            backImg.isUserInteractionEnabled = true
            backImg.addGestureRecognizer(tapGestureRecognizer)
        descriptionLbl.font = UIFont(name: Fonts().lexendLight, size: 15)
        
        titleLbl.font = UIFont(name: Fonts().lexendMedium, size: 19)
        
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.navigationController?.popViewController(animated: true)
        // Your action
    }
}
