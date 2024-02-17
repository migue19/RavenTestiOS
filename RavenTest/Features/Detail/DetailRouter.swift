//
//  DetailRouter.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 17/02/24.
//  
//

class DetailRouter {
    var view: DetailVC
    private var presenter: DetailPresenter
    private var interactor: DetailInteractor
    init() {
        self.view = DetailVC()
        self.presenter = DetailPresenter()
        self.interactor = DetailInteractor()
        view.presenter = self.presenter
        presenter.view = self.view
        presenter.interactor = self.interactor
        presenter.router = self
        interactor.presenter = self.presenter
    }
}
extension DetailRouter: DetailRouterProtocol {
    
}
