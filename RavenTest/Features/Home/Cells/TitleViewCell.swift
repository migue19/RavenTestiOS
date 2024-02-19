//
//  TitleViewCell.swift
//  MyPasswords
//
//  Created by Miguel Mexicano Herrera on 19/01/24.
//

import UIKit

class TitleViewCell: UITableViewCell, ReusableView {
    lazy var containerView: UIView = {
        var view: UIView = UIView()
        view.backgroundColor = .cellColor
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var titleLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        //label.backgroundColor = .green
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
        containerView.elevate(elevation: 2)
    }
}
extension TitleViewCell: CreateView {
    func setupView() {
        self.selectionStyle = .none
        addSubviews()
        setupConstraints()
    }
    func addSubviews() {
        self.contentView.addSubview(containerView)
        self.containerView.addSubview(titleLabel)
    }
    func setupConstraints() {
        containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 1).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -1).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -16).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -16).isActive = true
    }
}
