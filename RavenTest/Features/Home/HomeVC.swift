//
//  HomeVC.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 16/02/24.
//  
//
import Foundation
import UIKit
class HomeVC: UIViewController {
    var presenter: HomePresenterProtocol?
    var progress: ProgressView?
    lazy var tableView: UITableView = {
        var tableView: UITableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TitleViewCell.self, forCellReuseIdentifier: "TitleViewCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    var dataSources: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getData()
    }
    func getData() {
        presenter?.getData()
    }
}
/// Protocolo para recibir datos del presenter.
extension HomeVC: HomeViewProtocol {
    func showData(data: [String]) {
        self.dataSources = data
        self.tableView.reloadData()
    }
    func showHUD() {
        progress?.startProgressView()
    }
    func hideHUD() {
        progress?.stopProgressView()
    }
}
extension HomeVC: CreateView {
    func setupView() {
        self.title = "Home"
        progress = ProgressView(inView: self.view)
        addSubviews()
        setupConstraints()
    }
    func addSubviews() {
        self.view.addSubview(tableView)
    }
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.tapInArticle(index: indexPath.row)
    }
}
extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleViewCell") as? TitleViewCell else {
            return UITableViewCell()
        }
        let title = dataSources[indexPath.row]
        cell.setupCell(title: title)
        return cell
    }
}
