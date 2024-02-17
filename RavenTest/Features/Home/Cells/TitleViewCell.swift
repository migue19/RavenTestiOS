//
//  TitleViewCell.swift
//  MyPasswords
//
//  Created by Miguel Mexicano Herrera on 19/01/24.
//

import UIKit

class TitleViewCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupCell(title: String) {
        titleLabel.text = title
    }
}
extension TitleViewCell: GeneralView {
    func setupView() {
        addSubviews()
        setupConstraints()
    }
    func addSubviews() {
        self.contentView.addSubview(titleLabel)
    }
    func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
    }
}
