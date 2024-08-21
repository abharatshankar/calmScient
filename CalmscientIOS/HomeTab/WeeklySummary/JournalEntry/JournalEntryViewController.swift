//
//  JournalEntryViewController.swift
//  CalmscientIOS
//
//  Created by BVK on 19/07/24.
//

import UIKit

class JournalEntryViewController: UIViewController,UITextFieldDelegate {
  
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var discoveryButton: UIButton!
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var quizButton: UIButton!
    @IBOutlet weak var calenderButton: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var journalTableView: UITableView!
    @IBOutlet weak var needToTalkButton: LinearGradientButton!
    var quizData: [[String: Any]] = []
    var filteredQuizData: [[String: Any]] = []
    var dailyData: [[String: Any]] = []
    var filtereddailyData: [[String: Any]] = []
    var discoverData: [[String: Any]] = []
    var filtereddiscoverData: [[String: Any]] = []
    var totalData: [[String: Any]] = []
    var buttonTag : Int = 1
    var dateString : String = ""
    var dateString1 : String = ""
    @IBOutlet var pickerBackView: UIView!
    var nomedications = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        calenderButton.layer.cornerRadius = calenderButton.frame.height/2

        searchTF.delegate = self
        
        needToTalkButton.setAttributedTitleWithGradientDefaults(title: "Need to talk with someone?")
        buttonTag = 1
        quizButton.layer.cornerRadius = 10
        discoveryButton.layer.cornerRadius = 10
        dailyButton.layer.cornerRadius = 10

        journalTableView.register(UINib(nibName: "quizTableViewCell", bundle: nil), forCellReuseIdentifier: "quizTableViewCell")
        journalTableView.delegate = self
        journalTableView.dataSource = self
        journalTableView.reloadData()
        quizButton.backgroundColor = UIColor(named: "AppBorderColor")
        
        pickerBackView.backgroundColor = UIColor.white
        pickerBackView.layer.borderColor = UIColor.lightGray.cgColor
        pickerBackView.layer.borderWidth = 1

        pickerBackView.translatesAutoresizingMaskIntoConstraints = false
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(pickerBackView)
            
