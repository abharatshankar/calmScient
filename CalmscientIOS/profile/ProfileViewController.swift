//
//  ProfileViewController.swift
//  CalmscientIOS
//
//  Created by BVK on 04/07/24.
//

import UIKit

@available(iOS 16.0, *)
class ProfileViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var profileScrollView: UIScrollView!
    @IBOutlet weak var lastNameTextfield: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var newPwTF: ImagePaddingTextField!
    
    @IBOutlet weak var confirmPwTF: ImagePaddingTextField!
    
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var newView: UIView!
    
    @IBOutlet weak var lastView: UIView!
    @IBOutlet weak var confirmView: UIView!
    var profileDetails: [[String: Any]] = []
    
    
    @IBOutlet weak var profileTitle: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var newPassLabel: UILabel!
    @IBOutlet weak var confirmPassLabel: UILabel!
    @IBOutlet weak var submitButton: LinearGradientButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cornerRadius: CGFloat = 7.0
        let borderColor = UIColor(named: "AppBorderColor")?.cgColor

        
        submitButton.setTitle(UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Submit" : "Enviar", for: .normal)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //self.title = "Profile"
        // Apply the corner radius and border color to each text field
        firstView.setCornerRadiusAndBorder(cornerRadius: cornerRadius, borderColor: borderColor ?? "" as! CGColor)
        lastView.setCornerRadiusAndBorder(cornerRadius: cornerRadius, borderColor: borderColor ?? "" as! CGColor)
        emailView.setCornerRadiusAndBorder(cornerRadius: cornerRadius, borderColor: borderColor ?? "" as! CGColor)
        phoneView.setCornerRadiusAndBorder(cornerRadius: cornerRadius, borderColor: borderColor ?? "" as! CGColor)
        newView.setCornerRadiusAndBorder(cornerRadius: cornerRadius, borderColor: borderColor ?? "" as! CGColor)
        confirmView.setCornerRadiusAndBorder(cornerRadius: cornerRadius, borderColor: borderColor ?? "" as! CGColor)
        
//        guard let userNameText = firstNameTextField.text?.trimmingCharacters(in: .whitespaces), !userNameText.isEmpty else {
//            self.view.showToast(message: "Username or Password can't be empty.")
//            return
//        }
        
        profileScrollView.delegate = self

               // Assuming contentView is already constrained inside the scrollView
        profileScrollView.contentSize = CGSize(width: profileScrollView.frame.width, height: ContentView.frame.height)

        profileScrollView.bounces = false
        profileScrollView.alwaysBounceVertical = false
        profileScrollView.alwaysBounceHorizontal = false
        
        
        guard let userInfo = ApplicationSharedInfo.shared.loginResponse else {
            fatalError("Unable to found Application Shared Info")
            
        }
        
        self.view.showToastActivity()
        
        getPatientProfileDetails( patientId: userInfo.patientID,bearerToken: ApplicationSharedInfo.shared.tokenResponse!.accessToken) { [self] result in
            switch result {
            case .success(let data):
                // Convert data to JSON object and print it
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async { [self] in
                            self.view.hideToastActivity()
                            
                            if let profileDetails1 = json["patientProfileDetails"] as? [String: Any] {
                                //self.profileDetails = profileDetails1
                                
                                // Update the text fields
                                if let firstName = profileDetails1["firstName"] as? String {
                                    firstNameTextField.text = firstName
                                }
                                if let lastName = profileDetails1["lastName"] as? String {
                                    lastNameTextfield.text = lastName
                                }
                                if let emailAddress = profileDetails1["emailAddress"] as? String {
                                    emailTF.text = emailAddress
                                }
                                if let phone = profileDetails1["phone"] as? String {
                                    phoneTF.text = phone
                                }
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            scrollView.contentOffset.x = 0 // Lock horizontal scrolling
        }
    override func viewWillAppear(_ animated: Bool) {
        
        profileTitle.font = UIFont(name: Fonts().lexendMedium, size: 19)
        profileTitle.text = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Profile" : "Perfil"
        
        firstName.text = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "First Name" : "Nombre"
        firstName.font = UIFont(name: Fonts().lexendRegular, size: 16)
        lastName.text = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Last Name" : "Apellido"
        lastName.font =  UIFont(name: Fonts().lexendRegular, size: 16)
        emailLabel.text = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Email" : "Correo electrónico"
        emailLabel.font =  UIFont(name: Fonts().lexendRegular, size: 16)
        
        phoneLabel.text =  UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Phone" : "Teléfono"
        phoneLabel.font =  UIFont(name: Fonts().lexendRegular, size: 16)
        
        newPassLabel.text =  UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "New Password" : "Nueva contraseña"
        newPassLabel.font =  UIFont(name: Fonts().lexendRegular, size: 16)
        
        confirmPassLabel.text =  UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Confirm Password" : "Confirmar contraseña"
        confirmPassLabel.font =  UIFont(name: Fonts().lexendRegular, size: 16)
        
        submitButton.setTitle(UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Submit" : "Enviar", for: .normal)
        
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        
        guard let userInfo = ApplicationSharedInfo.shared.loginResponse else {
            fatalError("Unable to found Application Shared Info")
            
        }
        guard let firstNameText = firstNameTextField.text?.trimmingCharacters(in: .whitespaces), !firstNameText.isEmpty else {
            self.view.showToast(message: "First Name can't be empty.")
            return
        }
        
        guard let lastNameText = lastNameTextfield.text?.trimmingCharacters(in: .whitespaces), !lastNameText.isEmpty else {
            self.view.showToast(message: "Last Name can't be empty.")
            return
        }
        
        guard let emailText = emailTF.text, !emailText.isEmpty else {
            self.view.showToast(message: "Email can't be empty.")
            return
        }
        
        guard let newpasswordText = newPwTF.text, !newpasswordText.isEmpty else {
            self.view.showToast(message: "New Password can't be empty.")
            return
        }
        
        guard let confirmpasswordText = confirmPwTF.text, !confirmpasswordText.isEmpty else {
            self.view.showToast(message: "Confirm Password can't be empty.")
            return
        }
        
        guard newpasswordText == confirmpasswordText else {
        self.view.showToast(message: "Passwords do not match.")
                   return
               }
      
        self.view.showToastActivity()
        
        updatePatientProfileDetails( patientId: userInfo.patientID,bearerToken: ApplicationSharedInfo.shared.tokenResponse!.accessToken) { [self] result in
            switch result {
            case .success(let data):
                // Convert data to JSON object and print it
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async { [self] in
                            
                            self.view.hideToastActivity()
                            
                            print(json)
                           
                            self.view.showToast(message: "Profile updated succeffully")
                            self.navigationController?.popViewController(animated: true)
                        
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
    func getPatientProfileDetails(patientId: Int, bearerToken: String, completion: @escaping (Result<Data, Error>) -> Void) {
        // Define the URL
        guard let url = URL(string: "\(baseURLString)identity/api/v1/settings/getPatientProfileDetails") else {
            print("Invalid URL")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        
        
        let payload: [String: Any] = [
            "patientId": patientId,
        ]
        print(payload)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.httpBody = jsonData
            //    print(jsonData)
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
                // print("Response JSON: \(jsonResponse)")
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
    
    func updatePatientProfileDetails(patientId: Int, bearerToken: String, completion: @escaping (Result<Data, Error>) -> Void) {
        // Define the URL
        guard let url = URL(string: "\(baseURLString)identity/api/v1/settings/updatePatientProfileDetails") else {
            print("Invalid URL")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let payload: [String: Any] = [
            "patientId": patientId,
            "firstName": firstNameTextField.text ?? "",
            "lastName": lastNameTextfield.text ?? "",
            "email": emailTF.text ?? "",
            "password1": newPwTF.text ?? "",
            "password2": confirmPwTF.text ?? "",
            "phone": phoneTF.text ?? ""
        ]
        
        
        
        print(payload)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
            request.httpBody = jsonData
            //    print(jsonData)
        } catch {
            print("Error converting payload to JSON: \(error)")
            completion(.failure(error))
            return
        }
        
        // Create the URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error with request: \(error)")
                DispatchQueue.main.async { [self] in
                    
                    self.view.hideToastActivity()
                    
                
            }
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
                // print("Response JSON: \(jsonResponse)")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIView {
    func setCornerRadiusAndBorder(cornerRadius: CGFloat, borderColor: CGColor, borderWidth: CGFloat = 1.0) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
    }
}
