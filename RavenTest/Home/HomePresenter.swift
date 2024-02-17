//
//  HomePresenter.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 16/02/24.
//  
//

import Foundation

class HomePresenter {
    var view: HomeViewProtocol?
    var interactor: HomeInteractorInputProtocol?
    var router: HomeRouterProtocol?
}
extension HomePresenter: HomePresenterProtocol {
}
extension HomePresenter: HomeInteractorOutputProtocol {
}
