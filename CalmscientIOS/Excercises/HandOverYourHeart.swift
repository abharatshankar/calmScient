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
    
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.subtitleLbl.font = UIFont(name: Fonts().lexendLight, size: 19)
        
        self.titleLbl.font = UIFont(name: Fonts().lexendMedium, size: 19)
        
        let arrayString = [
            "Rest the heel of your hand on your sternum around your heart area.",
            "Apply a steady, gentle, but firm pressure.",
            "For added effect, you can place your other hand across your forehead or on your abdomen.",
            "Experiment with the various placements and wait until you feel a shift. It may take up to 5 or 10 minutes of deep breathing in this position to shift if you are very activated."
        ]

        howToDoIt.attributedText = add(stringList: arrayString, font: UIFont(name: Fonts().lexendLight, size: 15)!
                                       , bullet: "•")

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
    override func viewWillAppear(_ animated: Bool) {
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
