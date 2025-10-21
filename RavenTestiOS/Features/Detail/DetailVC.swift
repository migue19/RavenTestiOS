//
//  DetailVC.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//

import Foundation
import UIKit

class DetailView: BaseController {
    
    // MARK: Properties
    var presenter: DetailPresenterProtocol?
    private var article: Article?
    
    // MARK: UI Components
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bylineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var publishedDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .tertiaryLabel
        return label
    }()
    
    private lazy var sectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemBlue
        return label
    }()
    
    private lazy var abstractLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private lazy var openArticleButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Leer artículo completo", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(openArticleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        title = "Detalle del Artículo"
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(articleImageView)
        contentView.addSubview(sectionLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bylineLabel)
        contentView.addSubview(publishedDateLabel)
        contentView.addSubview(abstractLabel)
        contentView.addSubview(openArticleButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            articleImageView.heightAnchor.constraint(equalToConstant: 250),
            
            sectionLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 16),
            sectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            bylineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            bylineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bylineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            publishedDateLabel.topAnchor.constraint(equalTo: bylineLabel.bottomAnchor, constant: 8),
            publishedDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            publishedDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            abstractLabel.topAnchor.constraint(equalTo: publishedDateLabel.bottomAnchor, constant: 16),
            abstractLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            abstractLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            openArticleButton.topAnchor.constraint(equalTo: abstractLabel.bottomAnchor, constant: 24),
            openArticleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            openArticleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            openArticleButton.heightAnchor.constraint(equalToConstant: 50),
            openArticleButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    @objc private func openArticleButtonTapped() {
        presenter?.openArticleInBrowser()
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                self?.articleImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}

extension DetailView: DetailViewProtocol {
    func showArticleDetail(_ article: Article) {
        self.article = article
        
        titleLabel.text = article.title
        bylineLabel.text = article.byline
        abstractLabel.text = article.abstract
        sectionLabel.text = article.section.uppercased()
        publishedDateLabel.text = "Publicado: \(formatDate(article.publishedDate))"
        
        // Cargar la imagen si está disponible
        if let media = article.media.first,
           let metadata = media.mediaMetadata.last {
            loadImage(from: metadata.url)
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy"
        outputFormatter.locale = Locale(identifier: "es_ES")
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        
        return dateString
    }
}
