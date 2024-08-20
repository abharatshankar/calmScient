//
//  UserEntryYesOrNoCell.swift
//  HealthApp
//
//  Created by KA on 26/02/24.
//

import UIKit

class UserEntryYesOrNoCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var toggleImageView: UIImageView!
    
    private var cellType:UserEntryDayFeedbackTableCell! {
        didSet {
            if cellType == .UserEntryJournalCell {
                let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
                
                self.titleLabel.text = languageId == 1 ? instance.journalData?.journalKey : "Diario"
            } else {
                let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
                
                self.titleLabel.text = languageId == 1 ? instance.medicineData?.medicineQuestion : "¿Tomaste tus medicamentos esta noche?"
            }
        }
    }
    private var instance:UserStartupScreenDayData!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        addShadowAndBorder()
        
//        shadowView.applyShadow()
        borderView.applyShadow()
        self.journalTextView.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.2).cgColor
        self.journalTextView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        self.journalTextView.layer.borderWidth = 1.0
        self.journalTextView.layer.cornerRadius = 4
        self.journalTextView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.toggleTheImage))
        self.toggleImageView.isUserInteractionEnabled = true
        self.toggleImageView.addGestureRecognizer(tapGestureRecognizer)
        self.toggleImageView.tag = -1
        journalTextView.delegate = self
        // Initialization code
    }
    
    func textViewDidChange(_ textView: UITextView) {
        instance.journalAnswer = textView.text
    }
    
    func updateUIWithCellInstance(instance:UserStartupScreenDayData, cellType:UserEntryDayFeedbackTableCell) {
        self.instance = instance
        self.cellType = cellType
    }
    
    @objc func toggleTheImage(){
        var toggleImage:UIImage!
        if self.toggleImageView.tag == -1 {
            instance.medicineAnswer = "1"
            toggleImage = UIImage(named: "ToggleSwitch_Yes")
            self.toggleImageView.tag = 1
        } else {
            instance.medicineAnswer = "0"
            toggleImage = UIImage(named: "ToggleSwitch_No")
            self.toggleImageView.tag = -1
        }
        UIView.transition(with: self.toggleImageView,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { self.toggleImageView.image = toggleImage },
                          completion: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configureJournalView(isJournalView:Bool) {
        toggleImageView.isHidden = isJournalView
        self.journalTextView.isHidden = !isJournalView
    
    }
    
//    fileprivate func addShadowAndBorder() {
//        shadowView.layer.backgroundColor = UIColor.clear.cgColor
//        shadowView.layer.shadowColor = UIColor(named: "AppViewShadowColor")?.cgColor
//        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//        shadowView.layer.shadowOpacity = 0.2
//        shadowView.layer.shadowRadius = 2.0
//        
//        borderView.layer.cornerRadius = 8
//        borderView.layer.masksToBounds = true
//        borderView.layer.borderWidth = 1
//        borderView.layer.borderColor = UIColor(named: "AppViewBorderColor")?.cgColor
//    }

    
}
