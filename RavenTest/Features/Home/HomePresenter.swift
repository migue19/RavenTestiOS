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
        view?.showHUD()
        interactor?.requestData()
    }
}
extension HomePresenter: HomeInteractorOutputProtocol {
    func getTitles(data: [ResultsModel]) -> [String]{
        return data.compactMap({$0.title})
    }
    private func processData(data: [ResultsModel]) {
        self.data = data
        let titles = getTitles(data: data)
        self.view?.hideHUD()
        self.view?.showData(data: titles)
    }
    func showSaveData(data: [ResultsModel]) {
        processData(data: data)
        self.view?.showMessage(message: "Datos Guardados", type: .success)
    }
    func sendErrorMessage(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.hideHUD()
            self?.view?.showNoData()
            self?.view?.showMessage(message: message, type: .error)
        }
    }
    func sendData(data: [ResultsModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.processData(data: data)
        }
    }
    
}
