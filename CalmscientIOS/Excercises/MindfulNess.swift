//
//  MindfulNess.swift
//  sample
//
//  Created by Krishna on 8/4/24.
//

import Foundation
import UIKit



class MindfulNess: UIViewController {
    
    
    @IBOutlet weak var stepsImgView: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var backActionImg: UIImageView!
    @IBOutlet weak var frontActionImg: UIImageView!
    
    
    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var text2: UILabel!
    
    
    @IBOutlet weak var leftBtn: UIImageView!
    @IBOutlet weak var rightBtn: UIImageView!
    
    @IBOutlet weak var imgStack: UIStackView!
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    var languageId : Int = 1
    
    
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
    
    
    func setupLanguage() {
        
             languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }

        setupData()
        
        }
    
    func setupData(){
        if(counter == 0){
            imgStack.isHidden = true
            stackHeight.constant = 0
            leftBtn.isHidden = true
            // Define the attributes for each text segment
                    let highlightAttr: [NSAttributedString.Key: Any] = [
                        .font: UIFont(name: Fonts().lexendLight, size: 15)!,
                        .foregroundColor: (UserDefaults.standard.value(forKey: "isDarkMode") ?? false) as! Bool ? UIColor(hex: "#F48383") : UIColor(hex: "#6E6BB3")
                    ]

                    let attrs2: [NSAttributedString.Key: Any] = [
                        .font: UIFont(name: Fonts().lexendLight, size: 15)!,
                        .foregroundColor: (UserDefaults.standard.value(forKey: "isDarkMode") ?? false) as! Bool ? .white : UIColor(hex: "#110E0E")
                        
                    ]

                    // Define the text segments
                    let segments = [
                        (text: languageId == 1 ? "Have you ever caught your mind wandering or daydreaming" : "¿Alguna vez te has sentido vagando o soñando despierto?", attributes: highlightAttr),
                        (text: languageId == 1 ?  " while you are in the middle of a familiar or repetitive task? You could be walking, working or even driving your car, and your mind is miles away, perhaps fantasizing about going on vacation, thinking about your to-do list, or worrying about some upcoming event." : " ¿mientras estás en medio de una tarea familiar o repetitiva? Podrías estar caminando, trabajando o incluso conduciendo tu auto, y tu mente está a kilómetros de distancia, tal vez fantaseando con irte de vacaciones, pensando en tu lista de tareas pendientes o preocupándote. sobre algún evento próximo." , attributes: attrs2)
                    ]

                    // Create the combined attributed string
                    let combinedAttributedString = createAttributedString(segments: segments)
                    
            text1.attributedText = combinedAttributedString//textArray[0]
            
            let fulltxt2 = languageId == 1 ? "In either case, you are not focusing on the current situation and not in touch with the ‘here and now’.  This mode of operation is often referred to as automatic pilot." : "En cualquier caso, no te estás centrando en la situación actual ni en contacto con el 'aquí y ahora'. \n Este modo de operación a menudo se denomina piloto automático"
            
                    // Create a mutable attributed string
                    let attributedString = NSMutableAttributedString(string: fulltxt2, attributes: attrs2)
                    
                    // Define the range of the highlighted text
            let highlightedTextRange = (fulltxt2 as NSString).range(of: languageId == 1 ? "automatic pilot." : "piloto automático" )
                    
                    // Apply the highlighted attributes to the specific range
                    attributedString.addAttributes(highlightAttr, range: highlightedTextRange)
                    
            
            text2.attributedText = attributedString
            stepsImgView.image = UIImage(named: "step1")
            imgView.image = imagesArray[0]
            
        }else if(counter == 1){
            
            leftBtn.isHidden = false
            stepsImgView.image = UIImage(named: "step2")
            imgView.image = imagesArray[1]
            let highlightAttr: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: Fonts().lexendLight, size: 15)!,
                .foregroundColor: (UserDefaults.standard.value(forKey: "isDarkMode") ?? false) as! Bool ? UIColor(hex: "#F48383") : UIColor(hex: "#6E6BB3")
            ]

            let attrs2: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: Fonts().lexendLight, size: 15)!,
                .foregroundColor: (UserDefaults.standard.value(forKey: "isDarkMode") ?? false) as! Bool ? .white : UIColor(hex: "#110E0E")
                
            ]
            
            let fullString = languageId == 1 ? "Mindfulness is the opposite of automatic pilot. It is about experiencing the world that is firmly in the ‘here and now’. This is referred to as the being mode. It liberates you from automatic and unhelpful thoughts and responses." : "La atención plena es lo opuesto al piloto automático. Se trata de experimentar el mundo que está firmemente en el 'aquí y ahora'. Esto se conoce como el modo de ser. Te libera de pensamientos y respuestas automáticas e inútiles"

            // Create an NSMutableAttributedString with the entire string
            let attributedString = NSMutableAttributedString(string: fullString)

            

            // Apply the default attributes to the entire string
            attributedString.addAttributes(attrs2, range: NSRange(location: 0, length: fullString.count))

            // Define the ranges of the words you want to highlight
            let mindfulnessRange = (fullString as NSString).range(of:languageId == 1 ? "Mindfulness" : "Consciencia" )
            let beingRange = (fullString as NSString).range(of:languageId == 1 ?  "being" : "ser")

            

            // Apply the highlighted attributes to the specific ranges
            attributedString.addAttributes(highlightAttr, range: mindfulnessRange)
            attributedString.addAttributes(highlightAttr, range: beingRange)

            text1.attributedText = attributedString
            text2.text = ""
        }
        else if(counter == 2){
            text1.text = languageId == 1 ? textArray[2] : "¿Cómo ayuda la atención plena con la ansiedad?"
            text1.font = UIFont(name: Fonts().lexendRegular, size: 15)!
            imgView.image = imagesArray[2]
            stepsImgView.image = UIImage(named: "step3")
            imgView.contentMode = .scaleAspectFit
            text2.text = languageId == 1 ? "When we allow our brain to enter automatic pilot mode too often, it can be at risk of being conditioned to be overly preoccupied about the future, past experiences or our emotions in negative ways. If we have fallen into this old and unhelpful habit, we can unlearn it and replace it with skills that help us resist ‘buying into’ automatic worry and anxiety. " : "Cuando permitimos que nuestro cerebro entre en modo piloto automático con demasiada frecuencia, podemos correr el riesgo de verse condicionado a estar demasiado preocupado por el futuro, las experiencias pasadas o nuestras emociones de manera negativa. Si hemos caído en este viejo e inútil hábito, podemos desaprenderlo y reemplazarlo con habilidades que nos ayuden a resistir la preocupación y la ansiedad automáticas"
        }
        else if(counter == 3){
            text1.text = languageId == 1 ? textArray[3] : "La atención plena nos recuerda que no tenemos que tomar el control inmediato, eliminar o arreglar las experiencias desagradables. En cambio, podemos identificar y participar activamente en algo que nos dé una sensación de seguridad y conexión"
            text1.font = UIFont(name: Fonts().lexendLight, size: 15)!
            text2.text = ""
            imgView.contentMode = .scaleAspectFill
            imgView.image = imagesArray[3]
            stepsImgView.image = UIImage(named: "step4")
        }
        else if(counter == 4){
            imgStack.isHidden = true
            stackHeight.constant = 0
            rightBtn.isHidden = false
            text1.text = languageId == 1 ? textArray[4] : "Como un ejemplo simple: en lugar de concentrarte en cuántas millas caminaste por la mañana, ¿puedes estar consciente del canto de los pájaros, sentir activamente el aire fresco y sentir el cambio de estación? Cuando conectas tus sentidos con la naturaleza , los animales, las personas y tu propio cuerpo, captas la atención de tu sistema nervioso, lo que a su vez calma tu ansiedad. Cuando regreses a casa, estarás en mejor estado de ánimo y más preparado para afrontar tu día."
            text2.text = ""
            imgView.contentMode = .scaleAspectFit
            imgView.image = imagesArray[4]
            stepsImgView.image = UIImage(named: "step5")
        }
        else if(counter == 5){
            imgStack.isHidden = false
            stackHeight.constant = 41
            rightBtn.isHidden = true
            text1.text = languageId == 1 ? textArray[5] : "¿Qué ejercicios de atención plena le gustaría incluir en su rutina diaria? Calmscient puede recordarle algunas rutinas sencillas de atención plena que le ayudarán a mantenerse saludable"
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
    
    override func viewWillAppear(_ animated: Bool) {
        imgStack.isHidden  =   (counter == 5) ?  false :  true
        stackHeight.constant = (counter == 5) ? 41 : 0
        setupLanguage()
        titleLabel.textColor = (UserDefaults.standard.value(forKey: "isDarkMode") ?? false) as! Bool ? .white : UIColor(hex: "#424242")
    }
    override func viewDidLoad() {
        //back button tapped
        
       
        let arrowBack = UITapGestureRecognizer(target: self, action: #selector(bottomBackTapped(tapGestureRecognizer:)))
        
        titleLabel.font = UIFont(name: Fonts().lexendMedium, size: 20)
        titleLabel.textColor = (UserDefaults.standard.value(forKey: "isDarkMode") ?? false) as! Bool ? .white : UIColor(hex: "#424242")
        
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
