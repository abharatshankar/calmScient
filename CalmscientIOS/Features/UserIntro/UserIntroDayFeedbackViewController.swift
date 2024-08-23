//
//  UserIntroDayFeedbackViewController.swift
//  HealthApp
//
//  Created by KA on 26/02/24.
//

import UIKit

enum UserEntryDayFeedbackTableCell:String {
    case UserMoodHoursCell = "UserMoodHoursCell"
    case UserIntroSleepCell = "UserIntroSleepCell"
    case UserEntryTimeSpendCell = "UserEntryTimeSpendCell"
    case UserEntryMedicineCell = "UserEntryMedicineCell"
    case UserEntryJournalCell = "UserEntryJournalCell"
    
    func getCellIdentifier() -> String {
        switch self {
        case .UserMoodHoursCell, .UserEntryTimeSpendCell:
            return "UserIntroSelectionTableCell"
        case .UserIntroSleepCell:
            return "UserEntrySleepHoursCell"
        case .UserEntryMedicineCell, .UserEntryJournalCell:
            return "UserEntryYesOrNoCell"
        }
    }
    
    func getCellHeight() -> CGFloat {
        switch self {
        case .UserMoodHoursCell:
            return 160
        case .UserIntroSleepCell:
            return 120
        case .UserEntryTimeSpendCell:
            return 160
        case .UserEntryMedicineCell:
            return 140
        case .UserEntryJournalCell:
            return 180
        }
    }
}

@available(iOS 16.0, *)
@available(iOS 16.0, *)
class UserIntroDayFeedbackViewController: ViewController {

    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var savebutton: LinearGradientButton!
    @IBOutlet weak var skipButton: BorderShadowButton!
    @IBOutlet weak var feedbackTableView: UITableView!
    var afternoonVC = false
    var titleString = "Good Morning"
    
    private let GoodMorningTitle = "Good morning!"
    private let GoodAfternoonTitle = "Good afternoon!"
    private let GoodEveningTitle = "Good evening!"
    
    private let userDayWiseData:UserStartupScreenDayData? = UserStartupScreenDayData.getStartUpScreenData()
    
    
    fileprivate var cellData:[UserEntryDayFeedbackTableCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savebutton.cornerRadius = (skipButton.frame.size.height / 2) - 1
        self.navigationController?.isNavigationBarHidden = true
        savebutton.setAttributedTitleWithGradientDefaults(title: "Save")
        skipButton.cornerRadius = (skipButton.frame.size.height / 2) - 1
        skipButton.setAttributedTitleWithGradientDefaults(title: "Skip")
        screenTitleLabel.text = titleString
        feedbackTableView.register(UINib(nibName: "UserIntroSelectionTableCell", bundle: nil), forCellReuseIdentifier: "UserIntroSelectionTableCell")
        feedbackTableView.register(UINib(nibName: "UserEntryYesOrNoCell", bundle: nil), forCellReuseIdentifier: "UserEntryYesOrNoCell")
        feedbackTableView.register(UINib(nibName: "UserEntrySleepHoursCell", bundle: nil), forCellReuseIdentifier: "UserEntrySleepHoursCell")
        feedbackTableView.dataSource = self
        feedbackTableView.delegate = self
        feedbackTableView.separatorStyle = .none
        skipButton.layer.borderWidth = 2
        skipButton.layer.borderColor = UIColor(named: "AppThemeColor")?.cgColor
        skipButton.layer.masksToBounds = true
        skipButton.layer.cornerRadius = skipButton.frame.height/2 - 2
        cellData = prepareCellData()
        if let dayTimeValue = userDayWiseData?.dayTimeValue {
            switch dayTimeValue {
            case .Morning:
                self.screenTitleLabel.text = AppHelper.getLocalizeString(str: GoodMorningTitle)
            case .Afternoon:
                self.screenTitleLabel.text = AppHelper.getLocalizeString(str: GoodAfternoonTitle)
            case .Evening:
                self.screenTitleLabel.text = AppHelper.getLocalizeString(str: GoodEveningTitle)
            }
        }
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setupLanguage()
    }
    
    
    func setupLanguage() {
        
            let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
                
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
               
            }
        
