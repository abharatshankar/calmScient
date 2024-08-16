//
//  AddNewMedicationSwitchTableCell.swift
//  CalmscientIOS
//
//  Created by NFC on 26/04/24.
//

import UIKit

class AddNewMedicationSwitchTableCell: UITableViewCell {
    let FontReqular = UIFont(name: Fonts().lexendRegular, size: 18)

    @IBOutlet weak var switchButton: SwitchButton!
    @IBOutlet weak var cellTitleLabel: UILabel!
    var isMedicationIncluded:((Bool) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        switchButton.changeResponseClosure = {[weak self] in self?.isMedicationIncluded?($0)}
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
