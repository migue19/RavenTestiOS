//
//  DetailPresenter.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 17/02/24.
//  
//

import Foundation

class DetailPresenter {
    var view: DetailViewProtocol?
    var interactor: DetailInteractorInputProtocol?
    var router: DetailRouterProtocol?
}
extension DetailPresenter: DetailPresenterProtocol {
    func getData() {
        interactor?.requestData()
    }
}
extension DetailPresenter: DetailInteractorOutputProtocol {
    func detailEntity(data: ResultsModel) -> DetailEntity {
        return DetailEntity(title: data.title ?? "", author: data.byline ?? "", date: data.published_date ?? "", abstract: data.abstract ?? "")
    }
    func sendData(data: ResultsModel) {
        let data = detailEntity(data: data)
        view?.showData(data: data)
    }
}
