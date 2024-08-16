import UIKit

class CustomCheckboxCell: UITableViewCell {

        @IBOutlet weak var customLabel: UILabel!
        @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var main_view: UIView!

//        var isChecked: Bool = true {
//            didSet {
//                let imageName = isChecked ? "check" : "uncheck_circle"
//                checkBox.setImage(UIImage(named: imageName), for: .normal)
//            }
//        }

        override func awakeFromNib() {
            super.awakeFromNib()
//            checkBox.layer.cornerRadius = 15
//            checkBox.layer.borderWidth = 1
//            checkBox.layer.borderColor = UIColor.black.cgColor
//            checkBox.translatesAutoresizingMaskIntoConstraints = false
          //  checkBox.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
            setShadow()
          //  updateCheckboxAppearance()
        }

//        @objc func toggleCheckbox() {
//            isChecked.toggle()
//        }

//        private func updateCheckboxAppearance() {
//            let imageName = isChecked ? "check" : "uncheck_circle"
//            checkBox.setImage(UIImage(named: imageName), for: .normal)
//        }
        
        private func setShadow() {
            main_view.layer.cornerRadius = 10
            main_view.layer.shadowColor = UIColor.gray.cgColor
            main_view.layer.shadowOffset = CGSize(width: 2, height: 2)
            main_view.layer.shadowOpacity = 0.5
            main_view.layer.shadowRadius = 2.0
            main_view.layer.masksToBounds = false
        }
    }

