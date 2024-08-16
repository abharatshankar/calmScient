//
//  Consequences.swift
//  CalmscientIOS
//
//  Created by mac on 05/06/24.
//

import UIKit

@available(iOS 16.0, *)
class Consequences:  ViewController {
    @IBOutlet weak var selection_view: UIImageView!

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var normalTextLabel: UILabel!
    @IBOutlet weak var hyperTextLabel: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Basic Knowledge"
        //self.navigationController?.isNavigationBarHidden = true
       // self.navigationController?.navigationBar.isHidden = false
        
     //   let backButton = UIBarButtonItem(image: UIImage(named: "backward"), style: .plain, target: self, action: #selector(backButtonOverrideAction))

      //  backButton.tintColor = UIColor.clear

           // Assign it to the navigation item's leftBarButtonItem
        
        //   self.navigationItem.leftBarButtonItem = backButton
        
        
        var image = UIImage(named: "NavigationBack")
        image = image?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image , style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonOverrideAction))

    }
    @objc func backButtonOverrideAction() {
        print("Back button tapped")
        // Perform the action you want here
        let next = UIStoryboard(name: "Basicknowledge", bundle: nil)
        let vc = next.instantiateViewController(withIdentifier: "Basicknowledge") as? Basicknowledge
        vc?.title = "Basic Knowledge"
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @IBAction func forward_action(_ sender: UIButton) {
        let next = UIStoryboard(name: "Consequences", bundle: nil)
        let vc = next.instantiateViewController(withIdentifier: "Consequences_two") as? Consequences_two
                   vc?.title = "Basic knowledge"
        self.navigationController?.pushViewController(vc!, animated: true)
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
        self.title = AppHelper.getLocalizeString(str: "Basic Knowledge")
        
        headerLabel.text = AppHelper.getLocalizeString(str: "What are the consequence?")
        normalTextLabel.text = AppHelper.getLocalizeString(str:"typesOfconsequence" )
        
        }
}

