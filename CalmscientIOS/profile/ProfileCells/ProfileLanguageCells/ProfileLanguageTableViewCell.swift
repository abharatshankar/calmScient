//
//  ProfileLanguageTableViewCell.swift
//  CalmscientIOS
//
//  Created by KA on NA.
//

import UIKit

class ProfileLanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellIconView: UIImageView!
    @IBOutlet weak var languageCollectionView: UICollectionView!
    var languagesArray: [[String: Any]] = [] {
            didSet {
                print("languagesArray updated: \(languagesArray)")
                languageCollectionView.reloadData()
            }
        }
    var languageSelectionClosure: ((Int) -> Void)?
    var selectedIndexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "ProfileLanguage1CollectionViewCell", bundle: nil)
        languageCollectionView.backgroundColor = UIColor(named: "AppBackGroundColor")
        languageCollectionView.register(nib, forCellWithReuseIdentifier: "ProfileLanguage1CollectionViewCell")
        languageCollectionView.delegate = self
        languageCollectionView.dataSource = self
        if let layout = languageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        languageCollectionView.contentInset = .zero
        languageCollectionView.showsHorizontalScrollIndicator = false
        languageCollectionView.showsVerticalScrollIndicator = false
        languageCollectionView.reloadData()
     //   print("getPatientLanguages===\(self.languagesArray)")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}

extension ProfileLanguageTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languagesArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileLanguage1CollectionViewCell", for: indexPath) as? ProfileLanguage1CollectionViewCell else {
            return UICollectionViewCell()
        }
        let newData = languagesArray[indexPath.row]
        cell.langaugeLable.text = newData["languageName"] as? String
        cell.langaugeLable.textColor = (UserDefaults.standard.value(forKey: "isDarkMode") ?? false) as! Bool ? UIColor(hex: "#424242") : .white
        if let imageUrlString = newData["flagUrl"] as? String, let url = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.languageImage.image = UIImage(data: data)
                        
                    }
                }
            }
        }
        cell.cellBackGroundView.layer.borderWidth = 1
        cell.cellBackGroundView.layer.borderColor = UIColor(red: 110/255, green: 107/255, blue: 179/255, alpha: 1).cgColor
        cell.cellBackGroundView.layer.cornerRadius = 10
        
        if let preferred = newData["preferred"] as? Int, preferred == 1 {
            cell.cellBackGroundView.backgroundColor = UIColor(named: "AppBorderColor")
               } else {
                   cell.cellBackGroundView.backgroundColor = UIColor.clear
               }
//        if selectedIndexPath == indexPath {
//            cell.cellBackGroundView.backgroundColor = UIColor.green // Change to desired color
//               } else {
//                   cell.cellBackGroundView.backgroundColor = UIColor.white // Default color
//               }
       return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // Return the size of each item in your collection view
//        let height = collectionView.frame.height - 4
//        return CGSize(width: height, height: height)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let newData = languagesArray[indexPath.row]
//       // print(newData["languageId"] as! Int)
//       // print(newData["preferred"] as Any)
//        let languageId = newData["languageId"] as! Int
//        
//        if let languageId = newData["languageId"] as? Int {
//                    languageSelectionClosure?(languageId)
//                }
       // selectedIndexPath = indexPath
                let newData = languagesArray[indexPath.row]
                let languageId = newData["languageId"] as! Int
                if let languageId = newData["languageId"] as? Int {
                    languageSelectionClosure?(languageId)
                }
                collectionView.reloadData()
        languageCollectionView.reloadData()
        
//        guard let userInfo = ApplicationSharedInfo.shared.loginResponse else {
//            fatalError("Unable to found Application Shared Info")
//        }
//        
//        updateUserLanguage(patientId: userInfo.patientID, clientId: userInfo.clientID,languageId: languageId ,bearerToken: ApplicationSharedInfo.shared.tokenResponse!.accessToken) { [self] result in
//            switch result {
//            case .success(let data):
//                do {
//                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                        DispatchQueue.main.async {
//                          //  print(json)
//                          // self.languageCollectionView.reloadData()
//                            let next = UIStoryboard(name: "UserProfile", bundle: nil)
//                            let vc = next.instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
//                           // self.navigationController?.pushViewController(vc!, animated: false)
//                            
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

}
