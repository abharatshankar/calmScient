//
//  CustomImageAlertView.swift
//  CalmscientIOS
//
//  Created by Arimilli Venkata Rama Kishore on 29/04/24.
//

import UIKit

protocol QuestionAlertAlertViewActionProtocol:AnyObject {
    func didClickOnYESButton()
    func didClickOnNOButton()
}

class QuestionAlert: UIView {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alertIconImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var cancelButton: BorderShadowButton!
    @IBOutlet weak var okButton: LinearGradientButton!
    
    weak var alertActionDelegate:QuestionAlertAlertViewActionProtocol?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib(nibName: "QuestionAlert")
        cancelButton.setAttributedTitleWithGradientDefaults(title: "No")
        okButton.setAttributedTitleWithGradientDefaults(title: "Yes")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib(nibName: "QuestionAlert")
        okButton.setAttributedTitleWithGradientDefaults(title: "Yes")
        cancelButton.setAttributedTitleWithGradientDefaults(title: "No")
    }
    
    private func loadViewFromNib(nibName: String) {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        addSubview(view)
       
    }

    
    @IBAction func didClickOnNoButton(_ sender: UIButton) {
        alertActionDelegate?.didClickOnNOButton()
    }
    
    
    @IBAction func didClickOnYesButton(_ sender: Any) {
        alertActionDelegate?.didClickOnYESButton()
    }
}
