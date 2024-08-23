//
//  UserMedicalRecordsViewController.swift
//  MainTabBarApp
//
//  Created by KA on 13/03/24.
//

import UIKit

class UserMedicalRecordsViewController: ViewController {

    @IBOutlet weak var medicalRecordsTableView: UITableView!
    let content:[(String,UIImage)] = [("Medications",UIImage(named: "Medications_Cell")!),("Upcoming medical appointments",UIImage(named: "MedicalAppointment_Cell")!),("Screenings",UIImage(named: "Screening_Cell")!)]
    let spanishContent:[(String,UIImage)] = [("Medicamentos",UIImage(named: "Medications_Cell")!),
                                             ("Próximas citas médicas",UIImage(named: "MedicalAppointment_Cell")!),
                                             ("Exámenes",UIImage(named: "Screening_Cell")!)]
    override func viewDidLoad() {
        super.viewDidLoad()
        let customButton = UIButton(type: .system)
        customButton.setImage(UIImage(named: "BackArrow")?.withRenderingMode(.alwaysOriginal), for: .normal) // Example with an image
            customButton.addTarget(self, action: #selector(customButtonTapped), for: .touchUpInside)
            
            // Assign the custom button to the leftBarButtonItem
            let customBarButton = UIBarButtonItem(customView: customButton)
            self.navigationItem.leftBarButtonItem = customBarButton
        
        self.navigationController?.isNavigationBarHidden = false

        medicalRecordsTableView.register(UINib(nibName: "MyMedicalRecordsCell", bundle: nil), forCellReuseIdentifier: "MyMedicalRecordsCell")
        medicalRecordsTableView.dataSource = self
        medicalRecordsTableView.delegate = self
        self.navigationController?.navigationBar.isHidden = false
        
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
                //set image for button
        button.setImage(UIImage(named: "profileIcon.png"), for: UIControl.State.normal)
                //add function for button
        button.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
                //set frame
                button.frame = CGRectMake(0, 0, 32, 32)

                let barButton = UIBarButtonItem(customView: button)
                //assign button to navigationbar
                self.navigationItem.rightBarButtonItem = barButton
        // Do any additional setup after loading the view.
    }
    @objc func customButtonTapped() {
        // Action for the custom button
        print("Custom left button tapped!")
        // You can also add custom functionality here, such as popping the view controller
        
        if #available(iOS 16.0, *) {
            if let sceneDelegate = UIApplication.shared.connectedScenes
                .first?.delegate as? SceneDelegate {
                guard let window = sceneDelegate.window else { return }
                let homeController = UIStoryboard(name: "AppTabBar", bundle: nil).instantiateViewController(withIdentifier: "AppMainTabViewController") as! AppMainTabViewController
                homeController.isInitalView = false
                window.rootViewController = homeController
                window.makeKeyAndVisible()
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "My medical records" :  "Mis registros médicos"
        medicalRecordsTableView.reloadData()
    }
    @objc func profileButtonPressed() {

        let userProfileViewController = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        self.navigationController?.pushViewController(userProfileViewController, animated: true)
        }
}

extension UserMedicalRecordsViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyMedicalRecordsCell", for: indexPath) as! MyMedicalRecordsCell
        let cellContent = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? content[indexPath.row] : spanishContent[indexPath.row]
        cell.medicalCellImage.image = cellContent.1
        cell.titleTextField.text = cellContent.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 172
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let next = UIStoryboard(name: "UserMedications", bundle: nil)
            let vc = next.instantiateViewController(withIdentifier: "UserMedicationsViewController") as? UserMedicationsViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        } else if indexPath.row == 1 {
            let next = UIStoryboard(name: "NextAppointments", bundle: nil)
            let vc = next.instantiateViewController(withIdentifier: "NextAppointmentsViewController") as? NextAppointmentsViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            let next = UIStoryboard(name: "ScreeningListVC", bundle: nil)
            let vc = next.instantiateViewController(withIdentifier: "ScreeningListVC") as? ScreeningListVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
    
}
