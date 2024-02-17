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
    var data: [ResultsModel] = []
}
extension HomePresenter: HomePresenterProtocol {
    func tapInArticle(index: Int) {
        router?.showArticle(data: data[index])
    }
    func getData() {
        interactor?.requestData()
    }
}
extension HomePresenter: HomeInteractorOutputProtocol {
    func sendData(data: [ResultsModel]) {
        self.data = data
        let titles = data.compactMap({$0.title})
        view?.showData(data: titles)
    }
    
}
