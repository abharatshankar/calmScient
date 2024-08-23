//
//  ScreeningResultVC.swift
//  HealthScreeningApp
//
//  Created by KA on 23/03/24.
//

import UIKit

class ScreeningResultVC: ViewController {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var totalScoreLbl: UILabel!
    
    @IBOutlet weak var testDateLbl: UILabel!
    @IBOutlet weak var testTimeLbl: UILabel!
    @IBOutlet weak var remindOptionLbl: UILabel!
    @IBOutlet weak var needToTalkButton: LinearGradientButton!
    
    private var customAlertBackgroundView:UIVisualEffectView?
    public weak var selectedScreening:Screening? = nil

    fileprivate var screeningResult:ScreeningSuccessResults? = nil
    @IBOutlet weak var remindMeLabel: UILabel!
    
    
    @IBOutlet weak var scoreMarkedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        needToTalkButton.setAttributedTitleWithGradientDefaults(title: "Need to talk with someone?")
        addShadowAndBorder()
        print(progressBar.frame.height)
        print(progressBar.frame.height)
        progressBar.subviews.forEach { subview in
            subview.layer.masksToBounds = true
            subview.layer.cornerRadius = 12
        }
        
        navigationItem.title = "Your Results"
        getResultsForScreening()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: Date())
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeString = timeFormatter.string(from: Date())
        testDateLbl.text = dateString
        testTimeLbl.text = timeString
        
        let backButton = UIButton(type: .custom)
            
            // Set the image
            if let backImage = UIImage(named: "backButton") { // Replace "back_icon" with your image name
                backButton.setImage(backImage, for: .normal)
            }

            // Set the size of the button
            backButton.frame = CGRect(x: 0, y: 0, width: 31, height: 31)
            // Add an action to the button
            backButton.addTarget(self, action: #selector(customBackButtonPressed), for: .touchUpInside)

            // Set the button as the left bar button item
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setupLanguage()
    }
    
    @objc func customBackButtonPressed() {
        if let viewControllers = self.navigationController?.viewControllers {
            for vc in viewControllers {
                if vc is ScreeningListVC { // Replace with your specific view controller class
                    self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }
    
    func setupLanguage() {
        
            let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        self.title =  UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Your Results" : "Tus Resultados."
        needToTalkButton.titleLabel!.text = AppHelper.getLocalizeString(str:"Need to talk with someone?")
        remindMeLabel.text = AppHelper.getLocalizeString(str:"Remind me")
        scoreMarkedLabel.text =  AppHelper.getLocalizeString(str:"Score marked")
        totalScoreLbl.text = AppHelper.getLocalizeString(str:"Total score")
        
//        change at line 48, 49,
        }
    @IBAction func needToTalkAction(_ sender: Any) {
        let next = UIStoryboard(name: "NeedToTalkViewController", bundle: nil)
        let vc = next.instantiateViewController(withIdentifier: "NeedToTalkViewController") as? NeedToTalkViewController
        vc?.title = "Emergency resource"
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    fileprivate func getResultsForScreening() {
        self.view.showToastActivity()
        var prepareRequestBodyParams:[String:Any] = [:]
        guard let screeningObject = self.selectedScreening, let loginResponse = ApplicationSharedInfo.shared.loginResponse else {
            return
        }
        prepareRequestBodyParams["screeningId"] = screeningObject.screeningID
        prepareRequestBodyParams["assessmentId"] = screeningObject.assessmentID
        
        prepareRequestBodyParams["patientLocationId"] = loginResponse.patientLocationID
        prepareRequestBodyParams["patientId"] = loginResponse.patientID
        prepareRequestBodyParams["clientId"] = loginResponse.clientID
        
        
        let questonariesRequest = ScreeningSuccessResultRequestForm(prepareRequestBodyParams)
        guard let requestURL = questonariesRequest.getURLRequest() else {
            self.view.showToast(message: "An Unknown error occured. Please check with Admin")
            return
        }
        NetworkAPIRequest.sendRequest(request: requestURL) { [weak self](response: ScreeningSuccessResponse?, failureResponse: FailureResponse?, error: Error?) in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.view.hideToastActivity()
                if let _ = error {
                    self.view.showToast(message: "An Unknown error occured. Please check with Admin")
                } else if let response = response {
                    self.screeningResult = response.screeningResults
                    self.totalScoreLbl.text = "\(self.screeningResult?.total ?? 0)"
                    self.scoreLbl.text =  "\(self.screeningResult?.score ?? 0)"
                    self.progressBar.setProgress(Float(response.screeningResults.score)/Float(response.screeningResults.total), animated: true)
                } else if let failureResponse = failureResponse {
                    self.view.showToast(message: failureResponse.statusResponse.responseMessage)
                }
            }
        }
    }
    
    fileprivate func addShadowAndBorder() {
        shadowView.layer.backgroundColor = UIColor.clear.cgColor
        shadowView.layer.shadowColor = UIColor(named: "AppViewShadowColor")?.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowRadius = 4.0
        
        cornerView.layer.cornerRadius = 8
        cornerView.layer.masksToBounds = true
        cornerView.layer.borderWidth = 1
        cornerView.layer.borderColor = UIColor(named: "AppViewBorderColor")?.cgColor
    }
    @IBAction func didClickOnInfo(_ sender: Any) {
        addAlertView()
    }
    
    private func addAlertView() {
       
       customAlertBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        customAlertBackgroundView?.frame = self.view.frame
        var customAlertView:CustomAlertMoreInfoView? = CustomAlertMoreInfoView(frame: self.view.frame)
        customAlertBackgroundView?.contentView.addSubview(customAlertView!)
        customAlertView?.translatesAutoresizingMaskIntoConstraints = false
        customAlertView?.okAction = { [weak self] in
            guard let self = self else {
                return
            }
            UIView.transition(with: self.view, duration: 0.25, options: .transitionCrossDissolve, animations: {
                customAlertView?.removeFromSuperview()
                self.customAlertBackgroundView?.removeFromSuperview()
                customAlertView = nil
                self.customAlertBackgroundView = nil
                self.navigationController?.navigationBar.layer.zPosition = 0

            }, completion: nil)
        }
        
        UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.navigationController?.navigationBar.layer.zPosition = -1
            self.view.addSubview(self.customAlertBackgroundView!)
            }, completion: nil)
        customAlertView?.layer.cornerRadius = 10
        customAlertView?.layer.masksToBounds = true
        customAlertView?.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        customAlertView?.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        customAlertView?.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.9).isActive = true
        customAlertView?.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.6).isActive = true
       

    
    }
    

}
