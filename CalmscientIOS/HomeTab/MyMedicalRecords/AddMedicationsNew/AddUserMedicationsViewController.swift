//
//  AddUserMedicationsViewController.swift
//  CalmscientIOS
//
//  Created by NFC on 26/04/24.
//

import UIKit


fileprivate enum AddUserMedicationsCellDef:String {
    case textFieldUserEntry = "AddNewMedicationUserEntryTableCell"
    case switchAndTableCell = "AddNewMedicationSwitchTableCell"
    case MedicationsDetailCell = "MedicationsDetailTableCell"
    
    fileprivate func getRowHeight() -> CGFloat {
        switch self {
        case .MedicationsDetailCell : return 96
        case .switchAndTableCell : return 122
        case .textFieldUserEntry : return 80
        }
    }
    
}

class AddUserMedicationsViewController: ViewController, UIAdaptivePresentationControllerDelegate, UISheetPresentationControllerDelegate {
    var dimmingView: UIView?
    @IBOutlet weak var cancelButton: BorderShadowButton!
    @IBOutlet weak var saveButton: LinearGradientButton!
    @IBOutlet weak var userAddMedicationsTableView: UITableView!
    
    @IBOutlet weak var tableFooter: UIView!
    fileprivate let cellData:[AddUserMedicationsCellDef] = [.textFieldUserEntry,.textFieldUserEntry,.textFieldUserEntry,.textFieldUserEntry,.switchAndTableCell,.MedicationsDetailCell,.MedicationsDetailCell,.MedicationsDetailCell]
    
    let imageNames:[String] = ["Isolation_Mode","afternoonSun","moon"]
    var refreshControlClosure:((Bool)->Void)?
    private var isMedicineWithMeals:Bool = false
    private var userEnteredDetails:[String] = Array(repeating: "", count: 4)
    
