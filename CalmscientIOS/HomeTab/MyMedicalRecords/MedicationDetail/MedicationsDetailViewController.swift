//
//  MedicationsDetailViewController.swift
//  MainTabBarApp
//
//  Created by KA on 14/03/24.
//

import UIKit



class MedicationsDetailViewController: ViewController {

    @IBOutlet weak var scrennTitleView: UIView!
    @IBOutlet weak var dosageView: UIView!
    @IBOutlet weak var tableTitleLabel: UILabel!
    @IBOutlet weak var medicationsDetailsTableView: UITableView!
    
    @IBOutlet weak var doctorTitle: UILabel!
    @IBOutlet weak var medicineTitle: UILabel!
    @IBOutlet weak var directionsValue: UILabel!
    @IBOutlet weak var dosageValue: UILabel!
    
    weak var medicineDetails:MedicineDetails? = nil {
        didSet {
            guard let details = medicineDetails?.medicationDetailsByDate.first?.medicalDetails else {
                return
            }
            tableData = details.scheduledTimeList.sorted(by: {
                $0.scheduledTimes.first?.medicineTime ?? "" < $1.scheduledTimes.first?.medicineTime ?? ""
            })
            medicineDetails?.medicationDetailsByDate.first?.medicalDetails.scheduledTimeList = tableData
        }
    }
    
    @IBOutlet weak var cancelButton: BorderShadowButton!
    @IBOutlet weak var saveButton: LinearGradientButton!
    var tableData:[ScheduledTimeList] = []
    let imageNames:[String] = ["sunset","afternoonSun","moon"]
    var headingLabelString = ""
    var saveStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        medicationsDetailsTableView.register(UINib(nibName: "MedicationsDetailTableCell", bundle: nil), forCellReuseIdentifier: "MedicationsDetailTableCell")
        medicationsDetailsTableView.dataSource = self
        medicationsDetailsTableView.delegate = self
        medicationsDetailsTableView.reloadData()
        self.title = "Medications detail"
        dosageView.layer.cornerRadius = 8
        dosageView.layer.masksToBounds = true
        dosageView.layer.borderWidth = 1
        dosageView.layer.borderColor = UIColor(named: "AppViewBorderColor")?.cgColor
     //   saveButton.setAttributedTitleWithGradientDefaults(title:saveStr)
     //   cancelButton.setAttributedTitleWithGradientDefaults(title:AppHelper.getLocalizeString(str: "Cancel"))
        guard let details = medicineDetails?.medicationDetailsByDate.first?.medicalDetails else {
            return
        }
        doctorTitle.text = details.providerName
        medicineTitle.text = details.medicineName
        dosageValue.text = details.medicineDosage
        directionsValue.text = details.directions
    }
    

}
extension MedicationsDetailViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationsDetailTableCell", for: indexPath) as! MedicationsDetailTableCell
        cell.selectionStyle = .none
        cell.updateCellData(withScheduledTimeList: tableData[indexPath.row], medicineDetails: medicineDetails!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentModal(forInstance: tableData[indexPath.row])
    }
    func setupLanguage() {
        
            let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        self.title = AppHelper.getLocalizeString(str:"Add Medications")
       // var headingLabelString = AppHelper.getLocalizeString(str:"Add Time & Alarm")
        saveStr = AppHelper.getLocalizeString(str: "Save")
//        change at line 48, 49,
        }

    private func presentModal(forInstance:ScheduledTimeList) {
            let next = UIStoryboard(name: "BottomSheetTimeAndAlarmVC", bundle: nil)
            guard let sheetVC = (next.instantiateViewController(withIdentifier: "BottomSheetTimeAndAlarmVC") as? BottomSheetTimeAndAlarmVC) else {
                return
            }
        
            sheetVC.instanceObj = forInstance
            sheetVC.isNewMedicationCreation = false
            sheetVC.onScheetClosed = {
                [weak self] in
                self?.medicationsDetailsTableView.reloadData()
                guard let scheduleAlarm = forInstance.scheduledTimes.first else {
                    fatalError("Update Medications failed")
                }
                guard let updatedAlarm = MedicationAlarm(withScheduledTime: scheduleAlarm, medicationID: self?.medicineDetails?.medicationDetailsByDate.first?.medicalDetails.medicationId ?? 0) else {
                    return
                }
                let medAlarmData = OnlyMedicationAlarm()
                medAlarmData.alarms = [updatedAlarm]
                guard let jsonData = try? JSONEncoder().encode(medAlarmData) else {
                    return
                }
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("JSON String: \(jsonString)")
                }
                
                let requestForm = UpdateMedicationsAlarmRequestForm(jsonData)
                guard let requestURL = requestForm.getURLRequest() else {
                    self?.view.showToast(message: "An Unknown error occured. Please check with Admin")
                    return
                }
                NetworkAPIRequest.sendRequest(request: requestURL) {(response: ResponseDetails?, failureResponse: FailureResponse?, error: Error?) in
                    print(response?.responseMessage ?? "")
                }
            }
            self.navigationController?.modalPresentationStyle = .pageSheet
            
            if #available(iOS 15.0, *) {
                if let sheet = sheetVC.sheetPresentationController {
                   // sheet.detents = [.large()]
                    sheet.detents = [.medium(), .large()]
                    sheet.largestUndimmedDetentIdentifier = .medium
                    sheet.prefersGrabberVisible = true
                }
            } else {
                
            }
           sheetVC.headingLabelString = "Update Time & Alarm"
            present(sheetVC, animated: true, completion: nil)
        }
}
