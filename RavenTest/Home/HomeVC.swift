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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
/// Protocolo para recibir datos del presenter.
extension HomeVC: HomeViewProtocol {
}
