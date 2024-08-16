//
//  ChartViewHeaderTableCell.swift
//  CalmscientIOS
//
//  Created by NFC on 01/05/24.
//

import UIKit

class ChartViewHeaderTableCell: UITableViewCell {

    @IBOutlet weak var calenderIcon: UIImageView!
    @IBOutlet weak var textField: UITextField!
        
    let datePicker = UIDatePicker()
    private let dateDifference = -15
    var dateRange:(fromDate:Date, toDate:Date) = (Date().getOlderDateWithDaysDifference(minusDays: -30), Date())
    var userSelectedNewDates:((_ fromdate:Date, _ toDate:Date) -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.calenderIconTapped))
        self.calenderIcon.isUserInteractionEnabled = true
        self.calenderIcon.addGestureRecognizer(tapGestureRecognizer)
        textField.isUserInteractionEnabled = false
        datePicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        textField.text = "\(dateFormatter.string(from: dateRange.fromDate)) - \(dateFormatter.string(from: dateRange.toDate))"
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.maximumDate = Date()
        datePicker.locale = Locale(identifier: "en_US_POSIX")
        textField.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
    }
    @objc func calenderIconTapped(_ sender: UITapGestureRecognizer) {
        // Handle tap gesture here
        textField.isUserInteractionEnabled = true
        textField.becomeFirstResponder()
    }
    
    @objc func doneTapped() {
        textField.isUserInteractionEnabled = false
        let datePickerDate = datePicker.date
        let previousDate = datePickerDate.getOlderDateWithDaysDifference(minusDays: dateDifference)
        userSelectedNewDates?(previousDate,datePickerDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        textField.text = "\(dateFormatter.string(from: previousDate)) - \(dateFormatter.string(from: datePickerDate))"
        textField.resignFirstResponder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
