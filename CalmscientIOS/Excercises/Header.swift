//
//  Header.swift
//  CalmscientIOS
//
//  Created by Krishna on 8/13/24.
//

import UIKit


class HeaderView: UICollectionReusableView {
    static let identifier = "HeaderView"

    private let label: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: Fonts().lexendRegular, size: 20)
            label.textColor = .black
            label.textAlignment = .center
            return label
        }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String) {
        label.text = text
    }
}
