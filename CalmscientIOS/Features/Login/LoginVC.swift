//
//  LoginVC.swift
//  MentalHealth
//
//  on 19/02/24.
//

import UIKit
import Toast_Swift

@available(iOS 16.0, *)
class LoginVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNameTextField: ImagePaddingTextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: ImagePaddingTextField!
    
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var selectionButton: SelectionButton!
    @IBOutlet weak var loginButton: LinearGradientButton!
    
    @IBOutlet weak var createAnAccountLabel: UILabel!
    var languageId : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLanguage()

       
//       userNameTextField.text = "mtabata@gmail.com"
//       passwordTextField.text = "mtabata@1234"
//        
//       userNameTextField.text = "chandra.p@gmail.com"
//       passwordTextField.text = "chandra@1234"
        
        
       userNameTextField.text = "ramesh@gmail.com"
       passwordTextField.text = "ramesh@123"
        
//          userNameTextField.text = "sravanthi@gmail.com"
//          passwordTextField.text = "sravanthi@1234"

//        userNameTextField.text = ""
//        passwordTextField.text = ""
        
        userNameTextField.delegate = self
        userNameTextField.layer.borderColor = UIColor(named: "AppBorderColor")?.cgColor
        userNameTextField.layer.borderWidth = 1.0
        userNameTextField.layer.cornerRadius = 4
        userNameTextField.layer.masksToBounds = true
        userNameTextField.backgroundColor = UIColor(named: "MainViewBackground")
        userNameTextField.font = UIFont(name: Fonts().lexendLight, size: 16.0)
        userNameTextField.textColor = UIColor(named: "MainTextColor")
        
        passwordTextField.delegate = self
        passwordTextField.layer.borderColor = UIColor(named: "AppBorderColor")?.cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.cornerRadius = 4
        passwordTextField.layer.masksToBounds = true
        passwordTextField.backgroundColor = UIColor(named: "MainViewBackground")
        passwordTextField.font = UIFont(name: Fonts().lexendLight, size: 16.0)
        passwordTextField.textColor = UIColor(named: "MainTextColor")
        
        
        
        
        
        
        self.forgotPasswordLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordGesture(tapGestureRecognizer:)))
        tapGesture.numberOfTapsRequired = 1
        self.forgotPasswordLabel.addGestureRecognizer(tapGesture)
        
        self.createAnAccountLabel.isUserInteractionEnabled = true
        let createAccountTapGesture = UITapGestureRecognizer(target: self, action: #selector(createAnAccountGesture(tapGestureRecognizer:)))
        createAccountTapGesture.numberOfTapsRequired = 1
        self.createAnAccountLabel.addGestureRecognizer(createAccountTapGesture)
        
        languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
        let termsAndConditions = (languageId == 0 ? 1 : languageId  ) == 1 ? "Accept terms and conditions" : " Aceptar términos y condiciones"
        let termsAndConditionsAttributedText = NSMutableAttributedString(string: termsAndConditions, attributes: [.font: UIFont(name: Fonts().lexendLight, size: 14.0)!, .foregroundColor:UIColor(named: "MainTextColor") ?? UIColor.white])
        termsAndConditionsAttributedText.addAttributes([.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor:UIColor(named: "MainTextColor") ?? UIColor.white], range: (termsAndConditions as NSString).range(of: "terms and conditions"))
        selectionButton.contentLabel.attributedText = termsAndConditionsAttributedText
    }
    
    func setupLanguage() {
        
            let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
        
        
        
        
        let attributedText = NSMutableAttributedString(string: (languageId == 0 ? 1 : languageId  ) == 1 ?  "Forgot Password?" : "¿Has olvidado tu contraseña?", attributes: [.font: UIFont(name: Fonts().lexendLight, size: 14.0)!, .foregroundColor:UIColor(named: "MainTextColor") ?? UIColor.white, .underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor:UIColor(named: "MainTextColor") ?? UIColor.white])
        forgotPasswordLabel.attributedText = attributedText
        
       
        let createAccountAttributedText = NSMutableAttributedString(string:  (languageId == 0 ? 1 : languageId  ) == 1 ?  "Create an new account" : "Crea una nueva cuenta", attributes: [.font: UIFont(name: Fonts().lexendLight, size: 14.0)!, .foregroundColor:UIColor(named: "MainTextColor") ?? UIColor.white, .underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor:UIColor(named: "MainTextColor") ?? UIColor.white])
        createAnAccountLabel.attributedText = createAccountAttributedText
        
        
        self.loginButton.setAttributedTitleWithGradientDefaults(title: (languageId == 0 ? 1 : languageId  ) == 1 ?  "Login" : "Acceso")
        selectionButton.contentLabel.text = (languageId == 0 ? 1 : languageId  ) == 1 ? "Accept Terms & Conditions" : "Aceptar Términos y Condiciones"
        userNameLabel.text = AppHelper.getLocalizeString(str: "Username")
        passwordLabel.text = AppHelper.getLocalizeString(str: "Password")
        createAnAccountLabel.text = (languageId == 0 ? 1 : languageId  ) == 1 ? "Create an New account" : "Crear una nueva cuenta"
        forgotPasswordLabel.text = (languageId == 0 ? 1 : languageId  ) == 1 ?  "Forgot Password?" : "¿Has olvidado tu contraseña?"
        
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
//        userNameTextField.text = ""
//        passwordTextField.text = ""
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Disallow spaces
            return string.rangeOfCharacter(from: .whitespaces) == nil
        }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func forgotPasswordGesture(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.navigationController?.navigationBar.isHidden = false
        let next = UIStoryboard(name: "ForgotPasswordVC", bundle: nil)
        let vc = next.instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func createAnAccountGesture(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.navigationController?.navigationBar.isHidden = false
        let next = UIStoryboard(name: "CreateAccountVC", bundle: nil)
        let vc = next.instantiateViewController(withIdentifier: "CreateAccountVC") as? CreateAccountVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func didClickOnLoginButton(_ sender: UIButton) {
        /*
        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate {
            guard let window = sceneDelegate.window else { return }
            let homeController = UIStoryboard(name: "AppTabBar", bundle: nil).instantiateViewController(withIdentifier: "AppMainTabViewController") as! AppMainTabViewController
            window.rootViewController = homeController
            window.makeKeyAndVisible()
        }*/
        
        
        guard let userNameText = userNameTextField.text?.trimmingCharacters(in: .whitespaces), !userNameText.isEmpty else {
            self.view.showToast(message: "Username or Password can't be empty.")
            return
        }
        
        guard let passwordText = passwordTextField.text, !passwordText.isEmpty else {
            self.view.showToast(message: "Password can't be empty.")
            return
        }
        
        if userNameText.contains(" ") || passwordText.contains(" ") {
               let alert = UIAlertController(title: "Error", message: "Username and Password should not contain spaces.", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default))
               self.present(alert, animated: true)
               return
           }
        
        guard selectionButton.isSelected else {
            self.view.showToast(message: "Please Accept Terms & Conditions")
            return
        }
        
        self.view.showToastActivity()
        self.createLoginRequest(userName: userNameText, password: passwordText)
    }
    
    fileprivate func createLoginRequest(userName:String,password:String) {
     //   let url = URL(string: "http://20.197.5.97:8089/identity/api/v1/settings/userLogin")!
        let url = URL(string: "\(baseURLString)identity/api/v1/settings/userLogin")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "userName": userName,
            "password": password
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Error: Unable to serialize parameters")
            return
        }
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else {
                return
            }
            if let _ = error {
                DispatchQueue.main.async {
                    self.view.hideToastActivity()
                    self.view.showToast(message: error?.localizedDescription ?? "An unknown error occured. Please Try Again!")
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.view.hideToastActivity()
                    self.view.showToast(message: error?.localizedDescription ?? "An unknown error occured. Please Try Again!")
                }
                return
            }
            NetworkLogger.log(response: data)
            do {
                if let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                    DispatchQueue.main.async {
                        if loginResponse.statusResponse.responseCode != 200 {
                            self.view.hideToastActivity()
                            self.view.showToast(message: loginResponse.statusResponse.responseMessage)
                        } else {
                            self.view.hideToastActivity()
                            ApplicationSharedInfo.shared.loginResponse = loginResponse.loginDetails
                            ApplicationSharedInfo.shared.tokenResponse = loginResponse.tokenResponse
         //                   if let sceneDelegate = UIApplication.shared.connectedScenes
//                                .first?.delegate as? SceneDelegate {
//                                guard let window = sceneDelegate.window else { return }
//                                let homeController = UIStoryboard(name: "AppTabBar", bundle: nil).instantiateViewController(withIdentifier: "AppMainTabViewController") as! AppMainTabViewController
//                                window.rootViewController = homeController
//                                window.makeKeyAndVisible()
                            
                            
//                                    let next = UIStoryboard(name: "UserIntro", bundle: nil)
//                                    let vc = next.instantiateViewController(withIdentifier: "UserIntroDayFeedbackViewController") as? UserIntroDayFeedbackViewController
//                                    vc?.afternoonVC = true
//                                    vc?.titleString = "Good Afternoon"
//                                    self.navigationController?.pushViewController(vc!, animated: true)
                            
                            
                            
                            
                            
                            
                            let storyboard = UIStoryboard(name: "UserIntro", bundle: nil)
                                let homeViewController = storyboard.instantiateViewController(withIdentifier: "UserIntroDayFeedbackViewController") as! UserIntroDayFeedbackViewController
                            homeViewController.afternoonVC = true
                            homeViewController.titleString = "Good Afternoon"
                                // Wrap the home view controller in a navigation controller if needed
                                let navController = UINavigationController(rootViewController: homeViewController)
                            
                                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                                    sceneDelegate.changeRootViewController(to: navController)
                                }
                            
                            
//                            }
                        }
                    }
                } else {
                    if let failureResponse = try? JSONDecoder().decode(FailureResponse.self, from: data) {
                        DispatchQueue.main.async {
                            self.view.hideToastActivity()
                            self.view.showToast(message: failureResponse.statusResponse.responseMessage)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.view.hideToastActivity()
                            self.view.showToast(message: "Invalid credentials!!!!. Please Try Again!")
                        }
                    }
                    
                }
            }
        }
        task.resume()
    }
    
    fileprivate func showUnKnownErrorMessage() {
        
    }
    
}