        skipButton.setAttributedTitleWithGradientDefaults(title: AppHelper.getLocalizeString(str: "Skip"))
        savebutton.setAttributedTitleWithGradientDefaults(title: AppHelper.getLocalizeString(str: "Save"))
        
        }
    private func prepareCellData() -> [UserEntryDayFeedbackTableCell] {
        guard let userDayWiseData = self.userDayWiseData, let dayTime = userDayWiseData.dayTimeValue else {
            return []
        }
        switch dayTime {
        case .Morning:
            return [.UserMoodHoursCell,.UserIntroSleepCell,.UserEntryMedicineCell]
        case .Afternoon:
            return [.UserMoodHoursCell]
        case .Evening:
            return [.UserMoodHoursCell,.UserEntryTimeSpendCell,.UserEntryMedicineCell,.UserEntryJournalCell]
        }
    }
    
    @IBAction func didClickOnSaveButton(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let userDayWiseData = self.userDayWiseData, let dayTime = userDayWiseData.dayTimeValue else {
            return
        }
        let answers = PatientLog()
        switch dayTime {
        case .Morning:
            answers.moodId = userDayWiseData.moodAnswer ?? 5
            answers.sleepHours = userDayWiseData.sleepAnswer ?? 8
            answers.medicineFlag = Int(userDayWiseData.sleepAnswer ?? 0)
        case .Afternoon:
            answers.moodId = userDayWiseData.moodAnswer ?? 5
        case .Evening:
            answers.moodId = userDayWiseData.moodAnswer ?? 5
            answers.sleepHours = userDayWiseData.sleepAnswer ?? 8
            answers.medicineFlag = Int(userDayWiseData.sleepAnswer ?? 0)
            answers.spendTime = userDayWiseData.timeSpendAnswer ?? ""
            answers.journal = userDayWiseData.journalAnswer ?? ""
        }
        
        self.view.showToastActivity()
        guard let requestForm = SaveUserStartupScreenDetailsRequestForm(answers) else {
            self.view.showToast(message: "An Unknown error occured. Please check with Admin")
            return
        }
        guard let requestURL = requestForm.getURLRequest() else {
            self.view.showToast(message: "An Unknown error occured. Please check with Admin")
            return
        }
        NetworkAPIRequest.sendRequest(request: requestURL) { [weak self](response: ResponseDetails?, failureResponse: FailureResponse?, error: Error?) in
            DispatchQueue.main.async {
                self?.view.hideToastActivity()
                guard let self = self else {
                    return
                }
                if let err = error {
                    self.view.showToast(message: err.localizedDescription)
                } else if let response = response {
                    if response.responseCode == 200 {
//                        let vc1 = UIStoryboard(name: "DashboardHomeTab", bundle: nil).instantiateViewController(withIdentifier: "HomeTabDashboardViewController") as! HomeTabDashboardViewController
//                        self.navigationController?.pushViewController(vc1, animated: true)
                        
                        if let sceneDelegate = UIApplication.shared.connectedScenes
                            .first?.delegate as? SceneDelegate {
                            guard let window = sceneDelegate.window else { return }
                            let homeController = UIStoryboard(name: "AppTabBar", bundle: nil).instantiateViewController(withIdentifier: "AppMainTabViewController") as! AppMainTabViewController
                            window.rootViewController = homeController
                            window.makeKeyAndVisible()
                        }
                    } else {
                        self.view.showToast(message: response.responseMessage)
                    }
                } else if let failureResponse = failureResponse {
                    self.view.showToast(message: failureResponse.statusResponse.responseMessage)
                }
            }
        }
    }
    
    @IBAction func didClickOnSkipButton(_ sender: BorderShadowButton) {
        
//        let vc1 = UIStoryboard(name: "DashboardHomeTab", bundle: nil).instantiateViewController(withIdentifier: "HomeTabDashboardViewController") as! HomeTabDashboardViewController
//        self.navigationController?.pushViewController(vc1, animated: true)
//        
        
        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate {
            guard let window = sceneDelegate.window else { return }
            let homeController = UIStoryboard(name: "AppTabBar", bundle: nil).instantiateViewController(withIdentifier: "AppMainTabViewController") as! AppMainTabViewController
            homeController.isInitalView = true
            window.rootViewController = homeController
            window.makeKeyAndVisible()
        }
        
        
        
//        let next = UIStoryboard(name: "UserMedicalRecords", bundle: nil)
//                    let vc = next.instantiateViewController(withIdentifier: "UserMedicalRecordsViewController") as? UserMedicalRecordsViewController
//                    self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

@available(iOS 16.0, *)
extension UserIntroDayFeedbackViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userDayWiseData = self.userDayWiseData else {
            return UITableViewCell()
        }
        let cellType = cellData[indexPath.row]
        switch cellType {
        case .UserMoodHoursCell, .UserEntryTimeSpendCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellType.getCellIdentifier(), for: indexPath) as? UserIntroSelectionTableCell else {
                return UITableViewCell()
            }
            cell.updateUIWithCellInstance(instance: userDayWiseData, cellType: cellType)
        case .UserIntroSleepCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellType.getCellIdentifier(), for: indexPath) as? UserEntrySleepHoursCell else {
                return UITableViewCell()
            }
            cell.updateUIWithCellInstance(instance: userDayWiseData, cellType: cellType)
        case .UserEntryMedicineCell, .UserEntryJournalCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellType.getCellIdentifier(), for: indexPath) as? UserEntryYesOrNoCell else {
                return UITableViewCell()
            }
            cell.updateUIWithCellInstance(instance: userDayWiseData, cellType: cellType)
            cell.configureJournalView(isJournalView: cellType == .UserEntryJournalCell)
            return cell
        }
        /*
        if (indexPath.row < 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserIntroSelectionTableCell", for: indexPath) as! UserIntroSelectionTableCell
            cell.cellIndex = indexPath.row
            cell.tableCellCollectionView.reloadData()
            if indexPath.row == 0 {
                cell.titleLabel.text = "How was your day?"
            } else {
                cell.titleLabel.text = "Who did you spend time with?"
            }
            return cell
        } else if (indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserEntrySleepHoursCell", for: indexPath) as! UserEntrySleepHoursCell
            cell.sleepHoursCollectionView.reloadData()
            cell.titleLabel.text = "How many hours did you sleep last night?"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserEntryYesOrNoCell", for: indexPath) as! UserEntryYesOrNoCell
            if indexPath.row == 2 {
                cell.configureJournalView(isJournalView: false)
                cell.titleLabel.text = "Did you take your meds this evening?"
            } else {
                cell.configureJournalView(isJournalView: true)
                cell.titleLabel.text = "Daily Journal"
            }
            return cell
        }
         */
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = cellData[indexPath.row]
        return cellType.getCellHeight()
    }
    
   
    
}
