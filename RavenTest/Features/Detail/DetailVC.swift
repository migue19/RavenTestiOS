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
    var presenter: DetailPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
/// Protocolo para recibir datos del presenter.
extension DetailVC: DetailViewProtocol {
}
