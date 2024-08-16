//
//  TellUsCell.swift
//  CalmscientIOS
//
//  Created by mac on 24/06/24.
//

import Foundation
import UIKit

class TellUsCell: UITableViewCell {
    @IBOutlet weak var track_btn: UIButton!
    @IBOutlet weak var quit_btn: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yesButton: LinearGradientButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        track_btn.layer.borderWidth = 2
        track_btn.layer.cornerRadius = 20
        track_btn.layer.borderColor = UIColor(red: 110/255, green: 107/255, blue: 179/255, alpha: 1).cgColor
        
        quit_btn.layer.borderWidth = 2
        quit_btn.layer.cornerRadius = 20
        quit_btn.layer.borderColor = UIColor(red: 110/255, green: 107/255, blue: 179/255, alpha: 1).cgColor
        setupLanguage()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func setupLanguage() {
        
            let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        
        headerLabel.text = AppHelper.getLocalizeString(str: "Save it to weekly summary journal entry")
        titleLabel.text = AppHelper.getLocalizeString(str: "Have tried cutting down but cannot stay within the limit you set." )
        
        yesButton.titleLabel?.text = AppHelper.getLocalizeString(str: "Yes")
        
        quit_btn.titleLabel?.text = AppHelper.getLocalizeString(str: "Quit or cut down drinking")
        
        track_btn.titleLabel?.text = AppHelper.getLocalizeString(str: "Just track the alcohol consumption")
        
        }
}
