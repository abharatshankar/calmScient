//
//  USGuidlines.swift
//  CalmscientIOS
//
//  Created by mac on 02/06/24.
//

import Foundation
import UIKit

class Moderation: ViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var normalTextLabel: UILabel!
    @IBOutlet weak var hyperTextLabel: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
        let primaryReasons = AlcoholAvoidanceReason.primaryReasons().map { "\n   • \($0.rawValue)" }.joined(separator: "\n")
                let additionalReasons = AlcoholAvoidanceReason.additionalReasons().map { "\n   • \($0.rawValue)" }.joined(separator: "\n")

                let guidelinesText = """
                According to the 2020-2025 Dietary Guidelines for
                Americans, certain individuals should not consume
                alcohol. It’s safest to void alcohol altogether
                if you are:
                \(primaryReasons)
                
                In addition, certain individuals, particularly older adults, who are planning to drive a vehicle or operate machinery-or who are participating in activities that require skill, coordination, and alertness-should avoid alcohol completely.
                """

       // \(additionalReasons)
      //      normalTextLabel.text = guidelinesText
       // normalTextLabel.numberOfLines = 0
        
        
        let text = """
        What is alcohol misuse?
        
        NIAAA defines heavy drinking as follows:

        For women:
        4 or more drinks on any day or 8 or more per week

        For men:
        5 or more drinks on any day or 15 or more per week.
        """

        let attributedString = NSMutableAttributedString(string: text)

        let womenRange = (text as NSString).range(of: "For women: 4 or more drinks on any day or 8 or more per week")
        let menRange = (text as NSString).range(of: "For men: 5 or more drinks on any day or 15 or more per week.")
        let womenDetailRange = (text as NSString).range(of: "4 or more drinks on any day or 8 or more per week")
        let menDetailRange = (text as NSString).range(of: "5 or more drinks on any day or 15 or more per week")


        attributedString.addAttribute(.link, value: "", range: womenRange)
        attributedString.addAttribute(.link, value: "", range: menRange)
        attributedString.addAttribute(.link, value: "", range: womenDetailRange)
        attributedString.addAttribute(.link, value: "", range: menDetailRange)

        let font = UIFont(name: Fonts().lexendRegular, size: 15)!
        let textColor = UIColor(red: 66/255.0, green: 66/255.0, blue: 66/255.0, alpha: 1.0) 
        let fullRange = NSRange(location: 0, length: attributedString.length)

        attributedString.addAttribute(.font, value: font, range: fullRange)
        attributedString.addAttribute(.foregroundColor, value: textColor, range: fullRange)

//
     //   hyperTextLabel.attributedText = attributedString
     //   hyperTextLabel.isEditable = false
     //   hyperTextLabel.dataDetectorTypes = .link
        title = "Basic Knowledge"
        
        self.view.showToastActivity()
        
        guard let userInfo = ApplicationSharedInfo.shared.loginResponse else {
            fatalError("Unable to found Application Shared Info")
        }
        updateBasicKnowledgeIndex( patientId: userInfo.patientID, clientId: userInfo.clientID, activityDate: "", bearerToken: ApplicationSharedInfo.shared.tokenResponse!.accessToken) { [self] result in
            switch result {
            case .success(let data):
                // Convert data to JSON object and print it
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async { [self] in
                            print(json)
                            
                            self.view.hideToastActivity()
                        }
                        
                    } else {
                        print("Unable to convert data to JSON")
                    }
                } catch {
                    print("Error converting data to JSON: \(error)")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
       // setupLanguage()
    }
    
    
    func setupLanguage() {
        
            let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
                
                
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
                
               
            }
        self.title = AppHelper.getLocalizeString(str: "Basic Knowledge")
        headerLabel.text = AppHelper.getLocalizeString(str: "What’s a standard drink")
        normalTextLabel.text = AppHelper.getLocalizeString(str: "According to the 2020-2025 Dietary Guidelines for Americans, certain individuals should not consume alcohol. It’s safest to void alcohol altogether if you are: Taking medications that interact with alcohol Managing a medical condition that can be made Worse by drinking Under the age of 21, the minimum legal drinking age in the United States Recovering from alcohol use disorder (AUD) or unable to control the amount you drink Pregnant or might be pregnant In addition, certain individuals, particularly older adults, who are planning to drive a vehicle or operate machinery-or who are participating in activities that require skill, coordination, and alertness-should avoid alcohol completely.")
        hyperTextLabel.text = AppHelper.getLocalizeString(str: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.")
        }
    func updateBasicKnowledgeIndex(patientId: Int, clientId: Int, activityDate: String,bearerToken: String, completion: @escaping (Result<Data, Error>) -> Void){
        // Define the URL
        guard let url = URL(string: "\(baseURLString)patients/api/v1/takingControl/updateBasicKnowledgeIndex") else {
            print("Invalid URL")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        
        // Define the JSON payload
        let payload: [String: Any] = [
            
            "patientId":patientId,
            "isCompleted":1,
            "sectionId":3
        ]
        
        
        print("payload\(payload)")
        // Convert the payload to JSON data
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.httpBody = jsonData
            print(jsonData)
        } catch {
            print("Error converting payload to JSON: \(error)")
            completion(.failure(error))
            return
        }
        
        // Create the URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error with request: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                print("Response JSON: \(jsonResponse)")
            } catch {
                print("Error parsing JSON response: \(error)")
                completion(.failure(error))
                return
            }
            // If needed, handle the response here
            completion(.success(data))
        }
        
        // Start the data task
        task.resume()
    }
}

