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

class AddUserMedicationsViewController: ViewController {
    
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
        saveButton.setAttributedTitleWithGradientDefaults(title:saveStr)
        cancelButton.setAttributedTitleWithGradientDefaults(title:AppHelper.getLocalizeString(str: "Cancel"))
        userAddMedicationsTableView.tableFooterView = tableFooter
        tableFooter.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80)
        userAddMedicationsTableView.register(UINib(nibName: "MedicationsDetailTableCell", bundle: nil), forCellReuseIdentifier: "MedicationsDetailTableCell")
        userAddMedicationsTableView.register(UINib(nibName: "AddNewMedicationSwitchTableCell", bundle: nil), forCellReuseIdentifier: "AddNewMedicationSwitchTableCell")
        userAddMedicationsTableView.register(UINib(nibName: "AddNewMedicationUserEntryTableCell", bundle: nil), forCellReuseIdentifier: "AddNewMedicationUserEntryTableCell")
        userAddMedicationsTableView.dataSource = self
        userAddMedicationsTableView.delegate = self
        userAddMedicationsTableView.separatorStyle = .none
        self.title = "Add Medications"
        self.scrollTableViewToBottom()
       // self.view.showToast(message: "Schedule medication time by clicking on it.")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollTableViewToBottom()
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
                self.view.showToast(message: "An Unknown error occured. Please check with Admin")
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
                        let alertController = UIAlertController(title: "Add Medication", message: response.response.responseMessage, preferredStyle: .alert)
                        // Add an action button to the alert
                        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
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
        let detailsMatch:[Int:String] = [0:"Name",1:"Provider",2:"Dosage",3:"Direction"]
        for (idx,detailEntered) in userEnteredDetails.enumerated() {
            if detailEntered.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.view.showToast(message: "Please enter \(detailsMatch[idx]!)!")
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
            presentModal(instance: medicationTimeData[indexPath.row - alarmCellStartIndex])
        }
        
    }
    
    private func presentModal(instance:MedicationAlarm) {
        let next = UIStoryboard(name: "BottomSheetTimeAndAlarmVC", bundle: nil)
        let vc = (next.instantiateViewController(withIdentifier: "BottomSheetTimeAndAlarmVC") as? BottomSheetTimeAndAlarmVC)!
        vc.isNewMedicationCreation = true
        vc.newMedicationInstance = instance
        vc.onScheetClosed = {
            [weak self] in
            self?.userAddMedicationsTableView.reloadData()
        }
       // self.navigationController?.pushViewController(vc, animated: true)
        vc.headingLabelString = "Add Time & Alarm"
        
        if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = true
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            }
        } else {
            // Fallback on earlier versions
        }
        present(vc, animated: true, completion: nil)
        
        
//        let next = UIStoryboard(name: "BottomSheetTimeAndAlarmVC", bundle: nil)
//        guard let viewControllerToPresent = next.instantiateViewController(withIdentifier: "BottomSheetTimeAndAlarmVC") as? BottomSheetTimeAndAlarmVC else {
//            return
//        }
//        if #available(iOS 15.0, *) {
//            if let sheet = viewControllerToPresent.sheetPresentationController {
//                sheet.detents = [.large(), .large()]
//                sheet.largestUndimmedDetentIdentifier = .medium
//                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//                sheet.prefersEdgeAttachedInCompactHeight = true
//                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//        present(viewControllerToPresent, animated: true, completion: nil)
        
        
        

//        vc.modalPresentationStyle = .formSheet
//        vc.preferredContentSize =  CGSize(width: self.view.frame.width, height: 0.6*self.view.frame.height)
//        if #available(iOS 15.0, *) {
//            if let sheet = vc.sheetPresentationController {
//                sheet.detents = [.large()]
//                sheet.prefersGrabberVisible = true
//            }
//        } else {
//        }
//        present(vc, animated: true, completion: nil)

    }
}
