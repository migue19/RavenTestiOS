//
//  ArticleCell.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import UIKit

class ArticleCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let abstractLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        return label
    }()
    
    private let bylineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .tertiaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(abstractLabel)
        contentView.addSubview(bylineLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            abstractLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            abstractLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            abstractLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            bylineLabel.topAnchor.constraint(equalTo: abstractLabel.bottomAnchor, constant: 8),
            bylineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bylineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bylineLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with article: Article) {
        titleLabel.text = article.title
        abstractLabel.text = article.abstract
        bylineLabel.text = article.byline
    }
}
