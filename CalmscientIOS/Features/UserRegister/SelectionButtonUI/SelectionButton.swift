//
//  SelectionButton.swift
//  HealthApp
//
//

import Foundation
import UIKit

public enum SelectionButtonState {
    case dafault
    case selected
    
    func getAssetImageForState() -> UIImage? {
        switch self {
        case.dafault: return UIImage(named: "cellUnselectedImage")
        case .selected: return UIImage(named: "CellSelectionImage")
        }
    }
}

final class SelectionButton : UIView {
    
    @IBOutlet weak var userSelectionImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    public var isSelected = true
    private var buttonState:SelectionButtonState = .selected {
        didSet {
            self.isSelected = (buttonState == .selected)
        }
    }

    @IBAction func didTapOnSelectionButton(_ sender: UITapGestureRecognizer) {
        if buttonState == .dafault {
            buttonState = .selected
        } else {
            buttonState = .dafault
        }
        UIView.transition(with: userSelectionImage, duration: 0.5, options: .transitionCrossDissolve) {
            self.userSelectionImage.image = self.buttonState.getAssetImageForState()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib(nibName: "SelectionButton")
        userSelectionImage.image = buttonState.getAssetImageForState()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib(nibName: "SelectionButton")
        userSelectionImage.image = buttonState.getAssetImageForState()
    }
    
    private func loadViewFromNib(nibName: String? = "\(type(of: SelectionButton.self))") {
        guard let nibName = nibName else { return }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        setupLanguage()

    }
    func setupLanguage() {
        
            let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
        contentLabel.text = AppHelper.getLocalizeString(str: "I agree to share my info with medical provider")
        
        
        }
}
