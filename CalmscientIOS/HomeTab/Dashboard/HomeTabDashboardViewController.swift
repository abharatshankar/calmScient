//
//  HomeTabDashboardViewController.swift
//  MainTabBarApp
//
//  Created by KA on 23/04/24.
//

import UIKit

class HomeTabDashboardViewController: ViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var noFavsLabel: UILabel!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var dashboardTableView: UITableView!
    @IBOutlet weak var dashBoardCollectionView: UICollectionView!
    @IBOutlet weak var actionButton: LinearGradientButton!
    var favorites: [[String: Any]] = []
    var patientFavorites: [[String: Any]] = []
    
    let screenTitle = "Hello  \(ApplicationSharedInfo.shared.loginResponse!.firstName)\nWe are happy to see you"
    let helloFont = UIFont(name: Fonts().lexendLight, size: 34)
    let userFont = UIFont(name: Fonts().lexendSemiBold, size: 34)
    let subTextFont = UIFont(name: Fonts().lexendLight, size: 14)
    
    @IBOutlet weak var myFavourites: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        setupLanguage()
        guard let userInfo = ApplicationSharedInfo.shared.loginResponse else {
            fatalError("Unable to found Application Shared Info")
        }
        self.view.showToastActivity()
        getPatientFavorites(plId: userInfo.patientLocationID, patientId: userInfo.patientID, clientId: userInfo.clientID, parentId: 0) { [self] result in
            switch result {
            case .success(let data):
                // Convert data to JSON object and print it
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("favorites===\(json)")
                        DispatchQueue.main.async {
                            self.dashBoardCollectionView.hideToastActivity()
                            self.patientFavorites = json["favorites"] as! [[String : Any]]
                            print("self.patientFavorites\(self.patientFavorites)")
                            self.dashBoardCollectionView.reloadData()
                            self.view.hideToastActivity()
                        }
                        
                    } else {
                        self.view.hideToastActivity()
                        print("Unable to convert data to JSON")
                    }
                } catch {
                    self.view.hideToastActivity()
                    print("Error converting data to JSON: \(error)")
                }
            case .failure(let error):
                self.view.hideToastActivity()
                print("Error: \(error)")
            }
        }
    }

    @IBAction func didClickOnProfile(_ sender: UIButton) {
        let userProfileViewController = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        self.navigationController?.pushViewController(userProfileViewController, animated: true)
        
    }
    var nomedications1 = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        let text = NSMutableAttributedString(string: "Hello \(ApplicationSharedInfo.shared.loginResponse!.firstName)\nWe are happy to see you")
        text.addAttributes([.font:helloFont!], range: text.mutableString.range(of: "Hello"))
        text.addAttributes([.font:userFont!], range: text.mutableString.range(of: ApplicationSharedInfo.shared.loginResponse!.firstName))
        text.addAttributes([.font:subTextFont!], range: text.mutableString.range(of: "We are happy to see you"))
        screenTitleLabel.attributedText = text
        actionButton.setAttributedTitleWithGradientDefaults(title: "Need to talk with someone?")
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)

        dashboardTableView.register(UINib(nibName: "DashboardMainTableCell", bundle: nil), forCellReuseIdentifier: "DashboardMainTableCell")
        dashboardTableView.dataSource = self
        dashboardTableView.delegate = self
        
        
        let nib = UINib(nibName: "HomeTabFavoritesCollectionViewCell", bundle: nil)
        
        dashBoardCollectionView.register(nib, forCellWithReuseIdentifier: "HomeTabFavoritesCollectionViewCell")
        
        dashBoardCollectionView.delegate = self
        dashBoardCollectionView.dataSource = self
        if let layout = dashBoardCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        dashBoardCollectionView.showsHorizontalScrollIndicator = false
        
        self.noFavsLabel.isHidden = true
        
        guard let userInfo = ApplicationSharedInfo.shared.loginResponse else {
            fatalError("Unable to found Application Shared Info")
        }
      //  self.view.showToastActivity()
        
        getMeniItems(plId: userInfo.patientLocationID, patientId: userInfo.patientID, clientId: userInfo.clientID, parentId: 0) { [self] result in
            switch result {
            case .success(let data):
                // Convert data to JSON object and print it
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                          //  self.view.hideToastActivity()
                            self.favorites = json["favorites"] as! [[String : Any]]
                            if self.favorites.isEmpty{
                                self.noFavsLabel.isHidden = false
                            }
                            else {
                                self.noFavsLabel.isHidden = true
                                print("self.favorites\(self.favorites)")
                                self.dashBoardCollectionView.reloadData()
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
//        self.dashBoardCollectionView.showToastActivity()
//        getPatientFavorites(plId: userInfo.patientLocationID, patientId: userInfo.patientID, clientId: userInfo.clientID, parentId: 0) { [self] result in
//            switch result {
//            case .success(let data):
//                // Convert data to JSON object and print it
//                do {
//                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                        print("favorites===\(json)")
//                        DispatchQueue.main.async {
//                            self.dashBoardCollectionView.hideToastActivity()
//                            self.patientFavorites = json["favorites"] as! [[String : Any]]
//                            print("self.patientFavorites\(self.patientFavorites)")
//                            self.dashBoardCollectionView.reloadData()
//                        }
//                        
//                    } else {
//                        print("Unable to convert data to JSON")
//                    }
//                } catch {
//                    print("Error converting data to JSON: \(error)")
//                }
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//        }
        
    }
    
    func setupLanguage() {
        
            let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        
        noFavsLabel.text = AppHelper.getLocalizeString(str: "No favorites found for this patient")
        myFavourites.text = AppHelper.getLocalizeString(str: "My Favorites")
        }
    @objc func actionButtonTapped() {
           // Perform the action you want when the button is tapped
        let next = UIStoryboard(name: "NeedToTalkViewController", bundle: nil)
        let vc = next.instantiateViewController(withIdentifier: "NeedToTalkViewController") as? NeedToTalkViewController
        vc?.title = "Emergency resource"
        self.navigationController?.pushViewController(vc!, animated: true)
       }
    func getPatientFavorites(plId: Int, patientId: Int, clientId: Int,parentId: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: "\(baseURLString)patients/api/v1/course/getPatientFavorites") else {
            print("Invalid URL")
            return
        }
  
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(ApplicationSharedInfo.shared.tokenResponse?.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        
        
        let payload: [String: Any] = [
            "plId": plId,
            "patientId": patientId,
            "parentId" : parentId,
            "clientId": clientId,
        ]
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
    func getMeniItems(plId: Int, patientId: Int, clientId: Int,parentId: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        // Define the URL
        guard let url = URL(string: "\(baseURLString)identity/api/v1/menu/fetchMenus") else {
            print("Invalid URL")
            return
        }
  
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(ApplicationSharedInfo.shared.tokenResponse?.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        
        
        let payload: [String: Any] = [
            "plId": plId,
            "patientId": patientId,
            "parentId" : parentId,
            "clientId": clientId,
        ]
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardMainTableCell", for: indexPath) as! DashboardMainTableCell
       // "MyMedicalRecordsIcon"
      //  weeklySummaryImage
        if (indexPath.row == 0) {
            cell.cellTitleLabel.text = "My Medical Records"
            cell.imageView?.image = UIImage(named: "MyMedicalRecordsIcon")
        } else {
            cell.cellTitleLabel.text = "Weekly Summary"
            cell.imageView?.image = UIImage(named: "weeklySummaryImage") //UIImage(named: "weeklySummaryImage")//MyMedicalRecordsIcon
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 106
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let next = UIStoryboard(name: "UserMedicalRecords", bundle: nil)
            let vc = next.instantiateViewController(withIdentifier: "UserMedicalRecordsViewController") as? UserMedicalRecordsViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            let next = UIStoryboard(name: "WeeklySummaryDashboard", bundle: nil)
            let vc = next.instantiateViewController(withIdentifier: "WeeklySummaryDashboardViewController") as? WeeklySummaryDashboardViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    
}

extension HomeTabDashboardViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favorites.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeTabFavoritesCollectionViewCell", for: indexPath) as? HomeTabFavoritesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let images = favorites[indexPath.row]
        
        
        if let imageUrlString = images["thumbnailUrl"] as? String, let url = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.cellImageView.image = UIImage(data: data)
                    }
                }
            }
        }
        
       // cell.cellImageView.image = UIImage(named: "HometabFavorites\(Int.random(in: 1...2))")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedFavorite = favorites[indexPath.item]
        let patientselectedFavorite = patientFavorites[indexPath.item]
        
            if let favoritesId = selectedFavorite["favoritesId"] as? Int,
               let patientFavoriteId = patientselectedFavorite["favoritesId"] as? Int,
               favoritesId == patientFavoriteId {
                if let navigateURL = patientselectedFavorite["navigateURL"] as? String {
                    
                    print("navigateURL===\(navigateURL)")
                    
                    let next = UIStoryboard(name: "FavoritesVideosWebViewController", bundle: nil)
                    let vc = next.instantiateViewController(withIdentifier: "FavoritesVideosWebViewController") as? FavoritesVideosWebViewController
                    vc?.favURL = navigateURL
                    vc?.title = "Favorite Video"
                    self.navigationController?.pushViewController(vc!, animated: true)

                }
            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the size of each item in your collection view
        
        return CGSize(width: 160, height: 100)
    }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets.zero
        }
    
    
    
}
