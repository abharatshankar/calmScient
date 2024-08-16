//
//  MindfulNess.swift
//  sample
//
//  Created by Krishna on 8/4/24.
//

import Foundation
import UIKit



class MindfulNess: UIViewController {
    
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var stepsImgView: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var backActionImg: UIImageView!
    @IBOutlet weak var frontActionImg: UIImageView!
    
    
    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var text2: UILabel!
    
    
    @IBOutlet weak var leftBtn: UIImageView!
    @IBOutlet weak var rightBtn: UIImageView!
    
    
    let textArray = [
        "Have you ever caught your mind wandering or daydreaming while you are in the middle of a familiar or repetitive task? You could be walking, working or even driving your car, and your mind is miles away, perhaps fantasizing about going on vacation, thinking about your to-do list, or worrying about some upcoming event.",
                     
                     "Mindfulness is the opposite of automatic pilot. It is about experiencing the world that is firmly in the ‘here and now’. This is referred to as the being mode. It liberates you from automatic and unhelpful thoughts and responses.",
                     
                     "How does mindfulness help with anxiety?",
                     
    "Mindfulness reminds us that we don’t have to take immediate control of, remove or fix unpleasant experiences. Instead, we can identify and actively engage in something that will give us a sense of safety and connection.",
                     
                     "As a simple example: Instead of focusing on how many miles you walked in the morning, can you be mindfully aware of the birds singing, actively feel the fresh air, and sense the changing of the season? When you connect your senses to nature, animals, people and your own body, you capture the attention of your nervous system, which in turn soothes your anxiety. When you return home, you will be in a better frame of mind and more prepared to face your day.",
                     
                     "Which mindfulness exercises would you like to make part of your daily routine? Calmscient can remind you of some easy mindfulness routines that will help you stay in a healthy, being mode."
    ]
    let imagesArray = [
                       UIImage(named: "stpe1_img"),
                       UIImage(named: "step2_img"),
                       UIImage(named: "step3_img"),
                       UIImage(named: "step4_img"),
                       UIImage(named: "step5_img"),
                       UIImage(named: "step6_img"),
                    ]
    
    var counter = 0

    
    func createAttributedString(segments: [(text: String, attributes: [NSAttributedString.Key: Any])]) -> NSMutableAttributedString {
            let attributedString = NSMutableAttributedString()
            
            for segment in segments {
                let attributedSegment = NSAttributedString(string: segment.text, attributes: segment.attributes)
                attributedString.append(attributedSegment)
            }
            
            return attributedString
        }
    
    @objc func bottomBackTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        counter = counter - 1
        if(counter < 0){
            counter = 0
        }
        setupData()
        
    }
    
    @objc func bottomFrontTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("front tapped")
        counter = counter + 1
        setupData()
        // Your action
    }
    
    
    func outputAttStr(highlightedStr1: String,normalStr: String)->NSMutableAttributedString{
        let highlightAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(hex: "#6E6BB3")
        ]

        let attrs2: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(hex: "#110E0E")
        ]

        // Define the text segments
        let segments = [
            (text: highlightedStr1, attributes: highlightAttr),
            (text: normalStr, attributes: attrs2)
        ]

        // Create the combined attributed string
        let combinedAttributedString = createAttributedString(segments: segments)
        return combinedAttributedString
    }
    
    func setupData(){
        if(counter == 0){
            leftBtn.isHidden = true
            // Define the attributes for each text segment
                    let highlightAttr: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 15),
                        .foregroundColor: UIColor(hex: "#6E6BB3")
                    ]

                    let attrs2: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 15),
                        .foregroundColor: UIColor(hex: "#110E0E")
                    ]

                    // Define the text segments
                    let segments = [
                        (text: "Have you ever caught your mind wandering or daydreaming", attributes: highlightAttr),
                        (text: " while you are in the middle of a familiar or repetitive task? You could be walking, working or even driving your car, and your mind is miles away, perhaps fantasizing about going on vacation, thinking about your to-do list, or worrying about some upcoming event.", attributes: attrs2)
                    ]

                    // Create the combined attributed string
                    let combinedAttributedString = createAttributedString(segments: segments)
                    
            text1.attributedText = combinedAttributedString//textArray[0]
            
            let fulltxt2 = "In either case, you are not focusing on the current situation and not in touch with the ‘here and now’.  This mode of operation is often referred to as automatic pilot."
            
                    // Create a mutable attributed string
                    let attributedString = NSMutableAttributedString(string: fulltxt2, attributes: attrs2)
                    
                    // Define the range of the highlighted text
                    let highlightedTextRange = (fulltxt2 as NSString).range(of: "automatic pilot.")
                    
                    // Apply the highlighted attributes to the specific range
                    attributedString.addAttributes(highlightAttr, range: highlightedTextRange)
                    
            
            text2.attributedText = attributedString
            stepsImgView.image = UIImage(named: "step1")
            imgView.image = imagesArray[0]
            
        }else if(counter == 1){
            
            leftBtn.isHidden = false
            text1.attributedText = outputAttStr(highlightedStr1: "Mindfulness", normalStr: "is the opposite of automatic pilot. It is about experiencing the world that is firmly in the ‘here and now’. This is referred to as the being mode. It liberates you from automatic and unhelpful thoughts and responses.")
            text2.text = ""
            stepsImgView.image = UIImage(named: "step2")
            imgView.image = imagesArray[1]
        }
        else if(counter == 2){
            text1.text = textArray[2]
            text1.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            imgView.image = imagesArray[2]
            stepsImgView.image = UIImage(named: "step3")
            text2.text = "When we allow our brain to enter automatic pilot mode too often, it can be at risk of being conditioned to be overly preoccupied about the future, past experiences or our emotions in negative ways. If we have fallen into this old and unhelpful habit, we can unlearn it and replace it with skills that help us resist ‘buying into’ automatic worry and anxiety. "
        }
        else if(counter == 3){
            text1.text = textArray[3]
            text1.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            text2.text = ""
            imgView.image = imagesArray[3]
            stepsImgView.image = UIImage(named: "step4")
        }
        else if(counter == 4){
            rightBtn.isHidden = false
            text1.text = textArray[4]
            text2.text = ""
            imgView.image = imagesArray[4]
            stepsImgView.image = UIImage(named: "step5")
        }
        else if(counter == 5){
            rightBtn.isHidden = true
            text1.text = textArray[5]
            text2.text = ""
            imgView.image = imagesArray[5]
            stepsImgView.image = UIImage(named: "step6")
        }
    }
    
    @IBOutlet weak var backImg: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        //back button tapped
        
       
        let arrowBack = UITapGestureRecognizer(target: self, action: #selector(bottomBackTapped(tapGestureRecognizer:)))
        
        titleLabel.font = UIFont(name: Fonts().lexendMedium, size: 20)
        
        backActionImg.isUserInteractionEnabled = true
        backActionImg.addGestureRecognizer(arrowBack)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        //front button tapped
        let arrowFront = UITapGestureRecognizer(target: self, action: #selector(bottomFrontTapped(tapGestureRecognizer:)))
        
        frontActionImg.isUserInteractionEnabled = true
        frontActionImg.addGestureRecognizer(arrowFront)
        setupData()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            backImg.isUserInteractionEnabled = true
            backImg.addGestureRecognizer(tapGestureRecognizer)
        
        text1.font = UIFont(name: Fonts().lexendLight, size: 15)
        text2.font = UIFont(name: Fonts().lexendLight, size: 15)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.navigationController?.popViewController(animated: true)
        // Your action
    }
}
