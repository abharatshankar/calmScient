//
//  NeedToTalkViewController.swift
//  CalmscientIOS
//
//  Created by BVK on 21/07/24.
//

import UIKit

class NeedToTalkViewController: UIViewController {
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var doctorSubtitle: UILabel!
    @IBOutlet weak var doctorName: UILabel!
    
    @IBOutlet weak var needToTalkTableView: UITableView!
    var needToTalkData: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        needToTalkTableView.register(UINib(nibName: "NeedToTalkTableViewCell", bundle: nil), forCellReuseIdentifier: "NeedToTalkTableViewCell")
        
        self.navigationController?.isNavigationBarHidden = false

        
        needToTalkTableView.dataSource = self
        needToTalkTableView.delegate = self
        
        self.view.showToastActivity()
        guard let userInfo = ApplicationSharedInfo.shared.loginResponse else {
            fatalError("Unable to found Application Shared Info")
        }
        
        getNeedToTalkData(patientId: userInfo.patientID, bearerToken: ApplicationSharedInfo.shared.tokenResponse!.accessToken) { [self] result in
            switch result {
            case .success(let data):
                // Convert data to JSON object and print it
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            print(json)
                            self.view.hideToastActivity()
                            if let need = json["providerDetails"] as? [String: Any] {
                                if let docName = need["providerName"] as? String {
                                    self.doctorName.text = docName
                                } else {
                                    print("providerName key is missing or not a String")
                                }
                                if let docNameSub = need["location"] as? String {
                                    self.doctorSubtitle.text = docNameSub
                                } else {
                                    print("providerName key is missing or not a String")
                                }
                                if let docNamePhone = need["phoneNumber"] as? String {
                                    self.phoneNumber.text = docNamePhone
                                } else {
                                    self.phoneNumber.text = "Not Updated"
                                }
                                
                            } else {
                                print("providerDetails key is missing or not a dictionary")
                            }
                            
                            if let needArray = json["needToTalkWithSomeOne"] as? [[String: Any]] {
                                        self.needToTalkData = needArray
                                        DispatchQueue.main.async {
                                            self.needToTalkTableView.reloadData()
                                        }
                                    } else {
                                        print("Failed to cast JSON data")
                                    }


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
        self.title = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ?  "Emergency Resources" : "Recursos de emergencia."
        needToTalkTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func setupLanguage() {
        
            let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLanguage()
        needToTalkTableView.reloadData()
        self.navigationController?.isNavigationBarHidden = false
    }
    func getNeedToTalkData(patientId: Int,bearerToken: String, completion: @escaping (Result<Data, Error>) -> Void) {
        // Define the URL
        guard let url = URL(string: "\(baseURLString)identity/api/v1/settings/getNeedToTalkWithSomeoneDetails") else {
            print("Invalid URL")
            return
        }
   // https://calmscient.centralindia.cloudapp.azure.com:8090/identity/api/v1/settings/getNeedToTalkWithSomeoneDetails
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        
        // Define the JSON payload
        let payload: [String: Any] = [
                        "patientId": patientId,
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
            
            // If needed, handle the response here
            completion(.success(data))
        }
        
        // Start the data task
        task.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
   
}
extension NeedToTalkViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return needToTalkData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NeedToTalkTableViewCell", for: indexPath) as! NeedToTalkTableViewCell
        
        let event = needToTalkData[indexPath.row]
                
                if let eventName = event["title"] as? String {
                    cell.titleLabel.text = eventName
                } else {
                    cell.titleLabel.text = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "No title available" : "Título no disponible."
                }
                
                if let eventContent = event["content"] as? String {
                    cell.descriptionLabel.text = eventContent
                } else {
                    cell.descriptionLabel.text = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ?  "No content available" : "No hay contenido disponible."
                }
        cell.learnMoreButton.setTitle(UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Learn more" : "Aprende más.", for: .normal)  
        cell.learnMoreButton.tag = indexPath.row

        cell.learnMoreButton.addTarget(self, action: #selector(NeedToTalkViewController.learnMoreButtonClicked(_:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    @objc func learnMoreButtonClicked(_ sender: UIButton) {
            let index = sender.tag
            let event = needToTalkData[index]
            if let url = event["learnMore"] as? String {
                print("Learn More URL for row \(index): \(url)")
                
                let next = UIStoryboard(name: "FavoritesVideosWebViewController", bundle: nil)
                let vc = next.instantiateViewController(withIdentifier: "FavoritesVideosWebViewController") as? FavoritesVideosWebViewController
                vc?.favURL = url
                vc?.title = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ?  "Emergency Resources" : "Recursos de emergencia."
                self.navigationController?.pushViewController(vc!, animated: true)
                
                
            } else {
                print("No URL available for row \(index)")
            }
        }
}