extension UIView {
    public func updateToastStyleWithAppDefaults() {
        var toastStyle = ToastManager.shared.style
        toastStyle.backgroundColor = UIColor(named: "toastBackgroundColor")!
        toastStyle.titleColor = .white
        toastStyle.messageColor = .white
        toastStyle.messageAlignment = .center
        toastStyle.messageNumberOfLines = 0
        toastStyle.messageFont = UIFont(name: Fonts().lexendLight, size: 14) ?? .systemFont(ofSize: 14)
        toastStyle.titleFont = UIFont(name: Fonts().lexendLight, size: 16) ?? .systemFont(ofSize: 16)
        toastStyle.titleAlignment = .center
        toastStyle.activityBackgroundColor = UIColor(named: "toastBackgroundColor")!
        toastStyle.activityIndicatorColor = .white
        ToastManager.shared.style = toastStyle
    }
    
    public func showToast(message:String,title:String? = nil,point:CGPoint? = nil) {
        self.hideAllToasts(includeActivity: true)
        self.updateToastStyleWithAppDefaults()
        self.makeToast(message, duration: 2 ,point: point ?? CGPoint(x: self.frame.width/2, y: self.frame.height/2), title: title, image: nil) { didTap in
            self.hideToastActivity()
        }
    }
    
    public func showToastActivity() {
        self.isUserInteractionEnabled = false
        self.hideAllToasts(includeActivity: true)
        self.updateToastStyleWithAppDefaults()
        self.makeToastActivity(.center)
    }
    
    public func hideToastActivity() {
        self.isUserInteractionEnabled = true
        self.hideAllToasts(includeActivity: true)
    }
    
}

