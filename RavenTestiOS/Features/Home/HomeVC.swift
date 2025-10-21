//
//  HomeVC.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//
//

import Foundation
import UIKit

final class HomeView: BaseController {
    // MARK: Properties
    var presenter: HomePresenterProtocol?
    private var articles: [Article] = []
    
    // MARK: UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(ArticleCell.self)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 120
        return table
    }()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        title = "NY Times - Most Emailed"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HomeView: HomeViewProtocol {
    func showArticles(_ articles: [Article]) {
        self.articles = articles
        tableView.reloadData()
    }
}

// MARK: - TableView DataSource & Delegate
extension HomeView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArticleCell = tableView.dequeueReusableCell(for: indexPath)
        let article = articles[indexPath.row]
        cell.configure(with: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        presenter?.didSelectArticle(article)
    }
}
