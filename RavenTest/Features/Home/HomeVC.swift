//
//  HomeVC.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 16/02/24.
//  
//
import Foundation
import UIKit
class HomeVC: BaseController {
    var presenter: HomePresenterProtocol?
    var isEmptyData = true
    let noDataText = "No Hay Datos\npara mostrar"
    lazy var tableView: UITableView = {
        var tableView: UITableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TitleViewCell.self)
        tableView.register(ErrorViewCell.self)
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
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
        self.isEmptyData = data.count == 0
        self.dataSources = isEmptyData ? [noDataText] : data
        self.tableView.reloadData()
    }
    func showNoData() {
        self.isEmptyData = true
        self.dataSources = [noDataText]
        self.tableView.reloadData()
    }
}
extension HomeVC: CreateView {
    func setupView() {
        self.title = "Home"
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
        if !isEmptyData {
            presenter?.tapInArticle(index: indexPath.row)
        }
    }
}
extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isEmptyData {
            let cell = tableView.dequeueReusableCell(for: indexPath) as TitleViewCell
            let title = dataSources[indexPath.row]
            cell.setupCell(title: title)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as ErrorViewCell
            let title = dataSources[indexPath.row]
            cell.setupCell(title: title)
            return cell
        }
    }
}
