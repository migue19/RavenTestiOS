//
//  HomeVC.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//
//

import Foundation
import UIKit
import SwiftMessages

final class HomeView: BaseController {
    // MARK: Properties
    var presenter: HomePresenterProtocol?
    private var articles: [Article] = []
    private var filteredArticles: [Article] = []
    private var isSearching: Bool = false
    private var hasAppeared = false
    
    // MARK: UI Components
    private let offlineBanner = OfflineBannerView()
    private let placeholderView = PlaceholderView()
    
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Buscar artículos..."
        search.searchBar.delegate = self
        return search
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(ArticleCell.self)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 120
        table.separatorStyle = .singleLine
        
        // Agregar refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        table.refreshControl = refreshControl
        
        return table
    }()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNetworkObserver()
        updateOfflineBanner()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Solo llamar al presenter la primera vez que aparece la vista
        // En este punto estamos 100% seguros de que la vista está en la jerarquía
        if !hasAppeared {
            hasAppeared = true
            presenter?.viewDidLoad()
        }
    }
    
    @MainActor
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        title = "NY Times - Most Emailed"
        view.backgroundColor = .systemBackground
        
        // Configurar search controller
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        view.addSubview(offlineBanner)
        view.addSubview(tableView)
        
        // Configurar callback de reintentar del placeholder
        placeholderView.onRetry = { [weak self] in
            self?.presenter?.viewDidLoad()
        }
        
        NSLayoutConstraint.activate([
            offlineBanner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            offlineBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            offlineBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: offlineBanner.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNetworkObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged),
            name: NetworkMonitor.connectivityChanged,
            object: nil
        )
    }
    
    @objc private func networkStatusChanged() {
        updateOfflineBanner()
    }
    
    @objc private func handleRefresh() {
        print("🔄 Pull to refresh triggered")
        presenter?.viewDidLoad()
    }
    
    private func updateOfflineBanner() {
        let isConnected = NetworkMonitor.shared.isConnected
        offlineBanner.updateConnectivityStatus(isConnected: isConnected)
    }
}

extension HomeView: HomeViewProtocol {
    func showArticles(_ articles: [Article]) {
        print("📰 showArticles called with \(articles.count) articles")
        self.articles = articles
        self.filteredArticles = articles
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Detener el refresh control si está activo
            self.tableView.refreshControl?.endRefreshing()
            
            let displayArticles = self.isSearching ? self.filteredArticles : self.articles
            
            if displayArticles.isEmpty && !self.isSearching {
                // No hay artículos - mostrar placeholder
                print("⚠️ No articles - showing placeholder")
                self.tableView.backgroundView = self.placeholderView
                self.tableView.separatorStyle = .none
            } else {
                // Hay artículos - ocultar placeholder y mostrar tabla
                print("✅ \(displayArticles.count) articles - showing table")
                self.tableView.backgroundView = nil
                self.tableView.separatorStyle = .singleLine
                self.tableView.reloadData()
            }
        }
    }
    
    func showError(_ error: String) {
        // Detener el refresh control si está activo
        DispatchQueue.main.async { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
        
        showMessage(message: error, type: .error)
        // En caso de error, mostrar placeholder (pasando array vacío)
        showArticles([])
    }
}

// MARK: - TableView DataSource & Delegate
extension HomeView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let displayArticles = isSearching ? filteredArticles : articles
        return displayArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArticleCell = tableView.dequeueReusableCell(for: indexPath)
        let displayArticles = isSearching ? filteredArticles : articles
        let article = displayArticles[indexPath.row]
        cell.configure(with: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let displayArticles = isSearching ? filteredArticles : articles
        let article = displayArticles[indexPath.row]
        presenter?.didSelectArticle(article)
    }
}

// MARK: - UISearchResultsUpdating
extension HomeView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterArticles(with: searchText)
    }
    
    private func filterArticles(with searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredArticles = articles
        } else {
            isSearching = true
            filteredArticles = articles.filter { article in
                // Buscar en título, abstract, autor y sección
                let titleMatch = article.title.localizedCaseInsensitiveContains(searchText)
                let abstractMatch = article.abstract.localizedCaseInsensitiveContains(searchText)
                let authorMatch = article.byline.localizedCaseInsensitiveContains(searchText)
                let sectionMatch = article.section.localizedCaseInsensitiveContains(searchText)
                
                return titleMatch || abstractMatch || authorMatch || sectionMatch
            }
        }
        
        tableView.reloadData()
        
        // Mostrar mensaje si no hay resultados
        if isSearching && filteredArticles.isEmpty {
            let noResultsLabel = UILabel()
            noResultsLabel.text = "No se encontraron artículos"
            noResultsLabel.textAlignment = .center
            noResultsLabel.textColor = .secondaryLabel
            noResultsLabel.font = .systemFont(ofSize: 17, weight: .medium)
            tableView.backgroundView = noResultsLabel
        } else if !isSearching || !filteredArticles.isEmpty {
            tableView.backgroundView = nil
        }
    }
}

// MARK: - UISearchBarDelegate
extension HomeView: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredArticles = articles
        tableView.reloadData()
        tableView.backgroundView = nil
    }
}
