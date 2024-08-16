//
//  DefineMakeCell.swift
//  CalmscientIOS
//
//  Created by mac on 25/06/24.
//

import Foundation
import Foundation
import UIKit

class DefineMakeCell: UITableViewCell {
    @IBOutlet weak var label: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupLabel()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    private func setupLabel() {
        let fullText = """
        First of all, let's define what is the best for you.

        If you're considering changing your drinking, you'll need to decide whether to cut down or quit. It's a good idea to discuss different options with a healthcare professional, a friend, or someone else you trust.

        Please note, when someone who has been drinking heavily for a prolonged period of time suddenly stops drinking, the body can go into a painful or even potentially life-threatening process of withdrawal.

        Symptoms can include nausea, rapid heart rate, seizures, or other problems. Seek medical help to plan a safe recovery. Doctors can prescribe medications to address these symptoms and make the process safer and less distressing.
        """
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let defaultTextColor: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "AppLightTextColor") ?? UIColor.darkGray
        ]
        attributedString.addAttributes(defaultTextColor, range: NSRange(location: 0, length: attributedString.length))
        
        let hyperlinkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "AppThemeColor")!
        ]
        
        attributedString.addAttributes(hyperlinkAttributes, range: (fullText as NSString).range(of: " a painful or even potentially life-threatening process of withdrawal."))
        attributedString.addAttributes(hyperlinkAttributes, range: (fullText as NSString).range(of: "nausea, rapid heart rate, seizures, or other problems."))
//        attributedString.addAttributes(hyperlinkAttributes, range: (fullText as NSString).range(of: "pros and cons of doing so?"))
        
        label.attributedText = attributedString
        label.font = UIFont(name: Fonts().lexendRegular, size: 15)
//        label.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
//        label.isUserInteractionEnabled = true
//        label.addGestureRecognizer(tapGestureRecognizer)
    }
    
//    @objc private func labelTapped(_ recognizer: UITapGestureRecognizer) {
//        let label = recognizer.view as! UITextView
//        let text = (label.attributedText?.string ?? "") as NSString
//
//        let range1 = text.range(of: "We want you to know that the decision to reduce alcohol/drug consumption is entirely yours!")
//        let range2 = text.range(of: "stopping, cutting down, or reducing your drinking.")
//        let range3 = text.range(of: "pros and cons of doing so?")
//
//        let tapLocation = recognizer.location(in: label)
//        let index = indexOfCharacter(at: tapLocation, in: label)
//
//        if NSLocationInRange(index, range1) {
//            // Handle tap on the first hyperlink
//            print("First hyperlink tapped")
//        } else if NSLocationInRange(index, range2) {
//            // Handle tap on the second hyperlink
//            print("Second hyperlink tapped")
//        } else if NSLocationInRange(index, range3) {
//            // Handle tap on the third hyperlink
//            print("Third hyperlink tapped")
//        }
//    }
//
    private func indexOfCharacter(at point: CGPoint, in label: UILabel) -> Int {
        guard let attributedText = label.attributedText else { return NSNotFound }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0.0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let boundingRect = layoutManager.boundingRect(forGlyphRange: NSMakeRange(0, textStorage.length), in: textContainer)
        guard boundingRect.contains(point) else { return NSNotFound }
        
        let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer)
        return layoutManager.characterIndexForGlyph(at: glyphIndex)
    }
}
