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
}
extension DetailPresenter: DetailInteractorOutputProtocol {
}
