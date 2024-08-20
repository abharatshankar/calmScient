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
    @IBOutlet weak var text2: UILabel!
    
    
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
    
