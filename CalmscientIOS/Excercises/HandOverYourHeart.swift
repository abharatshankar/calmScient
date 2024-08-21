//
//  HandOverYourHeart.swift
//  sample
//
//  Created by Krishna on 8/3/24.
//

import Foundation
import UIKit


class HandOverYourHeart: UIViewController {

    @IBOutlet weak var howToDoIt: UILabel!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var subtitleLbl: UILabel!
    
    @IBOutlet weak var backImg: UIImageView!
    
    var languageId : Int = 1
    
    let arrayString = [
        "Rest the heel of your hand on your sternum around your heart area.",
        "Apply a steady, gentle, but firm pressure.",
        "For added effect, you can place your other hand across your forehead or on your abdomen.",
        "Experiment with the various placements and wait until you feel a shift. It may take up to 5 or 10 minutes of deep breathing in this position to shift if you are very activated."
    ]
    
    let arrayStringSpanish = [
        "Apoya el talón de tu mano sobre tu esternón, alrededor de la zona del corazón.",
        "Aplica una presión constante, suave, pero firme.",
        "Para un efecto adicional, puedes colocar la otra mano en la frente o en el abdomen.",
        "Experimenta con las diferentes posiciones y espera hasta sentir un cambio. Puede tomar hasta 5 o 10 minutos de respiración profunda en esta posición para que el cambio ocurra si estás muy activado."
    ]
    
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.subtitleLbl.font = UIFont(name: Fonts().lexendLight, size: 19)
        
        self.titleLbl.font = UIFont(name: Fonts().lexendMedium, size: 19)
        
        

        howToDoIt.attributedText = add(stringList: languageId == 1 ? arrayString : arrayStringSpanish, font: UIFont(name: Fonts().lexendLight, size: 15)!
                                       , bullet: "•",textColor: (UserDefaults.standard.value(forKey: "isDarkMode") ?? false) as! Bool ? .white : UIColor(hex: "#424242"),bulletColor: (UserDefaults.standard.value(forKey: "isDarkMode") ?? false) as! Bool ? .white : UIColor(hex: "#424242"))

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
        titleLbl.text = AppHelper.getLocalizeString(str:"Hand over your heart")
        
        subtitleLbl.text = AppHelper.getLocalizeString(str: "HOW TO DO IT")
        
        }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.navigationController?.popViewController(animated: true)
        // Your action
    }
    override func viewWillAppear(_ animated: Bool) {
        setupLanguage()
        
        howToDoIt.attributedText = add(stringList: languageId == 1 ? arrayString : arrayStringSpanish, font: UIFont(name: Fonts().lexendLight, size: 15)!
                                       , bullet: "•",textColor: (UserDefaults.standard.value(forKey: "isDarkMode") ?? false) as! Bool ? .white : UIColor(hex: "#424242"),bulletColor: (UserDefaults.standard.value(forKey: "isDarkMode") ?? false) as! Bool ? .white : UIColor(hex: "#424242"))
        super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func add(stringList: [String],
             font: UIFont,
             bullet: String = "\u{2022}",
             indentation: CGFloat = 20,
             lineSpacing: CGFloat = 2,
             paragraphSpacing: CGFloat = 12,
             textColor: UIColor = UIColor(hex: "#424242"),
             bulletColor: UIColor = .black) -> NSAttributedString {

        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: bulletColor]

        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation

        let bulletList = NSMutableAttributedString()
        for (index,string) in stringList.enumerated() {
            let formattedString = "\(bullet)\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)

            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))

            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))

            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }

        return bulletList
    }
}
