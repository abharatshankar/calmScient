//
//  ProgressCollapsableTableCell.swift
//  CalmscientIOS
//
//  Created by NFC on 29/04/24.
//

import UIKit

public class ProgressOfWorkCellData {
    var title:String
    var subtitle:[String]
    var percentage:[String]
    var titlePer:String
    var exapansionState:Bool = false
    
    init(title: String, subtitle: [String], percentage: [String], titlePer: String) {
        self.title = title
        self.subtitle = subtitle
        self.percentage = percentage
        self.titlePer = titlePer
    }
    
    func updateExpansionState(isExpanded:Bool) {
        self.exapansionState = isExpanded
    }
}
class ProgressCollapsableTableCell: UITableViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var titlePercentage: UILabel!
    
    @IBOutlet weak var subTitlePercentage: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    var subStackView: UIStackView! // Programmatically created stack view
    
    var dataItem: ProgressOfWorkCellData! {
        didSet {
            title.text = dataItem.title
            titlePercentage.text = dataItem.titlePer
            
            // Clear previous sub-section views
            subStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            // Add sub-section views dynamically if expanded
            if dataItem.exapansionState {
                       for (index, subtitle) in dataItem.subtitle.enumerated() {
                           let horizontalStackView = UIStackView()
                           horizontalStackView.axis = .horizontal
                           horizontalStackView.alignment = .fill
                           horizontalStackView.distribution = .fill
                           horizontalStackView.spacing = 8
                           
                           let subLabel = UILabel()
                           subLabel.text = "  \(subtitle)"
                           subLabel.font = UIFont.systemFont(ofSize: 14)
                           
                           let percentageLabel = UILabel()
                           percentageLabel.font = UIFont(name: Fonts().lexendMedium, size: 15)
                           if index < dataItem.percentage.count {
                               percentageLabel.text = "\(dataItem.percentage[index])%  "
                           } else {
                               percentageLabel.text = ""
                           }
                           percentageLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal) // Ensure percentage label stays on the right side
                           
                           horizontalStackView.addArrangedSubview(subLabel)
                           horizontalStackView.addArrangedSubview(percentageLabel)
                           
                           subStackView.addArrangedSubview(horizontalStackView)
                       }
                   }
        }
    }
    
    var cellExpansionClosure: ((Bool) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        addShadowAndBorder()
        setupSubStackView()
        // Initialization code
    }

    private func setupSubStackView() {
        subStackView = UIStackView()
        subStackView.axis = .vertical
        subStackView.alignment = .fill
        subStackView.distribution = .fill
        subStackView.spacing = 8
        
        subStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subStackView)
        
        NSLayoutConstraint.activate([
            subStackView.topAnchor.constraint(equalTo: titlePercentage.bottomAnchor, constant: 8),
            subStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            subStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }


    @IBAction func didClickOnExpandOrCollapse(_ sender: UIButton) {
        dataItem.updateExpansionState(isExpanded: !dataItem.exapansionState)
        cellExpansionClosure?(dataItem.exapansionState)
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
        
//        borderView.layer.cornerRadius = 8
//        borderView.layer.masksToBounds = true
//        borderView.layer.borderWidth = 1
//        borderView.layer.borderColor = UIColor(named: "AppViewBorderColor")?.cgColor
        borderView.applyShadow()
    }
    
    
    
}





