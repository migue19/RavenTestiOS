//
//  HomeRouter.swift
//  RavenTest
//
//  Created by Miguel Mexicano Herrera on 16/02/24.
//  
//

class HomeRouter {
    var view: HomeVC
    private var presenter: HomePresenter
    private var interactor: HomeInteractor
    init() {
        self.view = HomeVC()
        self.presenter = HomePresenter()
        self.interactor = HomeInteractor()
        view.presenter = self.presenter
        presenter.view = self.view
        presenter.interactor = self.interactor
        presenter.router = self
        interactor.presenter = self.presenter
    }
}
extension HomeRouter: HomeRouterProtocol {
}
