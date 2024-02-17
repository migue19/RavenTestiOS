//
//  DetailVC.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 17/02/24.
//  
//

import Foundation
import UIKit

class DetailVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    var presenter: DetailPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getData()
    }
    func getData() {
        presenter?.getData()
    }
}
extension DetailVC: CreateView {
    func setupView() {
        self.title = "Detalle"
        addSubviews()
        setupConstraints()
    }
    func addSubviews() {
    }
    func setupConstraints() {
    }
}
/// Protocolo para recibir datos del presenter.
extension DetailVC: DetailViewProtocol {
    func showData(data: DetailEntity) {
        titleLabel.text = data.title
        authorLabel.text = data.author
        dateLabel.text = data.date
        abstractLabel.text = data.abstract
    }
}
