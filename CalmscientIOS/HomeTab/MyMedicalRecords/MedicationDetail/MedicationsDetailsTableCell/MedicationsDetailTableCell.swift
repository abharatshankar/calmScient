//
//  MedicationsDetailTableCell.swift
//  MainTabBarApp
//
//  Created by KA on 14/03/24.
//

import UIKit

class MedicationsDetailTableCell: UITableViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var dayTimeImageView: UIImageView!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var leftContentLabel: UILabel!
    
    @IBOutlet weak var rightContentLabel: UILabel!
    
    @IBOutlet weak var rightTitleLabel: UILabel!
    
    @IBOutlet weak var cellSwitchImageView: UIImageView!
    
    private var defaultImage = UIImage(named: "ToggleSwitch_No")
    private var selectedImage = UIImage(named: "ToggleSwitch_Yes")
    
    private var currentImage:UIImage? = UIImage(named: "ToggleSwitch_No")
    private weak var medicationAlarmInstance:ScheduledTimeList?
    private weak var medicineDetails:MedicineDetails?
    public var isCellSelected = false {
        didSet {
            if isCellSelected {
                currentImage = selectedImage
            } else {
                currentImage = defaultImage
            }
        }
    }
    private var buttonState:SelectionButtonState = .dafault {
        didSet {
            self.isCellSelected = (buttonState == .selected)
        }
    }
    
    @IBAction func didTapOnSelectionButton(_ sender: UITapGestureRecognizer) {
        if buttonState == .dafault {
                   buttonState = .selected
               } else {
                   buttonState = .dafault
               }
               UIView.transition(with: cellSwitchImageView, duration: 0.3, options: .transitionCrossDissolve) {
                   self.cellSwitchImageView.image = self.currentImage
               }
               guard let scheduleAlarm = medicationAlarmInstance?.scheduledTimes.first else {
                   return
               }
               if buttonState == .dafault {
                   scheduleAlarm.alarmEnabled = "0"
               } else {
                   scheduleAlarm.alarmEnabled = "1"
               }
               guard let updatedAlarm = MedicationAlarm(withScheduledTime: scheduleAlarm, medicationID: self.medicineDetails?.medicationDetailsByDate.first?.medicalDetails.medicationId ?? 0) else {
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
                   return
               }
               NetworkAPIRequest.sendRequest(request: requestURL) {(response: ResponseDetails?, failureResponse: FailureResponse?, error: Error?) in
                   print(response?.responseMessage ?? "")
               }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        buttonState = .dafault
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadowAndBorder()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnSelectionButton(_:)))
        self.cellSwitchImageView.isUserInteractionEnabled = true
        self.cellSwitchImageView.addGestureRecognizer(tapGestureRecognizer)
        isCellSelected = false
        buttonState = .dafault
        self.cellSwitchImageView.image = self.currentImage
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func addShadowAndBorder() {
        shadowView.layer.backgroundColor = UIColor.clear.cgColor
        shadowView.layer.shadowColor = UIColor(named: "AppViewShadowColor")?.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowRadius = 2.0
        
        borderView.layer.cornerRadius = 8
        borderView.layer.masksToBounds = true
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor(named: "AppViewBorderColor")?.cgColor
    }

    func updateCellData(withScheduledTimeList data:ScheduledTimeList, medicineDetails:MedicineDetails?) {
            self.medicineDetails = medicineDetails
            medicationAlarmInstance = data
            guard let scheduledTime = data.scheduledTimes.first else {
                return
            }
            if scheduledTime.alarmEnabled == "1" {
                buttonState = .selected
            } else {
                buttonState = .dafault
            }
            self.cellSwitchImageView.image = self.currentImage
            guard let alarmDayType = scheduledTime.alarmTime.getDayTimeFromDate(), let alarmDayTypeShortForm = scheduledTime.alarmTime.getDayTimeFromDate(includeTimeZone:true) else {
                return
            }
            guard let dayTypeMatch = DayTimeValue(rawValue: alarmDayType) else {
                return
            }
            guard let medicineTimeShortForm = scheduledTime.medicineTime.getDayTimeFromDate(formatter: "HH:mm:ss", includeTimeZone: true) else {
                return
            }
            self.dayTimeImageView.image = dayTypeMatch.getIconImage()
            leftTitleLabel.text = dayTypeMatch.rawValue
            rightTitleLabel.text = "Alarm"
            leftContentLabel.text = medicineTimeShortForm
            rightContentLabel.text = alarmDayTypeShortForm
        }
        
        func updateCellData(medicationAlarm:MedicationAlarm) {
            if medicationAlarm.isEnabled == 1 {
                buttonState = .selected
            } else {
                buttonState = .dafault
            }
            self.cellSwitchImageView.image = self.currentImage
            self.dayTimeImageView.image = medicationAlarm.getDayTime().getIconImage()
            leftTitleLabel.text = medicationAlarm.getDayTime().rawValue
            rightTitleLabel.text = "Alarm"
            leftContentLabel.text = medicationAlarm.getMedicineTimeWithAMorPM()
            rightContentLabel.text =  medicationAlarm.getAlarmTimeWithAMOrPM()
        }
    
}
