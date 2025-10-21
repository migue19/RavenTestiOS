//
//  HomePresenter.swift
//  RavenTestiOS
//
//  Created by Miguel Mexicano Herrera on 21/10/25.
//
//

import Foundation
import SwiftMessages

class HomePresenter  {
    
    // MARK: Properties
    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorInputProtocol?
    var router: HomeRouterProtocol?
    
}

extension HomePresenter: HomePresenterProtocol {
    func viewDidLoad() {
        fetchArticles()
    }
    
    func fetchArticles() {
        view?.showHUD()
        interactor?.getArticles()
    }
    
    func didSelectArticle(_ article: Article) {
        router?.navigateToDetail(with: article)
    }
}

extension HomePresenter: HomeInteractorOutputProtocol {
    func didFetchArticles(_ articles: [Article]) {
        view?.hideHUD()
        view?.showArticles(articles)
    }
    
    func didFailFetchingArticles(error: String) {
        view?.hideHUD()
        view?.showMessage(message: error, type: .error)
    }
}