            // Add constraints
            NSLayoutConstraint.activate([
                pickerBackView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                pickerBackView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                pickerBackView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
                pickerBackView.heightAnchor.constraint(equalToConstant: 200)
            ])
        }
        
        pickerBackView.isHidden = true
        
        
        nomedications.text = "No data for this date"
        nomedications.textColor = .purple
        nomedications.textAlignment = .center
        nomedications.font = UIFont.boldSystemFont(ofSize: 17)

              
        view.addSubview(nomedications)

        nomedications.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
                    nomedications.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    nomedications.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
        self.nomedications.isHidden = true
        
        self.view.showToastActivity()
      //  dateString =  "05/03/2024"
        
        let currentDate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy" // Adjust the format as needed
                 dateString = dateFormatter.string(from: currentDate)
        
        print("dateString===\(dateString)")
        
        guard let userInfo = ApplicationSharedInfo.shared.loginResponse else {
            fatalError("Unable to found Application Shared Info")
        }
        getJournalEntryData(plId: userInfo.patientLocationID, patientId: userInfo.patientID, clientId: userInfo.clientID, fromDate: "",entry: "", bearerToken: ApplicationSharedInfo.shared.tokenResponse!.accessToken) { [self] result in
            switch result {
            case .success(let data):
                // Convert data to JSON object and print it
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            print("getJournalEntryData===\(json)")
//                            if let totalData1 = json as? [String: Any] {
//                                self.totalData = totalData1 as? [String: Any]
//                            }
                            self.view.hideToastActivity()
                            
                            if let quiz1 = json["quiz"] as? [[String: Any]] {
                                self.quizData = quiz1
                                print("self.quizData==\(self.quizData)")
                                self.filteredQuizData = self.quizData
                                if self.filteredQuizData.isEmpty {
                                    self.nomedications.isHidden = false
                                }
                                else{
                                    self.nomedications.isHidden = true
                                }
                                self.journalTableView.reloadData()

                            } else {
                                print("providerDetails key is missing or not a dictionary")
                            }
                            if let dailyJournal1 = json["dailyJournal"] as? [[String: Any]] {
                                self.dailyData = dailyJournal1
                                print("self.dailyData==\(self.dailyData)")
                                self.filtereddailyData = self.dailyData
//                                if self.filtereddailyData.isEmpty {
//                                    self.nomedications.isHidden = false
//                                }
//                                else{
//                                    self.nomedications.isHidden = true
//                                }

                            } else {
                                print("providerDetails key is missing or not a dictionary")
                            }
                            if let discoveryExercises1 = json["discoveryExercises"] as? [[String: Any]] {
                                self.discoverData = discoveryExercises1
                                self.filtereddiscoverData = self.discoverData
                                print("self.discoverData==\(self.discoverData)")
//                                if self.filtereddiscoverData.isEmpty {
//                                    self.nomedications.isHidden = false
//                                }
//                                else{
//                                    self.nomedications.isHidden = true
//                                }

                            } else {
                                print("providerDetails key is missing or not a dictionary")
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
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false

        setupLanguage()
    }
    override func viewDidDisappear(_ animated: Bool) {
        pickerBackView.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        pickerBackView.isHidden = true
    }
    func setupLanguage() {
        
            let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        
        quizButton.titleLabel!.text = AppHelper.getLocalizeString(str: "Quiz")
        dailyButton.titleLabel!.text = AppHelper.getLocalizeString(str: "Daily jouneral")
        discoveryButton.titleLabel!.text = AppHelper.getLocalizeString(str: "Discovery Excercise")
        }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            filterAndSortData(with: currentText)
            return true
        }
    func filterAndSortData(with searchText: String) {
        if buttonTag == 1{
            if searchText.isEmpty {
                filteredQuizData = quizData
            } else {
                filteredQuizData = quizData.filter { event in
                    if let title = event["title"] as? String {
                        return title.lowercased().contains(searchText.lowercased())
                    }
                    return false
                }
            }
            
            filteredQuizData.sort { (event1, event2) -> Bool in
                guard let title1 = event1["title"] as? String, let title2 = event2["title"] as? String else {
                    return false
                }
                return title1 < title2
            }
            
            journalTableView.reloadData()
        }
        if buttonTag == 2 {
            if searchText.isEmpty {
                filtereddailyData = dailyData
            } else {
                filtereddailyData = dailyData.filter { event in
                    if let title = event["entry"] as? String {
                        return title.lowercased().contains(searchText.lowercased())
                    }
                    return false
                }
            }
            
            filtereddailyData.sort { (event1, event2) -> Bool in
                guard let title1 = event1["entry"] as? String, let title2 = event2["entry"] as? String else {
                    return false
                }
                return title1 < title2
            }
            
            journalTableView.reloadData()
            
        }
        if buttonTag == 3 {
            if searchText.isEmpty {
                filtereddiscoverData = discoverData
            } else {
                filtereddiscoverData = discoverData.filter { event in
                    if let title = event["entry"] as? String {
                        return title.lowercased().contains(searchText.lowercased())
                    }
                    return false
                }
            }
            
            filtereddiscoverData.sort { (event1, event2) -> Bool in
                guard let title1 = event1["entry"] as? String, let title2 = event2["entry"] as? String else {
                    return false
                }
                return title1 < title2
            }
            
            journalTableView.reloadData()
        }
       }
    @IBAction func needToTalkAction(_ sender: Any) {
        let next = UIStoryboard(name: "NeedToTalkViewController", bundle: nil)
               let vc = next.instantiateViewController(withIdentifier: "NeedToTalkViewController") as? NeedToTalkViewController
               vc?.title = "Emergency resource"
               self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func closeButtonClicked(_ sender: Any) {
      //  calenderBackGroundView.removeFromSuperview()
        pickerBackView.isHidden = true

    }
    
    @IBAction func okButtomClicked(_ sender: Any) {
        pickerBackView.isHidden = true
        let selectedDate = datePickerView.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateString1 = dateFormatter.string(from: selectedDate)
    //  print(dateString)
        
        self.view.showToastActivity()
        guard let userInfo = ApplicationSharedInfo.shared.loginResponse else {
            fatalError("Unable to found Application Shared Info")
        }
        getJournalEntryData(plId: userInfo.patientLocationID, patientId: userInfo.patientID, clientId: userInfo.clientID, fromDate: dateString1,entry: "", bearerToken: ApplicationSharedInfo.shared.tokenResponse!.accessToken) { [self] result in
            switch result {
            case .success(let data):
                // Convert data to JSON object and print it
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            print("getJournalEntryData===\(json)")
//                            if let totalData1 = json as? [String: Any] {
//                                self.totalData = totalData1 as? [String: Any]
//                            }
                            self.view.hideToastActivity()
                            
                            if let quiz1 = json["quiz"] as? [[String: Any]] {
                                self.quizData = quiz1
                               // print("self.quizData==\(self.quizData)")
                                self.filteredQuizData = self.quizData
//                                if self.filteredQuizData.isEmpty {
//                                    self.nomedications.isHidden = false
//                                }
//                                else{
//                                    self.nomedications.isHidden = true
//                                }
                                self.journalTableView.reloadData()

                            } else {
                                print("providerDetails key is missing or not a dictionary")
                            }
                            if let dailyJournal1 = json["dailyJournal"] as? [[String: Any]] {
                                self.dailyData = dailyJournal1
                              //  print("self.dailyData==\(self.dailyData)")
                                self.filtereddailyData = self.dailyData
//                                if self.filtereddailyData.isEmpty {
//                                    self.nomedications.isHidden = false
//                                }
//                                else{
//                                    self.nomedications.isHidden = true
//                                }
                                self.journalTableView.reloadData()
                            } else {
                                print("providerDetails key is missing or not a dictionary")
                            }
                            if let discoveryExercises1 = json["discoveryExercises"] as? [[String: Any]] {
                                self.discoverData = discoveryExercises1
                                self.filtereddiscoverData = self.discoverData
                            //    print("self.discoverData==\(self.discoverData)")
//                                if self.filtereddiscoverData.isEmpty {
//                                    self.nomedications.isHidden = false
//                                }
//                                else{
//                                    self.nomedications.isHidden = true
//                                }
                                self.journalTableView.reloadData()
                            } else {
                                print("providerDetails key is missing or not a dictionary")
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
    }
    @IBAction func calenderButtonTapped(_ sender: Any) {
        self.view.bringSubviewToFront(pickerBackView)
      //  datePickerView.maximumDate = Date()
print("calenderButtonTapped")
        pickerBackView.isHidden = false
    }
    
    @IBAction func quizButtonTapped(_ sender: Any) {
        buttonTag = 1
        journalTableView.register(UINib(nibName: "quizTableViewCell", bundle: nil), forCellReuseIdentifier: "quizTableViewCell")
        journalTableView.delegate = self
        journalTableView.dataSource = self
        journalTableView.reloadData()
        quizButton.backgroundColor = UIColor(named: "AppBorderColor")
        dailyButton.backgroundColor = UIColor(named: "AppBackGroundColor")
        discoveryButton.backgroundColor =  UIColor(named: "AppBackGroundColor")
        searchTF.text = ""
        if self.filteredQuizData.isEmpty {
            self.nomedications.isHidden = false
        }
        else{
            self.nomedications.isHidden = true
        }
        self.journalTableView.reloadData()
    }
    @IBAction func dailyButtonTapped(_ sender: Any) {
        buttonTag = 2
        journalTableView.register(UINib(nibName: "JournalEntryExpandedTableCell", bundle: nil), forCellReuseIdentifier: "JournalEntryExpandedTableCell")
        journalTableView.delegate = self
        journalTableView.dataSource = self
        journalTableView.reloadData()
        quizButton.backgroundColor =  UIColor(named: "AppBackGroundColor")
        dailyButton.backgroundColor = UIColor(named: "AppBorderColor")
        discoveryButton.backgroundColor =  UIColor(named: "AppBackGroundColor")
        searchTF.text = ""
        if self.dailyData.isEmpty {
            self.nomedications.isHidden = false
        }
        else{
            self.nomedications.isHidden = true
        }
        self.journalTableView.reloadData()
        
    }
    @IBAction func discoveryButtonTapped(_ sender: Any) {
        buttonTag = 3
        journalTableView.register(UINib(nibName: "JournalEntryExpandedTableCell", bundle: nil), forCellReuseIdentifier: "JournalEntryExpandedTableCell")
        journalTableView.delegate = self
        journalTableView.dataSource = self
        journalTableView.reloadData()
        quizButton.backgroundColor =  UIColor(named: "AppBackGroundColor")
        dailyButton.backgroundColor =  UIColor(named: "AppBackGroundColor")
        discoveryButton.backgroundColor = UIColor(named: "AppBorderColor")
        searchTF.text = ""
        if self.discoverData.isEmpty {
            self.nomedications.isHidden = false
        }
        else{
            self.nomedications.isHidden = true
        }
        self.journalTableView.reloadData()
    }
    func getJournalEntryData(plId: Int, patientId: Int, clientId: Int, fromDate: String,entry: String,bearerToken: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: "\(baseURLString)patients/api/v1/patientDetails/getPatientJournalByPatientIdForMobile") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        // Define the JSON payload
        let payload: [String: Any] = [
            "patientLocationId":plId ,
            "fromDate": fromDate,
            "patientId": patientId,
            "clientId": clientId,
            "entry":entry
        ]
        
        print("payload\(payload)")
        // Convert the payload to JSON data
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.httpBody = jsonData
            //print(jsonData)
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
extension JournalEntryViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if buttonTag == 1 {
            return filteredQuizData.count
    }
        if buttonTag == 2 {
            return filtereddailyData.count
        }
        if buttonTag == 3 {
            return filtereddiscoverData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if buttonTag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "quizTableViewCell", for: indexPath) as! quizTableViewCell
            
            let event = filteredQuizData[indexPath.row]
            
            if let eventName = event["title"] as? String {
                cell.titleLabel.text = eventName
            }
            
            if let completionDateTime = event["completionDateTime"] as? String {
                cell.dateandTimeLabel.text = formatDateTime(completionDateTime)
            }
            if let score = event["score"] as? Int, let total = event["totalScore"] as? Int {
                cell.countLabel.text = "\(score)/\(total)"
                cell.quizProgressBar.progress = Float(score) / Float(total)
            } else {
                cell.countLabel.text = "0"
                cell.quizProgressBar.setProgress(0, animated: true)
            }
            
            return cell
        } 
        else if buttonTag == 2 {
            print("daily jounerel")
            let cell = tableView.dequeueReusableCell(withIdentifier: "JournalEntryExpandedTableCell", for: indexPath) as! JournalEntryExpandedTableCell
            
            let event = filtereddailyData[indexPath.row]
            
            if let eventName = event["createdAt"] as? String {
                cell.titleLabel.text = formatDateTime1(eventName)
            }
            if let createdAt = event["entry"] as? String {
                cell.journalTextLabel.text = createdAt
            }
//            nomedications.text = filtereddailyData.count > 0 ?  "" :  "No data for this date"
            return cell
        }
        else if buttonTag == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JournalEntryExpandedTableCell", for: indexPath) as! JournalEntryExpandedTableCell
            
            let event = filtereddiscoverData[indexPath.row]
            
            if let createdAt = event["createdAt"] as? String, let title = event["title"] as? String {
                let createdAt1 = formatDateTime1(createdAt)
                cell.titleLabel.text = ("\(createdAt1 ?? "") | \(title)")
            }

           
            if let createdAt = event["entry"] as? String {
                cell.journalTextLabel.text = createdAt
            }
//            nomedications.text = filtereddiscoverData.count > 0 ?  "" :  "No data for this date"
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "quizTableViewCell", for: indexPath)
            //cell.textLabel?.text = "Default cell"
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if buttonTag == 3{
            let names = discoverData[indexPath.row] as [String : Any]
            let newUrl = names["url"] as! String
            let title = names["title"] as? String
            print("newUrl===\(newUrl)")
            
            let next = UIStoryboard(name: "FavoritesVideosWebViewController", bundle: nil)
            let vc = next.instantiateViewController(withIdentifier: "FavoritesVideosWebViewController") as? FavoritesVideosWebViewController
            vc?.favURL = newUrl
            vc?.titleString = title ?? ""
            
            vc?.title = "Favorite Video"
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if buttonTag == 1 {
            return 150
        }
        if buttonTag == 2 {
            return 98
        }
        if buttonTag == 3 {
            return 98
        }
        return 150
       
    }
    func formatDateTime(_ dateTime: String) -> String? {
           let inputFormatter = DateFormatter()
           inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           
           let outputFormatter = DateFormatter()
           outputFormatter.dateFormat = "MM/dd/yyyy | hh:mm a"
           
           if let date = inputFormatter.date(from: dateTime) {
               return outputFormatter.string(from: date)
           }
           return nil
       }
    func formatDateTime1(_ dateTime: String) -> String? {
           let inputFormatter = DateFormatter()
           inputFormatter.dateFormat = "yyyy-MM-dd"
           
           let outputFormatter = DateFormatter()
           outputFormatter.dateFormat = "MM/dd/yyyy"
           
           if let date = inputFormatter.date(from: dateTime) {
               return outputFormatter.string(from: date)
           }
           return nil
       }
    func setFormattedCountLabel(score: Int, total: Int) {
           let scoreString = "\(score)"
           let totalString = "\(total)"
           let combinedString = "\(scoreString)|\(totalString)"
           
           let scoreAttributes: [NSAttributedString.Key: Any] = [
               .foregroundColor: UIColor.purple,
               .font: UIFont.systemFont(ofSize: 14)
           ]
           
           let totalAttributes: [NSAttributedString.Key: Any] = [
               .foregroundColor: UIColor.black,
               .font: UIFont.boldSystemFont(ofSize: 18)
           ]
           
           let attributedString = NSMutableAttributedString(string: combinedString)
           attributedString.addAttributes(scoreAttributes, range: NSRange(location: 0, length: scoreString.count))
           attributedString.addAttributes(totalAttributes, range: NSRange(location: scoreString.count + 1, length: totalString.count))
           
       }
}
