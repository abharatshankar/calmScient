import UIKit

class BasicStandardDrink: ViewController {
    
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var normalTextLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var main_view: UIView!
    @IBOutlet weak var image_view: UIView!
    @IBOutlet weak var normalTextView: UITextView!
    var images: [UIImage] = []
    var titles: [String] = []
    var currentIndex: Int = 0
    var drinks: [[String: Any]] = []
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        main_view.layer.cornerRadius = 10
        main_view.layer.borderWidth = 1
        main_view.layer.borderColor = UIColor.lightGray.cgColor
        updateContent()
        title = "Basic Knowledge"
        
        self.view.bringSubviewToFront(backButton)
        self.view.bringSubviewToFront(forwardButton)
        
        self.view.showToastActivity()
        
        guard let userInfo = ApplicationSharedInfo.shared.loginResponse else {
            fatalError("Unable to found Application Shared Info")
        }
        
        
        getAlcoholDrinks(plId: userInfo.patientLocationID, patientId: userInfo.patientID, clientId: userInfo.clientID, activityDate: "", bearerToken: ApplicationSharedInfo.shared.tokenResponse!.accessToken) { [self] result in
            switch result {
            case .success(let data):
                // Convert data to JSON object and print it
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async { [self] in
                            print(json)
                            
                            self.drinks = json["drinksList"] as! [[String : Any]]
                            self.view.hideToastActivity()
                            loadTitlesAndImages()
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
    }
    func setupLanguage() {
        
            let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
                
                headerLabel.text = AppHelper.getLocalizeString(str: "What’s a standard drink")
                normalTextLabel.text = AppHelper.getLocalizeString(str: "standard drink description")
                normalTextView.text = AppHelper.getLocalizeString(str: "standard drink description2")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
                
                headerLabel.text = AppHelper.getLocalizeString(str: "What’s a standard drink")
                normalTextLabel.text = AppHelper.getLocalizeString(str: "standard drink description")
                normalTextView.text = AppHelper.getLocalizeString(str: "standard drink description2")
            }
        self.title = AppHelper.getLocalizeString(str: "Basic Knowledge")
        }
    func loadTitlesAndImages() {
        activityIndicator.startAnimating()
        
        let filteredDrinks = drinks.filter { drink in
            if let drinkId = drink["drinkId"] as? Int {
                return drinkId != 1
            }
            return false
        }
        for drink in filteredDrinks {
            if let title = drink["drinkName"] as? String, let imageUrlString = drink["imageUrl"] as? String, let url = URL(string: imageUrlString) {
                
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.titles.append(title)
                            
                            self.images.append(image)
                            if self.images.count == 1 {
                                self.updateContent()
                            }
                            
                            if self.images.count == self.drinks.count {
                                self.activityIndicator.stopAnimating()
                            }
                            
                        }
                    } else {
                        DispatchQueue.main.async {
                            print("Failed to load image from URL: \(url)")
                            self.activityIndicator.stopAnimating()
                        }
                    }
                }
            } else {
                print("Invalid data: \(drink)")  // Debug statement
            }
        }
    }
    
    func getAlcoholDrinks(plId: Int, patientId: Int, clientId: Int, activityDate: String,bearerToken: String, completion: @escaping (Result<Data, Error>) -> Void) {
        // Define the URL
        guard let url = URL(string: "\(baseURLString)patients/api/v1/alcohol/getDrinksList") else {
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
            "plId": plId,
            "patientId": patientId,
            "clientId": clientId,
            "activityDate": activityDate
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
            "sectionId":1
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
    func updateContent() {
        if !images.isEmpty && !titles.isEmpty {
            imageView.image = images[currentIndex]
            drinkName.text = titles[currentIndex]
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        //            guard !images.isEmpty, !titles.isEmpty else { return }
        //            currentIndex = (currentIndex - 1 + images.count) % images.count
        //            updateContent()
        guard !images.isEmpty, !titles.isEmpty else { return }
        if currentIndex > 0 {
            currentIndex -= 1
            updateContent()
        }
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        //            guard !images.isEmpty, !titles.isEmpty else { return }
        //            currentIndex = (currentIndex + 1) % images.count
        //            updateContent()
        guard !images.isEmpty, !titles.isEmpty else { return }
        if currentIndex < images.count - 1 {
            currentIndex += 1
            updateContent()
        }
    }
    //    @IBAction func backButtonTapped(_ sender: UIButton) {
    //        guard !images.isEmpty, !titles.isEmpty else { return }
    //        if currentIndex > 0 {
    //            currentIndex -= 1
    //            updateContent()
    //        }
    //    }
    //
    //    @IBAction func forwardButtonTapped(_ sender: UIButton) {
    //        guard !images.isEmpty, !titles.isEmpty else { return }
    //        if currentIndex < images.count - 1 {
    //            currentIndex += 1
    //            updateContent()
    //        }
    //    }
    
    
}

