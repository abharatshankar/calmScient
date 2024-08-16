//
//  AddNewMedicationUserEntryTableCell.swift
//  CalmscientIOS
//
//  Created by NFC on 26/04/24.
//

import UIKit

enum AddMedicationsCellType:String {
    case MedicationName = "Name"
    case MedicationProvider = "Provider"
    case MedicationDosage = "Dosage"
    case MedicationDirection = "Direction"
}

class AddNewMedicationUserEntryTableCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userEntryTextField: TextFieldWithPadding!
    public var cellType:AddMedicationsCellType = .MedicationName
    var userEntryCaptureClosure:((_ text:String, _ row:Int)->Void)?
    var cellRow:Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        userEntryTextField.layer.borderWidth = 1
        userEntryTextField.layer.borderColor = UIColor(named: "light6E6BB3Color")?.cgColor
        userEntryTextField.backgroundColor = UIColor(named: "lightF2F2F2Color")
        userEntryTextField.layer.cornerRadius = 2
        userEntryTextField.layer.masksToBounds = true
        userEntryTextField.delegate = self
        if cellType == .MedicationName {
                    userEntryTextField.autocapitalizationType = .allCharacters
                }
        
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userEntryTextField.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        userEntryCaptureClosure?(textField.text ?? "",cellRow)
    }
    
    
    
}

public class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 8,
        bottom: 0,
        right: 8
    )

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
}