    private var medicationTimeData:[MedicationAlarm] = [MedicationAlarm.init(alarmTime: .Morning)!,MedicationAlarm.init(alarmTime: .Afternoon)!,MedicationAlarm.init(alarmTime: .Evening)!]
    private let alarmCellStartIndex = 5
    var saveStr = "Save"
    override func viewDidLoad() {
        super.viewDidLoad()
        userEnteredDetails[1] = ApplicationSharedInfo.shared.loginResponse?.providerName ?? "NA"
        saveButton.setAttributedTitleWithGradientDefaults(title: "Save")
        cancelButton.setAttributedTitleWithGradientDefaults(title: "Cancel")
        
        userAddMedicationsTableView.tableFooterView = tableFooter
        tableFooter.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80)
        userAddMedicationsTableView.register(UINib(nibName: "MedicationsDetailTableCell", bundle: nil), forCellReuseIdentifier: "MedicationsDetailTableCell")
        userAddMedicationsTableView.register(UINib(nibName: "AddNewMedicationSwitchTableCell", bundle: nil), forCellReuseIdentifier: "AddNewMedicationSwitchTableCell")
        userAddMedicationsTableView.register(UINib(nibName: "AddNewMedicationUserEntryTableCell", bundle: nil), forCellReuseIdentifier: "AddNewMedicationUserEntryTableCell")
        userAddMedicationsTableView.dataSource = self
        userAddMedicationsTableView.delegate = self
        userAddMedicationsTableView.separatorStyle = .none
//        self.scrollTableViewToBottom()
       // self.view.showToast(message: "Schedule medication time by clicking on it.")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let presentingVC = presentingViewController as? AddUserMedicationsViewController {
            // Hide or remove the dimming view
            presentingVC.dimmingView?.removeFromSuperview()
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.scrollTableViewToBottom()
    }
    func setupLanguage() {
        
            let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        self.title = AppHelper.getLocalizeString(str:"Add Medications")
        var headingLabelString = AppHelper.getLocalizeString(str:"Add Time & Alarm")
        saveStr = AppHelper.getLocalizeString(str: "Save")
        saveButton.setAttributedTitleWithGradientDefaults(title:AppHelper.getLocalizeString(str:saveStr))
        cancelButton.setAttributedTitleWithGradientDefaults(title:AppHelper.getLocalizeString(str: "Cancel"))
//        change at line 48, 49,
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLanguage()
    }
    
    
    @IBAction func didClickOnCancelButton(_ sender: Any) {
        let alertController = UIAlertController(title: AppHelper.getLocalizeString(str:"Medications"), message: AppHelper.getLocalizeString(str:"Are you sure you want to cancel?"), preferredStyle: .alert)
        let okAction = UIAlertAction(title: AppHelper.getLocalizeString(str:"YES"), style: .default) { _ in
            // Handle OK button action if needed
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction =  UIAlertAction(title: AppHelper.getLocalizeString(str:"NO"), style: .default)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func DidClickOnSaveButton(_ sender: Any) {
        view.endEditing(true)
        if doValidation() {
            let medicationData = AddMedication()
            medicationData.alarms = medicationTimeData
            medicationData.direction = userEnteredDetails[3]
            medicationData.dosage = userEnteredDetails[2]
            medicationData.medicationName = userEnteredDetails[0]
            
            //TODO: - How to get provider ID
            medicationData.providerId = 1
            
            medicationData.alarms = self.medicationTimeData
            medicationData.quantity = medicationTimeData.count
            medicationData.withMeal = (isMedicineWithMeals ? 1 : 0)
            medicationData.medicineTime = medicationTimeData.first?.medicineTime ?? "13:30:00"
            guard let jsonData = try? JSONEncoder().encode(medicationData) else {
                return
            }
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON String: \(jsonString)")
            }
       
            let requestForm = AddMedicationsRequestForm(jsonData)
            guard let requestURL = requestForm.getURLRequest() else {
                self.view.showToast(message:  UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "An Unknown error occured. Please check with Admin" : "Se produjo un error desconocido. Consulte con el administrador")
                return
            }
            NetworkAPIRequest.sendRequest(request: requestURL) { [weak self](response: AddMedicationSavedResponse?, failureResponse: FailureResponse?, error: Error?) in
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    self.view.hideToastActivity()
                    if let err = error {
                        self.view.showToast(message: err.localizedDescription)
                    } else if let response = response {
                        let alertController = UIAlertController(title:  UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Add Medication" : "Agregar medicación", message: response.response.responseMessage, preferredStyle: .alert)
                        // Add an action button to the alert
                        let okAction = UIAlertAction(title:  UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "OK" : "DE ACUERDO", style: .default) { _ in
                            // Handle OK button action if needed
                            self.navigationController?.popViewController(animated: true)
                            self.refreshControlClosure?(true)
                        }
                        alertController.addAction(okAction)
                        // Present the alert
                        self.present(alertController, animated: true, completion: nil)
                    } else if let failureResponse = failureResponse {
                        self.view.showToast(message: failureResponse.statusResponse.responseMessage)
                    }
                }
            }
            
        } else {
            userAddMedicationsTableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    public func doValidation() -> Bool {
        
        let name = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Name" : "Nombre"
        let provider = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Provider" : "Proveedora"
        let dosage = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Dosage" : "Dosificación"
        let direction = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Direction" : "Dirección"
        let pleaseEnter = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Please enter" : "Por favor ingresa"
        
        
        let detailsMatch:[Int:String] = [0:name,1:provider,2:dosage,3:direction]
        for (idx,detailEntered) in userEnteredDetails.enumerated() {
            if detailEntered.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.view.showToast(message: "\(pleaseEnter) \(detailsMatch[idx]!)!")
                return false
            }
        }
        return true
    }
    
    private func scrollTableViewToBottom() {
        guard let footerView = userAddMedicationsTableView.tableFooterView else {
            return
        }

        let footerFrameInTableView = userAddMedicationsTableView.convert(footerView.frame, from: footerView.superview)
        userAddMedicationsTableView.scrollRectToVisible(footerFrameInTableView, animated: true)
    }

}
extension AddUserMedicationsViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellData[indexPath.row]
        switch cellType {
        case .MedicationsDetailCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationsDetailTableCell", for: indexPath) as! MedicationsDetailTableCell
            cell.dayTimeImageView.image = UIImage(named: "\(imageNames[Int.random(in: 0..<imageNames.count)])")
            cell.updateCellData(medicationAlarm: medicationTimeData[indexPath.row - alarmCellStartIndex])
            cell.selectionStyle = .none
            return cell
        case .textFieldUserEntry:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewMedicationUserEntryTableCell", for: indexPath) as! AddNewMedicationUserEntryTableCell
            cell.userEntryTextField.text = userEnteredDetails[indexPath.row]
            switch indexPath.row % 4  {
            case 0:
                cell.titleLabel.text = AppHelper.getLocalizeString(str:"Name")
                cell.cellType = .MedicationName
            case 1:
                cell.titleLabel.text = AppHelper.getLocalizeString(str:"Provider")
                cell.cellType = .MedicationProvider
                cell.userEntryTextField.text = ApplicationSharedInfo.shared.loginResponse?.providerName ?? "NA"
                cell.userEntryTextField.textColor = UIColor.lightGray

                cell.userEntryTextField.isEnabled = false
            case 2:
                cell.titleLabel.text = AppHelper.getLocalizeString(str:"Dosage")
                cell.cellType = .MedicationDosage
            case 3:
                cell.titleLabel.text = AppHelper.getLocalizeString(str:"Direction")
                cell.cellType = .MedicationDirection
            default:
                break
            }
            cell.selectionStyle = .none
            cell.cellRow = indexPath.row
            cell.userEntryCaptureClosure = {
                [weak self] (enteredText, Idx) in
                guard let self = self else {
                    return
                }
                self.userEnteredDetails[Idx] = enteredText
                print(self.userEnteredDetails)
            }
            return cell
        case .switchAndTableCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewMedicationSwitchTableCell", for: indexPath) as! AddNewMedicationSwitchTableCell
            cell.selectionStyle = .none
            cell.cellTitleLabel.text = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "With Meal" : "Con la Comida."
            cell.scheduleTimeLbl.text = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ?   "Schedule Time & Alarm" :  "Programar Hora y Alarma."
            cell.isMedicationIncluded = {
                [weak self] (canIncludeMedicineWithMeals) in
                self?.isMedicineWithMeals = canIncludeMedicineWithMeals
            }
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = cellData[indexPath.row]
        return cellType.getRowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = cellData[indexPath.row]
        
        if cellType == .MedicationsDetailCell {
//            presentModal(instance: medicationTimeData[indexPath.row - alarmCellStartIndex])
            checkNotificationPermission(instance: medicationTimeData[indexPath.row - alarmCellStartIndex])
        }
        
    }
    
    
    
    func requestNotificationPermission(instance:MedicationAlarm) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted")
                DispatchQueue.main.async {
                    // UI update code here
                    self.presentModal(instance:instance)
                }
                
            } else {
                print("Permission not granted")
                DispatchQueue.main.async {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                return
                            }
                            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            }
                }
            }
        }
    }
    
    
    func checkNotificationPermission(instance:MedicationAlarm) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                // Permission not requested yet, request permission
                print("Permission not requested yet, request permission")
            case .denied:
                // Permission was denied, show an alert to guide the user to settings
                DispatchQueue.main.async {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                return
                            }
                            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            }
                }
            case .authorized, .provisional, .ephemeral:
                // Permission granted or in provisional state
                print("Permission granted")
                DispatchQueue.main.async {
                    // UI update code here
                    self.requestNotificationPermission(instance:instance)
                }
                
            @unknown default:
                break
            }
        }
    }
    
    private func presentModal(instance:MedicationAlarm) {

        // Present the bottom sheet
        let next = UIStoryboard(name: "BottomSheetTimeAndAlarmVC", bundle: nil)
        guard let vc = next.instantiateViewController(withIdentifier: "BottomSheetTimeAndAlarmVC") as? BottomSheetTimeAndAlarmVC else {
            fatalError("Could not instantiate view controller with identifier 'BottomSheetTimeAndAlarmVC'")
        }
        vc.isNewMedicationCreation = true
        vc.newMedicationInstance = instance
        vc.onScheetClosed = { [weak self] in
            self?.userAddMedicationsTableView.reloadData()
            self?.dimmingView?.removeFromSuperview()
        }
        vc.headingLabelString = AppHelper.getLocalizeString(str:"Add Time & Alarm")

        
        // Create a dimming view and add it to the window
        if let window = UIApplication.shared.keyWindow {
            let dimmingView = UIView(frame: window.bounds)
            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            window.addSubview(dimmingView)
            self.dimmingView = dimmingView // Store the reference
        }


        if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = true
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true

                sheet.delegate = self // To handle delegate methods and adjust dimming view
                presentationControllerShouldDismiss(sheet)
            }
        } else {
            // Fallback on earlier versions
        }

        present(vc, animated: true, completion: nil)

    }
}



extension AddUserMedicationsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfScreenPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        // Return false to prevent the sheet from dismissing when tapping outside or swiping down
        return false
    }
}

