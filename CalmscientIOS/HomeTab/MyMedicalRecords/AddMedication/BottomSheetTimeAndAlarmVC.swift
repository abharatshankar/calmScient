//
//  BottomSheetTimeAndAlarmVC.swift
//  HealthApp
//
//  Created by NFC on 13/03/24.
//

import UIKit

class BottomSheetTimeAndAlarmVC: UIViewController {
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    
    weak var instanceObj:ScheduledTimeList?
    weak var newMedicationInstance:MedicationAlarm?
    var isNewMedicationCreation = false
    
    var timeArray = ["05", "10", "15", "20", "25", "30"]
    var dayArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var daySelectedArray = ["SunSelected", "MonSelected", "TueSelected", "WedSelected", "ThuSelected", "FriSelected", "SatSelected"]
    
    var selectedDays = [Int]()
    var onScheetClosed:(()->Void)?
    var headingLabelString : String = ""
    
    @IBAction func onDateValueChanged(_ sender: UIDatePicker) {
        let newDateTime = sender.date.dateToString(format: "HH:mm:ss")
        if isNewMedicationCreation {
            newMedicationInstance?.medicineTime = newDateTime
            newMedicationInstance?.isEnabled = 1
        } else {
            guard let scheduledObj = self.instanceObj?.scheduledTimes.first else {
                return
            }
            scheduledObj.medicineTime = newDateTime
            let alarmTime = Calendar.current.date(byAdding: .minute, value: -(Int(scheduledObj.alarmInterval) ?? 0), to: newDateTime.getDate(formatString: "HH:mm:ss"))
            guard var newAlarmDateAndTime = scheduledObj.alarmTime.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .whitespaces).first else {
                fatalError("Get SPlit Date Failed")
            }
            guard let newAlarmTime = alarmTime?.dateToString(format: "HH:mm:ss") else {
                fatalError("Get alarm Date Failed")
            }
            newAlarmDateAndTime = "\(newAlarmDateAndTime) \(newAlarmTime)"
            scheduledObj.alarmTime = newAlarmDateAndTime
            scheduledObj.alarmEnabled = "1"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headingLabel.text = headingLabelString
        timePicker.timeZone = Calendar.current.timeZone
        timePicker.layer.cornerRadius = 5
        timePicker.layer.masksToBounds = true
        timePicker.backgroundColor = UIColor(named: "AppViewContentColor")
        timePicker.layer.borderColor = UIColor(named: "AppViewBorderColor")?.cgColor
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        tableView.register(UINib(nibName: "UpdateMedicationsTableViewCell", bundle: nil), forCellReuseIdentifier: "UpdateMedicationsTableViewCell")
        timeLbl.text = AppHelper.getLocalizeString(str:"Time")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        if isNewMedicationCreation {
            updateWithNewMedicationAlarmInstance()
        } else {
            updateWithUserSelectedDefaults()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onScheetClosed?()
    }
    
    private func updateWithNewMedicationAlarmInstance() {
        guard let scheduledAlarmObj = self.newMedicationInstance else {
            
            return
        }
        let now = scheduledAlarmObj.medicineTime.createDateFromTimeString()
        print("Current date with time \(now)")
        timePicker.setDate(now, animated: true)
        let dateRestrictions = scheduledAlarmObj.getTimeRestrictionsFromDate()
        print("Date Restricitions are \(dateRestrictions)")
        timePicker.minimumDate = dateRestrictions[0]
        timePicker.maximumDate = dateRestrictions[1]
    }
    
    private func updateWithUserSelectedDefaults() {
        guard let scheduledObj = self.instanceObj?.scheduledTimes.first else {
            return
        }
        guard let medicineDayType = scheduledObj.alarmTime.getDayTimeFromDate() else {
            return
        }
        guard let dayTimeValue = DayTimeValue(rawValue: medicineDayType) else {
            return
        }
        let alarmDate = scheduledObj.medicineTime.getDate(formatString: "HH:mm:ss")
        timePicker.setDate(alarmDate, animated: true)
        let calendar = Calendar.current

//        if dayTimeValue == .Morning {
//            let midnight = calendar.startOfDay(for: alarmDate)
//            let noon = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: alarmDate)!
//            timePicker.minimumDate = midnight
//            timePicker.maximumDate = noon
//        } else {
//            let noon = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
//            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
//            timePicker.minimumDate = noon
//            timePicker.maximumDate = endOfDay
//
//        }
//
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension BottomSheetTimeAndAlarmVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isNewMedicationCreation {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateMedicationsTableViewCell", for: indexPath) as? UpdateMedicationsTableViewCell, let timeObj = self.newMedicationInstance else {
                return UITableViewCell()
            }
            cell.isNewMedicationCreation = isNewMedicationCreation
            cell.cellIndex = indexPath.row
            cell.prepareForNewMedicationTiming(medicationAlarm: timeObj)
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateMedicationsTableViewCell", for: indexPath) as? UpdateMedicationsTableViewCell, let timeObj = instanceObj?.scheduledTimes.first else {
                return UITableViewCell()
            }
            cell.isNewMedicationCreation = isNewMedicationCreation
            cell.cellIndex = indexPath.row
            cell.prepareWithCellData(scheduledTime: timeObj)
            cell.selectionStyle = .none
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 90
        } else {
            return 115
        }
    }
    
}


class CustomPresentationController: UIPresentationController {
    let presentedHeight: CGFloat

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, height: CGFloat) {
        self.presentedHeight = height
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return CGRect.zero }
        
        let safeAreaFrame = containerView.bounds.inset(by: containerView.safeAreaInsets)
        let presentedHeight = min(self.presentedHeight, safeAreaFrame.height)
        
        let frame = CGRect(x: 0,
                           y: safeAreaFrame.maxY - presentedHeight,
                           width: safeAreaFrame.width,
                           height: presentedHeight)
        return frame
    }
}

